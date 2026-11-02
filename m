Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793628184;
	b=HVe3C/m33eWybv7B3iowooXV5On88XmJyB17/sIfXv/EfCkjOg+6wtH4Q+gr3vjtaUzs
	 KjyJ/MOEstWoaRdsIkMEqLoHsIrtVlbVRVBLAWimcxa/jQSK+dx9SMGHo0V6rcZ8CdAaI
	 lJQngoTRjgohYgAfJaCxNvSatO4eihNki/WlGdUiLI+DrHMfnwRi2M7yKjNVCMWnjt+wQ
	 4QWmR3bDUEq9YfPs8E3jrwe4kVgKSj93stu2nTLNY7lZhna09IZetcitajjhigebzV3o/
	 baOeSr6JK43sYiaUMSEO+dJ2t0F9HOW+YqwyZ/LZPryl+48Fs26jwMekY2ekVoDGYTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628184;
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
	bh=5QK9WyupBaIuH9J2/o78/L+Cch4bNRdxV0Kh/8hIp6E=;
	b=exnXFzyx5skiZwU8zSucuSFT7ygT/ym6jEg3xW3VVLa39t9tQwkqGTbyvqjB70bZswZY
	 YySFj5rBjkMZDuqhvczKX1eon9gE7mGYiSqscxfK8X4OOjm6dIf0hMF3KMjlSqF/TWFWG
	 mmKyXD3eGdZF9tziINDHokvKRexaJgWymWUEMtlcAgOUT7gTtQFzLSsuy1lgPKt2grVGV
	 h3796h9QOaYsphpqsnfLVi94PjhcRALm/yiIt96xiSW8L1V+/EBGq0kKVpAhkZxTFQHnE
	 9S/TZopo29fnUssNmq+lsQygCCi7egdQ/xeWJLmbTKHxveo28E+d6yB1cifzdO3y8WQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mCdkcruV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.5
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012005.outbound.protection.outlook.com [52.101.43.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EE8606A326;
	Mon,  2 Nov 2026 14:03:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47EE8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mCdkcruV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldpQTB8JmLcZWyonQkfmGoaDTH0jjr7YyXa3zsL3hX+RbG7wbn2vxY/tokZwtBhT5HP7/P/2SJtBZvIxEyyuoNKCRRQ5LFVtLehKui+vkI+na7xzYIpMZ/3QZED1Igxje+GPLleMh/m7jSrq25vryfWKX5oPUQdXk6wK98F0laie3XvL+jO/2R3VMuxL1MOH0lXvp2hHmucJjFY9ZsffKFBxFHtkzTuehRS/NrjLx1RDSVKExpmXIaOo5QqWE6UwpGgCV/x9PQ2YXE30SDrPwlzMpRvcI3djeiTSkCHjhDGfcuQtve0gByqH7huWrBEJ9AcCchIYZxyV/c8MnFRU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QK9WyupBaIuH9J2/o78/L+Cch4bNRdxV0Kh/8hIp6E=;
 b=KLBu2NFaiXmtaoT8AAILi42wi1JSFckyNNXrPsU73v5VpttgmvXvpdmjT011YV6oi3qd++5qUwXf+lxNWSF0KmU/UGFfGV280mx5uZBVr0ZsuKaHtl2cgHEkL/TG8RUzsD8hoIsD4AwoZpp15lrU+eTKr1fQK8qfXm6ynGj0SyKn8JglkhaXI/NDm9pJ8+DBg7JhC56AT4yMD/MwDVdifAv8gDbrHA5jCrv/cYFCY2ijM1bTorAh/WJB/eGutC1Z2LsOZGOP2l8lYKWT/uenWw9p+ckt3gK3R45C7HapsZo3DS6zmqlw58I1Bdh7dT9Vzi4YlQsaj+4AyY4PFd+vJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QK9WyupBaIuH9J2/o78/L+Cch4bNRdxV0Kh/8hIp6E=;
 b=mCdkcruVVpNwebUqVdjW3+kuyyDaCJhqyxLvOw4od82hASo03urbpUiwaD91WTcL2H9RJPenBPrObHkCLoXE4KxJM0xcpBGnwuN3PzWFXrXsQ2UTDf3sAH8cy5VNRdoSHOAtxcey6Dbjd/2PWv813ak8yLbYUA+MFZKHTHjTchk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ2PR12MB9191.namprd12.prod.outlook.com (2603:10b6:a03:55a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 14:02:54 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 14:02:53 +0000
Message-ID: <20edef9c-39c3-44f4-b6f5-89d1b4ba4666@amd.com>
Date: Mon, 2 Nov 2026 15:02:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
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
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 op-tee@lists.trustedfirmware.org, echanude@redhat.com, mripard@kernel.org
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
 <d76d8bfe-e955-4e90-9f5f-e3e914c0869c@amd.com>
 <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
 <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
 <auNzHjhT5xezyZ4I@aesteve-thinkpadp1gen8.rmtes.csb>
 <08705a7a-86aa-4b43-a22a-e80a572010f2@amd.com>
 <auhb1W6CRi0vo0Tq@aesteve-thinkpadp1gen8.rmtes.csb>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <auhb1W6CRi0vo0Tq@aesteve-thinkpadp1gen8.rmtes.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0187.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::17) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ2PR12MB9191:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a13e805-6e65-4397-63b1-08df38e9fd22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|18002099003|22082099003|56012099006|10067099003|261009223027099003|261009221227099003|261022105027099003|261021123027099003|261021121427099003|4143699003|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	Emt+n6woItPT/493zIFDyOGj5+vXvioLeZWsb6yqIjwN7i8C5p5shz+LQ3i7zLMLY7D8z4YXPYXQj2OJSQkA0WqlCSJxA4ekaLV2he9Fe4sLikESOxS92Xt9pkt5QX75+cYYjeg6F1rBJCbyiNGjQy1lF8N1BsBbUZsx/A0gclgkcqoKw/POHZF7pbFfZMoFQiu+LnP+AVrjgjLN8VDXPb5uCjqIiiEIB89EecfPNReFhCSSF+20Sj3SBR7N+6spaXUHUNSyIA3K0+uBEeWIIt4TumySp4GWZvM5Q9TNlaki/y4EvYTfQ4TBKS+LFkzQDHcwKIEmthED2AxziEMzllHLHfHyd9fHat+fPxZWwCzc+J++ECs6GSIDhF2nms7SjPh5zPdlSCya8tiekQ3fAiwmPiIR2wNjZYMBU4O0maqkzAhRJqmmCMjQYYTT4H+OPEQTX9Ef2lIpPOmGdAKUhpaiCEZWbI3DItjpXDtNetGzj6rtF7U8UVu2rwcSzYypKp6wWexMafMlgzresQcUegxj54koDBxGojmtAXEcIT1i6oKNp1l1na/dJbpWGAM3lq8VFEzVND3zsSlH/ec0BT9RD8BzYTyUcSNZB2faa0NHv1cgvGdlfCyyjCYsHmIJCQBFBXf6cHhfG14/ZAjDVkC+oxjaTQnfkwLTQxQYwPI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(10067099003)(261009223027099003)(261009221227099003)(261022105027099003)(261021123027099003)(261021121427099003)(4143699003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGJSTSt6TlZXMno2M3dJdXdtUGcxWHQwejFuTlg3a1NGWTBHQ1pZSlJoM2VU?=
 =?utf-8?B?S3FkMTc5MDhtUFBZYVl6eWs0bFNXQmFtMXByNzc0bkZMREEybE0wUDd6ZEtt?=
 =?utf-8?B?d3ZPZXF3NVZkUnUxVmF3S0k4RVEzaGRzM0Fxbi9hVmgzVW9CR2ZBNEUxZk5S?=
 =?utf-8?B?Yk44TzYxTVh6Rngzdi9nU1UxOTRvVEJEd1RJSkhDQUVaN0p3U0VVTXUybDN4?=
 =?utf-8?B?dnIrQitNRFZyTkV3bGdjUzZuSEpySkV5bGl2NjlDdytmMEJSdCtJeUEvS3kr?=
 =?utf-8?B?Y1M3NktkcVlrVDZQODI4Y09OQWxUeHFNN1Rjd2U0OXo2ek8xZWhxMnc4cm15?=
 =?utf-8?B?K0JtbDcxUlExeFU2ZmkveGpUM3ZNaE1lU09LU1M1TWN2cmptaXBKc0VwZmNU?=
 =?utf-8?B?Z1BPalhDWkgySmlpS2kvMFdramUvcUx4TERoWTVuZ29uc2NyWDV0eDVhWXBE?=
 =?utf-8?B?K2JMK1FUek1lWVhsNC9Ta3ZQeFZpRWM3UVdkV3FFS2tHbFgxYUdJLys5YW9E?=
 =?utf-8?B?T1R2M1B4czIyUlRpZ3BHMStWUDY5VDZ0bGQ1eHR5RngxcHg5TDRNS3pOaGFw?=
 =?utf-8?B?Z1BPSFdrRHpBOGFneXpOR0prYk8wcmdFSExxVGk4aS9LOHF4UWpIVzhLaGc1?=
 =?utf-8?B?TEY0K1ZhWXZLSU0xcmhwUGdPbWdiMGZRcHNIdGJmbFQwNFhxSERqSjFjRGtx?=
 =?utf-8?B?dnpOdWhVUGJnb2FZbGlmSWMzUmZKdkhnQjlzVFZzSlJ1RGhoK1JyeG1YVVpv?=
 =?utf-8?B?b1ZaNFVFQ2hjanErT3VnOWtKMVlmOVQ2aTR1V3h5bURyQVk5ZEp0VHgyMGNM?=
 =?utf-8?B?QVY3K0lVRVdhcmFMSHZVN042NTRwbEx4SzNPMzE2L3FyOUVtdUYzdGh1VnBR?=
 =?utf-8?B?WXZFSWJGeGdHZXd4cHNkVzhzN0p5U0R5WHhONHJxaFhtQXBienk0RHJkSWQ1?=
 =?utf-8?B?L1NLTHRyTFlBNjZRbXJ6MVFMcW1MclF1M214eUx2M1gxQkZPU0tmV2ptc3hu?=
 =?utf-8?B?VTNJTG55bkJsdmhPMTM3YUhuUnE4N1lQZUV5cXUzdUx4NTBWUnR5MS9zSHVT?=
 =?utf-8?B?ZHJ5M0VOVmxXVGJ2dnpLTVFGZ2R5UFBDVXdQR0VZazBzcm9KenBOUjJDM0th?=
 =?utf-8?B?aEhNYWRWcjJVSXpDMkxpNEx3b20xYTdRbHVhcU4vTXMweFhZUGd6QVNlM0E2?=
 =?utf-8?B?MUtFWVUraVkyOE9sZE92a2ozaW1TU21LNUdxWGtpb0NObHQwRlBzaktWSDhG?=
 =?utf-8?B?NDZ2VStBMU5JOG1zZHhHMnZnamtGTU9rUVAyaHowTHR5TVNjL0dtcVk0Vmlz?=
 =?utf-8?B?Z0R5Z3MrdTlRNGwvMjdqMStoNmtjRGVkS0EwWmE2b0xURWtwaTgrUkFHc0pC?=
 =?utf-8?B?UUVMVGhBOEdZWjJ4NVQ4RHlhdTlDSUM5VEZwWEMvRVZzbXRMc1VXV1F5dHRI?=
 =?utf-8?B?ajVsU0hwYVpiYzNrNE52Ny9CRFFjZlErclM5NGsxUm1QVHlpQnA3cTdyRjhO?=
 =?utf-8?B?Skl6a09tNzZQOUxMNm0ySmI1YjlaNjlOWCtpcjlCS1gwQWRCOWdNaEt3Uits?=
 =?utf-8?B?R1loRkMvQ3hhQjIxMlNqUTdIWlJBN0RSVjQ0SE8ya1JQOGlNb1F6bEZoSldC?=
 =?utf-8?B?ck85UVBXdm5tY0FoMG5QbktncEdUSlE4VUhkSHhMY2tSRDJJckZJQmtYdzVS?=
 =?utf-8?B?SmlKZENadkJMdEYyZVNTelJoSEVmSW4ya1pSMHNTWW40N3pCNjdGWFVwS2hJ?=
 =?utf-8?B?dmJtTWQ5d08rOU94Z3BXYWNmbnZncndmaXRXRitlcXNtbUVPSSt1ZHh1bzRT?=
 =?utf-8?B?S3dJZTBwMkNmSVpvWnE4SWJyMGlrbHYwNEprWTZpd1c2UmNZdTNnMnQ4ejVv?=
 =?utf-8?B?ZEdEMHNpUTFjaEpEK0x5ZElya01XZ2VaYjl5ay8zanlqWmR4eFlPNjA4WTky?=
 =?utf-8?B?elZJYVgvNjhZUUxmSHlTalpVeGNoTzA5T250V1JKQ2NnaEM5UHFnaXZlWTFm?=
 =?utf-8?B?ZDNCYmx1ZHB3VCtoUER5d1MzVHpYbXY2MCtEbS9qL2xGbGZIc2x5azdqb0k4?=
 =?utf-8?B?T0EweDJpMFJ2K3hVOGxtZnJCZFpZdkFuWkJrczhnbnNMaHQ2eG9pYTd5ck9x?=
 =?utf-8?B?WkNoMUVsYitVbzdob2J5Qjh1b0syVCtTbjlRREE5dURudS9uNUtyYWU3ck9T?=
 =?utf-8?B?T3dTc0F1S3BJTlJFTGl0OWZNVytzcEE3WnR6NzBVVXVwR2FZVWgrdGM1blRB?=
 =?utf-8?B?SU1MVytRTWYweWE3R2MxWE9PRzlZc2V5V1I1UEFSSkc3eE54VU92a1VkcnN4?=
 =?utf-8?Q?wPHyrvQOaKxLnOYT9o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a13e805-6e65-4397-63b1-08df38e9fd22
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:02:53.7068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAfquCe+QDBEjdzQRwTnnUzZGhP013vFxac9dXFO3zJ3dNSTVIa7RL+5e72DF221
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9191

On 11/2/26 10:45, Albert Esteve wrote:
> On Fri, Oct 30, 2026 at 11:14:50AM +0100, Christian König wrote:
>> On 10/29/26 17:23, Albert Esteve wrote:
>>> On Thu, Oct 29, 2026 at 03:16:12PM +0100, Christian König wrote:
>>>> On 10/28/26 17:09, Albert Esteve wrote:
>>>>> On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
>>>>>> On 10/27/26 16:02, Albert Esteve wrote:
>>>>>>> dma-heap already supports charging a specific cgroup at allocation
>>>>>>> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
>>>>>>> originate from any exporter (DRM, V4L2, etc.), and the allocator may
>>>>>>> not know the final owner at allocation time.
>>>>>>>
>>>>>>> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
>>>>>>> to a different cgroup after allocation. The target is identified by
>>>>>>> charge_fd, which may be a cgroupfd or a pidfd.
>>>>>>>
>>>>>>> The transfer charges the new cgroup before uncharging the old one,
>>>>>>> preserving the original charge on failure. An atomic cmpxchg on
>>>>>>> dmabuf->memcg prevents races with concurrent transfers.
>>>>>>>
>>>>>>> Not all dma-buf exporters back their buffers with reclaimable system
>>>>>>> memory. Some represent device registers, VRAM, or carved-out pools
>>>>>>> where size is not a meaningful memory cost. Add a memcg_account flag
>>>>>>> to dma_buf_export_info that exporters set when their buffers should
>>>>>>> participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
>>>>>>> for buffers that do not set the flag. Currently only the system heap
>>>>>>> sets it, other exporters can opt in as needed.
>>>>>>>
>>>>>>> Usage example:
>>>>>>>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
>>>>>>>
>>>>>>>   struct dma_buf_transfer_charge xfer = {
>>>>>>>       .charge_fd = cg_fd,
>>>>>>>   };
>>>>>>>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
>>>>>>>   /* charge now on app1's cgroup */
>>>>>>>   close(cg_fd);
>>>>>>>
>>>>>>> Signed-off-by: Albert Esteve <aesteve@redhat.com>
>>>>>>> ---
>>>>>>>  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
>>>>>>>  drivers/dma-buf/heaps/system_heap.c |  1 +
>>>>>>>  include/linux/dma-buf.h             |  5 +++++
>>>>>>>  include/linux/memcontrol.h          |  9 ++++++++
>>>>>>>  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
>>>>>>>  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
>>>>>>>  6 files changed, 125 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>>>>>> index f31f49ebd0af..07513ecedc10 100644
>>>>>>> --- a/drivers/dma-buf/dma-buf.c
>>>>>>> +++ b/drivers/dma-buf/dma-buf.c
>>>>>>> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
>>>>>>>  }
>>>>>>>  #endif
>>>>>>>  
>>>>>>> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
>>>>>>> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
>>>>>>> +				const void __user *user_data)
>>>>>>> +{
>>>>>>> +	struct dma_buf_transfer_charge arg;
>>>>>>> +	struct mem_cgroup *memcg;
>>>>>>> +	int ret = 0;
>>>>>>> +
>>>>>>> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
>>>>>>> +		return -EFAULT;
>>>>>>> +
>>>>>>> +	if (!IS_ENABLED(CONFIG_MEMCG))
>>>>>>> +		return 0;
>>>>>>> +
>>>>>>> +	if (arg.flags != 0)
>>>>>>> +		return -EINVAL;
>>>>>>> +
>>>>>>> +	if (!dmabuf->memcg_account)
>>>>>>> +		return -EOPNOTSUPP;
>>>>>>> +
>>>>>>> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
>>>>>>> +	if (IS_ERR(memcg))
>>>>>>> +		return PTR_ERR(memcg);
>>>>>>> +
>>>>>>> +	if (dmabuf->memcg == memcg)
>>>>>>> +		goto skip_transfer;
>>>>>>> +
>>>>>>> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
>>>>>>> +		ret = -ENOMEM;
>>>>>>> +		goto skip_transfer;
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	return 0;
>>>>>>> +
>>>>>>> +skip_transfer:
>>>>>>> +	mem_cgroup_put(memcg);
>>>>>>> +	return ret;
>>>>>>> +}
>>>>>>> +
>>>>>>>  static long dma_buf_ioctl(struct file *file,
>>>>>>>  			  unsigned int cmd, unsigned long arg)
>>>>>>>  {
>>>>>>> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
>>>>>>>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
>>>>>>>  #endif
>>>>>>>  
>>>>>>> +	case DMA_BUF_IOCTL_XFER_CHARGE:
>>>>>>> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
>>>>>>> +
>>>>>>>  	default:
>>>>>>>  		return -ENOTTY;
>>>>>>>  	}
>>>>>>> @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>>>>>>  	dmabuf->size = exp_info->size;
>>>>>>>  	dmabuf->exp_name = exp_info->exp_name;
>>>>>>>  	dmabuf->owner = exp_info->owner;
>>>>>>> +	dmabuf->memcg_account = exp_info->memcg_account;
>>>>>>
>>>>>> The initial charging should probably be done here as well.
>>>>>>
>>>>>> This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
>>>>>
>>>>> The problem with doing the charge here is that it happens too late.
>>>>> That is the reasoning for this proposal to move all the charging logic
>>>>> into heap allocators before pages are allocated.
>>>>
>>>> Oh, that is a really good point we need to talk about.
>>>>
>>>> DMA-buf heaps is actually a rather simple use case, but we have way more complex things.
>>>>
>>>> For example in some use cases the backing store of a DMA-buf is only allocated on first use and only then it needs to be comitted to it's memcg or dmem.
>>>
>>> Yes. The idea is focus on heaps for now. But the uAPI is actually
>>> agnostic of the time when the charge happens. When we deal with
>>> lazy-allocation in the future we can just call the reserve/cancel
>>> helpers wherever is more appropiate. As long as the pages are not
>>> allocated, exporters do not set dmabuf->memcg, and XFER does not
>>> work (returns -EOPNOTSUPP).
>>
>> Yeah exactly that's the reason why I'm raising this topic. That approach won't work in all cases.
>>
>> See userspace is not aware that the kernel is delaying allocation or that the kernel is allocating the backing store asynchroniously in a background worker for example.
>>
>> So returning -EOPNOTSUPP when the backing store is not allocated yet and might be allocated later on is rather questionable uAPI because that is racy by design.
> 
> Ah! I see what you meant now.
> 
>>>>
>>>> I don't mind implementing it for DMA-buf heaps first, but we should have the uAPI and it's handling so solid that it also works for future use cases.
>>>
>>> Agreed. I think we should cover all usecases with the current status.
>>> Your feedback helped a lot in getting there!
>>
>> I mean we can postpone that until we finally need it, but essentially we need to be able to distinct between charging, e.g. making sure the cgroup has enough free limit, and committing, e.g. allowing the resource to be reclaimed.
>>
>> And then it is possible that when the memcg of a DMA-buf changes that only the charging changes, but there isn't any comitted backing store yet...
> 
> Right. That would need adding a specific flag for committed pages or
> a similar solution. When transfering an uncommited dmabuf only the
> charge moves (limit reservation and dmabuf->memcg), the stat is
> untouched. Once the backing store exists, the exporter commits, it
> sets the flag and bumps MEMCG_DMABUF stat. For memory where its
> backing store can go away (e.g., dynamic dma-buf sharing), it can
> have a mirror function that drops the stat but keeps the charge.
> That would resolve the -EOPNOTSUPP thingy, as transfer succeeds
> when dmabuf->memcg is set even for uncommitted pages.
> 
> My question would be if all exporters know when memory is committed.

