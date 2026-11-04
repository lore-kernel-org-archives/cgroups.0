Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793800319;
	b=kIQDX7FHPagQtiv8w0dJLmPhCCAbgjjdrNrpV3pHAUJ4+wjS1U6yvmwrUxuXE/0mU62t
	 y41yIuUFMCwzishko8VW/BcXIfcw2izxUJnlHtepHgajOTB4JrFfkUE44alp9cmoRaYu7
	 EjaS890jfHhk3CTkNuP/8bCS3hwTSVwG8oyTKrXHZWF9P4KqelVwkiJQ1oXkTjeMxsgp7
	 6YtehvkiyJOC3s5sPbuv+YUJyuJM3P+8kZ7h7RSyLy7DvsaC+OVeXpbZ7tm5S8/IDZ8Yw
	 N8+Pul6gX/x/u4ICGr850fvClFNZptVkV4aPJ9fOZdveAoEhJ6/HYH/WV28PjNtjqew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800319;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=mQtJKixgze7C+diWpLN9bp2gmSFhvKu0oFRTq7AaEEA=;
	b=YhofC9YBe9XAagT5Yfwuumxd/JC8kx7mODJy2sZ8J8gLo1AortwrEaCLaMSZe3YIZU7g
	 Txb2x6ncWxNF4BLcR152yslH+rJ2rrKVjWM1KcvL1cS6k0/ViK2Xxaa67JTgZe/JU4mtM
	 ihhdaJ9Jb8FwFIts35PvrQFrad7wfst95l7HKY5QQcbwnEAT14bgIaIBQgca11xLfv75g
	 Nsp5P5TiqYp0d8EjZFm9rBHHe6qlPwmX0se2tbbXMvzSq2iqnYOtD1e7UEydwxEmX+M3b
	 1nmjy+4tf4HGCG4oty0/neJzuRsSSNqQh9iMzIeKueSYKXZlPtkA6NjDlI95/OUgETw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=1OaV7a26;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.26
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A2606A31B;
	Wed,  4 Nov 2026 13:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 827A2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=1OaV7a26
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fwlrplglXoh9OyjK5tR8CAVbMbWktw9uFYFeNSHJvwGJ6DkHw5K7lbE9u/0Tbeg0GuJpfAQ0DM+niGciw4x8V57/ewqSGdo6Uu6Gj7GfEZsxws0lnruQXzrDGFNP+uCFaPnt63QckclpYwFSdePxd3NN7erCxuhk3D0J0dkyHfEboL+7dZrQtoas+CSPVf7pQHO29Jp4vngicwOSs9Iza9Jkn49P1c+sdpJdW/N6BoO/QznG37XJCLicoM9/Atf0ESIlCZdLjLBjfnQ0gtwuB6YclmswwLzgrTghAqSWXgOv4DA1Y1F6306oniarI3zwBqP62bf1bpIUUuhtRUlVXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQtJKixgze7C+diWpLN9bp2gmSFhvKu0oFRTq7AaEEA=;
 b=d0HeySeTfz4nN+X2kqhvBEsxytSTgVNh3MSxaO9/DsG9ALP2mlHiEvyzQoL6tRGw7w7JPCvBFca2gwurXJWCs0Q22jg5VEJbAlubvmj7zTC8drKFyl7TN+Au4wGjyfvHbJ91GyVN9D47edqL2FpnbVpK8qZlHK46HrhTgxzIuCv1c4I3QUMALPcvj4MXlze6SZUYkLeOoTG8t0lvva4YHeKf8ooCi4dbkMAwpBuWGEh4JtzrZeWXqRSNBELSeuo9L0HUlhMeFyxhRDYmR8hcVr6A+beAnEl0Es75IEWfwEuxHT2xxwf7Aa7fUbFgjJeX5sTy8Uiu8KAThXEnThXk5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQtJKixgze7C+diWpLN9bp2gmSFhvKu0oFRTq7AaEEA=;
 b=1OaV7a26aooUI4kXc46/YIBQOwvrUIdoGhyzhFxSpxgIEVSt4U2yJeUY/fSt5uSa5+GnmHRtNhKQU4V3Sfrs3Wf6vxVqL52H3qHecHZHh61/Fya8ToXnrPPOZw1D+aM4lJaE/5AgJPEhe+U+obCr80cQ0PbpgDd/hbDHVIqTHk4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB7885.namprd12.prod.outlook.com (2603:10b6:510:28f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 13:51:54 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 13:51:53 +0000
Message-ID: <fb40349c-18d2-45d6-9278-8f20e1b8dc74@amd.com>
Date: Wed, 4 Nov 2026 14:51:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>, Christian Brauner
 <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 op-tee@lists.trustedfirmware.org
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0334.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::10) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB7885:EE_
X-MS-Office365-Filtering-Correlation-Id: dd9bb6a9-3177-4234-7703-08df3a7ac85d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261022105027099003|261021123027099003|261021121427099003|261026121527099003|261009223027099003|921020|261026140227099003|261028144727099003|261102123227099003|261102130727099003|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003|261009221227099003;
X-Microsoft-Antispam-Message-Info:
	96/w4GoXA1uytAjAlaICjVANUoJGVhgUQ+B3edILtpMDdjhiIjrsi46l2ZvZbjLMyVtOK5RW6WCckTqoBlY6+3IUXaDW3P6593qCDRzUVJDSbEuOrZvslLqH5q3g4Tecn72FKzZ0S29pe4QfjmTpa5OnM2rMhSXbD/hpbbEXsfmSZMt6aukZ8wF0GlWPYCPN52PMLFrTk7biBJOUrj1D+aZ2hMLA3g5Th6CDqkZAV0qypC4qV+36Na1itA0xq8ixdMfx6EFHEMSS65pAQxqF1/hwEAnrs5rRxKJl4GyUtwed0jd2ZkbRXOidjMnSyx3FzAgAiXqIv9kAms1vTRcix3IAbuIZ9FLLfXDhDq9JApTwC+M1pYchghPpXHzPSiFZVc/h0sy07s8m0cVbQ7+x6vXykGfZscTQ3E1FDfrpmRMPSDVYYOx+kk1qbzHRGk4S8w7z57H1B2s6maq1axZIhQwTe0NNnFHAjmTC43ArwnooMsNRuZsW073HDWp1/ErBrdzlRpJBQ6MJ6KX2nJrALIvtsKU4IFcm+arQD6SB9nONco4NjD1YCuHYivFh/XEYogsrI8RT61L00ZqYfLqyXgYvkkSwjjxc2bQ/R4TwDvMi+c32ap+8oHdINZUQe0wNkrKVl5ubWP7eFPVf5hIYRQtvQIWAEgImiXiLqDezdG/82ORn6zwq7EoIuayAIVO1+JgCCb0c8wHjj6dxtwNhPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261022105027099003)(261021123027099003)(261021121427099003)(261026121527099003)(261009223027099003)(921020)(261026140227099003)(261028144727099003)(261102123227099003)(261102130727099003)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tml0N01Kd2FnaFJ2bjMwTDI0VUY1d2FKNklkWnRjdnJlc2d1ZjdpUy8rdlo3?=
 =?utf-8?B?RVIvd243dmE2OVpNSXVONGdxVFRva3pKeDM5ZmVBZVF4WkFyZmMySDU0RitH?=
 =?utf-8?B?YnVTeEVXTk5FWkU3Z21ZeEtIeEVhcHhJZ3dwSThyV3FOeEMzQXgreG9QTjRG?=
 =?utf-8?B?ODR3V1c5c1lib2lSNWtsRDRoc3U0eWRoNTdOWU10dUZYcVFTdmh6TjFiOThm?=
 =?utf-8?B?Y2p0N3QyL3VXQUdwVXFpa1hJMVJsQi91aG5EdTEyaVBhV0tuT1l4alp1U1Uz?=
 =?utf-8?B?L3VYTDNWUE9UTkhndmxDdXNwNjVkcXJuc3NIOFNCVWZRSzJvdXk0QXRrZnE4?=
 =?utf-8?B?OVl2cmdIditoOHZsdEpaTmpjUGd2Q2VzNWNodHdwQTJYRm54K3RKK3FaNEV4?=
 =?utf-8?B?NnNUSHZWRDhvRitLcUVtOEt1NUY4UDVBalZrakFoRHgvWm5vbU1vdU51cWIx?=
 =?utf-8?B?VkNUd1ZYd21SUlZ0Q2RrV2dVT2tycVV6dUI3ZWZEQnZHRzFGbllGS0k1bkVq?=
 =?utf-8?B?eTF1dnJKUnpiVi9ndkRpNFgwM2swTDFaWncra2V3NHRVMC90UGczZnA2cE5q?=
 =?utf-8?B?QTVzTDZYemZiZHlOY2ljZHlBMU9BcWhxUlJ0R093c3B2cUpmL3YvMDN6bGN2?=
 =?utf-8?B?M3dWWXBZTCtNMzVMaHNmYmgxUSsrNmM1TStQMk9yR0F0N1h5bVc0cDUweWMw?=
 =?utf-8?B?bTZ5MUxPT1U3cXJCU2pjdVZ6eHpCbDlnUnYva3g1Mk01U2FXbDdkN2YxZWlz?=
 =?utf-8?B?ZnFtYWRpMGk3ZTNDMlpXQy9GanFra3A5bFIzQW9QeE5nSngyT05GQXdUUHBp?=
 =?utf-8?B?V0l0cEZpUnBDY3VxSXRzRittSEM5OXBoSzFlQ1l5REsvVjRpdldSZjIrSmV0?=
 =?utf-8?B?RHQwMXFxYjVaNkNSN2ZXcWxMOWxoSnlENnd1T2RVWjFVSlNQYTNMbzdzdUEz?=
 =?utf-8?B?RWsvY2s0UXZpcHNQaHdoRjc5bTJWaW5zNG8rVDh4NGo1dC9zWnlMYjBzV3NF?=
 =?utf-8?B?QVlCR3NGWGtCRFdEMU00akorRUdpQmdKZ05qdFdXa3RCamJtNTFZMzI4bnJI?=
 =?utf-8?B?aEhiWHI1UEVadENCejNiekhzRXpLb1EzU2lFSjFTYTVzeWhnSUh3VGtZT25U?=
 =?utf-8?B?VUVPSWo2U2RHbW9pM3FEWlg2QjdoeitQTE5SSnZEakl4Q2p2ekVnZXo0bFdP?=
 =?utf-8?B?SjZ4QU8rVWF1V2ZOU2lBVlRib1JNUXpSSFR1NFZhTm5yK2trOTRjU0x3cnZO?=
 =?utf-8?B?RjI4ZWViWk0vNktHNzNqS1pnRUZPaEdxSHZIaTBnL2dDUEZiM2IyVVNYTno1?=
 =?utf-8?B?TG1IMzlkZGxsVmxhUWN4RDlvSHVrUVdBRDBwRDFoaXFWeVF0VUwzVUVEbncy?=
 =?utf-8?B?bE8xMGVXZEpITzJaVUFPOWtZV3N5L0lPeTRwTDVHZUxYdkNybzhYR01xNlI2?=
 =?utf-8?B?Q3BUWnlZWVNsQjd4ZmdsNEJQWFgzN1RNOXNqNGUrMHZhK293QktRaU0yaHZ6?=
 =?utf-8?B?VGNvcllrb1piNVY0blBaSmQzOU12OE1oZWx6MnFMY2lrd0xRYkNlVjIxWHVR?=
 =?utf-8?B?NUpRWFI4VFhHTE5FdFZ1UldDZ3o0VDBVZGUvZHpNalE5VE50K0cxQ2QrcHRw?=
 =?utf-8?B?SitsNzNnRXdGR0pnN25LYlhuWFZ5Nm1DTEFFek5xemFYUWJYcnEvWWFoOVFq?=
 =?utf-8?B?S2lpeFpQTlpOaUI0SG93YnN5czVQamxxdGdIOEpBQ3A5cXNSWW1xb3NUNGlG?=
 =?utf-8?B?M0JpVFBEWUVNYUxzKzRFRDJNWERQZGxFcFdnSml5VTBpUnAzYWIyakVVWnF0?=
 =?utf-8?B?YVVIRUg4Q3paOXlMaldzVFUzTWRnL3U3ZlNSbVMrM0JuVFdiNVlFcnJ1V3lR?=
 =?utf-8?B?dk9Rb1N5MVluVURvRkNKWW9RQXJrRHdKc00rdnA3MG5KQnhqNHdacXVVcmgw?=
 =?utf-8?B?aWV0UEorVGs3dDdZSmNubHdkWUN4NUtHc1VIZk5HRzlSbllwZ0xSN3RKdG54?=
 =?utf-8?B?b21meUl1K1FrUVFKalNPZS8zTi9FM2xPQ3ZseGNTUGNFNlRSZmlLZFZ4aW8v?=
 =?utf-8?B?UmJtdG1GbVhoeFdvZWpkZHh6RTYvUnRSdnRkNCtESkxMeExKTFVSSTNCUXlS?=
 =?utf-8?B?VVJ2eDZiVkxkWWRrb0NZMGNXMVNKcC9sREZwcDV6bVhmSWFDUnF0Z0VlREQ1?=
 =?utf-8?B?QnM2ZW9RNWVWN0hoM2RVNzhqSWNaSWVLU08ydkN5MHVyc1p3MTF5dEZwOXgz?=
 =?utf-8?B?Ry80amUzVEJYWjJqdmwxbWFsWkVTTGxTWkFsWk5qMmpjallCdmFuRTFKeWJY?=
 =?utf-8?Q?2Pylw29bJiUZ3VhooJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9bb6a9-3177-4234-7703-08df3a7ac85d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 13:51:53.3435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IadmT3l8oiO2qnIkVu2dbS/48UcoHNhnw+j+DT0Zya9ULx2PgyZc+8BlUvhXyMR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7885

