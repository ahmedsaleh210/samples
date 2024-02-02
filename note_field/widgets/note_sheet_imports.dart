import 'dart:developer';

import 'package:cattle_management/src/core/extensions/padding_extension.dart';
import 'package:cattle_management/src/core/extensions/sized_box_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../features/cattle_health/data/models/local/note_model.dart';
import '../../../../features/cattle_health/presentation/widgets/cattle_health_widgets_imports.dart';
import '../../../../features/cattle_health/presentation/widgets/default_bottom_sheet_skelton.dart';
import '../../../extensions/validators.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../app_text.dart';
import '../../audio_wave_slider.dart';
import '../../default_text_field.dart';
import '../../filter_bottom_sheet/filter_bottom_sheet_imports.dart';
import '../../home_voice_note.dart';
import '../cubit/note_cubit.dart';
import '../cubit/note_state.dart';

part 'note_field.dart';
part 'text_note_bottom_sheet.dart';
part 'voice_bottom_sheet.dart';
part 'audio_container.dart';
