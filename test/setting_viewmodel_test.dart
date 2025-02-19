import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ollama_talk/config/dependencies.dart';
import 'package:ollama_talk/domain/models/ollama_entity.dart';
import 'package:ollama_talk/domain/repository/device_info_repository.dart';
import 'package:ollama_talk/domain/repository/ollama_repository.dart';
import 'package:ollama_talk/domain/repository/preferences_repository.dart';
import 'package:ollama_talk/domain/use_cases/update_host_use_case.dart';
import 'package:ollama_talk/domain/use_cases/watch_selected_model_use_case.dart';
import 'package:ollama_talk/ui/core/base/base_command.dart';
import 'package:ollama_talk/ui/tab/setting/setting_viewmodel.dart';
import 'package:ollama_talk/utils/logger.dart';

@GenerateMocks([
  OllamaRepository,
  PreferencesRepository,
  DeviceInfoRepository,
  WatchOllamaModelsUseCase,
  UpdateHostUseCase,
  UICommandController,
])
import 'setting_viewmodel_test.mocks.dart';

void main() {
  late SettingViewmodel sut;
  late MockOllamaRepository mockOllamaRepository;
  late MockPreferencesRepository mockPreferencesRepository;
  late MockDeviceInfoRepository mockDeviceInfoRepository;
  late MockWatchOllamaModelsUseCase mockWatchOllamaModelsUseCase;
  late MockUpdateHostUseCase mockUpdateHostUseCase;
  late MockUICommandController mockUICommandController;

  setUp(() {
    getIt.reset();

    mockOllamaRepository = MockOllamaRepository();
    mockPreferencesRepository = MockPreferencesRepository();
    mockDeviceInfoRepository = MockDeviceInfoRepository();
    mockWatchOllamaModelsUseCase = MockWatchOllamaModelsUseCase();
    mockUpdateHostUseCase = MockUpdateHostUseCase();
    mockUICommandController = MockUICommandController();

    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<UICommandController>(mockUICommandController);

    when(mockUICommandController.isClosed).thenReturn(false);
    when(mockDeviceInfoRepository.getAppVersion())
        .thenAnswer((_) async => '1.0.0');
    when(mockPreferencesRepository.watch<String>(PreferenceKeys.apiHost))
        .thenAnswer((_) => Stream.value('http://localhost:11434'));
    when(mockPreferencesRepository.watch<String>(PreferenceKeys.themeMode))
        .thenAnswer((_) => Stream.value('dark'));
    when(mockWatchOllamaModelsUseCase.stream).thenAnswer(
      (_) => Stream.value(
        (
          models: [
            OllamaModelEntity(
              name: 'phi4:latest',
              model: 'phi4:latest',
              modifiedAt: DateTime.timestamp(),
              size: 9053116391,
              digest:
                  'ac896e5b8b34a1f4efa7b14d7520725140d5512484457fab45d2a4ea14c69dba',
              details: const OllamaDetailsModelEntity(
                parentModel: '',
                format: 'gguf',
                family: 'phi3',
                families: ['phi3'],
                parameterSize: '14.7B',
                quantizationLevel: 'Q4_K_M',
              ),
            ),
          ],
          selectedModel: null
        ),
      ),
    );

    sut = SettingViewmodel(
      mockOllamaRepository,
      mockPreferencesRepository,
      mockDeviceInfoRepository,
      mockWatchOllamaModelsUseCase,
      mockUpdateHostUseCase,
    );
  });

  tearDown(() async {
    await sut.close();
    await getIt.reset();
  });

  group('SettingViewmodel Tests >', () {
    test('Initial state test', () async {
      // When
      await Future.delayed(const Duration(milliseconds: 100));

      // Then
      expect(sut.state.isLoading, false);
      expect(sut.state.selectedModel, null);
      expect(sut.state.uiError, null);
      expect(sut.state.themeModeList.length, 3);
    });

    test('init() loads app version and theme mode correctly', () async {
      // When
      await sut.init();
      await Future.delayed(const Duration(milliseconds: 100));

      // Then
      expect(sut.state.appVersion, '1.0.0');
      expect(sut.state.themeMode, 'Dark');
      expect(sut.state.baseUrl, 'http://localhost:11434');
      verify(mockDeviceInfoRepository.getAppVersion()).called(2);
    });

    group('URL Update Tests >', () {
      test('Valid URL update', () async {
        // Given
        const validUrl = 'http://test.com';
        when(mockUpdateHostUseCase.execute(validUrl))
            .thenAnswer((_) => Future.value());

        // When
        sut.updateBaseUrl(validUrl);

        // Then
        verify(mockUpdateHostUseCase.execute(validUrl)).called(1);
      });

      test('Invalid URL update', () async {
        // Given
        const invalidUrl = 'invalid-url';

        // When
        sut.updateBaseUrl(invalidUrl);

        // Then
        verifyNever(mockUpdateHostUseCase.execute(any));
      });
    });

    group('Theme Mode Tests >', () {
      test('Theme mode update', () async {
        // Given
        const newThemeMode = 'Light';
        when(
          mockPreferencesRepository.set(
            PreferenceKeys.themeMode,
            newThemeMode,
          ),
        ).thenAnswer((_) => Future.value(true));

        // When
        sut.updateThemeMode(newThemeMode);

        // Then
        verify(
          mockPreferencesRepository.set(
            PreferenceKeys.themeMode,
            newThemeMode,
          ),
        ).called(1);
      });

      test('Theme mode mapping', () {
        expect(sut.mapThemeMode('dark'), 'Dark');
        expect(sut.mapThemeMode('light'), 'Light');
        expect(sut.mapThemeMode('system'), 'System');
        expect(sut.mapThemeMode(null), 'Dark');
      });
    });

    group('Error Handling Tests >', () {
      test('Models load failure', () async {
        // Given
        when(mockWatchOllamaModelsUseCase.stream)
            .thenAnswer((_) => Stream.error('Error loading models'));

        // When
        await sut.init();
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(sut.state.uiError, isA<ModelsLoadFailed>());
      });
    });
  });
}
