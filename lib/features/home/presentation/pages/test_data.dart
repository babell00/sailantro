import 'dart:ui';

import '../../../../themes/light_mode.dart';
import '../../domain/models/challenge.dart';
import '../../domain/models/question.dart';
import '../../domain/models/section.dart';

final testData = <Section>[
  Section(
    id: 'sec_safety_equipment',
    unit: 1,
    index: 1,
    title: 'Safety equipment',
    colorArgb: lightMode.colorScheme.primary.value,
    challenges: [
      Challenge(
        id: 'ch_safety_intro',
        title: 'Safety Gear · Intro',
        order: 100,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_lifejackets_required',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'When should you wear a lifejacket?',
            payload: {
              'options': [
                'Only at night',
                'Only offshore',
                'When on deck',
                'All of the above',
              ],
              'answerIndex': 3,
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_liferaft_basics',
        title: 'Liferaft Basics',
        order: 200,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_liferaft_check',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'How often should a liferaft be serviced?',
            payload: {
              'options': ['Monthly', 'Annually', 'Every 3–5 years', 'Never'],
              'answerIndex': 2,
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_ppe_match',
        title: 'PPE Match',
        order: 300,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_ppe_match',
            type: QuestionType.matchPairs,
            order: 100,
            stem: 'Match item to purpose.',
            payload: {
              'pairs': [
                ['Jackstay', 'Clip-on tether run'],
                ['Whistle', 'Sound signal on LJ'],
                ['Sprayhood', 'Protect face in waves'],
              ],
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_safety_review',
        title: 'Safety Review',
        order: 400,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_safety_multi',
            type: QuestionType.mcqMulti,
            order: 100,
            stem: 'Select all items found in a liferaft grab bag.',
            payload: {
              'options': ['Flares', 'EPIRB', 'Kettle', 'Sea anchor'],
              'correctIndexes': [0, 1, 3],
            },
          ),
        ],
      ),
    ],
  ),

  Section(
    id: 'sec_distress_signals',
    unit: 1,
    index: 2,
    title: 'Distress signals',
    colorArgb: lightMode.colorScheme.secondary.value,
    // orange
    challenges: [
      Challenge(
        id: 'ch_flares',
        title: 'Flares & Smoke',
        order: 100,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_distress_flare',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'Which is a recognized distress signal?',
            payload: {
              'options': [
                'Red hand flare',
                'White torch light',
                'Morse X with arms',
              ],
              'answerIndex': 0,
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_radio_mayday',
        title: 'MAYDAY Voice',
        order: 200,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_mayday_order',
            type: QuestionType.ordering,
            order: 100,
            stem: 'Order a MAYDAY voice call.',
            payload: {
              'items': [
                'MAYDAY ×3',
                'Vessel name & call sign',
                'Position',
                'Nature of distress',
                'Assistance required',
              ],
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_dsc_basics',
        title: 'DSC Basics',
        order: 300,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_dsc_true_false',
            type: QuestionType.mcqSingle,
            order: 100,
            stem:
                'True or false: A DSC distress alert transmits your position automatically.',
            payload: {
              'options': ['True', 'False'],
              'answerIndex': 0,
            },
          ),
        ],
      ),
    ],
  ),

  Section(
    id: 'sec_lifejackets',
    unit: 1,
    index: 3,
    title: 'Lifejackets',
    colorArgb: lightMode.colorScheme.tertiary.value,
    // green
    challenges: [
      Challenge(
        id: 'ch_lj_types',
        title: 'Types & Buoyancy',
        order: 100,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_150n_when',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'When is a 150N lifejacket typically recommended?',
            payload: {
              'options': [
                'Inland lakes',
                'Sheltered bays',
                'Coastal/offshore',
                'Never',
              ],
              'answerIndex': 2,
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_lj_care',
        title: 'Care & Servicing',
        order: 200,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_co2_check',
            type: QuestionType.mcqMulti,
            order: 100,
            stem: 'What should you check on an inflatable lifejacket?',
            payload: {
              'options': [
                'CO₂ cylinder tightness',
                'Auto cartridge expiry',
                'Top-up with air weekly',
              ],
              'correctIndexes': [0, 1],
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_lj_fit',
        title: 'Fitting & Adjustment',
        order: 300,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_crotch_straps',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'Crotch straps are important because…',
            payload: {
              'options': [
                'They look cool',
                'They prevent the jacket riding up in water',
                'They reduce buoyancy',
              ],
              'answerIndex': 1,
            },
          ),
        ],
      ),
    ],
  ),

  Section(
    id: 'sec_fire',
    unit: 1,
    index: 4,
    title: 'Fire & extinguishers',
    colorArgb: const Color(0xFF5D7A9F).value,
    // purple
    challenges: [
      Challenge(
        id: 'ch_classes_of_fire',
        title: 'Classes of Fire',
        order: 100,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_class_b',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'Class B fires involve…',
            payload: {
              'options': ['Wood/paper', 'Flammable liquids', 'Gases'],
              'answerIndex': 1,
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_ext_match',
        title: 'Extinguisher Match',
        order: 200,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        questions: const [
          Question(
            id: 'q_ext_match',
            type: QuestionType.matchPairs,
            order: 100,
            stem: 'Match extinguisher to fire.',
            payload: {
              'pairs': [
                ['CO₂', 'Electrical'],
                ['Foam', 'Fuel'],
                ['Water', 'Solid materials'],
              ],
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_eng_compartment',
        title: 'Engine Compartment',
        order: 300,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        isLocked: true,
        questions: const [
          Question(
            id: 'q_never_open',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'During an engine fire you should…',
            payload: {
              'options': [
                'Open the hatch wide',
                'Starve oxygen and use fire port',
                'Spray water from above',
              ],
              'answerIndex': 1,
            },
          ),
        ],
      ),
    ],
  ),

  Section(
    id: 'sec_engine_mob',
    unit: 1,
    index: 5,
    title: 'Engine checks & MOB',
    colorArgb: const Color(0xFFC75D5F).value,
    // red
    challenges: [
      Challenge(
        id: 'ch_prestart',
        title: 'Pre-start Checks',
        order: 100,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        isLocked: true,
        questions: const [
          Question(
            id: 'q_prestart_list',
            type: QuestionType.mcqMulti,
            order: 100,
            stem: 'Select the common pre-start checks.',
            payload: {
              'options': [
                'Oil level',
                'Coolant level',
                'Prop pitch',
                'Fuel shut-off open',
              ],
              'correctIndexes': [0, 1, 3],
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_mob_sight',
        title: 'MOB – First Actions',
        order: 200,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        isLocked: true,
        questions: const [
          Question(
            id: 'q_mob_order',
            type: QuestionType.ordering,
            order: 100,
            stem: 'Order the first actions in an MOB.',
            payload: {
              'items': [
                'Shout “Man overboard!”',
                'Throw lifebuoy',
                'Press MOB on GPS',
                'Keep pointing at casualty',
              ],
            },
          ),
        ],
      ),
      Challenge(
        id: 'ch_pickup',
        title: 'Pick-up Under Power',
        order: 300,
        iconPath: 'assets/svg/chip/chip_4ECDC4.svg',
        isLocked: true,
        questions: const [
          Question(
            id: 'q_approach_side',
            type: QuestionType.mcqSingle,
            order: 100,
            stem: 'Preferred side to recover under power (typical yacht)?',
            payload: {
              'options': ['Leeward side', 'Windward side'],
              'answerIndex': 0,
            },
          ),
        ],
      ),
    ],
  ),
];
