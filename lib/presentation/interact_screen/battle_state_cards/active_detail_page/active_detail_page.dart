import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/battle_result_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/active_detail_page/active_detail_bloc/active_detail_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/active_detail_page/active_detail_bloc/active_detail_state.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/active_detail_page/active_detail_bloc/bloc.dart'
    as active_detail_bloc;
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/extension.dart'
    show UserData, DateTimeExtension;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:one2one_run/utils/signal_r.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/finishedDetail'
class ActiveDetailPage extends StatefulWidget {
  const ActiveDetailPage({
    Key? key,
    required this.activeModel,
    required this.currentUserId,
    required this.onNeedToRefreshActivePage,
    required this.signalR,
  }) : super(key: key);

  final BattleRespondModel activeModel;
  final String currentUserId;
  final VoidCallback onNeedToRefreshActivePage;
  final SignalR signalR;

  @override
  _ActiveDetailPageState createState() => _ActiveDetailPageState();
}

class _ActiveDetailPageState extends State<ActiveDetailPage> {
  final TextEditingController _chatController = TextEditingController();
  final RoundedLoadingButtonController _showUploadResultsPageController =
      RoundedLoadingButtonController();

  List<Messages> _messages = <Messages>[];
  final List<String> _resultPhotos = <String>[];

  final InteractApi _interactApi = InteractApi();

  late UserModel _currentUserModel;
  late Future<OpponentChatModel?> _chatMessages;

  String _resultTime = '01:30';
  String _resultTimeForServer = '0001-01-01T01:30:00';
  late String _opponentId;

  bool _isUploadResultsPage = false;
  bool _isUploadingProgress = false;

  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFirst;
  File? _imageSecond;

