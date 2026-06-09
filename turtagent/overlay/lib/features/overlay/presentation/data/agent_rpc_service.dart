import 'package:grpc/grpc.dart';
import 'package:turtagent/generated/protobuf/turtagent.pbgrpc.dart';

class AgentRpcService {
  late ClientChannel _channel;
  late TurtAgentStreamServiceClient _client;

  AgentRpcService() {
    _channel = ClientChannel(
      'localhost',
      port: 50707,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _client = TurtAgentStreamServiceClient(_channel);
  }

  Stream<String> streamPrompt(String userPrompt) async* {
    final request = PromptRequest()..prompt = userPrompt;

    try {
      final responseStream = _client.generateResponse(request);

      await for (final response in responseStream) {
        if (response.textChunk.isNotEmpty) {
          yield response.textChunk;
        }

        if (response.isFinal) break;
      }
    } catch (error) {
      yield 'Error: Lost connection to turtagent daemon';
    }
  }

  Future<void> shutdown() async {
    await _channel.shutdown();
  }
}
