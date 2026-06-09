Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012031.outbound.protection.outlook.com [40.107.200.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157AC34BA24;
	Tue,  9 Jun 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016224; cv=fail; b=PXs/AAqrOB7wGPFzGnOms2ypE6Y5MQQRKUVI5sbS7JCkAlEjvYqsHAIDvvZV47tBvaS5PtkZivB8bCZlIUFIUBhE/1cU7tSAw5AUgA6uv3PTph5y28HaMmZIqmpHDnF/GfdONrXI+y7xmGbZ4LEtRIpZQqvsBIZqs0XmKhyARSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016224; c=relaxed/simple;
	bh=KOa6HPRb9Q1IkhQVurCs03EPtrAi25VLAXOIt2VTQIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BdFUGpj3eugLi0XSXesUbUGz2zevYUuOmHqvpGlWcpDmp/Se3Lt7qq1b5Ulfvf0cXNVcAK5rAG3WdFYXmhSnbewtkaaIZmtdsWpQWf3NKrHf8ElFVFRlhaSh+TRffAWQIw5LP1zk1wzpOliieA2Lk6pysMmQ6Qlk8BoOsCBU5KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BBIB0ob2; arc=fail smtp.client-ip=40.107.200.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BBIB0ob2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuDtTtPUUO/pfTYx07mvrZvnQXHlSqMwIzwgIIgugtmdoR268NGT+FLe7XOCdIZNr8tfZ3sghvkyZqR4R55+d+c5D0DNyPSFZ0aE3/7qedkR7c6ekeYyAl7wCYrz00EUu/AupBgiS/bxv/D17kVh2RG64/gfwRpCuUQu0hPfWY4Y/mxwzvYQ16mtEKZjGPvkVKgOKVfhQ3ZN8+TLSdQV/RuP/In+DOBKfSfrTPrOcSjJ2ux4SMKzJh3Z2oTHhas1rzPBBrwyBOR/78Bjk7x4Mjd84Jl3ciyY4zG8JvCS7DPNJ7IcHBZ8GgTFwFudrVDi9jMVH1wvcJ9auF94tkn/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIeavpDGaawl/H4vVB0MqK/6XPdsRpavdD//6Zmeshw=;
 b=HmuayrEgvR/eG3rL6q2GfuiCpLcBGGTnYWXgv5OENXK5q+j0ufjXwk6G/EGMjkhVF1HgbgIZc2WUVIrBjxXFfWixY9UN6Z+FXMYm6qJRUoF6Jb0Ez03knLRASpwrSaYIAxYJg/A5XBvsGy1fKdgdMzPACOy2wf1QdNm8CFgCdxUD9TsG7nzTq/UZPEK9vYGvGK4qLZDu6kYGcKSX8j5OoMqWhfu4dUKjI+rw7jE7cD921b/nz+Iunx9lD3urkPouVmmqpa99DZrCjfWMz+jiwt3BlXVw8HGS+/DYtN3l280ZnDQowhM6l4uKydv5kuOOzJC55InW3stv0iQApWSF7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIeavpDGaawl/H4vVB0MqK/6XPdsRpavdD//6Zmeshw=;
 b=BBIB0ob2Ella2kNKX7X4Gmq2Hy4WKrOWa/FXvYnrKJy3OxywrP/TCHhuI4bs6xbhhiUal6r/ClZr8LyxBKlBBjrBkc+NrwgNHNvbdJ7dWniGyMInlu373AKuJoz2nvmWZsqPs7h7HQZydyog9MxSqE+C2DCinpEQU79zzQ5rGFNMlq9b6AKrbBjsACL5Eed2iE/mGTca0kdU/fZsdGzKDfgztLARy7t6rNPoeMhUBlwsmUtmhticQGHlvcf770kchmztSfn4ZpPodyUKoF4CphMF5qxje59Mm2lKDdKuof0FYuBEWCxJ5Dops2IIvaLJRbd0j57iBlA6VQ2RXm/Q5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6907.namprd12.prod.outlook.com (2603:10b6:510:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 14:43:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 14:43:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@meta.com,
 longman@redhat.com, chenridong@huaweicloud.com, akpm@linux-foundation.org,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, rientjes@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context
 nodemask
Date: Tue, 09 Jun 2026 10:43:31 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E4240C0C-0A37-4B08-8764-67E806A66CF2@nvidia.com>
In-Reply-To: <aifC9s9X6hLWdKkd@lucifer>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com> <aifC9s9X6hLWdKkd@lucifer>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0044.namprd15.prod.outlook.com
 (2603:10b6:208:237::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: ffe7ee46-212f-4c33-59f5-08dec6357c58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	huGkyaNJltLtIaq9WfAqm84O385yOc3fBBU4qwLMysqpbp0WU/wIoETs162f6rdkU+t3FyrgmLNzJWS3fXofxydrcY6A013Skmmv/SDkFmo1ThJQ6IrR+9H/tF4MGKWuzABlO02EU8a/OZusunxjJ5uMW+tHAkIRZ9EYBSfF78v0h1N0x7oPwUSEPwvGllJYYKr6jypEjQt4h/VmeGcOEe7xeNUVrmmYH9mFhvkiTcwVGA1lkRH5M9s04mNwjE1LUbTQVxb7D4imc/ssbkphIGuEo8MlXvAQdBNhFR9Z+Xi7Z6LgvIYi/QrFQd+InAdSqd9v4E57OLGjlAaSmSqRMHeFCef7AvkiHeT6QFBHZyJcAJUEi9W1zanbHDeGsvBfnLVsLrm26CNn3Bvm2rVjwKzgl1VDBj5LEnB/z2PN2bJe2wECvTbdtAEryNRBoziM90wtB7qi5Z5y+T5tOxBgi22HygP3ZJILXcTqZ1DxcLUtVr0xOYdKFP9RxxcB7/DA0jpYU9YLeVlGxR+BOGIYJtpENZP7vAbiUomNNClmlJb94Yce7PpPlSNotMFuRYNiy3E0yECT9Wg+2V7LfZ1u6p6mAWRcLL4h9reTQYCcQR+L5TMBCucKO564drJmfa9RdWhNua5AWPbOasMSXItvNR1GyDtJGFanysPfib2CvVMxE5joxg2DTsydLdfRrkM0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w1J1O/TFkQo7VkBcA7MSxcTc1BFrD1DZx2BD9O59feoVIiHZKRSGnLKFUGTX?=
 =?us-ascii?Q?6/aWiVElmmehtrO1OPpJ0CHcPDuLuceFIfCx5Sryiwig1Ar+/66HyU2cWWSb?=
 =?us-ascii?Q?csGIOSiE/2yyGtSyEXyfWKnTvL0QJsSawuARteK7okbRLbyyYsm+76X/RUjU?=
 =?us-ascii?Q?pazfNBeWfAC1c+b6ZsPOyxBhzKnjrf9ryqKx5ZCxTo89COi2w4qkYkQD9vbD?=
 =?us-ascii?Q?I7/1679uvKjvB2/wfSn+0jLfd1HWpTQNWY3YuQc9fmGqtPGwpMYLWJmiey7M?=
 =?us-ascii?Q?+VSKRkWd7ZoeFXR7gk7oV+lk/O8nZtPT8928JnysRNKi0oWOixYDggBy4eu8?=
 =?us-ascii?Q?n5kYtKpkQLlK315cFUZ/RUgdlPfBu8rGX1l44nEfDbdZlVpwn0WsaDJFN1Ba?=
 =?us-ascii?Q?wsAr4ksUwUZq164a+5Rs9Zy9DyMRV0pLvCZjphdx5qE8iATxKJf03eWKsboy?=
 =?us-ascii?Q?TBeCrN8wDl8cV8LU3qaol4yqbcwh/fpaaLzC9mt7Sc8cdrrbq5JBnKGYM65A?=
 =?us-ascii?Q?+m6+Ox07PMm6x6oUk1+QkwF4q7DSLOkhRX2qDkotys2WUYd6ltqKsgKZeCl0?=
 =?us-ascii?Q?/B0CwiRmZpFwhttJuOHbH/u8C15j7WEI1uB/YqWz9pxA2uoPVUQ7mgRR8y0L?=
 =?us-ascii?Q?uI6R92hWtu8/blHz3pxsTEgmhy9tCsba9xmUQd54ZHAvR8acWN0QOaT8LV3m?=
 =?us-ascii?Q?/CcP9R2kKiMhD+5/xna+DcPEzxIc/1oEdZoezulQI/Z3emfRtSZA2kl2ou8r?=
 =?us-ascii?Q?gy/blTkvR9MOCh5U9DICiVDZffEbXRmss/x9foYRYoR7G376VR2EmSCmZ/56?=
 =?us-ascii?Q?DSbE3igxqrahy0xhmizqmcBGmdoRxIUdshGapztWhf0Hvl43/cxobpv0bzP6?=
 =?us-ascii?Q?vr/d1h1g9VYNUWbGMnEw7fjdgBhjBRNhWik+3bsoU3Q3vbINcrNI6eu5q2cG?=
 =?us-ascii?Q?bdF1BkMN52W4vcQnNenma8PynuAIXPKb57D/AjdionFleGGIrNrztZTmo/nO?=
 =?us-ascii?Q?dDr+PX++gn4wnxzEneavoErN54/eH9GqYtNevYaqnnCxFGcaBFTLcRNimEWR?=
 =?us-ascii?Q?ICGgj7aqg1Ev93Fq4LT6I4JdYMte4CnzdlnW2B7NGgO3wmeadc0yagi509Ka?=
 =?us-ascii?Q?Huh6dP5JhYscvafeYfOMOYE0jlvCARwVGQ9GVYceQn2haQBV8tVAr+YHeXIT?=
 =?us-ascii?Q?c9pYH5cPbeU6M9XBgYjRwKAi9ZLEjnyYmTC5lHobhAvQk64LyOokQ50q+Bg+?=
 =?us-ascii?Q?owzpYXaccQO8IPmPj4sx47Z/hK0Uo8SFv5k60SPbY4jD28dLwiEg7UXmA5cP?=
 =?us-ascii?Q?UHM7qe8SfAYXSZcDlASNgXlosvQXR9L8qDWFEe3nRD8Pw5a/tl/ZGdMjaS+p?=
 =?us-ascii?Q?3IPPLLcJOcqEH6cMtAWKJU6vVhh3M92J4HQGItnybMUiyQgiBH4uiq213MQx?=
 =?us-ascii?Q?IP5a2/9XyO9dktpDp7J6i9kKPMZoMkXFR7OoK8NjazRdgh1xe/IHd0ibkhaa?=
 =?us-ascii?Q?Q0ZAh0rEJ40+LEdM4WWhZ+QkKbDiDCLrIq3fRP+qUPKlCcb+BTk2y/2MEVU6?=
 =?us-ascii?Q?H5B9Fw4V8EialC1F9Zzktsn46B6rAqtdj56JC5FNTS4OsDpXEDapS5V7v1Lf?=
 =?us-ascii?Q?MeO4Sf/4OQlsgoZnv+TH7rH1F1awKaMOJl0rAMXxzl5XclrUUQRcsxDSOQM4?=
 =?us-ascii?Q?e3utQlXHrRt+c2mEcfH80s4PHs3S45jfZ/kMo+riSh+4OMElCOpPW3Ax/gTw?=
 =?us-ascii?Q?mH6wwcrS+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe7ee46-212f-4c33-59f5-08dec6357c58
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 14:43:35.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5Mddx1q1nMkY3QRdilHWhjT82RGlQ+AidNVX7wdQxTGcRkU3TuL0KrAnFbd7SrO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6907

On 9 Jun 2026, at 3:39, Lorenzo Stoakes wrote:

> On Mon, Jun 08, 2026 at 09:44:42PM -0400, Zi Yan wrote:
>> On 8 Jun 2026, at 20:29, Gregory Price wrote:
>>
>>> The nodemasks in these structures may come from a variety of sources,
>>> including tasks and cpusets - and should never be modified by any code
>>> when being passed around inside another context.
>>>
>>> Signed-off-by: Gregory Price <gourry@gourry.net>
>>> ---
>>>  include/linux/cpuset.h | 4 ++--
>>>  include/linux/mm.h     | 4 ++--
>>>  include/linux/mmzone.h | 6 +++---
>>>  include/linux/oom.h    | 2 +-
>>>  include/linux/swap.h   | 2 +-
>>>  kernel/cgroup/cpuset.c | 2 +-
>>>  mm/internal.h          | 2 +-
>>>  mm/mmzone.c            | 5 +++--
>>>  mm/page_alloc.c        | 6 +++---
>>>  mm/show_mem.c          | 9 ++++++---
>>>  mm/vmscan.c            | 6 +++---
>>>  11 files changed, 26 insertions(+), 22 deletions(-)
>>>
>>
>> LGTM and it compiles. As long as Sashiko does not complain, feel free to
>> add:
>
> I would add caveats of:
>
> - Complains legitimately
> - And it's about this actual patch not something unrelated
>
> :P
>
> (Not speaking for Zi of course, but I mean just in general I feel these caveats
> should be implicit :))

I agree. Thank you for bringing it up.

>
>>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>>
>> Best Regards,
>> Yan, Zi
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi
