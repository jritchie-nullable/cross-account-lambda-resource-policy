import { LambdaClient, InvokeCommand } from "@aws-sdk/client-lambda";

export const handler = async (event) => {
	const client = new LambdaClient();

	const [developmentResp, testingResponse, productionResp] = await Promise.all([
		client.send(
			new InvokeCommand({
				FunctionName: process.env.DEVELOPMENT_ARN,
				InvokeArgs: "[]",
			}),
		),
		client.send(
			new InvokeCommand({
				FunctionName: process.env.TESTING_ARN,
				InvokeArgs: "[]",
			}),
		),
		client.send(
			new InvokeCommand({
				FunctionName: process.env.PRODUCTION_ARN,
				InvokeArgs: "[]",
			}),
		),
	]);

	console.log(
		"\nDevelopment\n",
		new TextDecoder().decode(developmentResp.Payload),
		"\nTesting\n",
		new TextDecoder().decode(testingResponse.Payload),
		"\nProduction\n",
		new TextDecoder().decode(productionResp.Payload),
	);

	return "";
};
