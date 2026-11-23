Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795465055;
	b=eTAQDDwoYPpLSF5SDxKArUEbM4tM12mf+XWQlUfjnW5JLEbjBcL500LqwB72nGlHk/0q
	 WYYR51eIEbg4CY+iZCln3t4w6RALFe5UQfbIHs4UYououS8RPFP5UvOhZOpncvjvTauDV
	 2UDwVViW9X7ztQ2UzgYVsGbQaTYwOLiEvpTZ8ahcd1GopvcuUZY+TMSzW5OSgPN1H9H+g
	 lSxe+kZ2Fr3ZAQMa5ics0LnIdtpGDo3iWEUlQWpaMlX6Oz4GNm0vIsTS+EorTg6VgqIF3
	 EdIzrQ0mt7jfDH4+6aw7i9lBpT9licB+iEF8t1bvaweQXqoUsIzD9hwUR7z2FljXnGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465055;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:To:From:
	 Subject:Cc:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=Eoa156C/ExCR/OJ9hg5I/bUi8aicbJCrUtqcCscc/SU=;
	b=dwNUqh6lEzysk57sDraavvgQis5tvOkzmwatEWd7FrNBsMMWT8ovcsw3s/3myR9TOapE
	 hMOtzn2fiEyM6dYeeJ9+U5DpcDHvhmnLBWoUyJ+RIiCl4XmFnv9bNdv+8EvbETRCJO06S
	 F3sgSOb09K4/zswrvKHcfRcUBckeMV9LdqC0vmkMLt7Aeke3tjZLj9eWGtKFDnuOyQJEJ
	 f/3FlTj+hIPgPs1SazePTC97j5e/O0YZfBb6bi+fqFfi72NITdy8NdPm002xy+UkuuDlD
	 JwiAE03hR7QXDWSVdpUXHeVu5/NptvQS638SC9yNgtCxPHvEOt50F/F//Kd7xCqv96g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iq0Bu1Kb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.70
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010070.outbound.protection.outlook.com [52.101.61.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2D8606A31E;
	Mon, 23 Nov 2026 20:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC2D8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iq0Bu1Kb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAP373qsuyhEgdLX2LjxVxhRo5apETlpl3PkXfFiuoGe8CcqgMPJ2l6KnMDbWNtzojYDqV/VsIOaJrVyTEamAJVGoYAv6L2m+oXSdk2+lCrCwABE3zOFaIskPpZXKlFiPqygXfveTajBxzveM4W6fF12dKIPC3r5mZcjrLmYc0T0mKlMwBDMRWALhoI+VRyamihZ8zTGd6hhJQ1OdwsxX1qtdrj6wMbAJ4lKOzhObKKFWv2S0aHBolv2lu//4lMFc762h1R9Ogv2NNsYZ9pTetB6IsqLe8hJxYqddoYWpfoST3oCO1+GS1g0Cbg4lWBRO7U/Kkl8KzoekkPiJF4UMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eoa156C/ExCR/OJ9hg5I/bUi8aicbJCrUtqcCscc/SU=;
 b=xUbInM7mvDPCL2rUVckDn2otiVDtFvRFO5ZP3/OF8G/YBH7W53bbSic/GcHWsSdphPkbogSpvzod868F2kh7V5dZiJ0/J9RYmPZzjU3cLQ2FHXvgoh5+Svq4eASiTAeJVa9K6omzlG8iX6tMKRGKoRSxs6iB6gLsqwLrMDNiD+QTLklZ/C42YkUMOgWf0f1718AdfhNTXxt8Li77iPqJrYylWkVV142UH2wW55IeOqBIf+VViF4u4KeMkAgKkFNmx2sgdo57mNW3WbxK9efV5rCW59vclxXrqzIjToEy/6G+ffgZVCSWJgzWwrcZg7n27AwbA35Ga9VyuJooD3SQNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eoa156C/ExCR/OJ9hg5I/bUi8aicbJCrUtqcCscc/SU=;
 b=iq0Bu1Kb+6g29U4SGskIdw146Ky2M99b+5+Ytd0zquT2PyoHE/csXCoQeMrxK+D1/RQx//6Megz///3sBPSeC18WhRLsdlrgdWrRLi5HHZCxiigVXSeSFKKLTGSY9q1lT+XU6enn3puDgepYRD42bI56UeULKjqumgrna209ZtZNk2Elr9OjHvj+uhrqv4But+MqZ32iREBkHZ3pau3eho0TjNAk7Sfdk9UdZJFUalKGytxVtXYaGWEDyUtzqHBNxQlpMBqu12kVBOSxmOcNeybV/fnRykV/Y7DntI9x14jlSdm6jaRCnw4vz0ODBLpLG5V7B4MXklQR3JODSfW0IQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6668.namprd12.prod.outlook.com (2603:10b6:510:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Mon, 23 Nov
 2026 20:17:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 20:17:07 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 15:17:05 -0500
Message-Id: <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Muchun Song" <muchun.song@linux.dev>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Chris
 Li" <chrisl@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico Pache"
 <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Nhat Pham" <nphamcs@gmail.com>,
 "Youngjun Park" <youngjun.park@lge.com>, "Gregory Price"
 <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang"
 <lance.yang@linux.dev>, "Hugh Dickins" <hughd@google.com>, "SJ Park"
 <sj@kernel.org>, "David Rientjes" <rientjes@google.com>, "Yu Zhao"
 <yuzhao@google.com>, "Vernon Yang" <vernon2gm@gmail.com>, "Zicheng Wang"
 <wangzicheng@honor.com>, "Tal Zussman" <tz2294@columbia.edu>, "Kairui Song"
 <ryncsn@gmail.com>, "Xiang Liu" <liuxiang.277@bytedance.com>, "Ehab
 Ababneh" <ehab.ababneh@intel.com>, "Zhao Zhenzhuo"
 <zhaozhengzhuo@uniontech.com>, "Lian Wang" <lianux.mm@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Kunwu Chan" <kunwu.chan@gmail.com>, "Hui
 Zhu" <hui.zhu@linux.dev>, "Maxim Muzafarov" <maxmuzaf@gmail.com>,
 <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
 <damon@lists.linux.dev>, <linux-doc@vger.kernel.org>, "Tianyi Chen"
 <hi@tychen.cc>, "Ridong Chen" <ridong.chen@linux.dev>
X-Mailer: aerc 0.22.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
X-ClientProxiedBy: MN0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::28) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b619d27-ea4d-4fa1-d684-08df499ebf5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|22082099003|6133799003|18002099003|11063799006|56012099006|261026140227099003|261028144727099003|4143699003|261021121427099003|261102123227099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5wRZGc5T/wKdtsBQT/wXVuO/6kY+7qmVrLaUfBFKaYaegZJI0fzznJhq/BGH4d/qM+YCGyCMnClDEXBOT5JDJ4YI3BzoM5t00OmtxfopE5h9Ykh9QHDC+AMvWRjkSzZ5yhcBTWFAp0HuodUToDdidaNWnM//MpM9L9k4LkM9QAVHh7b4ZK+WE3Aja4o8b1Ye3vl6JDeg8Qyl78FGQQjNzUlC2oa4g8hUCUGDuoeQMygKNXdBqAUXosBWxlghhUAo5Jnh6QuegtPtyVczEHTlrwU6gToCaGUYLpiSq01NFHKJbBTNKd7SB285UZHVjPShvIOuZs1WbISnWfYdA/zIiyTYp0Npx1Qck3HOGYI3yOsIFKBYIrU+rBszjMeVaqTF2zVmGI0izEgiIpY0qm1NlrlrAubh58wv58LVEER2NXoANJ1lYHa6Niv5+QEM9GG7gLPrJMj071LKBr/Pkh+vrxsrLByKIvQnIUNMCiWkcB+Nl/qgUKjfj3YLbZXxiMIx0ZfAhM8XMJk5T4uYwpmZl5tOq7oEe54jr2mQ1U6wgMhOhidDTEUtXFz9Ib5cvxFjIn375K2swzbijXe/lG9JAdqN3DvUS5OEHOx+iBHWlD/EbTJe/ic0ucSoErVcTfLhItAUmCLZFDiOlsP2ZTZRaLxc08oV5yytiAW+B9H2KzU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(22082099003)(6133799003)(18002099003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(4143699003)(261021121427099003)(261102123227099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1NNbThLeE9HUDVRWDdEZVhhZHdGK0dVZmd4a0J1OWxzeUhtYUF3b21XbHZk?=
 =?utf-8?B?TmF6Sk5wcXhtVXlueFR4NGZGblowRm9iNmRKS1RNRzE0ZkNDWXZoQUFHV2RE?=
 =?utf-8?B?TW52OGgvUTYxQ1RqbU13a2xsRGhsM0hORGk2OUpGM3FZRWczOFZwb2Y1cXdi?=
 =?utf-8?B?empFUS9MVnhFdXFyV3liMUJpNmNLOWpCSml1RFRKaFg0bGVleHQ5V29NYUpU?=
 =?utf-8?B?UTlMc3g2QnY5MENJQ0RSOWhhYlp4Z3U2TzhoTGJEbW9qZDhjZTlnRDhOc2hZ?=
 =?utf-8?B?U05FRTd1YXQwc3NXUGxCcHVvc2xwZ3puaUppVEFBV2JhWktMaUdtSk5CcThD?=
 =?utf-8?B?SkpkWWlzL29RcmM2UndmWUJ5SWttaEpwTFpYZFh2a3FxZ295UENhV3dIbzZu?=
 =?utf-8?B?dVowQW8rd0FsQVJ0WDJRYmxBQ0JPNzR1ZUZQMEJMTS9PcTBSSVVzQ1dvejNF?=
 =?utf-8?B?SDd6YmZPR2dLb1AvWXUxV2toaHZVQUNadGRmc0FCWm5uZ3JnanpPbHJKUlNO?=
 =?utf-8?B?WGtmWGhpZHNnS243Q0JsZUVYWG5BdHpJUnZ4SVBYaUJNQlA0cGdKbXBsV29y?=
 =?utf-8?B?QWY3Vjg3NFUrTzJ4QitrQ29PNW5lWkd0MWJ3bVMrQUNWejdPa2F5S3V2dnM1?=
 =?utf-8?B?UmtJSnVMNUVIMHVtWE9MRTJJT3ExS3FIblBDamluNDIzNTdQY1p1di9SVkk5?=
 =?utf-8?B?V2JaUGt0QXlvMjhWTmdMZmNucG5QeGNET011M1JkWENUNVRweG8zeVdpOHRE?=
 =?utf-8?B?WGlnODNFUlc3ZFJodld2T28rRGZ4ZU11V1owUjJGKzcvN244VHN6ckNVb2Fz?=
 =?utf-8?B?N0tESyswMjNmS1NheW1aRDJMYVBrUlRjZEdzNkZ1Ly9EUXovS2NyTkgvQXhw?=
 =?utf-8?B?TzFSUmw2N0trbmNYVXh2K01sYUZ3STNNQ08xdCtTRnRGRHhPQmlsQjhjVnJt?=
 =?utf-8?B?WSttN2JqVVNueFMrb3N3ditUSk9oQis2cnpEM2lMNDU5TnplNldqMXFLaFhX?=
 =?utf-8?B?OW50VzFlN1BkRDdxd1FOMGZ6bTZDcyt4N1B6WUJnU3RYRmRWTzYvcnFuL3Yw?=
 =?utf-8?B?bmNKRnFqa2NqaTV6eHlTdGgrY0VTZVBEa0RYUUNBRWYrMndwcXg1eno3T1pk?=
 =?utf-8?B?dWlDc1FyUUlNajdGOURjeE9tR2ZOTXJsdnBYcVlvRTdFTUZrSEtmQ01pUFRT?=
 =?utf-8?B?NloydmkxVUwydG4vdTNxc3BlYVRGaSt2aWxMR0pqV0lFY1hzUis4b0sydUhC?=
 =?utf-8?B?ZlRwSHNFcU9FMXZqUnUvK0Q3Z21BRlIvRWlWOGNlRUJJalg4NzcxQkZpRnM2?=
 =?utf-8?B?NWE0cTJVYk5jNncvWnBNUWgxaE52VUJscFJpR1UyREpIOTdIYmFNdmhHN2JJ?=
 =?utf-8?B?enhtRUhscGY2K0I1aUtDdnU1RzlPenJyRXhyaWJPZ2Ztdi9FUXpPZk9mbFR3?=
 =?utf-8?B?aDR1ZzhwVFhHNytTdXN1UUtHWVI5OHVCK2lTQVVGYmFQdEk1OVFFTUtIR3g5?=
 =?utf-8?B?cW1RODVvWGcycnE3a0dLOFRhMkVpRlEzWVloTDF4STlJWjdUeGR2dnllQmJn?=
 =?utf-8?B?ampZN1hSZ2lWUmJKT3IzbnBwMzVrNlRtOUc2SVpmSHEyeW5HSURyaUpzb3NG?=
 =?utf-8?B?TnliS2RsNldsL1dLZTBhQW94TE5zNUU0ZUMrWE51TWR3czFJT1dSYmdKZnpT?=
 =?utf-8?B?UUowb2ViZkJoYUJCOUNWQXE3dlQrcGJxZ2Z4WHFndkhoVTFVOFl5TC8rNFdG?=
 =?utf-8?B?Z2FlYjkvSlI1TkI4dE8rN3VQdDNuVHg1ZWhXUlFZUmxWeEN2TlRzSVVWNGZt?=
 =?utf-8?B?WHI0aDg5YWhxaC8xYUFaMnhNWDgyb2R1WXhmYlU4b1lpWEdVSW1nTlZXWFQ0?=
 =?utf-8?B?V0F2VVd5VUNmaFVkV3gvVFdRYmxTQmpPbWthcDE3cS9aajVCMkpjMFFtcEcw?=
 =?utf-8?B?RVVFbll3QkNsNVNZZ0tyWkZTYS9qRnZKS0FjTHQyZkVRUE5mdFRrRmZzWVBK?=
 =?utf-8?B?Q1gxUDVkTkk5RHptZ0M0R2VrNDN3eG16WGtFU1p2cmNnRGwwZktvZC9Cbnhn?=
 =?utf-8?B?N0dXTVpUSFBTNnp6V21xaGpjczJXS0RpVElMZGhpdCtZYlhod1NEeTJkS3dq?=
 =?utf-8?B?dmM5RVU5dDA5STlNcElXR1I0bDZaSHJoTWdIKzM5a0VyNEQ3d3YwTXdnL1M1?=
 =?utf-8?B?VjlHa0g3Z1ZDRWlzdWpnUjFLMXQySTFOeEJFdVNrUnlpcUFEWkZOdlR1bTlt?=
 =?utf-8?B?VTc3MWhwbTY0dkszcG1TOFNRWEpKd0luWmNkQXRTak1wc0NnY0RybGVWZDhH?=
 =?utf-8?Q?DErc+v/oWUEp7nJ9M4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b619d27-ea4d-4fa1-d684-08df499ebf5e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 20:17:07.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta7jsfzqdBKPqK2+fTzVIttY3FyD/72HVQ8y0kGZstXd4AcN4CU7C1FNi5O7/mqt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6668

