Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795541489;
	b=lUx+ciEvUN2dDYb7+gL9JrQqLrXlG+AhCIbYo6uVcS0I86Zn3shWSk7FlzNqAGcO/hJ0
	 dUNNbsKd5D/BrVI6z+IFyh6zNxLuBWkqdvrifBOnf/PqDfE8PZ5ebGD4tQHDKRf8hts2W
	 z75nsO7VEN1NSIbQCf6USWJlSSQ2Cu104vj7OHJ0pJ/iLC1Fa1XWFDSBxvxPkeSVSD1TZ
	 GGXI6c+NLd6S9lug4lV4HIjqG/WMKUyK3ZEUPaqs/vihE6okHVuTyaYe03zQTVPBPj8ot
	 NHw+cu+2tff0DC+93ZrLLCCAhzMk6+IHQYzzE4e5Ufh1ewG7L5oAYQg7W2TmcF0EQBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541489;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:X-Mailer:Message-ID:In-Reply-To:References:Content-Type:
	 X-MS-Reactions:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=rh2tp8mhJ17iK9O6ovVhJrl688gggXEfBhn9QZS+Im4=;
	b=5JGy5+G/tq8Eo6yEN9vb6o1E5bw6c3nWUBNFD0ohiTGg8V0mA8Rk3x69DI6HHx0fV3uc
	 TDdrbsNY4M7GTSglMY/WUbm4oPkawmnJTvLq3MJXcKRJXA3M++Ium/aUpKD9KauDHUYk+
	 863E7T5AOKjxKORuY5iT9PG7oYysHRLzPIclTiiW2+6r0J8NS+3y57zG+RB/r6xjJGOXg
	 f2nLBuZqoAjWyjoYffce+2Nu5kOqNHvGDubnJvHnwoK/e5DWUnWXiSTCiVODnCGPBK+po
	 RgGd5wE3/HynGLn/+wYjWtfypaJnUhmmjKuH2DiU0JUZexCbPmv0157m8nDyahMmJXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=heFfopeh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.52
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B15606A31E;
	Tue, 24 Nov 2026 17:31:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40B15606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=heFfopeh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYslmPOZpgoSyuQdx63GjrbA0kdNZcS+m+pgEMzuFbGQ3qluOySJK4jfxNBitrCJmFn0FZ724AvgyVBTuVb6/96ooVCeL9lvBf/07cqqnXmRS3ulmvregF+nD0iwJSAsbQQ14lvMOTWGsyg/vCinUb7RlYlt4phmeLeAHdw2gaRZVVqFQHuFaqAjZGgr3lkxoAqmaVPYxZEz/hmShMOwiFfkt54bvRW3845h1UNTSUMG4VMRHjcPPwZCVLvv4KKV+jhqhekWc7MMyRh+3ehatkt4SP+FLITnwntgWVDdQn6vNGK+bhwpwSDUz+W5c7zKve70nXAlpmMsqcDSnUUtbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rh2tp8mhJ17iK9O6ovVhJrl688gggXEfBhn9QZS+Im4=;
 b=oryOKsPDUFnWmg6cZ4dg+26dPKNmKwEM1dWyzVe9c7E39Zi5EnA720zikBAA0lm8v0co9ngMCXGJckrhx2iYmu5BHI+LD+JVTeAAG0dZlCjrInHyKDhm0Ogw10s9SSuyRW66x4GwQnz9LV+aMHoGaYjnt0o+y3lfuOTcTSIhvQmUemgqE2tOrtLiP2V9hN14V/fqY3EUOXAVg7OFsa/hLZWdHWHO7Ha1USjNP2fk0ebg6w1iWKkZOEsQ7nTCBZW9icQhbuSf9qUXOLJyDeqJ3+aWMQcXo6Q3Zw8ey5pqxK6InAUsEZbyRSyShLFhhCR76MhpVBqzcihWvnhfF8Ruiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rh2tp8mhJ17iK9O6ovVhJrl688gggXEfBhn9QZS+Im4=;
 b=heFfopehOKznDQJrrmun62LXHHPHQ4bVoQudpAZ6Jyv59bt7Lgn6GrC9spuDvNTU4i5T/uQmW5TuAbR7sFDLOILEB4t/8q2LEqIPuklMNCcu4AWiTBhfcQulHhsJKnhtiiz/hbAkYsBb8VTOrzaN9EyUnhLaRMvALoEtOq+O4oo6TnqZtHmMUguHriJp5fEDgLgG30aS9xAzwmNC7GEPTi1/1pxm50McOkc1+bSpj02Zplcwz9PPPAXl906gzfVAj75M84UKMTFnpt9hqdMw7aRnPcIwyvMZsnWUl9gBxPz7pBL7s+5GKkGxUG3BLt5wiHsAl3CuAhTHsd4Q/KCGdQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Tue, 24 Nov
 2026 17:30:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 17:30:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
 Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>,
 Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