On 11/4/26 12:09, Albert Esteve wrote:
> dma-heap already supports charging a specific cgroup at allocation
> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> originate from any exporter (DRM, V4L2, etc.), and the allocator may
> not know the final owner at allocation time.
> 
> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> to a different cgroup after allocation. The target is identified by
> charge_fd, which may be a cgroupfd or a pidfd.
> 
> The transfer charges the new cgroup before uncharging the old one,
> preserving the original charge on failure. Concurrent transfers are
> serialized by the dma-buf reservation lock, so lockdep covers the
> locking order of the charge path early. The transfer implementation
> is generic (mem_cgroup_transfer_charge) and not dma-buf specific, so
> it can be reused by other subsystems.
> 
> Not all dma-buf exporters back their buffers with reclaimable system
> memory. Some represent device registers, VRAM, or carved-out pools
> where size is not a meaningful memory cost. The xfer ioctl returns
> -EOPNOTSUPP for buffers whose memcg is not set. Exporters opt in by
> passing a memcg through dma_buf_export_info at export time. Currently
> only the system heap sets it, other exporters can opt in as needed.
> 
> Usage example:
>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> 
>   struct dma_buf_transfer_charge xfer = {
>       .charge_fd = cg_fd,
>   };
>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
>   /* charge now on app1's cgroup */
>   close(cg_fd);
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  drivers/dma-buf/dma-buf.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h      |  3 ++-
>  include/linux/memcontrol.h   | 13 +++++++++++++
>  include/uapi/linux/dma-buf.h | 26 ++++++++++++++++++++++++++
>  mm/memcontrol.c              | 42 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 125 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 837666273550..3bd26fbb1109 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
>  }
>  #endif
>  
> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> +				const void __user *user_data)
> +{
> +	struct dma_buf_transfer_charge arg;
> +	struct mem_cgroup *memcg;
> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> +	int ret = 0;
> +
> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (!IS_ENABLED(CONFIG_MEMCG))
> +		return 0;
> +
> +	if (arg.flags != 0)
> +		return -EINVAL;
> +
> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
> +	if (IS_ERR(memcg))
> +		return PTR_ERR(memcg);
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +
> +	if (!dmabuf->memcg) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (dmabuf->memcg != memcg &&
> +	    !mem_cgroup_transfer_charge(&dmabuf->memcg, memcg, MEMCG_DMABUF, nr_pages))

Please move the calculation of nr_pages after taking the dma_resv_lock().

We currently don't have anybody dynamically changing DMA-buf sizes but just to be on the save side.

With that done Reviewed-by: Christian König <christian.koenig@amd.com>

Regards,
Christian.

> +		ret = -ENOMEM;
> +
> +out:
> +	dma_resv_unlock(dmabuf->resv);
> +	mem_cgroup_put(memcg);
> +	return ret;
> +}
> +
>  static long dma_buf_ioctl(struct file *file,
>  			  unsigned int cmd, unsigned long arg)
>  {
> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
>  #endif
>  
> +	case DMA_BUF_IOCTL_XFER_CHARGE:
> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> +
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 85dd747c9b36..b01149d26b44 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -507,7 +507,8 @@ struct dma_buf_attachment {
>   * @priv:	Attach private data of allocator to this buffer
>   * @memcg:	memcg to charge for this buffer's memory. Set only for
>   *		buffers backed by system memory where @size reflects the
> - *		actual allocation in bytes.
> + *		actual allocation in bytes. Enables charge transfer via
> + *		DMA_BUF_IOCTL_XFER_CHARGE.
>   *
>   * This structure holds the information required to export the buffer. Used
>   * with dma_buf_export() only.
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f8ec751b7d7b..af02d9777fe9 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -676,6 +676,11 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
>  bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
>  			       unsigned int nr_pages);
>  
> +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> +				struct mem_cgroup *new_memcg,
> +				enum memcg_stat_item item,
> +				unsigned int nr_pages);
> +
>  void __mem_cgroup_uncharge(struct folio *folio);
>  
>  /**
> @@ -1197,6 +1202,14 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
>  {
>  }
>  
> +static inline bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> +					      struct mem_cgroup *new_memcg,
> +					      enum memcg_stat_item item,
> +					      unsigned int nr_pages)
> +{
> +	return true;
> +}
> +
>  static inline void mem_cgroup_uncharge(struct folio *folio)
>  {
>  }
> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> index e827c9d20c5d..0aaf2e7d593b 100644
> --- a/include/uapi/linux/dma-buf.h
> +++ b/include/uapi/linux/dma-buf.h
> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
>  	__s32 fd;
>  };
>  
> +/**
> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> + *
> + * Any holder of a dma-buf file descriptor can perform a
> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> + * cost to a specific cgroup, or move it from one cgroup to
> + * another.  The ioctl charges the new cgroup before uncharging
> + * the old one atomically.  On failure the original charge is
> + * preserved.  If the buffer has no existing memcg charge, the
> + * ioctl returns -EOPNOTSUPP.
> + */
> +struct dma_buf_transfer_charge {
> +	/** @flags: Reserved, must be zero */
> +	__u32 flags; /* unused for now */
> +	/**
> +	 * @charge_fd: File descriptor identifying the target cgroup.
> +	 *
> +	 * May be either a pidfd, in which case the charge moves to the
> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> +	 * by opening a cgroup v2 directory, in which case the charge moves
> +	 * directly to that cgroup's memory controller.
> +	 */
> +	__u32 charge_fd;
> +};
> +
>  #define DMA_BUF_BASE		'b'
>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
>  
> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
>  
>  #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17fdefc56b97..3e717b5663c8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5752,6 +5752,48 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
>  }
>  EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
>  
> +/**
> + * mem_cgroup_transfer_charge - move a charge between memcgs
> + * @ptr_memcg: pointer to the memcg to transfer from
> + * @new_memcg: target memcg; caller must hold a reference
> + * @item: stat counter to adjust
> + * @nr_pages: number of pages to transfer
> + *
> + * Transfers @nr_pages of charge from *@ptr_memcg to @new_memcg and, on
> + * success, stores @new_memcg in *@ptr_memcg.
> + *
> + * Updates to *@ptr_memcg must be serialized by the caller.
> + * Returns %true on success, %false if the charge against @new_memcg
> + * failed.
> + */
> +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> +				struct mem_cgroup *new_memcg,
> +				enum memcg_stat_item item,
> +				unsigned int nr_pages)
> +{
> +	struct mem_cgroup *old_memcg = *ptr_memcg;
> +
> +	if (!new_memcg || mem_cgroup_disabled())
> +		return true;
> +
> +	if (try_charge(new_memcg, GFP_KERNEL, nr_pages))
> +		return false;
> +
> +	mod_memcg_state(new_memcg, item, nr_pages);
> +	css_get(&new_memcg->css);
> +	*ptr_memcg = new_memcg;
> +
> +	if (old_memcg) {
> +		/* Uncharge old cgroup */
> +		mod_memcg_state(old_memcg, item, -nr_pages);
> +		if (!mem_cgroup_is_root(old_memcg))
> +			refill_stock(old_memcg, nr_pages);
> +		mem_cgroup_put(old_memcg);
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
>   * @dmabuf: buffer to uncharge
> 