Yes, the exporter "owns" the backing store and is the only one who can allocate it based on requests from importers (or itself).

> For those that only get, e.g., a firmware handle and cannot observe
> the allocation, I guess the buffer can just remain reserved without
> even being committed. Or in case of protected memory like OP-TEE
> they would not even opt-in to begin with.
> 
> I do not mind adding that for next version, or leaving it for when
> lazy exporters actually opt-in. It is not a big change either way.
> Although, it may look weird while the system heap is the only user
> and commits right away. But either way I can try to document the
> flag / explain this discussion in the commit.

I think we should keep it simple and stupid for now, just not make decisions which would block extending it in the future.

>>>>> What we could do is fill the dmabuf->memcg field when the flag is set
>>>>> (i.e., committing into the dmabuf in the patch semantics). But for that
>>>>> we'd need adding the memcg we want to charge it to into exp_info in
>>>>> order to support charging to cgroups other than the allocator's (for
>>>>> the common case would be simpler as we can just look at current).
>>>>> Maybe that's what you meant?
>>>>
>>>> At least for the DMA-buf heaps use case that sounds reasonable for now.
>>>
>>> Thanks! Next version will have the flag removed and just use
>>> dmabuf->memcg as indicator, set within dma_buf_export().
>>> Also, `nr_pages` will be computed within dma_buf_export(), the
>>> contract being that exporters setting exp_info.memcg assert that
>>> size reflects actual system memory bytes.
>>
>> Thinking more about it I would also put changing dmabuf->memcg under the dmabuf->resv lock instead of doing it with cmpxchg.
>>
>> We don't need it currently, but the dmabuf->resv lock is used for all state changes of the DMA-buf object and this operation is not performance critical in any way possible.
>>
>> If there is a problem with locking order we at least get lockdep screaming at us very early and not when we want to extend the functionality in the future.
> 
> Sure, will do.