On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
>
> Right now it only checks and sets the folio's referenced flag, which isn'=
t
> enough since folio flag updates on access have their own rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.

Can you elaborate on why vma_has_recency() should be used? "false updates"
might be too vague.

>
> So first just use the right helper here to be more consistent. Keep
> accounting the young PTE as a cache access, sticking to the current
> behavior.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 75e8641bf9ff..fa9f6d21e786 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_area_=
struct *vma, pud_t *pud,
> =20
>  	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>  		folio_mark_dirty(folio);
> -	if (!folio_test_referenced(folio) && pud_young(old_pud))
> -		folio_set_referenced(folio);
> +	if (pud_young(old_pud) && vma_has_recency(vma))
> +		folio_mark_accessed(folio);
>  	folio_remove_rmap_pud(folio, page, vma);
>  	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>  		-HPAGE_PUD_NR);
> @@ -3245,8 +3245,8 @@ static void __split_huge_pmd_locked(struct vm_area_=
struct *vma, pmd_t *pmd,
>  			folio =3D page_folio(page);
>  			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
>  				folio_mark_dirty(folio);
> -			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
> -				folio_set_referenced(folio);
> +			if (pmd_young(old_pmd) && vma_has_recency(vma))
> +				folio_mark_accessed(folio);
>  			folio_remove_rmap_pmd(folio, page, vma);
>  			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>  			folio_put(folio);




--=20
Best Regards,
Yan, Zi

