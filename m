Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793959657;
	b=TjKtXvM6W/8I5zqoziSYvVMpBHnfHjUe+EAUcSVBXRRKpUEV1R5rpHYkIsEbAJ/dzQLK
	 X99UtPV9ht/27IskZe9Br9qzMPHcVorH2kjFRPA6imL+GEH89VwNv2bsOcsT+6U0URwN/
	 LsqD4xDGRnuxiLNtm/y1BwzlRrdYBQiA5cUqMfyJAmUMe3v66+Qdaps3gbG5ALd5sjJ3T
	 Afu8ZIWPJ3uGYFqW2uOnfjn/a/o4rHgY47Fpn75hJDn3CrE7jQdnLEVgz32EbAtLsaNLe
	 Nk0ECxgD9lUJanm5d+2Yo11M6d/uxx45Foqvrjnrb4WwKcPKwvC7O1kIeotWcIpaStw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959657;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yHD/RpfUjSx94Lvg9mBmOf6cNArrPmvUb8sTgQ54zbM=;
	b=bk5XBQ+51baB95d8/8t9C5Bqbhqa4WC5b5Kf+cr0HPrZD/lXBwuVIo3k+OFWN9jbxE9l
	 sXoTYOvQuXuRjV+hwIPqBBPbr9bmvc3sOUq7EfgHPnmM7kBETDcxbw3Ws/etM30gFCoxv
	 zNSpJohfklDGSq/Qys+kb9SDPQ0XnhbMNtDUWUARa8wIfWMAOdEccIFgf0BtKiXWbzs1R
	 FOmMOpvllT25wR+RGdyo8JXyG5MU1x51QdyShk21yh35b2E3xpocongQOOchcSQiHFE2n
	 9okTxlfrPMLIaQEt7C6s3tjZcx/4FsqYLuYi8mPYy70MpKyOpQcb62BDbescQHT1/8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=awE3xrn6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.60
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51A7606A329;
	Fri,  6 Nov 2026 10:07:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B51A7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=awE3xrn6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oOjLziJGg25OPrrGcUkBC999NeGy4KknI71F1V56PLXuUP7vzw4S1KK0ALukAc65a83+AuK2y+QTn9JXKzpZ9MKBaFW8BEYLv5e0CLbXKd3N1t1YLH9gR8s+bkXuIUB8okXNuHhbXVCH83+xexD0UoGCgP7p3OnTNgMKlJjUFN/1ZQH7S8rTpF0xQuJVtKJXzqjaJiT3pSG+58+rdLA8arJC1k+ru3Z9vKeQy+GNY9o2EO7VA3Z29/HJpqkvBDW0Dt3q3aUxwK7cAR7GRilpfvDAY1p7FN8uGQmJDgGVa5XiOvgGOEcDiEssFeKxVZvrzYVrU0LcRGWi1iShXQX2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHD/RpfUjSx94Lvg9mBmOf6cNArrPmvUb8sTgQ54zbM=;
 b=cVFqWd46YfElK26vnIXMjYAtCBUQHWp25jvoMuVkPAJEGNdYpqsirhK2IPwK1AZpKtDx8qJ4IYsgaOhYw/ve1aRcPqw1dcZ7b90jNxZvobCODZpJdk5sM+Vr/9trNSAUrqdO3pReGwM0NB+5pj1XDL/ZF4R95WNG62VGllgCmEfVI1B57K/0ljeCWM0+5iGgWdujX/b9ERh2MzUm1HKTk2Drdq3fJtBTw1cEYYxjj/9B0rzKBe88ACgoHE0zokvJro4z1zsFWubsCxlP+38z+SxWQJDGuY+yVYMyuAfvFB8/J2vqSHPx+8iqt3JlOoBFpi0DJomZ4++gRcBkdr15oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHD/RpfUjSx94Lvg9mBmOf6cNArrPmvUb8sTgQ54zbM=;
 b=awE3xrn65W3cf3pFfBrnW2h/ClWfAFw7QCkyoC4FlggVu/zn/7uDU7UliP+7feNIaHmIdCCqu9kWANy98y8Lu7i5kMpDyiUGzNzOVyupRkDBbGtp/x8L851pKqZyD5R5bOJu19VBrpRUBRN+7LtcF+sYN8Kcm2XpSb5F9HA7zitRfdvk6M8Gl7UyYd1T+nEeztLHUAr1s354ZQvDdE9glQtIDKD+edN4iD6JA1M82+lzOhZf0cWIRpjz2dn9UIZ/ljH1zLO1CS4XJ6o1YzdF6XpD9NdNy3yi6UCFkujui7q+aQ3GgcXeQGK43TawqNllClKc0U5XsVz/yXidz+5N9g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by CH2PR12MB9495.namprd12.prod.outlook.com (2603:10b6:610:27d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Fri, 6 Nov
 2026 10:07:30 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 10:07:29 +0000
Date: Fri, 6 Nov 2026 21:07:23 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>, Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v8 0/7] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <au2m28-Zl1MMs4Rk@parvat>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
 <auwfZj6QTwQqFIZb@parvat>
 <CAN+CAwPNsSWyqbKRGEL_rtrz9CWTdFvhKFvZpbUNoJJONXxuZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+CAwPNsSWyqbKRGEL_rtrz9CWTdFvhKFvZpbUNoJJONXxuZA@mail.gmail.com>
