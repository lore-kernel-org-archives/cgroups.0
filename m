Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793592222;
	b=lKXufL6fYZ0DTp0Rjazl0aALFda6Du6pitfHtxVwj3TvkvW0A2rxhA4+qRLrhCLiDfSl
	 GtMIYI7LyAfqZq1QioU/pV+p87qoJBdfVrhpyOzHwV2sOG8kdxmaG2jV3sabcnhbGC6um
	 wlT7VR5sRVLTTEz8GLxe1kMRsS7Im3/hZATwY/RWRXvh1w2JkQGHZrNRX8p3/W+O6yGnM
	 OlJcrTvkcSr4cOUujjTCkfYgKracxhn/WD+TQ57h+enVqqRz7wO0qcGrZhiVBuzgYgbdS
	 CUL2kCug0AfdUSFY2cJkDrUj/V9BrTpAR/htJcNjkr1dZaT4ZOV7wRfot00LW76kcRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793592222;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:Cc:To:
	 From:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=YIa39ZjUxRRG46A/D8IxpQ/XvD8KNdw5ZO9iyxMZmTE=;
	b=lr9jQStc+K2qn+9FJPEwE0h/umc27zVFwLpT73Fe6Eng3SXRzNRNXHImyEP8PTemABoS
	 5mnZ5BqZrFkJVKrD9Ey9i3ShGQM0hE4zmmNW59mnNn0jJOXg+Ji+u8I756OyR3ixOL+Qc
	 xhqYImQUZ7egdm1QdYxWH06Zg77WJoOuA7RwHTY0kwaaUNB0QBw+bqIJpk7h+UHSCZBfI
	 7wzsgi7VBSzbGD7Vu4Rz0+/qcwQP3MQ1/87PGrUTMP9n9tlJIDJyNPl/2lvBa84AiTRlA
	 EHU799FjuRr3dO1ZhjiBXpSZ7om0XsKVUh1qBd/YNxqU31vbYAa7Ft8bhdCxVuPOCmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SNvqp5G5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.65
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB8606A324;
	Mon,  2 Nov 2026 04:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91EB8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SNvqp5G5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmQBdYIWP3tzR/vLiH/pOR0xwLnCitECQyrNObfft6JwJlrKXHCSalSk29H/G25h4ro2k5JZ5si2QzuRQh6nrHSoEVYB97Ef8HJC+lc6XH6z2XR1bivYbQUMyVmkZ0XFw3jmkWgWOLB5kYYSALGqCCNf103LBx8xnFP9OJEBmZ8sQj2oliZ1QQlmKUSYOb2M51mT2fWjGMlV2kimEr4F3vPCFfA5Y5IstQ8/8wzeFZb0qfUkijSoOy6ek18CZmG1EX1/BgqZZVeQeeoA7oHJA124PJ7pxhARo1uNlqAaX1oL9XhzsMrrMhk0CfgDnEDx9JmuC7fjh9FM/ePjnT9T6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIa39ZjUxRRG46A/D8IxpQ/XvD8KNdw5ZO9iyxMZmTE=;
 b=bwAt7gxVNX4RYZqD00IT/baKV0azRIRpz3j3NdJIbQuKpMrJyOp8Db+7D28G8cyjk4wXxcJvCwwR4rkpTElwPFXFCFCEkvoHOdcS/+lsYjPiOyntRg0V6p8fNiEHSgZPNdZL7r84yQNsVO5pN+u6YDTXgiIsFDCHqhBzhgUTEtQOdtDWh/4vxnuj+rcLg6Bo/aNBsRgC0fg+R1pTD/XSgF0osNerObXb++c60KdTNqnLYy0wt8Go6DqxDrNRcCG5R3Xo/qbhLvZhAUoMnjMpqkIy4lq6MdGbui/jifLPE0ldz46iK+LLmnZqADYH/YR7UEP7Fekzx29eyXJo7VjWjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIa39ZjUxRRG46A/D8IxpQ/XvD8KNdw5ZO9iyxMZmTE=;
 b=SNvqp5G5+WMk8ROVRDkZ+/y1XFhdxsMNy3M8zXBHzfmSEZZCf+Tg1/r9VhbOxbTQhPR8gs+AudoObdlyPflIMfMefrpSrXdBFIUWwZL1xGMlDpJreMisZCfo2qWTQ+7A2w5r34Ng7U6uudeO7lH4pBr18RspBlVzIg+blOvVdi+8HSRy7vCsV8AgCmQHXrCSo41pf0hFTcyLcbI1nC17p72m4gXRi5q4vAvRqXuS0p7VIsm02X4jFTdCB1FDPekFoNrjYsyI12n5INfviwSrcSh4ejkACkKKzD+GCgq+ARzkLpea4GTVAA1IY8yDzb29fFbVqt0YKi/tXggTobXFqQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS6PR12MB738673.namprd12.prod.outlook.com (2603:10b6:8:417::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 04:03:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 04:03:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Nov 2026 23:03:36 -0500
Message-Id: <DMKFDL3A2TOX.78ST1JQZ0C3K@nvidia.com>
Subject: Re: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when
 returning folios to the pool
Cc: "Mani Tofigh" <mt4022@columbia.edu>, "Mike Kravetz"
 <mike.kravetz@oracle.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya Horiguchi"
 <nao.horiguchi@gmail.com>, "Frank van der Linden" <fvdl@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>, "Kaitao Cheng" <chengkaitao@kylinos.cn>
To: "Kaitao Cheng" <kaitao.cheng@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Mike Rapoport" <rppt@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
 <20261102024910.31486-3-kaitao.cheng@linux.dev>
In-Reply-To: <20261102024910.31486-3-kaitao.cheng@linux.dev>
X-ClientProxiedBy: BLAPR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:208:32e::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS6PR12MB738673:EE_
X-MS-Office365-Filtering-Correlation-Id: 24fc83b6-471d-4401-e45f-08df38964532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|22082099003|18002099003|921020|56012099006|5023799004|4143699003|11063799006|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261022105027099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	mOqYEilScVPEK2+YebiOE3sZ710pkfnn57FczT5oxLmLLmPPNgfQs0eZ/0n+fCxzReo6JS0CxZgJSzcaOM60Sdmn8PwYwhGKBSVB9gPlMeY58vYLU7TmjV8EOhuKv7MRa70Am/h2wzTnu9BaJZNi1w3mZb3kWcJGMK1TUYvnDvRR420qUMePJC70dIBkiUUpkOvn31mVuMigWO8uUCga7I13TRy791t02rFnA8qovpcd/QfeVJHBb7zM6TiOoUtyDft5zdGKnxfcttS1mHjaXApqsMHOKq+zyMoJda3rEACkFB7LbGlMlu8VGyEDIndS0Bx8VhHe9nONEKcMRs1u7Bo9Xe29cg8uk0/WfKDChVwkqWbyVsct2Ruv5mhhl/L++9RHKvPrCPSRmWohK5KBLpezkOmmav3zH8VZezFPbeWUm28AAHYI5HnvntLTYu5FFTqqr65MEmgC0mT5Hd/sXyP+duCaAWT5p1re7PiBI/xfpMrSTXAaTNtpo4ig47PVlAmx0I3v2DzRsl2kryeSmWyXhNrvIccErKhMop6PshGai3MSxcK2omaO2TsHQBrQnJUhocKr97yqJ+TY+nThwEzu+BuEuMyrn7hNlJeb/ZorzMoIpg0+JNTBnR8W8/JlhyBu0EAUsUaObfaHVjhVzocjHBsiY6ib9ZrYM18CxDi7xeh2ZMjv4PMI64b6KIgWIJjnJjRXVLTI+qe4lAvm3Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(921020)(56012099006)(5023799004)(4143699003)(11063799006)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261022105027099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0FSek5POWdwZ0JKNFFyVkZmVWNCWkpsbmR4aFdYdi9VbjdJekdIWVFJVFZR?=
 =?utf-8?B?TUtMSXdXMCtQZ08vdjBaQXVLdHZzdFVRYW9JOTRicEpPU3VFanlMcy8zOHJx?=
 =?utf-8?B?Z1VYUGxoNTZEcHB1QTRHTDR1MXc2bVJCMWpjanp1ejhPU1pnSlNwUTFoWnNV?=
 =?utf-8?B?SkNtNUg4ei9Qa245aWdibzZKdk04SGNsY3ZJLzNpb0UvdzFHZDQyWFRDL2xR?=
 =?utf-8?B?MGVHeWg0bUMxTERzK0RCT3R1djVOTWxVTVlqQ2U4cjFWT3h5QjdKeTdYcEtG?=
 =?utf-8?B?K3h0emFLWHBEOXJSaEpjTTY4ajNOZVphbDhmbEkvZjNEcGVURjFvbWRGUnBV?=
 =?utf-8?B?TjQ1WXRJbktQRnppN1p4SWt4ZW84bGhoaitCb1NRLzg1azIrZFlKbkwyblkr?=
 =?utf-8?B?TXB5b0lmbVFsN3ZzaTJIZE1iSC9nOXp1TnNCSWhPcmJyczBBNzNVVUxGYVZL?=
 =?utf-8?B?clBEeXI2QXJqbXRndVF1WndSaU9LZjhuV2VRQmZPdlVIbDNXVVZyUFNub2d4?=
 =?utf-8?B?NUQ1bFlQVVdoQTZrRjE3c3owek9RVWJSb09wQTFSV0tpTDdxZEN5SXNYMU9n?=
 =?utf-8?B?RTBCZVhBNEZPSVVEOGh5dStMMlRWcG9oaTU4MXhMR0xTLzQxRFUzNm5Nc0l6?=
 =?utf-8?B?R0lFV3NmeU1IOHZFRkszbzR1SjdHU2thNitJS2NZRnlKNTNKeTFDWjFYeldz?=
 =?utf-8?B?Y1BHTUlEMmRNNVk0Z0RwbkJEc05IU0JFM2MwdEMwR1MxeFZBY1JFY1FOTnRw?=
 =?utf-8?B?b3J1NmhIeUhoNFdmZjF1ZC9zTEE2aGF1MnMzT2d0L040dzZFcGRuT25rQ0JR?=
 =?utf-8?B?ZW96NVBmeFgxTnN2ak9sU0xJYXhjdmMyY1cvWWdhdUp1T0xBQU16YnVsQnFW?=
 =?utf-8?B?M1V2Yk8ydE9xQzZnUTA1cEpwNGhRR1JYZXI2WHF5SStqQWRZSHhlTTZlc21L?=
 =?utf-8?B?TnozUHgyR3FXSmpTQWFDQjBzNklnSTh1bE4vZ01KRlhvTFc4RHVmMEhZOVND?=
 =?utf-8?B?KzB5SjVTanpGQWxMUzJWUkhWSGlSZFFqNVhNdklQNTMzd1dscXZ5QmFSTTNi?=
 =?utf-8?B?T0Y5M1krdnFxUXJmTUZmOGR1WllCWGpIcFJQM0F5elh2RHlEYXV1ZXJPbnB3?=
 =?utf-8?B?VHEzZy9TdjVGNjZxYTJTMThZdWZwb0FmTnhrWngwVlAxbVkrR0dZaHJHdyt5?=
 =?utf-8?B?cTFxc3ZPRm5GcEhDUy9NWE5OWXB0TSs4Q2FFTmVnL2hJZklId3RycXpZNGUv?=
 =?utf-8?B?SmY2ZDk4UWlCVTJFWm8yQS96Rk5oOVk5Y0d1OFFWaE1sSTdlajZ6SVlHekZs?=
 =?utf-8?B?c01OaEZyak8xMmJ3TGRWdk1wbk1WdmFtandIUHV4bTJTWnAwUkVsMTY3WmNp?=
 =?utf-8?B?RDVIQk9TZWp6bVBFQmNBdjFtaUZCUzkzOWxDSUwyaHBBVWJQZGxTQldBZ3Rj?=
 =?utf-8?B?M3dRbkhmcHF5aVY4dUg3cjQzZHRQUGxJRmlFVjdNSTQ0WXk0TnRNN0pFa3dK?=
 =?utf-8?B?U3A5cDYrSUpZK0prQ1JCRnlaYzJSUWhWOU81UFFXcExIc0VwdEorN1U5Z3RK?=
 =?utf-8?B?NDd6RVFkb056ZWs0TTJISElvMGJhUy9KQThHYjFYNHg1YUVDdEkwQVRTcnFY?=
 =?utf-8?B?M2dBWDNMLzFZSEJ6bkhYQ1ZMQzhpRWRNelRZUkZqblkySEhnZDNoREMyT1gx?=
 =?utf-8?B?NkR4MTgwcDh2V2hBNEpQakdLSmtUTTlQOE5WOUE4K2FaRzJHYVpkSE1hOHVD?=
 =?utf-8?B?WVQ2bk5wcmhQZzdjK3c4cmJ4YmpRNC84SC95blcyQXYvTVRodFpQZ0ZxOXFZ?=
 =?utf-8?B?YlBHMHdGQWhTSGJRbVgyQlRVeVgyT205WTYxSGp1NXVZMG4vUXpOeWw5SEZJ?=
 =?utf-8?B?S0J5Y1NQclJma09HTktjWkQwK1VCL0huR2o5ZVMrOGtwelA3SDBVSCtqbDNK?=
 =?utf-8?B?d2FKV0owVXdjK2d1dm5Sc0RZZVdXbGxrdndTVm45dzdUK01ZbzEzTWUxbVla?=
 =?utf-8?B?a1l3WUI1bXh3OGU5S243Nmh6aHhEdWN4VlIrbXZrZDAyQlg4YVV1eGFmaEFV?=
 =?utf-8?B?Rmw2bWVVdXRGeUI1RE1hUjlJdmRDSWJ1SVVJbXc0THliVmZ3TWxsMnIyb2pT?=
 =?utf-8?B?cnNBTW1ROHdmR0pzQmFCOUMrRnFMZzhxT2tKVUtMV1RWUmVucy9mV1o4dVAx?=
 =?utf-8?B?cUl5dWFTdHV2clJWdDByYk9IZUpDWW9wUElwTEFnaEJkMGdpK3luZUZFM0pl?=
 =?utf-8?B?RzJBSmptK2hlSGg1clJoSlA5aGphNkFPdHRrcCt1cjZxQXMzNG44b0NHN0ll?=
 =?utf-8?Q?ZP8znxEaaa9p6U5RZ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24fc83b6-471d-4401-e45f-08df38964532
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 04:03:36.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44rOBgg5Qrek7xgPgwGuxWShN1YW9QTlRbA9b/pLD62hd2a1VLgdaMpg6/uTdkBE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB738673

On Sun Nov 1, 2026 at 9:49 PM EST, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
> restoration fails. It clears folio->private and restores only
> HPG_vmemmap_optimized, losing other flags that must survive the rollback.
>
> Clearing HPG_cma causes a later free to bypass the CMA release path,
> leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
> loses the indication that the locations of poisoned subpages are unknown,
> undermining the checks that prevent freeing or unpoisoning such folios.
>
> Preserve the existing flags instead of resetting folio->private. Callers
> already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
> returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
> before attempting to free a temporary folio, so a failed vmemmap restore
> does not leave that flag set on a folio returned as surplus.
>
> Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
> HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
> incomplete transient flag cleanup.
>
> Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of =
raw error pages")
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA area=
s")
> Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b=
258
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/hugetlb.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

