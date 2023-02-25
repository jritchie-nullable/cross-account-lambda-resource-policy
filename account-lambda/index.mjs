import { STSClient, GetCallerIdentityCommand } from "@aws-sdk/client-sts";

export const handler = async (event) => {
	const client = new STSClient();
	const data = await client.send(new GetCallerIdentityCommand());

	return { message: "Hello", account: data.Account };
};