X-ClientProxiedBy: ME3P282CA0061.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f3::12) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
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
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|CH2PR12MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: 2708a7e3-fe0c-43ad-9459-08df3bedc432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|7416014|23010399003|366016|261022105027099003|261022075727099003|261022113327099003|261028144727099003|261026140227099003|261026121527099003|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	xcZv+/8rQvxLjLDqzU1lXiIviLWt8NRSDDTp4SIWZSh4kpIiaEr4UJEhIFNyF7l0rzCVUgXMGf4DGlEacUoY5ypfRtGrfKrolZyAPdr6LPPZq+/bbKVodJtY8uIhM+eGZ8RhnV79jVX6s1vnPpE2or06gNcTFwF2ExwO8Y78UgiWof+6N7C7Xonzs4citbiV2V52Lnj2Q9+1SYRbLy3fLQ0vRQrxT1LKtx73iHseF3qlMARwcW4c822fiXzIOM6sPqxK96De2ZXT/KJFnV5wkcP1bah9fuYjCkIfbEWvLS1AkfrbwaLsysKwZihgT+4kwi3AEi5YPO95N7P9wJgXGz2cpXqgwJVxNLvilqtL75ZeFpLL4irnnpXnmqknRZGjEZV4aC+EP/9X4LEe5u/Po03ky1d74IMzNPdVyhhH6GasfHO4tARCPK+m/BUngjCi74IeVVv9gAfTZIrsIm0bDBfRDIEZVgzmEKAfr219CZNn1OMMg8aU45yYZEyBJfb+cOTA8bsP5evjFyUmN7ON1AAo9Unyo70eAB7mOKv6CEJBW2BAkYRfeTc95FCUbeuUz598PZZcHQ17MURu4UFFwC++XudPhHHY1gnA9vYfHZE+svTsWRfQQTtmjgj8vtZzXaqJ7702Z9C6y/lwSNgYhIdzwIy2/gkDuUOJxtafhjY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(7416014)(23010399003)(366016)(261022105027099003)(261022075727099003)(261022113327099003)(261028144727099003)(261026140227099003)(261026121527099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enAzMmZZa1g1M2YvaUYxL2RscHZ2UXl5RHZtQ1RjL0VDMGtyNVhrcVE0TkNu?=
 =?utf-8?B?aEpWNHZTM1YveEtaYVRDN3psSG80TXpLTlZNbE1zRHNHN2NYSXYrRFBGNVhT?=
 =?utf-8?B?WHJxNHJ4KzFqTzR0UzNKdnNBdzJ6UHoyakVLT01WQmNYWHZmaFFMd0V5OXYx?=
 =?utf-8?B?N2phMUxWK0tCdC9WNzhtRnA5Y0Faa1hEVGlsU0hZeWVIQzBDSUY4Z1JDZ3R3?=
 =?utf-8?B?SkxpVkZNQ0pIeUlZNzMySHE3QXAyVlRWbVJpdGpZZVMweHhFY0lXWUhtcm1y?=
 =?utf-8?B?MExuODc0QmJvT0wwcFN4ejJhbGxkU2p0Uk5oQk9FcjNwditCMHZ3TU1wU3JM?=
 =?utf-8?B?YWUxaEdQL2JRK0tiaXVQRGo4VUdkUWpQaDg0aGczMFNGVWRac2MyUDlPZThw?=
 =?utf-8?B?SHhJUHNJdk9iS3pyVDNkRTV2U3h0RHRBZUxCY0FMa2FCcE5Sb3ZSMEJibzZH?=
 =?utf-8?B?bTJIZ3F2cWJWQ2RxMjA2c1hNbFpGbk1VTk1pRUhqRXZzRUNLNC81VFduQW1S?=
 =?utf-8?B?ZHp5WG5RcnVicS95QWw2SHpUQlg1cGZFbDF0WnFBQlJkQ091TU5Wa2M4Mm1K?=
 =?utf-8?B?ck9YWHM5V3lTbUQvOGRlMEtmZys3aS82bHRiMFNyQ2JTbjgzRldIZENVL29J?=
 =?utf-8?B?THFqcldKV0Nmb0ZabUVvdHZhRVNPQlA2UjdsTUo2V0d3ZFdHSjFoV2Ztc3B4?=
 =?utf-8?B?N083MTNFOEgyYzZTU3BxWDQya3drcUlCU0U5ZnhhSXNyTmVGSUpCaHA4T1V4?=
 =?utf-8?B?dUlrVzNSTUxNa1lYdm9YUEZINFlwMTNsNkYrZUpNT2VHU2w0Q1FlYld4VWVG?=
 =?utf-8?B?bFhpZ1VRYVJ4eUJYQ2QrejNpbTI5bUpsVDU3dmxnbzgrNDFuYmdTbXNtUU45?=
 =?utf-8?B?WjdHVjFwS0JGVXdnckVQY3JJRzJac2tXMTV5UjB5VFR0TE83NzluR2ZnRmd6?=
 =?utf-8?B?UWJGRmJpbmpPZFNYMkkyaDdmTVVTZEhObXhxcDQ0U1ZpNmNrZUcxMHVGTkMz?=
 =?utf-8?B?d2F4SmZtVEUrR1o0VmFUQTdoT3o0OHdKUHd4U211Kzc3YldGd1VYajA5ZmRw?=
 =?utf-8?B?SjdYNUR6R0hPb1prVkJSYzJkcjRRTzM4VFljak9GOHkyNXdOaTlXSzJ3cGNw?=
 =?utf-8?B?UFpZcFgzTFBoUUdncmlSOWVsZmlYVmpWZTJSV0NaYTRsYzRZVjFqT2lJdzhS?=
 =?utf-8?B?Nm0vblFOem1VS0lYYkxacjdyVGRJbEJtZ2JYT2ZaNjZsSkQxbjd1Sy8yYmw3?=
 =?utf-8?B?Qko4eUJjTVBuSGdIUklsUldXMm1FSHNtWnZrK3poQVNpeUl5aE0ySlZhb1pl?=
 =?utf-8?B?NUdrOGJGcVlHaUV6cUZIczVhMFhLS0p5NnBIMjhycFBsWDYvekh5NTJsNmtO?=
 =?utf-8?B?SGZqY1RBUFAvbXJzK09BYXR4dnRpRDYxY0xjVWRiL0lYRE5IMVR2YnhzRlJU?=
 =?utf-8?B?LzZZZkFqM3VQZTRlM25VeU1zdkI5NlNNMTZmcU1INGJFeFZWWUtnRzMrRjJP?=
 =?utf-8?B?WlVlT3lSQzBscCtTaXoxOGlFWlB6b0ZZQUZrZS9FL3hZNSs1L0lrWnp1QUFX?=
 =?utf-8?B?TTJ2R05ERnpUc0FlRnNkT0JXZ2p1dzFtdUdoUC9PVEdpTkFEU1krSUpPUHdv?=
 =?utf-8?B?TkRlVUMzYWMyaUtWL2ltVW1GKzFpaWVWOVBoZGdqNXBiY3BKdW81WkhzS3hG?=
 =?utf-8?B?N3ZtM1lLVWtOdGNUdnVXR2poVS9TUldXMkxKdE9WdGhjQk5aNXVTVkNSeXJT?=
 =?utf-8?B?dC9UY0RiWW1RZW1UU01jR3hYcXdTaUFlbmo0WXhrb2o3Qk9yb1lBdTdiYzNG?=
 =?utf-8?B?OXNETGgzNFFvWTNxcVZoMnFUMDUxZWJnc0ZxRHBZbDlrQW94REgwZU8vdnJh?=
 =?utf-8?B?aGdmZ2NzSm4wdHVsVVJiS3AzUjZ0b1ROcGdXVU0wZXRhV1AvWHFLa1d4UmNC?=
 =?utf-8?B?djZ1L0tIbzlzb2dnMGNSWldEY21oN2ZmKzBSZkFkclJZUTVMckpSeThpUnlQ?=
 =?utf-8?B?cmZiREVyN3Fwc2FtS24rZzIrQ2R2bUdxeUpua3FHSThkSGdVd2lxM1M0UnVl?=
 =?utf-8?B?QkZGT1RKbklTU2tPL0pyd3V2ZlA1NzJLQTV4NTc5QmMrdFRZWDhLdHBKRENR?=
 =?utf-8?B?T0c0N0ZkZzhNOVc0Uktudnk2bXhuYjJaSmNicWFFSlp6aG9BOHVxTGREci93?=
 =?utf-8?B?VVdmWDBxbmRaNmxJNWtaWkxDbzhXY29aVHF2ME9aR1pNd1czbnFXZFZFTmNk?=
 =?utf-8?B?VFo3TnBRLzVBMUxaMU1hMFh2ME1ZeWlHd3F2K3dSMm42SVA0Nm1IWVJGK1VE?=
 =?utf-8?B?bzNEaXdhdEY4ZncyK2h5WWtIc0VxRHZ4ODQ4Q2xnK3AvS1B3aHZraWh2UC9E?=
 =?utf-8?Q?Sfebv38LhzeA4LWThWJVcs2V7a6ZDmv5QluVdw+FO13aM?=
X-MS-Exchange-AntiSpam-MessageData-1: z5HBvwBeW1W3pw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2708a7e3-fe0c-43ad-9459-08df3bedc432
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 10:07:29.7676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ouaWUTCbTbCYr2cYHf20oDNO5BqbPeIldhV/90LeXqPnDiajx4n3Tz0MXM7a9fztczfW3Aq6GIHEpJgZ+ZKeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9495

On Thu, Nov 05, 2026 at 09:50:43AM -0500, Joshua Hahn wrote:
> On Thu, Nov 5, 2026 at 1:17 AM Balbir Singh <balbirs@nvidia.com> wrote:
> >
> > On Wed, Nov 04, 2026 at 03:30:21PM -0800, Joshua Hahn wrote:
> > > INTRODUCTION
> > > ============
> > > Memcg keeps a per-CPU stock of precharged pages so that small and
> > > frequent allocations do not walk the page_counter hierarchy every time.
> > > Today, the stock implementation lives in memcontrol code, even though
> > > the operation it caches is a page_counter charge. This makes it
> > > difficult to add new page_counters to a memcg and preserve the fast path
> > > behavior.
> > >
> > > This series moves the stock into the page_counter layer.
> > > page_counter_try_charge() consumes the stock, charges a batch to the
> > > hierarchy on a miss, and refills the stock with the surplus. Memcg no
> > > longer manages the stock in try_charge_memcg.
> > >
> > > So the stock keeps the existing layout, which is still a per-CPU bank
> > > of 7 slots, each holding a count of precharged pages that it hands out.
> > > It maintains exclusion using local locks on each CPU, and for remote
> > > drains we schedule on the memcg workqueue.
> > >
> > > This change gives us the following benefits:
> > > - Separate charge caching (page_counter) from charge policy (memcg).
> > > - Makes it simple to keep stock out of interior cgroups on cgroup v2.
> > > - Prepares for future work for stock improvement, which can now be
> > >   isolated from memcg changes.
> 
> [...snip...]
> 
> > Is the main motivation ease of addition of page_counters to a memcg?
> > What would those counters be, why not add them here?
> 
> Hi Balbir,
> 
> Thank you for your interest in the series! So yes, that is the main
> motivation but this series offers standalone benefits as well (which
> are right above).
> 
> The new page_counters that I want to add track per-tier per-memcg
> residence. Those are used for enforcement (and not necessarily for
> visibility), so I think they wouldn't make too much sense to add on
> their own now, without the actual enforcement parts.
> 
> What do you think? I've also linked my tiered memcg series [1] if you
> wanted additional context.

Thanks! I'll take a look. I was just curious based on the numbers I saw
in the cover letter and wondering what the changes got, I can see how it
helps in a hierarchial situation.

> 
> Thank you, I hope you have a great day!
> Joshua
> 
> [1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

Balbir