  @override
  void initState() {
    super.initState();
    _currentUserModel = PreferenceUtils.getCurrentUserModel();
    _opponentId = getOpponentId(
        model: widget.activeModel, currentUserId: widget.currentUserId);
    _chatMessages =
        _interactApi.getOpponentChatMessages(opponentId: _opponentId);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<ActiveDetailBloc>(
        create: (final BuildContext context) => ActiveDetailBloc(),
        child: BlocListener<ActiveDetailBloc, ActiveDetailState>(listener:
            (final BuildContext context, final ActiveDetailState state) async {
          if (state is ResultBattlePrepared) {
            _isUploadingProgress = true;
            await _interactApi
                .sendResultPhoto(fileImage: _imageFirst)
                .then((String? photoFirst) async {
              if (photoFirst != null) {
                _resultPhotos.add(photoFirst.replaceAll(RegExp(r'\"'), ''));

                if (_imageSecond != null) {
                  await _interactApi
                      .sendResultPhoto(fileImage: _imageSecond)
                      .then((String? photoSecond) {
                    if (photoSecond != null) {
                      _resultPhotos
                          .add(photoSecond.replaceAll(RegExp(r'\"'), ''));
                    }
                  });
                }
              }
            });
            BlocProvider.of<ActiveDetailBloc>(context)
                .add(active_detail_bloc.UploadResultBattle());
          } else if (state is ResultBattleUploaded) {
            await _interactApi.sendBattleResult(
                model: BattleResultModel(
                  photos: _resultPhotos,
                  time: _resultTimeForServer,
                ),
                id: widget.activeModel.id);
            _isUploadingProgress = false;
            widget.onNeedToRefreshActivePage();
            BlocProvider.of<ActiveDetailBloc>(context).add(
                active_detail_bloc.ShowUploadResultPage(
                    isNeedResultPage: false));
          } else if (state is UploadResultPageShown) {
            _isUploadResultsPage = state.isNeedResultPage;
            _clearResultsData();
          } else if (state is TimePickerOpened) {
            final TimeOfDay? time = await getTime(context: context);
            if (time != null) {
              _resultTime = getFormattedTimeForUser(time: time);
              _resultTimeForServer = getFormattedTimeForServer(time: time);
            }
          } else if (state is GalleryIsOpened) {
            await _pickImage(context: context);
          } else if (state is ImageZoomDialogIsOpened) {
            dialogImageZoom(
              context: context,
              height: height,
              width: width,
              photos: state.photos,
            );
          } else if (state is MessageChatSent) {
            await sendMessage(
              message: _chatController.text,
              id: widget.activeModel.id,
            ).whenComplete(() => _chatMessages =
                _interactApi.getOpponentChatMessages(opponentId: _opponentId));
          }
          BlocProvider.of<ActiveDetailBloc>(context)
              .add(active_detail_bloc.UpdateState());
        }, child: BlocBuilder<ActiveDetailBloc, ActiveDetailState>(builder:
            (final BuildContext context, final ActiveDetailState state) {
          //receiveChatMessage();
          return FutureBuilder<OpponentChatModel?>(
            future: _chatMessages,
            builder: (BuildContext context,
                AsyncSnapshot<OpponentChatModel?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _messages = snapshot.data!.messages.cast<Messages>();
                return Scaffold(
                  backgroundColor: homeBackground,
                  appBar: AppBar(
                    shadowColor: Colors.transparent,
                    title: Text(
                      widget.activeModel.battleName ?? 'Battle',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: colorPrimary,
                  ),
                  body: _isUploadResultsPage
                      ? uploadBattleResultDialog(
                          width: width,
                          height: height,
                          resultTime: _resultTime,
                          imageFirst: _imageFirst,
                          imageSecond: _imageSecond,
                          isUploading: _isUploadingProgress,
                          onTimeTap: () {
                            BlocProvider.of<ActiveDetailBloc>(context)
                                .add(active_detail_bloc.OpenTimePicker());
                          },
                          onCancelTap: () {
                            BlocProvider.of<ActiveDetailBloc>(context).add(
                                active_detail_bloc.ShowUploadResultPage(
                                    isNeedResultPage: false));
                          },
                          onAddPhotoFirstTap: () {
                            BlocProvider.of<ActiveDetailBloc>(context)
                                .add(active_detail_bloc.OpenGallery());
                          },
                          onAddPhotoSecondTap: () {
                            BlocProvider.of<ActiveDetailBloc>(context)
                                .add(active_detail_bloc.OpenGallery());
                          },
                          onUploadTap: () async {
                            if (_imageFirst != null) {
                              BlocProvider.of<ActiveDetailBloc>(context).add(
                                  active_detail_bloc.PrepareResultBattle());
                            } else {
                              await Fluttertoast.showToast(
                                  msg: 'Please, upload at least one photo!',
                                  fontSize: 16.0,
                                  gravity: ToastGravity.CENTER);
                            }
                          },
                        )
                      : battleDetailsCard(
                          model: widget.activeModel,
                          width: width,
                          height: height,
                          context: context,
                          currentUserModel: _currentUserModel,
                          messages: _messages.reversed.toList(),
                          chatController: _chatController,
                          onMessageSend: () {
                            BlocProvider.of<ActiveDetailBloc>(context)
                                .add(active_detail_bloc.SendMessageChat());
                          },
                          uploadResultsController:
                              _showUploadResultsPageController,
                          onTapUploadResults: () {
                            BlocProvider.of<ActiveDetailBloc>(context).add(
                                active_detail_bloc.ShowUploadResultPage(
                                    isNeedResultPage: true));
                          },
                          onTapProofImage: (List<String> photos) {
                            BlocProvider.of<ActiveDetailBloc>(context).add(
                                active_detail_bloc.OpenImageZoomDialog(
                                    photos: photos));
                          },
                          distance:
                              distance(distance: widget.activeModel.distance),
                          opponentName: getOpponentName(
                            model: widget.activeModel,
                            currentUserId: widget.currentUserId,
                          ),
                          opponentPhoto: getOpponentPhoto(
                            model: widget.activeModel,
                            currentUserId: widget.currentUserId,
                          ),
                          myProofTime: _resultPhotos.isEmpty
                              ? getMyProofTime(
                                  model: widget.activeModel,
                                  currentUserId: widget.currentUserId,
                                )
                              : _resultTime,
                          myProofsPhoto: getMyProofPhotos(
                            model: widget.activeModel,
                            currentUserId: widget.currentUserId,
                          ).cast<String>(),
                          myProofPhotosLocalStorage: _resultPhotos,
                          opponentProofTime: getOpponentProofTime(
                            model: widget.activeModel,
                            currentUserId: widget.currentUserId,
                          ),
                          opponentProofPhotos: getOpponentProofPhotos(
                            model: widget.activeModel,
                            currentUserId: widget.currentUserId,
                          ).cast<String>(),
                        ),
                );
              }
              return Container(
                width: width,
                height: height,
                color: const Color(0xffF5F5F5),
                child: Center(child: progressIndicator()),
              );
            },
          );
        })));
  }

  Future<TimeOfDay?> getTime({required BuildContext context}) {
    return showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 01, minute: 30),
      confirmText: 'APPLY',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _pickImage({required BuildContext context}) async {
    await _imagePicker
        .pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    )
        .then((XFile? value) async {
      if (value != null) {
        _imageFirst == null
            ? _imageFirst = File(value.path)
            : _imageSecond = File(value.path);
      } else {
        await Fluttertoast.showToast(
            msg: 'No image selected.',
            fontSize: 16.0,
            gravity: ToastGravity.CENTER);
      }
    });
  }

  Future<void> sendMessage(
      {required String message, required String id}) async {
    await widget.signalR
        .sendChatMessage(message: message, id: id)
        .then((dynamic value) {
      dynamic fff = value;
      print('sendMessage $fff');
    });
  }

  Future<void> receiveChatMessage() async {
    await widget.signalR.receiveChatMessage(
        onReceiveChatMessage: (List<Object> arguments) {
      final Object data = arguments[0];
      final Map<dynamic, dynamic> dataMessage = data as Map<dynamic, dynamic>;
      final String message = dataMessage['text'] as String;
      print('receiveChatMessage:: $message');
    });
  }

  void _clearResultsData() {
    if (!_isUploadResultsPage && _imageFirst != null) {
      _imageFirst = null;
    }
    if (!_isUploadResultsPage && _imageSecond != null) {
      _imageSecond = null;
    }

    _resultTime = '01:30';
    _resultTimeForServer = '0001-01-01T01:30:00';
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }
}
