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
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/accepted_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/accepted_state.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/bloc.dart'
    as accepted_bloc;
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/extension.dart'
    show UserData, DateTimeExtension;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/accepted'
class AcceptedPage extends StatefulWidget {
  const AcceptedPage({
    Key? key,
    required this.activeModel,
    required this.currentUserId,
    required this.onNeedToRefreshActivePage,
  }) : super(key: key);

  final BattleRespondModel activeModel;
  final String currentUserId;
  final VoidCallback onNeedToRefreshActivePage;

  @override
  _AcceptedPageState createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  final TextEditingController _chatController = TextEditingController();
  final RoundedLoadingButtonController _showUploadResultsPageController =
      RoundedLoadingButtonController();

  List<Messages> _messages = <Messages>[];
  final List<String> _resultPhotos = <String>[];

  final InteractApi _interactApi = InteractApi();

  late UserModel _currentUserModel;

  String _resultTime = '01:30';
  String _resultTimeForServer = '0001-01-01T01:30:00';

  bool _isUploadResultsPage = false;
  bool _isUploadingProgress = false;

  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFirst;
  File? _imageSecond;

  @override
  void initState() {
    super.initState();
    _currentUserModel = PreferenceUtils.getCurrentUserModel();
    // getOpponentMessages();
  }

  // TODO(Issa): complete get Message 'Put it in Widget build(BuildContext context) FutureBuilder above BlocProvider'
/*  Future<void> getOpponentMessages() async {
    await _interactApi
        .getOpponentChatMessages(
            opponentId: getOpponentId(
                model: widget.activeModel, currentUserId: widget.currentUserId))
        .then((OpponentChatModel? value) {
      if (value != null) {
        messages = value.messages.cast<Messages>();
      } else {}
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<OpponentChatModel?>(
        future: _interactApi.getOpponentChatMessages(
            opponentId: getOpponentId(
                model: widget.activeModel,
                currentUserId: widget.currentUserId)),
        builder:
            (BuildContext context, AsyncSnapshot<OpponentChatModel?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _messages = snapshot.data!.messages.cast<Messages>();
            return BlocProvider<AcceptedBloc>(
              create: (final BuildContext context) => AcceptedBloc(),
              child: BlocListener<AcceptedBloc, AcceptedState>(
                listener: (final BuildContext context,
                    final AcceptedState state) async {
                  if (state is ResultBattlePrepared) {
                    _isUploadingProgress = true;
                    await _interactApi
                        .sendResultPhoto(fileImage: _imageFirst)
                        .then((String? photoFirst) async {
                      if (photoFirst != null) {
                        _resultPhotos
                            .add(photoFirst.replaceAll(RegExp(r'\"'), ''));

                        if (_imageSecond != null) {
                          await _interactApi
                              .sendResultPhoto(fileImage: _imageSecond)
                              .then((String? photoSecond) {
                            if (photoSecond != null) {
                              _resultPhotos.add(
                                  photoSecond.replaceAll(RegExp(r'\"'), ''));
                            }
                          });
                        }
                      }
                    });
                    BlocProvider.of<AcceptedBloc>(context)
                        .add(accepted_bloc.UploadResultBattle());
                  } else if (state is ResultBattleUploaded) {
                         await _interactApi.sendBattleResult(model: BattleResultModel(
                     photos: _resultPhotos,
                     time: _resultTimeForServer,
                   ), id: widget.activeModel.id).then((bool value){
                     var ddv = value;
                   });
                    _isUploadingProgress = false;
                    widget.onNeedToRefreshActivePage();
                    BlocProvider.of<AcceptedBloc>(context).add(
                        accepted_bloc.ShowUploadResultPage(
                            isNeedResultPage: false));
                  } else if (state is UploadResultPageShown) {
                    _isUploadResultsPage = state.isNeedResultPage;
                    _clearResultsData();
                  } else if (state is TimePickerOpened) {
                    final TimeOfDay? time = await getTime(context: context);
                    if (time != null) {
                      _resultTime = getFormattedTimeForUser(time: time);
                      _resultTimeForServer =
                          getFormattedTimeForServer(time: time);
                    }
                  } else if (state is GalleryIsOpened) {
                    await _pickImage(context: context);
                  }
                  BlocProvider.of<AcceptedBloc>(context)
                      .add(accepted_bloc.UpdateState());
                },
                child: BlocBuilder<AcceptedBloc, AcceptedState>(builder:
                    (final BuildContext context, final AcceptedState state) {
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
                              BlocProvider.of<AcceptedBloc>(context)
                                  .add(accepted_bloc.OpenTimePicker());
                            },
                            onCancelTap: () {
                              BlocProvider.of<AcceptedBloc>(context).add(
                                  accepted_bloc.ShowUploadResultPage(
                                      isNeedResultPage: false));
                            },
                            onAddPhotoFirstTap: () {
                              BlocProvider.of<AcceptedBloc>(context)
                                  .add(accepted_bloc.OpenGallery());
                            },
                            onAddPhotoSecondTap: () {
                              BlocProvider.of<AcceptedBloc>(context)
                                  .add(accepted_bloc.OpenGallery());
                            },
                            onUploadTap: () async {
                              if (_imageFirst != null) {
                                BlocProvider.of<AcceptedBloc>(context)
                                    .add(accepted_bloc.PrepareResultBattle());
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
                            messages: _messages,
                            chatController: _chatController,
                            onMessageSend: () {},
                            uploadResultsController:
                                _showUploadResultsPageController,
                            onTapUploadResults: () {
                              BlocProvider.of<AcceptedBloc>(context).add(
                                  accepted_bloc.ShowUploadResultPage(
                                      isNeedResultPage: true));
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
                }),
              ),
            );
          }
          return Container(
            width: width,
            height: height,
            color: const Color(0xffF5F5F5),
            child: Center(child: progressIndicator()),
          );
        });
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
        .pickImage(source: ImageSource.gallery)
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
