Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793283427;
	b=Q6JH+jONRga0IfGP0Erz2FoQqMSlm393FNw1xQ3HucVUcRZf8AIvuUI+ceTPaX2RwWsy
	 0o5Yv3rvDDy4GH8K9rxQRjgGSxVyQrs3VdV69lODwPClJIrEDii+rVZtbcySsUON78ioI
	 69ljJiol0gELJnh+KMc5+wWnEZRRhiYTbKh8OkM4ve2E8xsl0Ga/9k3oSpujFvv/abDDm
	 6ng/UIuRZ46MiQ1Ut6QqTXBHtWzVQWeXEf9NOEx47ns2Cp6iFXEqNzLKtA9/dqTSUO7jm
	 aZ76pz15g3311wHpD0i4YgoxsMjsTr6ClTu8h83bZ8gQV9ROc5ACx+ihg0A9x9gffAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283427;
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
	bh=8UYhPe0kmRbwlyhj7BUSe/Tr8+GrHIXXO+aLH7QV2qA=;
	b=CWNaXsk9bxQxanOC6VVLXz7W9QNvxdsHkSJQ4igZbQWawFwZNyMdRKotsN3l2F4Ss3M9
	 UqC5Q36sAizarlc+YJFegforglIUsL0ALLYWmuRNuTi/r6Ymh4ygzoxOo/waig0XVhUEu
	 CylNq7WJPu/AE18UhW8IAor6v26HiusWucAvmwHaFUMjgOGunYnLfB+ZAJvlPiriSbjgn
	 fONsbaMQlSEDxsXCh8KGTWeVDWQb8gtewWWk40sGzpc3fYGqRzB2pugWrkt9e/A5ZsMIU
	 uFbeSRj4xKjhPGz0OQk9pMltBKOTHwDmTlUed+0JADmAK3HrskoozkQo9qleCh2i0mw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=z54b1nmR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.56
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21690606A31C;
	Thu, 29 Oct 2026 14:17:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21690606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=z54b1nmR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7Y6PnvlkMX8yEI1GNNGZMQD9InS28dIOp6X7fc+KXrnn+bg/xa84k0hFY6f0j4Z7qfwS0/gbtdQEBzqXgGhoUuzF528Su0+iF2MZDndgnVY7Wdnn5LrCBT3PAy2q/S1/IbyCJ94izqPgrzIbqz87QDNdkU2Cp94bqFpVr6ar3O0of9dxZjJTP4+XXDKSsd11pPFzoJRzmpdXynO3aCGmdHauz0q795lkY0v0dAVpiTkwqpYt47ZAQ2BFaVUhjVDHpdfHYJI6EfnYrpVKjxeKssyVxV3vx9hM30MLMfcYm+BpT5KQLystHOD6vfsmE4J80yYEc0ncb+RQbHzqzG0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UYhPe0kmRbwlyhj7BUSe/Tr8+GrHIXXO+aLH7QV2qA=;
 b=poRU1IrY6CM2RgINNWq+hbBLAMj+lfmc5p76hCP6wglxL0G+rpktVJNDOgrnydax2wSVkPF/7ZOcAjZQRj3Uh2MIDoTvknTfRX7SaKPyaS6ke619bsLIjjpEbdtrCTbIr8yRZuQc902dZpZ1h4ogyGk5PtbBsUaZi4xcXpJTP2pt5lerZwKK0TDYlKkZoSBPbmzXQYP7CRyrGH+KRvlv1W9Rs8LnGcS1SdENmqqXYqbpvGfIn7V1F7W006ytihcqNg5qoe9hI7L3eK7ADGGDigE/WK5E0HNteYMi8fSCzj5G93hoitLXdkf+uEb4+1GRiSK114KoVDnikHMJy+cR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UYhPe0kmRbwlyhj7BUSe/Tr8+GrHIXXO+aLH7QV2qA=;
 b=z54b1nmRTBak7Armg0zFEikj97NwozyyTNjhTF4PFHoP+d9JNgaI4YMkQit10MpLV9mWltzeJQdYGWp29dm6+ozoO8YulWD2j+M8MFijbyjp0mjMjEnTBWXQ9X239kTm07g48LZi9SWz7YaKO6z0jy4rM3R90pSsM2TEjxFngak=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH9PR12MB174847.namprd12.prod.outlook.com (2603:10b6:510:415::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Thu, 29 Oct
 2026 14:16:22 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 14:16:21 +0000
Message-ID: <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
Date: Thu, 29 Oct 2026 15:16:12 +0100
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0449.namprd03.prod.outlook.com
 (2603:10b6:408:113::34) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH9PR12MB174847:EE_
X-MS-Office365-Filtering-Correlation-Id: 251e27fb-2967-48a1-50b6-08df35c7351f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|261009221227099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|10067099003|261022105027099003|261021121427099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6eokDo3Dim7WLZlzIdmzyUcuNjtN6TS5zPaByC0itX9cmXhUt4nWo2VBw8ncEsI/4lUokQZXVzx/Z9S0S8y5Sh1aUEMYOCgKV0akmRB/cBP2JRn9n/TgcLW20I1u5fexkrdKE9CKLdHFTzsR9FCo0chDZbX5jyZD4/+80CEpT/PPzwC47iZqln6whrfcvzQpnHUYPYpOHxolQ+sZJp9HcEaTMfyW02E/1cVQuu9vc70bre1XzKI9awvXnFhi9qJcGJPrGXFXEfm5X0xm30BYWpCDt9rN8lMMggq8hUbtJ8uODq2sv6UAtyx7WlTBl7FS2RgI1Lu+cuFNwGhLxXyCNUINtIB/jj7qLXQRWfwY+7ztVfdPEJBpv2UHu6tFudbKz0He7lmNjWdQV/rEgIox/okUgvucj4EzZgdh0S6mp+kBBol7aa8TiNfBj658M6dcvbogsdNkVuP3SwqMBCEUSJCzhh5XN4UIgDIUdqnZyPCcw/QAJz+rbZT7ZxHvgyRyENMUSFdsiUnSKiCwmuPEukeNWAuiKggcXJsuyDscvBDbYLlJ3zaCwFoLRtQTpMuKOtOf9AAdaQ0DtNcTSAxnJoeIBL0SOvcVn+sAO4dqc53wneLEs+GJOioLEaOY9n4b5ZYEOWwsopcjffCOivprwWK8jA97tLi8QvldOFm1uVw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(261009221227099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(261022105027099003)(261021121427099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFdDR2RLdElxbTJyN2FjWjJvUGlGTFpqTjR1eW5jQndMaldqVU9rSmJtQnZ6?=
 =?utf-8?B?VTlrUnBCYlpJK0R3bktKY0pDT1VKQ1Q0bEFJbjBiTkVHdzN3R3FsZFNTb3FP?=
 =?utf-8?B?VlU0QVJPMkEyK1FYR1FIL2FkL0hMK1NTSXdHNlAwOWFYdm1aaVZwN2NjKzg0?=
 =?utf-8?B?MGlGc2FQOGxmWk5EeXBKOXlTTmpoNmhpcDZRN2w3WWllS3JNWUZ6OEYyR0Rm?=
 =?utf-8?B?RHBYdzVHc2tQbUJnNFpPK0xUTGxzeWhtN2lZcm9hU3E1bzhwU0ZOSEVYeUZR?=
 =?utf-8?B?Q0VGcDllUDZJZjM3VVF1WmI4N0NtSzJzQmx5d2NHWEtBOEV4NWRLMFA3eGlO?=
 =?utf-8?B?Wk00cDZDNmJLSEo3WGZPdFdNMlpCSDlJR1FiYkNzNDhVd2ErVC9KQUVNb1BS?=
 =?utf-8?B?c0xWU3NNQ04zZncwdDlVbWlNUlFrb1l4QlRDek5CeVhaSEJSU1B1b2dFRnZu?=
 =?utf-8?B?UTNSQWNXMi9LZ21RbURiUnVvYTlYZGlJRDVBUG9OM2w4TUY2U0VBL1hqKzVL?=
 =?utf-8?B?YlpRaUlodEVjRTRER3VWZEJkTFptVjZLLzN1OWRYL0kyVlpjWDB1RFVaQldG?=
 =?utf-8?B?TldGTlRkUEJHQ2NQV3NqTDYvdmJaK1FCRGY5aGtlK2FjZStNN0VVaU0rWStL?=
 =?utf-8?B?UG4xLzlhb0JiVnQ0SitWMFljdnl1NGhJMmg3SGNPY1RkanNoZlNydFhESDFJ?=
 =?utf-8?B?UndJYVNpRXhwV2hZeThWcU1wTkE4akhqUElNQnNtRkdwTktrYTFYcWhtTFR3?=
 =?utf-8?B?Q1pNeDNVR3lvN1NVQVhNMS9pejJxWlVNejhtZkxBTDRjNW9hUmRYdC9OOXB2?=
 =?utf-8?B?RnNhUzNrcHFraUx6Y1NQTmJqUnh6bmhUY2MzZzhTb0hwVXVHVE5qZytPMFda?=
 =?utf-8?B?czlNTzI3S25tZGk4V2toemIvaUx0aTFHVHZ6WDZPTGJZQ1lyVFB4a1hUNDVH?=
 =?utf-8?B?cGlPV0RWWTZBdG5vV0FPdU1acmUxbzk3MWFHTWxhOUt0akVBM2ErWW5KQ3Mw?=
 =?utf-8?B?bTBERi9kTXBFUGxNcUd2YUx3OEYxdmZhY1ozMlJmRlV2dFNFV00wd1RXSDlC?=
 =?utf-8?B?eHRneXJpWUNFVlVtWDVaVmo4dllmaTd3U3RIVDNFQWY1ejF5TXgwMFdwNXJK?=
 =?utf-8?B?U1FhY0JQaVlBM05naCtUSzdkZE5DMW5BZHg2aUFFSklGTUFKQUJpNEZvVEdB?=
 =?utf-8?B?ZXZQR0NsY0FRdGJjSEtJUmwralVrVHlwcFBrY04xSGhkSDh5em9vWkUxei9J?=
 =?utf-8?B?QkZ3TWYyS3RmcVZLTVlJbDk1cWQ1NlpTNHplcVVSeVlSYXN3dU50WjFSSk9t?=
 =?utf-8?B?aExFczNlTjhlbmtISzd2ZEgvRUhZZkNxWmtvaEw5MWYxZm9DakVweElBaHFW?=
 =?utf-8?B?VjZoM082VEUzN0toR2dGVDZtRlp3L0dSd24rQ2dkTE50Rk5sM2c3b08zRUR5?=
 =?utf-8?B?ejFwUmw1ZHBmNVdYaTlJaXZnK0VTVFU1dTBLY0ZwcFJCME5BakIySTZ4aGFH?=
 =?utf-8?B?RjV1d1VWdWcyNktFakpVYjM1c1dibW9XcHk3Y1JwS1FIbngyMkFzRTlxQ3NO?=
 =?utf-8?B?SUp1aS8vM0p4SFhVUUpBcWdldkJTaW92S3dGd2xGejhwaEJPMnY4Y2taTko5?=
 =?utf-8?B?VGZQamYwZGlyNzZ4MFBvK0lybHdLaXU5eSt4dGVBZTNGMnNnYmlENnF5aE8z?=
 =?utf-8?B?Q3hwUjF1R1A5MERvdnRISk5UK1daWTA2OU9vZngxQStBcy9WUVcvWlY0K1Vq?=
 =?utf-8?B?UjFFb3ZvZUhOT1plSmpJVGhpTEI4Mm45amduVk9penNpbjNSOG9XVE5HNVJZ?=
 =?utf-8?B?OWd1YVpUUlN0TXlYSlZiN0hZcVVkZnF2bVArK0JiYmRaRDhveGFOR2hPTTlN?=
 =?utf-8?B?MzlmU0I2a1BQQTBiSTBNWEFtUEtKeUU1S05SbW9CLy9BKytUV1ZFK2ZKRUhE?=
 =?utf-8?B?TlN1c2F1YlROd2IxTGtJVUJ0VlZ1dVk4TWdaSHk0WWgxdkJmd2lBbmlydWpa?=
 =?utf-8?B?NWcxRlVFanhDVmpQcE9YbXpsVytwNWp2QkE3cXVjV0l1VEMzNWkrZ1pyOEdz?=
 =?utf-8?B?MkVQeW9wMkJFK2lqTlJnblBrNWZPZGozSTNyYTFQemZ5YTNnSDNydE92ZUxE?=
 =?utf-8?B?azF5K1dDZmN3dmVaZXl6NHFYemxkbi9iL3Bxd0lKSzhJajl0LzJZOWRqQU9B?=
 =?utf-8?B?dHlia0pwUnZ1ZVNOS1pSMDNxYURZL2loMy9YYzhBNE5na1FHOE9UeGdsMmZP?=
 =?utf-8?B?c0hDaU1LckpGWW5LU0R1ZWpkRndrZHBRTVBST0JrdEZ4RjMzRzBHaHpkOERH?=
 =?utf-8?Q?pinVAkpZbLp5Bw3bUh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251e27fb-2967-48a1-50b6-08df35c7351f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 14:16:21.8145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uuq72KcRChC4YW9c8uqLnSY+0jivqx+jIuNJkxYdGc5jcxVhEPXXlJqdyChC0Y5+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB174847

On 10/28/26 17:09, Albert Esteve wrote:
> On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
>> On 10/27/26 16:02, Albert Esteve wrote:
>>> dma-heap already supports charging a specific cgroup at allocation
>>> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
>>> originate from any exporter (DRM, V4L2, etc.), and the allocator may
>>> not know the final owner at allocation time.
>>>
>>> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
>>> to a different cgroup after allocation. The target is identified by
>>> charge_fd, which may be a cgroupfd or a pidfd.
>>>
>>> The transfer charges the new cgroup before uncharging the old one,
>>> preserving the original charge on failure. An atomic cmpxchg on
>>> dmabuf->memcg prevents races with concurrent transfers.
>>>
>>> Not all dma-buf exporters back their buffers with reclaimable system
>>> memory. Some represent device registers, VRAM, or carved-out pools
>>> where size is not a meaningful memory cost. Add a memcg_account flag
>>> to dma_buf_export_info that exporters set when their buffers should
>>> participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
>>> for buffers that do not set the flag. Currently only the system heap
>>> sets it, other exporters can opt in as needed.
>>>
>>> Usage example:
>>>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
>>>
>>>   struct dma_buf_transfer_charge xfer = {
>>>       .charge_fd = cg_fd,
>>>   };
>>>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
>>>   /* charge now on app1's cgroup */
>>>   close(cg_fd);
>>>
>>> Signed-off-by: Albert Esteve <aesteve@redhat.com>
>>> ---
>>>  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
>>>  drivers/dma-buf/heaps/system_heap.c |  1 +
>>>  include/linux/dma-buf.h             |  5 +++++
>>>  include/linux/memcontrol.h          |  9 ++++++++
>>>  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
>>>  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
>>>  6 files changed, 125 insertions(+)
>>>
>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>> index f31f49ebd0af..07513ecedc10 100644
>>> --- a/drivers/dma-buf/dma-buf.c
>>> +++ b/drivers/dma-buf/dma-buf.c
>>> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
>>>  }
>>>  #endif
>>>  
>>> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
>>> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
>>> +				const void __user *user_data)
>>> +{
>>> +	struct dma_buf_transfer_charge arg;
>>> +	struct mem_cgroup *memcg;
>>> +	int ret = 0;
>>> +
>>> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
>>> +		return -EFAULT;
>>> +
>>> +	if (!IS_ENABLED(CONFIG_MEMCG))
>>> +		return 0;
>>> +
>>> +	if (arg.flags != 0)
>>> +		return -EINVAL;
>>> +
>>> +	if (!dmabuf->memcg_account)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
>>> +	if (IS_ERR(memcg))
>>> +		return PTR_ERR(memcg);
>>> +
>>> +	if (dmabuf->memcg == memcg)
>>> +		goto skip_transfer;
>>> +
>>> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
>>> +		ret = -ENOMEM;
>>> +		goto skip_transfer;
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +skip_transfer:
>>> +	mem_cgroup_put(memcg);
>>> +	return ret;
>>> +}
>>> +
>>>  static long dma_buf_ioctl(struct file *file,
>>>  			  unsigned int cmd, unsigned long arg)
>>>  {
>>> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
>>>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
>>>  #endif
>>>  
>>> +	case DMA_BUF_IOCTL_XFER_CHARGE:
>>> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
>>> +
>>>  	default:
>>>  		return -ENOTTY;
>>>  	}
>>> @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>>  	dmabuf->size = exp_info->size;
>>>  	dmabuf->exp_name = exp_info->exp_name;
>>>  	dmabuf->owner = exp_info->owner;
>>> +	dmabuf->memcg_account = exp_info->memcg_account;
>>
>> The initial charging should probably be done here as well.
>>
>> This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
> 
> The problem with doing the charge here is that it happens too late.
> That is the reasoning for this proposal to move all the charging logic
> into heap allocators before pages are allocated.

Oh, that is a really good point we need to talk about.

DMA-buf heaps is actually a rather simple use case, but we have way more complex things.

For example in some use cases the backing store of a DMA-buf is only allocated on first use and only then it needs to be comitted to it's memcg or dmem.

I don't mind implementing it for DMA-buf heaps first, but we should have the uAPI and it's handling so solid that it also works for future use cases.
> What we could do is fill the dmabuf->memcg field when the flag is set
> (i.e., committing into the dmabuf in the patch semantics). But for that
> we'd need adding the memcg we want to charge it to into exp_info in
> order to support charging to cgroups other than the allocator's (for
> the common case would be simpler as we can just look at current).
> Maybe that's what you meant?

