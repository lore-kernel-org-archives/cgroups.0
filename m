Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D890140315F;
	Mon,  3 Aug 2026 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760270; cv=fail; b=J7zTLH5AU4JG9C3neXroC0Voer5sHCE0kPQPke2NsHBjXj21P53vSwIqf05TxRv/+olCO20a3STvSHK45GZs2ldTdm4Wz/JdhYCBHUjqu5WOQDGjtvlkhpQkkMa9wWOy+BIw/J1YEXpLkBfeEz1nbRwd5ivdW2YHE5uX1cbmLbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760270; c=relaxed/simple;
	bh=0oHlMVidO9SeK6iPsYOOGv38rCQf0mXLDRaW8cNt5pE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Psj2Bqo3mv8Kj52iEFsznSGPqU1OFCuc52kz47Xiaoi+mVixYllhpIVAiCKYdKImiD1tyod4zsND8SsxXOIVqHb8IT/S2L9qkAYyQKQWNKJqEf/lSuRCjF55h0zcSsGAr9/WZ+yhkgf5eSwgm7Vf7AIakuaw4dhMXBxNyoGqmTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WA71T8nK; arc=fail smtp.client-ip=52.101.48.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WA71T8nK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jl3u7mxRTL0exnG7E5G6uSoLG/nu/VuhLnI6NkYbmqyL41I5UYu6OyoUNWLmxjDTOcdEELLFU7Yvc3SvA5z8cU8fFHG/3JlIX2Hhq9PgMWiLqgjS8fgGkSzsHkW2BNs5aWdSoxiWSGjX0QuaRQGhM8Ek2K17kEPuRM83cAV4sd+3T+D0x6wd7A7SBw64b4j9eAvKRMm1a345oHb075ZnGo/j0dG4OFoJ78WXasm1GDa35VqUH4aohS0np68Vl/aAA76QCM9W35bscbmJHwk/YIMEXXJYBhiJhg6ydlIN1e7+xfkMlsg4PzfWzN7/GXkfDndSA3scr1ij0madq+OJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/Qb8vfqR7j38gjpFqRgGe+P/ND8LjiTd/nJ6eEvLy8=;
 b=iKGdBf5Bq2YXna/SaScMFmYLxoLEsVQ7wivnu7K2WlCShKfczeQFJWFHbayB06MW4y7Mu9iqKK8ZO63F5Ji4DWozFCWFOLlKWvbPD/5RL50xuITWgRfwDpsZUJClTbTFUJN63WfdDbe7yTjrEdpcOng05hWNZ0DgSUeX8+V7xo2dzQM69FbaURXa1mu1k+NG1eWlei6juY2gSbt7IS9gG7Ne2QJTPwyIkUc45EeSMRCLuhu+9BbAhjBd+sqseAlWmoeGvoSUfd3CssfrrZOgrvaSQM888T83QmcF8AT6ZOao5yeIwqVvWILBOyBmEopeHwD53H3L30BmOmNn+VR4Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/Qb8vfqR7j38gjpFqRgGe+P/ND8LjiTd/nJ6eEvLy8=;
 b=WA71T8nKAUrf/C1oO5Iiu9rDIQB7SQ3EnT7rMuO5L/bsZc/ww/FKC8YI9oxnJYEdnG9Yb+s+NEgyiuvb81gl2pOX1Z7ig53fw+eONFeovpkfrtUV9BNt00pvnb92Z9BJ/tv5m4tu9/xH62xEQ3okA2IMgIKAVgpefKjjlwklxZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 12:31:04 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 12:31:04 +0000
Message-ID: <c46ea663-756c-4575-be30-60c8b7d15c06@amd.com>
Date: Mon, 3 Aug 2026 14:30:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] drm/amdgpu: Fix init ordering in
 amdgpu_vram_mgr_init()
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Sashiko-bot <sashiko-bot@kernel.org>,
 Friedrich Vock <friedrich.vock@gmx.de>, Maarten Lankhorst
 <dev@lankhorst.se>, Tejun Heo <tj@kernel.org>,
 Maxime Ripard <mripard@kernel.org>, Alex Deucher
 <alexander.deucher@amd.com>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
 Natalie Vock <natalie.vock@gmx.de>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 Huang Rui <ray.huang@amd.com>, Matthew Brost <matthew.brost@intel.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Simona Vetter <simona@ffwll.ch>,
 David Airlie <airlied@gmail.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, linux-kernel@vger.kernel.org
