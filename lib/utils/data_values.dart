import 'package:flutter/material.dart';
import 'package:one2one_run/resources/images.dart';

mixin DataValues {
  static Map<int, Map<String, dynamic>> battleStatusLabels =
      <int, Map<String, dynamic>>{
    0: proposedData,
    1: negotiateData,
    2: acceptedData,
    3: declinedData,
    4: deadlineData,
    5: finishedData,
    6: discardedData,
  };

  static Map<String, dynamic> proposedData = <String, dynamic>{
    'title': 'Proposed',
    'icon': proposedIcon,
    'color': const Color(0xffEDEDED),
  };
  static Map<String, dynamic> negotiateData = <String, dynamic>{
    'title': 'Negotiate',
    'icon': negotiateIcon,
    'color': const Color(0xffEDEDED),
  };
  static Map<String, dynamic> acceptedData = <String, dynamic>{
    'title': 'Accepted',
    'icon': acceptedIcon,
    'color': const Color(0xffCFFFB1),
  };
  static Map<String, dynamic> declinedData = <String, dynamic>{
    'title': 'Declined',
    'icon': declinedIcon,
    'color': const Color(0xffFFBABA),
  };
  static Map<String, dynamic> deadlineData = <String, dynamic>{
    'title': 'Deadline',
    'icon': deadlineIcon,
    'color': const Color(0xffFFBABA),
  };
  static Map<String, dynamic> finishedData = <String, dynamic>{
    'title': 'Finished',
    'icon': finishedIcon,
    'color': const Color(0xffCFFFB1),
  };
  static Map<String, dynamic> discardedData = <String, dynamic>{
    'title': 'Discarded',
    'icon': discardedIcon,
    'color': const Color(0xffFFBABA),
  };

  static Map<int, Map<String, dynamic>> battleUserStatusLabel =
      <int, Map<String, dynamic>>{
    0: wonData,
    1: lostData,
    2: drawData,
  };

  static Map<String, dynamic> wonData = <String, dynamic>{
    'title': 'Winner',
    'icon': wonIcon,
    'color': const Color(0xffCFFFB1),
  };
  static Map<String, dynamic> lostData = <String, dynamic>{
    'title': '2nd place',
    'icon': lostIcon,
    'color': const Color(0xffFFBABA),
  };

  // TODO(action): need icon and action when to show.
  static Map<String, dynamic> drawData = <String, dynamic>{
    'title': 'Draw',
    'icon': wonIcon,
    'color': const Color(0xffCFFFB1),
  };

  static Map<String, dynamic> resultImagesApprovalState = <String, dynamic>{
    'title': 'Approved',
    'icon': approveResultIcon,
    'color': const Color(0xff1BCE2D),
  };
  static Map<String, dynamic> resultImagesPendingState = <String, dynamic>{
    'title': 'Pending approval',
    'icon': pendingResultIcon,
    'color': const Color(0xffC4C4C4),
  };

  static Map<String, dynamic> resultImagesRejectedState = <String, dynamic>{
    'title': 'Rejected',
    'icon': rejectResultIcon,
    'color': const Color(0xffFA1A1A),
  };
}