Date: Tue, 24 Nov 2026 12:30:28 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <09D65D03-B939-4E8E-B4D1-4B15FFAEBB37@nvidia.com>
In-Reply-To: <awXABa3dYhEN0YEt@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
 <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com> <awXABa3dYhEN0YEt@KASONG-MC4>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:208:160::22) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: d20d30b2-2cd9-42f6-9a40-08df4a50a433
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|261102123227099003|261026140227099003|261026121527099003|261021121427099003|11063799006|261022105027099003|4143699003|56012099006|261028144727099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	s0jzjEUVI8wscJmTDO9tgPBR7K1CrUMnceE3LLxAHBotJGJ6qldhLzhjTP/e9T+Wk5dqiIl+jmeBfldQT+E+rwnCQgnmATqvQfnRjm8woBcHwEup0fqFRyFSgJuhCHxBMv/ky+SoCSO8zUh8Pf8dgFLfrnkCG/Lg7fsEd+JCcZUnPRnXIKO7ojF4JJN2YITlHqPoBq5+XNAmMqtu+KBo6Bb2IAaYXi0LczkNkFHPsXAqXuPJJPsmX9pau0wwWjqr1WnCZDkgV0fSCmtmdmUt5rCPicWcrBCusEKxZBbY0fGckCySvnmOhsZWkmfBk8fddKt8O3Mju5n0mFqNqTcj21x6XMIZ49oepj7srxyBqiy/FcYeydxCYuwpwp7YiiOphGYJh19MDu+ohupQumB5Cd3VV54WENFnU9dzy04Uxvo5JayM8VsNK1OebLeuHK8t4I7uUJH9njsFRKG8LHqFxBOIsrE/xbMZE5j1LWDyjTtqgnX/JwGG8/3oSkhqafgSWIKFvsiNulKEkm0KcIA9uI2nSK+zicg6gRpvXhO1X8Ckat+uxAhEATEakWaNsfOxPOxa/O9sWiLlF61OpbdieuTBWxtOzIQ0b6UPwdazeVSqc0fGpeiaV+V46ctrjDQM9zrKCfiGmVqmvLQwliSXeo6fIKrcG1DQ3FhRNihYVLw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(261102123227099003)(261026140227099003)(261026121527099003)(261021121427099003)(11063799006)(261022105027099003)(4143699003)(56012099006)(261028144727099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gtmhdio2108nKFlyPU7q0YAlDShAYTsAjxJEjFNjq7T+rgg9K5Fpkt1rYklK?=
 =?us-ascii?Q?C8sCJoQ4uJJnLFhgyEJIXfa51vvChShuI3aqXRielY5A1zQi2a+dXPWEqcwU?=
 =?us-ascii?Q?PnNT+gG1s7zaNayRgai0gmLGqmhBY+r5cCKVgyPVCLNr5nIw5QdFExD6r/uo?=
 =?us-ascii?Q?iFWRXvOCfu/hkQBSgXZngugjALTgT9Za2Mz/fTbGCIFteGeoNh/GI4MiI5UF?=
 =?us-ascii?Q?qSqKNrux9ZENb/ScOdzn0Y04m3A+egx8MDU2ZnV9UpqazMNesYPAAZq3AHiE?=
 =?us-ascii?Q?hW0oBwNt7QBBahqGNenSMu6vFviVOx7g0DiIu4qdEBX/C1wz5q4Dw1aoDZO4?=
 =?us-ascii?Q?GJPR82FQtdJwnYlmL+ny7lomj1HPcizAMU/5sD8igXLXUAexEz1MJv3L1k+8?=
 =?us-ascii?Q?1V61Ue5Q18wuzqKz/VBYJQMUjXpuzGRp7K+D+xKXISG+mMkV/6SHlVU/Yd+P?=
 =?us-ascii?Q?myygd+nLYUyK5BfS0zObdDur1BvIvuy7mkIE+aQnaCi/XuZyg+ikeYMcXGhI?=
 =?us-ascii?Q?5uZffRZR3hH1ESrnVWlhewNVMZdo0iX6uCZkxUYuCkj8jrhN78F4fj0EZvIR?=
 =?us-ascii?Q?ExdnwpRNlMW+hJQF5tZxACDcSn4yHpI3bXGBeiWaejP11pVPG13jN5wPaVHd?=
 =?us-ascii?Q?CBILSau8KBvu6ww8iakiWz9wFyQH4muREhd6BDqo74FB7f8pJec3xvZjuTqi?=
 =?us-ascii?Q?DdTbTJUUs4WXb5D7fuXCn49kz3rEFyDxB80lLSWlR7xzDVMz9iWzHs0X4Zum?=
 =?us-ascii?Q?1ptoseu27GQLm1trxUmZofJaqIZ930QveG7oBIa/eQwP7z0c+d350mGExKvZ?=
 =?us-ascii?Q?vTusJiThByF4/j24j7SWjnQtuHzmvYEjF17AZdHl8kORf4XEivaEignshjNF?=
 =?us-ascii?Q?kLoV+MUfhSWHuh9tD8Cp9F4euxuGjxSyqIdk9rZaXO6QqSy9xCSgdpPh/Ed9?=
 =?us-ascii?Q?7s6koFe851c1BuQ/BMlxM1nh3hygkVA2Kjqg+QwhkcMKXCskbQ7xV1PNMcjj?=
 =?us-ascii?Q?moX5Zdz9okAaDzzqcRQy8lhtSaFRVlAXZuvsftShRhiZTNkdCZkikkhWC8a2?=
 =?us-ascii?Q?FMLqhKU8nthEKAWdntqZ5rxZUA/asjelpSgVPBLI9BX4bqVFuM7b756jQ6pg?=
 =?us-ascii?Q?6GENjGVnCMGcwWVOiDFvuhc5tauESNycmVS6jN4tt3qBXgeIVZcmBMho6D7l?=
 =?us-ascii?Q?z6Y8tiMkTv6QylUjt7UEQzkl4T1QQS59JsyEFUppWjonheo9yganphw1syBe?=
 =?us-ascii?Q?vwxPIzg95xB7H75gLDVENTvmfEw0AT0brBHbT+8fioa4rer2ib/0UhwHcTaQ?=
 =?us-ascii?Q?wqYQygbKf2vViOYfDS2xAhH9j31BCPJMFqgvQ1E2Xkkoh07dwRE6vBGkICYK?=
 =?us-ascii?Q?3uRTDzSkLaSOxcCqMCsrLBnWp0iGRvyTbLJi+05x8iHCRkhdJMOCIThOVP/n?=
 =?us-ascii?Q?XJyyub9HdR40L83os73e4k0zUC1c56thcKg4bFCdRoinFpHj4Z1oP2VQpMHy?=
 =?us-ascii?Q?ZFEf15YcHqycg/gnVu7PufrLea5XVszttGLB09KoxsQEAlilvuXqs1nP0CC/?=
 =?us-ascii?Q?d+mVVEwutTzgtENn7V6VuaLFETDglHBs4Shf71R3Jbp3Y73VaJxp4IMKq+vF?=
 =?us-ascii?Q?W4rO1HMS4DLuPsNo5RXGJ0w6GE1vC6fV/a18xon4rw6eTJSJ1Xn0wx7OevTI?=
 =?us-ascii?Q?Emi8wMc/wOf4NfTU3QyT9N1K1lYXzG4MTtJj6HfAKMXNIIPU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20d30b2-2cd9-42f6-9a40-08df4a50a433
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 17:30:32.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snJcW68tPHW0ANxBRCOqOgCfQ+HEiVPGCYJ5d+9MzFtogI3AjVPSh95KRn2FnOAu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858

On 24 Nov 2026, at 12:24, Kairui Song wrote:

> On Mon, Nov 23, 2026 at 03:17:05PM +0800, Zi Yan wrote:
>> On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The behavior of updating the folio's access info isn't consistent for
>>> huge mapping splitting or ordinary unmapping. The page table's young
>>> flag has to be translated into folio's access info.
>>>
>>> Right now it only checks and sets the folio's referenced flag, which isn't
>>> enough since folio flag updates on access have their own rules. Ordinary
>>> unmapping (zapping) calls folio_mark_accessed(), and it also checks
>>> if the VMA has recency to avoid false updates.
>>
>> Can you elaborate on why vma_has_recency() should be used? "false updates"
>> might be too vague.
>
> Thanks for the careful review!
>
> Right, maybe I shouldn't say these are "false updates" indeed. But it
> makes sense to do so, will reword that paragraph.
>
> The young PTE becomes folio hotness via the LRU refs to help improve
> LRU accuracy: telling the LRU that the folio is accessed, so it should
> be protected as it is more likely to be reused soon.
>
> But vma_has_recency() is the app's hint that these accesses are not a
> recency signal: MADV_RANDOM expects "page references in random order",
> POSIX_FADV_NOREUSE sets FMODE_NOREUSE, and MADV_SEQUENTIAL expects
> pages which "may be freed soon after they are accessed", which is the
> opposite of what the refs mean. In all these cases, marking the folio
> referenced from a PTE access hurts instead of helping.
>
> zap_pte_range() and folio_referenced_one() already ignore the accessed
> bit for such VMAs. The split path is the last place translating a young
> PTE into folio hotness without it. So while converting to the more
> useful folio_mark_accessed(), also add the missing recency check to
> avoid wrong promotion.

The above explanation helps a lot. With that in the commit message, feel
free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.

Best Regards,
Yan, Zi