References: <20260703130541.2686-1-thomas.hellstrom@linux.intel.com>
 <20260703130541.2686-2-thomas.hellstrom@linux.intel.com>
 <9eae1a5c-d2ef-4d75-a581-58299ca37a1f@amd.com>
 <9c8b4367-c029-4731-8ea8-b8263e11ada1@amd.com>
 <2e50a938-af3d-4495-926f-fbe084aaae9a@linux.intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <2e50a938-af3d-4495-926f-fbe084aaae9a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::7) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: d473c0cc-f706-4b1a-8f66-08def15b1567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|4143699003|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	PgbvhTyu5nP6A5GcBL1AkFySyTgM9iBFkanudPTqhllr9iHgHjt0F0eoEY4wNJuFXGgd+xccKLts7rgTtmu2KTB9ugAvB3BevPqqkulaIJqAPdTEOmoH4AcuUo6G8ERGqDJX89Ws075qYHpanSI992amCTA0Nt3EHAKwSo7wCqjrzabUwZuBKtJhGTkOlUZxZMuJrrHhicrYhy2TpnHQPESGRCDGLQksF+Z0GuLm7jlQv6RAycJ/JS/UhRG8fJ2e6eRvALPmEE9rV2iBEHGdcmzr/H0dbEiS/N3Y32Hw7y69S62Sl2G7qNiti+4DX+94qJiq+hUoUiLyBJkkrKJd9fJC1YgafVuOzJSE6t4eRrfL5FlR1+xdlRWX+CnzMLzg8RXRrXWCfubI2BKsMCL9hRQuNDpTd3JIGsiw269usCP/xjefE9icLeIW+XrrtRaZQ8EZKVAvwdRLSZP1N99kCQKolsm6F9uRjvuGfTsAPwN2K45lRSpxFBrKZb3T3u4utEY5GYajzIWVgloe3rtMyh+7u+UXB9/IMTMgUmY6LibKqIfQrq4UmyQTeLwtm2wrmpERM/DJxLEGV/wBTQF5Ut6jZ571jOQTm3hx1DHdHZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T01PQ0ZyN1cvenZjekIrNEZtSGVLOHZZeU9ZQmFPbmExbE0rTk1VU1RLQyts?=
 =?utf-8?B?YVNXZFA0U3RkNEE4NUc0VTRSUDBVaFkxbVplbStRN1BzN3NObE9nK1JtMENt?=
 =?utf-8?B?R2FwbFJyaG5tOE9aZTdUTy9zWjJPSDNtTmJxSkN5ZzZjaWVCOHNXRHBGWEJk?=
 =?utf-8?B?V0R6L1hScGpqOUtuNG10b0o0RnlwL0FUV3hrWUJJL2ZLZkJ2ZXZsdGcxNDhG?=
 =?utf-8?B?VXE0dXpueloxUVAzSlVjWTZwSmdPRG91V3M5SDFOZWdIWDkrQWg1UnFtbHl5?=
 =?utf-8?B?Q1M0TGJ3eUVCMUF1Wmh3RnpvWnJpYlZaTHFodTE3cFpobEN5Z3MvUjFPZlMv?=
 =?utf-8?B?WWxBbytVS0lqZ3BuM1dIb3JwUXhTT2pOS2VPb3NZNE1TemQ4TUZLS1plVC8r?=
 =?utf-8?B?amR3ZHNrMHZ0ai9FMWF5SWFONlpNTDkraUNQRjVyVlJobWlNTEtuKzJSVTdh?=
 =?utf-8?B?dWxjYkE5M0RpYTlkU0l2aE5pNnlxRlZyU2RsRWdFczUxbnRXOUF6Z21TOWpW?=
 =?utf-8?B?ek9XS3ErN2hvUGpJNENldExqNzA4QjBibHNDaVMxbkxTQWJVZGc1djd0cTcy?=
 =?utf-8?B?TG0wbTlsb0tBekdaWExmVFpmYVdORXpVYVYyYXZ4eVNFazZJQmhON2JvQ05Z?=
 =?utf-8?B?eFBQZHhIc0xFMExJOWVBaWNFQ1NjTzV0ZTBpR0NZZFdVWWxMeUVnWnpUYzVo?=
 =?utf-8?B?bHNlekJSeFN4N21SR1ZTRlRXR2ZPSFlNNnNvL0ZVOWlUZ2RwVlA3V0JYS1Fo?=
 =?utf-8?B?Q2tsWHM4ZVBBVU5tWThKWXRSR3QxQXAxeE83U2EzSm1FbUZlMnlZVkM2M3N3?=
 =?utf-8?B?cU5VNzVTM0svcWhmUEFSem9ya2xaTUltOSsrY3NRU2g3SVZldXZBL04wOGJp?=
 =?utf-8?B?eVlpSk1UN1RkL2ZlVnljcVBuelJudmQrTkVZdjNjMWNLc0svSjVoQ01wT2NW?=
 =?utf-8?B?YWVVcTZmUndBS1BvV1liSUNMRXA1d0QrQk83ZkRWQjZ6SUFOL29qL1FFdzBD?=
 =?utf-8?B?ZldBTWlUaVREV3hTdXdKREpqaE83d0xUUXJGRFhGbElJY2tHTWVDNG01YVhp?=
 =?utf-8?B?NnFzMlQwUkp6VGFSa3V2ZklKS1B1a2x2YW5VeWE0S0tCaDlQK1QrWkRjaGw1?=
 =?utf-8?B?ZlAyaVVjczl0UlZPdGRFNmgzbUc5ckdzTERVZjlWNXBIcGtVQ0FWaXRXZURy?=
 =?utf-8?B?dzNVd3RFMmpBWjBVQlh0VG1mWlZURkRMSXczR1U0aXpGdUU3UjJYTVFvYzdD?=
 =?utf-8?B?YnRxdjZEalNoNHp4LzdrSmxBZFBoa0liNTRxd3JnMmQyWlgrK05KbjZmZEx5?=
 =?utf-8?B?RnBpT0NsU1M2TEtmTG56MHpNZHI1WUsvWnJrRDdSdC9obzZ0Mndmc1JNSTBt?=
 =?utf-8?B?OW5vZWhGNGFGTnRFL0J2cDBSMWx0RW40Z1Y1bXUraTlkVWpzdXplM3l0Nzll?=
 =?utf-8?B?ZnUrT1YzVFhudXNlNFhZdVU1TXIxT00wOWdjdnM4RGxVNzE2RnpSYyswN0tG?=
 =?utf-8?B?WGNIeHZwdnB5NGcyZDQ4bkF1dU1SamM0QVluZzdQOEU5clh0dHVvU1Zad21s?=
 =?utf-8?B?b2lOUU5IL2hPajdBU1h1L1hoTmF0b1VDTHF5Q2IxWnhuYVQ4S29aUC9ySHFj?=
 =?utf-8?B?MWx3NW5QY25SYVk1WlFhMGN5bjRVN3NVWlNTeEQ3bEtTREtyWmp2RUVjUW1K?=
 =?utf-8?B?dERkcy9UVWpLSHg3MlFCY2lCRnA2cWlYV2pqeWJweTljVndJMmhOYXRHcWV3?=
 =?utf-8?B?a0FNWVNOZFFDWlUwTk4rMWc5MkNwNXhyWGJ2OXNVV24vQnhkb0R1MTh1WVNm?=
 =?utf-8?B?MndqTXBBUUE2eEpyKzFVbnpDTW9LUmNtMGoyWkRsYjJ1U3pGbEVqWkJ3RDlr?=
 =?utf-8?B?N0tnS2EzcXVoZUFSdTF6VEticWJIcnQyWE5Pdk5EYmQ2QkdiTlNYaGpUYm1D?=
 =?utf-8?B?Zk1yOEtvc1Jsak1wY2c0TzI1MEJ3Ti9ubWJqLzliTnpHNktROTl4TVNGMG1q?=
 =?utf-8?B?WVE4eEJWSDR0V1VnWE1rUXhpb3ZlVW5DQmY2eGR5VFhWeDBzMFU3dzgxaFRF?=
 =?utf-8?B?OUtEdVVaTWxUZUMyU3d3Z1BkTHZ6MzZVdCtOOUFtT1VweWZkRHVYMm9hZjVu?=
 =?utf-8?B?eCtmZWNScjRPcTM5ZEJIZkZRUVdQSFhoOE45RjRtU0ROYUM3N3BlOEpBaE9K?=
 =?utf-8?B?MW9pRVozVDdjMDVWc2s4Um9HQ2ZUb3pvcmx6N0JaMFhrWk4zYTkvVUpsUWpQ?=
 =?utf-8?B?Z2hMVHg1Yy9vazAzMW1Xei9tYUtBdE1oNG41SjVmWVRhVUo3cC9ZZ241VndS?=
 =?utf-8?Q?7VLnCTrxcaCdROJhE1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d473c0cc-f706-4b1a-8f66-08def15b1567
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 12:31:04.0066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: su/K/Zw+KbYt0IbQlljmnngsqqy+JTrMYqvU4xquS4LlVgCPSuoi5C6hZzzrdNDB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994