Thanks,
Christian.

> 
> BR,
> Albert.
> 
>>
>> Regards,
>> Christian.
>>
>>>
>>>>
>>>> Regards,
>>>> Christian.
>>>>
>>>>>
>>>>>>
>>>>>>>  	spin_lock_init(&dmabuf->name_lock);
>>>>>>>  	init_waitqueue_head(&dmabuf->poll);
>>>>>>>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
>>>>>>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
>>>>>>> index adeea8cd328b..a764167167ba 100644
>>>>>>> --- a/drivers/dma-buf/heaps/system_heap.c
>>>>>>> +++ b/drivers/dma-buf/heaps/system_heap.c
>>>>>>> @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>>>>>  	exp_info.size = buffer->len;
>>>>>>>  	exp_info.flags = fd_flags;
>>>>>>>  	exp_info.priv = buffer;
>>>>>>> +	exp_info.memcg_account = true;
>>>>>>>  	dmabuf = dma_buf_export(&exp_info);
>>>>>>>  	if (IS_ERR(dmabuf)) {
>>>>>>>  		ret = PTR_ERR(dmabuf);
>>>>>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>>>>>> index 23ec0ff23fba..ac0ec88cab93 100644
>>>>>>> --- a/include/linux/dma-buf.h
>>>>>>> +++ b/include/linux/dma-buf.h
>>>>>>> @@ -433,6 +433,9 @@ struct dma_buf {
>>>>>>>  
>>>>>>>  	/** @memcg: the cgroup to which this buffer is currently attributed */
>>>>>>>  	struct mem_cgroup *memcg;
>>>>>>> +
>>>>>>> +	/** @memcg_account: account buffer memory to cgroup */
>>>>>>> +	bool memcg_account;
>>>>>>>  };
>>>>>>>  
>>>>>>>  /**
>>>>>>> @@ -505,6 +508,7 @@ struct dma_buf_attachment {
>>>>>>>   * @flags:	mode flags for the file
>>>>>>>   * @resv:	reservation-object, NULL to allocate default one
>>>>>>>   * @priv:	Attach private data of allocator to this buffer
>>>>>>> + * @memcg_account:	account buffer memory to cgroup
>>>>>>>   *
>>>>>>>   * This structure holds the information required to export the buffer. Used
>>>>>>>   * with dma_buf_export() only.
>>>>>>> @@ -517,6 +521,7 @@ struct dma_buf_export_info {
>>>>>>>  	int flags;
>>>>>>>  	struct dma_resv *resv;
>>>>>>>  	void *priv;
>>>>>>> +	bool memcg_account;
>>>>>>>  };
>>>>>>>  
>>>>>>>  /**
>>>>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>>>>>> index 6b30baa79fa9..36fddafbef4e 100644
>>>>>>> --- a/include/linux/memcontrol.h
>>>>>>> +++ b/include/linux/memcontrol.h
>>>>>>> @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
>>>>>>>  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
>>>>>>>  			      unsigned int nr_pages);
>>>>>>>  
>>>>>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>>>>>> +				       struct mem_cgroup *new_memcg);
>>>>>>> +
>>>>>>>  void __mem_cgroup_uncharge(struct folio *folio);
>>>>>>>  
>>>>>>>  /**
>>>>>>> @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
>>>>>>>  {
>>>>>>>  }
>>>>>>>  
>>>>>>> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>>>>>> +						     struct mem_cgroup *new_memcg)
>>>>>>> +{
>>>>>>> +	return true;
>>>>>>> +}
>>>>>>> +
>>>>>>>  static inline void mem_cgroup_uncharge(struct folio *folio)
>>>>>>>  {
>>>>>>>  }
>>>>>>> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
>>>>>>> index e827c9d20c5d..ea957f4b1d38 100644
>>>>>>> --- a/include/uapi/linux/dma-buf.h
>>>>>>> +++ b/include/uapi/linux/dma-buf.h
>>>>>>> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
>>>>>>>  	__s32 fd;
>>>>>>>  };
>>>>>>>  
>>>>>>> +/**
>>>>>>> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
>>>>>>> + *
>>>>>>> + * Any holder of a dma-buf file descriptor can perform a
>>>>>>> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
>>>>>>> + * cost to a specific cgroup, or move it from one cgroup to
>>>>>>> + * another.  The ioctl charges the new cgroup before uncharging
>>>>>>> + * the old one atomically.  On failure the original charge is
>>>>>>> + * preserved.  If the buffer has no existing charge, a new
>>>>>>> + * charge is established.
>>>>>>> + */
>>>>>>> +struct dma_buf_transfer_charge {
>>>>>>> +	/** @flags: Reserved, must be zero */
>>>>>>> +	__u32 flags; /* unused for now */
>>>>>>> +	/**
>>>>>>> +	 * @charge_fd: File descriptor identifying the target cgroup.
>>>>>>> +	 *
>>>>>>> +	 * May be either a pidfd, in which case the charge moves to the
>>>>>>> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
>>>>>>> +	 * by opening a cgroup v2 directory, in which case the charge moves
>>>>>>> +	 * directly to that cgroup's memory controller.
>>>>>>> +	 */
>>>>>>> +	__u32 charge_fd;
>>>>>>> +};
>>>>>>> +
>>>>>>>  #define DMA_BUF_BASE		'b'
>>>>>>>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
>>>>>>>  
>>>>>>> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
>>>>>>>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
>>>>>>>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
>>>>>>>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
>>>>>>> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
>>>>>>>  
>>>>>>>  #endif
>>>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>>>> index 7b841b905759..3adc84fe6668 100644
>>>>>>> --- a/mm/memcontrol.c
>>>>>>> +++ b/mm/memcontrol.c
>>>>>>> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
>>>>>>>  		refill_stock(memcg, nr_pages);
>>>>>>>  }
>>>>>>>  
>>>>>>> +/**
>>>>>>> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
>>>>>>> + * @dmabuf: buffer to transfer charge
>>>>>>> + * @new_memcg: target memcg; caller must hold a reference
>>>>>>> + *
>>>>>>> + * Transfers the charge for @dmabuf to @new_memcg and, on
>>>>>>> + * success, stores @new_memcg in @dmabuf->memcg.
>>>>>>> + * Returns %true on success, %false if the charge against @new_memcg
>>>>>>> + * failed or a concurrent transfer raced on @dmabuf->memcg.
>>>>>>> + * On failure the caller retains its reference to @new_memcg.
>>>>>>> + */
>>>>>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>>>>>> +				       struct mem_cgroup *new_memcg)
>>>>>>
>>>>>> I would make that more generic instead of dmabuf specific. E.g. something like this:
>>>>>>
>>>>>> bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
>>>>>
>>>>> Ah yes, I like this generalization. And the implementation remains
>>>>> mostly the same. Thanks!
>>>>>
>>>>>>
>>>>>>> +{
>>>>>>> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
>>>>>>
>>>>>>> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
>>>>>>
>>>>>> This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
>>>>>>
>>>>>> Regards,
>>>>>> Christian.
>>>>>>
>>>>>>> +
>>>>>>> +	if (mem_cgroup_disabled())
>>>>>>> +		return true;
>>>>>>> +
>>>>>>> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
>>>>>>> +		return false;
>>>>>>> +
>>>>>>> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
>>>>>>> +
>>>>>>> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
>>>>>>> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
>>>>>>> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
>>>>>>> +		return false;
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	if (old_memcg) {
>>>>>>> +		/* Uncharge old cgroup */
>>>>>>> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
>>>>>>> +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
>>>>>>> +		mem_cgroup_put(old_memcg);
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	return true;
>>>>>>> +}
>>>>>>> +
>>>>>>>  /**
>>>>>>>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
>>>>>>>   * @dmabuf: buffer to uncharge
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 