At least for the DMA-buf heaps use case that sounds reasonable for now.

Regards,
Christian.

> 
>>
>>>  	spin_lock_init(&dmabuf->name_lock);
>>>  	init_waitqueue_head(&dmabuf->poll);
>>>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
>>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
>>> index adeea8cd328b..a764167167ba 100644
>>> --- a/drivers/dma-buf/heaps/system_heap.c
>>> +++ b/drivers/dma-buf/heaps/system_heap.c
>>> @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>  	exp_info.size = buffer->len;
>>>  	exp_info.flags = fd_flags;
>>>  	exp_info.priv = buffer;
>>> +	exp_info.memcg_account = true;
>>>  	dmabuf = dma_buf_export(&exp_info);
>>>  	if (IS_ERR(dmabuf)) {
>>>  		ret = PTR_ERR(dmabuf);
>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>> index 23ec0ff23fba..ac0ec88cab93 100644
>>> --- a/include/linux/dma-buf.h
>>> +++ b/include/linux/dma-buf.h
>>> @@ -433,6 +433,9 @@ struct dma_buf {
>>>  
>>>  	/** @memcg: the cgroup to which this buffer is currently attributed */
>>>  	struct mem_cgroup *memcg;
>>> +
>>> +	/** @memcg_account: account buffer memory to cgroup */
>>> +	bool memcg_account;
>>>  };
>>>  
>>>  /**
>>> @@ -505,6 +508,7 @@ struct dma_buf_attachment {
>>>   * @flags:	mode flags for the file
>>>   * @resv:	reservation-object, NULL to allocate default one
>>>   * @priv:	Attach private data of allocator to this buffer
>>> + * @memcg_account:	account buffer memory to cgroup
>>>   *
>>>   * This structure holds the information required to export the buffer. Used
>>>   * with dma_buf_export() only.
>>> @@ -517,6 +521,7 @@ struct dma_buf_export_info {
>>>  	int flags;
>>>  	struct dma_resv *resv;
>>>  	void *priv;
>>> +	bool memcg_account;
>>>  };
>>>  
>>>  /**
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 6b30baa79fa9..36fddafbef4e 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
>>>  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
>>>  			      unsigned int nr_pages);
>>>  
>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>> +				       struct mem_cgroup *new_memcg);
>>> +
>>>  void __mem_cgroup_uncharge(struct folio *folio);
>>>  
>>>  /**
>>> @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
>>>  {
>>>  }
>>>  
>>> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>> +						     struct mem_cgroup *new_memcg)
>>> +{
>>> +	return true;
>>> +}
>>> +
>>>  static inline void mem_cgroup_uncharge(struct folio *folio)
>>>  {
>>>  }
>>> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
>>> index e827c9d20c5d..ea957f4b1d38 100644
>>> --- a/include/uapi/linux/dma-buf.h
>>> +++ b/include/uapi/linux/dma-buf.h
>>> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
>>>  	__s32 fd;
>>>  };
>>>  
>>> +/**
>>> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
>>> + *
>>> + * Any holder of a dma-buf file descriptor can perform a
>>> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
>>> + * cost to a specific cgroup, or move it from one cgroup to
>>> + * another.  The ioctl charges the new cgroup before uncharging
>>> + * the old one atomically.  On failure the original charge is
>>> + * preserved.  If the buffer has no existing charge, a new
>>> + * charge is established.
>>> + */
>>> +struct dma_buf_transfer_charge {
>>> +	/** @flags: Reserved, must be zero */
>>> +	__u32 flags; /* unused for now */
>>> +	/**
>>> +	 * @charge_fd: File descriptor identifying the target cgroup.
>>> +	 *
>>> +	 * May be either a pidfd, in which case the charge moves to the
>>> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
>>> +	 * by opening a cgroup v2 directory, in which case the charge moves
>>> +	 * directly to that cgroup's memory controller.
>>> +	 */
>>> +	__u32 charge_fd;
>>> +};
>>> +
>>>  #define DMA_BUF_BASE		'b'
>>>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
>>>  
>>> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
>>>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
>>>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
>>>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
>>> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
>>>  
>>>  #endif
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 7b841b905759..3adc84fe6668 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
>>>  		refill_stock(memcg, nr_pages);
>>>  }
>>>  
>>> +/**
>>> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
>>> + * @dmabuf: buffer to transfer charge
>>> + * @new_memcg: target memcg; caller must hold a reference
>>> + *
>>> + * Transfers the charge for @dmabuf to @new_memcg and, on
>>> + * success, stores @new_memcg in @dmabuf->memcg.
>>> + * Returns %true on success, %false if the charge against @new_memcg
>>> + * failed or a concurrent transfer raced on @dmabuf->memcg.
>>> + * On failure the caller retains its reference to @new_memcg.
>>> + */
>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
>>> +				       struct mem_cgroup *new_memcg)
>>
>> I would make that more generic instead of dmabuf specific. E.g. something like this:
>>
>> bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
> 
> Ah yes, I like this generalization. And the implementation remains
> mostly the same. Thanks!
> 
>>
>>> +{
>>> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
>>
>>> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
>>
>> This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
>>
>> Regards,
>> Christian.
>>
>>> +
>>> +	if (mem_cgroup_disabled())
>>> +		return true;
>>> +
>>> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
>>> +		return false;
>>> +
>>> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
>>> +
>>> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
>>> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
>>> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
>>> +		return false;
>>> +	}
>>> +
>>> +	if (old_memcg) {
>>> +		/* Uncharge old cgroup */
>>> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
>>> +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
>>> +		mem_cgroup_put(old_memcg);
>>> +	}
>>> +
>>> +	return true;
>>> +}
>>> +
>>>  /**
>>>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
>>>   * @dmabuf: buffer to uncharge
>>>
>>
> 