On 7/21/26 13:46, Maarten Lankhorst wrote:
> Hey,
> 
> Can I merge this through drm-misc-next together with the rest of the series?

Sure go ahead, sorry for the delay I was on vacation for a while.

Regards,
Christian.

> 
> Kind regards
> ~Maarten
> 
> On 7/7/26 20:05, Arunpravin Paneer Selvam wrote:
>>
>>
>> On 7/3/2026 6:38 PM, Christian König wrote:
>>> Arun please take a look at this.
>> Sure Christian. This fix looks correct to me.
>> Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
>>
>> Thanks,
>> Arun.
>>>
>>> Thanks,
>>> Christian.
>>>
>>> On 7/3/26 15:05, Thomas Hellström wrote:
>>>> drmm_cgroup_register_region() is called before INIT_LIST_HEAD() and
>>>> gpu_buddy_init() in amdgpu_vram_mgr_init(). If it fails, the function
>>>> returns early and bypasses those initializations.
>>>>
>>>> Since adev->mman.initialized is set to true before amdgpu_vram_mgr_init()
>>>> is called, a failure triggers amdgpu_ttm_fini(), which calls
>>>> amdgpu_vram_mgr_fini(), which then:
>>>>
>>>>   - Calls list_for_each_entry_safe() on reservations_pending and
>>>>     reserved_pages, whose list_head::next pointers are zero-initialized
>>>>     (NULL). The loop does not recognize them as empty and dereferences NULL.
>>>>
>>>>   - Calls gpu_buddy_fini(), which iterates free_trees[] unconditionally
>>>>     via for_each_free_tree(). Since mm->free_trees is NULL
>>>>     (never allocated), this dereferences NULL.
>>>>
>>>> Both result in a kernel panic on the module load error path.
>>>>
>>>> Fix by moving drmm_cgroup_register_region() to after the list and buddy
>>>> allocator are fully initialized, so the teardown path is safe to run.
>>>>
>>>> Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
>>>> Closes: https://sashiko.dev/#/patchset/20260428073116.15687-1-thomas.hellstrom@linux.intel.com?part=4
>>>> Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in TTM")
>>>> Cc: Friedrich Vock <friedrich.vock@gmx.de>
>>>> Cc: Maarten Lankhorst <dev@lankhorst.se>
>>>> Cc: Tejun Heo <tj@kernel.org>
>>>> Cc: Maxime Ripard <mripard@kernel.org>
>>>> Cc: Christian König <christian.koenig@amd.com>
>>>> Cc: Alex Deucher <alexander.deucher@amd.com>
>>>> Cc: amd-gfx@lists.freedesktop.org
>>>> Cc: dri-devel@lists.freedesktop.org
>>>> Cc: <stable@vger.kernel.org> # v6.14+
>>>> Assisted-by: GitHub_Copilot:claude-sonnet-4.6
>>>> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>>>> ---
>>>>   drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 7 ++++---
>>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>> index 2a241a5b12c4..ac3f71d77140 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>> @@ -918,9 +918,6 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
>>>>       struct ttm_resource_manager *man = &mgr->manager;
>>>>       int err;
>>>>   -    man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram", adev->gmc.real_vram_size);
>>>> -    if (IS_ERR(man->cg))
>>>> -        return PTR_ERR(man->cg);
>>>>       ttm_resource_manager_init(man, &adev->mman.bdev,
>>>>                     adev->gmc.real_vram_size);
>>>>   @@ -935,6 +932,10 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
>>>>       if (err)
>>>>           return err;
>>>>   +    man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram", adev->gmc.real_vram_size);
>>>> +    if (IS_ERR(man->cg))
>>>> +        return PTR_ERR(man->cg);
>>>> +
>>>>       ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM, &mgr->manager);
>>>>       ttm_resource_manager_set_used(man, true);
>>>>       return 0;
>>
> 

