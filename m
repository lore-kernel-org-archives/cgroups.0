Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010044.outbound.protection.outlook.com [52.101.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D8B4A13BE;
	Wed, 22 Jul 2026 09:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714355; cv=fail; b=DUzYgldUQBGSU9vbsm5AWpBR+7By5CRmlmREASpRr0f9W+63q7uTQDUQQzSSR9PutvLDOeRP/3LpOwPVZpynr5KnuPvMX/HYd7/7Ioumj/cOMKn4iytUDujsYs3Veg28/V8UK9+qwid6iuQP/FiKtgTFsdTc0DzYs/bD+kTKm+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714355; c=relaxed/simple;
	bh=5q4kfjizm+XCQTT/qhM2eOnPBsWZnV9yR8IAzuC0L2Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qeIJQPP++jjMqdBvGfTXmT38ZCyTJx210ykhbB4z/lUOiY76Q5bAeqP+Q8n3f8n/8rz709Bv7AXfnxzwm8EbfuKmzP1+lTWGeJveL51icttemooBvR3wN6A+iTuhdy0nk2UrDl5T+zsVDQ9ekjH/7mFMuR5Gh7mU+rxmxFggk7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zInd2DDI; arc=fail smtp.client-ip=52.101.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zInd2DDI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVENGY3576ZbQYQAfzsMrQlbCjJ2QMuAs2MBoR65SORWzRWsYRHIlrf6F9ifbULVFss73fNOpB5/yffrlBKahtx2N8jPiUF9dP//LdFJhbdRUnDZfnD4N/k7IXBm1RXV1LLT69mbOV1VBABWFSE/CU97pdGMGSpA5m/OahDDD3dHj76f5L0JsXGdM4WhHbe0xpHE3metaSnGkLSLSZjN93wxJtwUnFogytup6R3MJsECTuBUa5yqq20GWsROVeb/t31nGLFDanli19/hg2HsFCutNRnIxxnc7BWhk9srwPPmHBBtielHO3buj+lu9NY56iEPer9UudD+Dm4+3yCOzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWePdtTu7JA4JODm0gw9vd4vNZ83H2W2yR419H86W2A=;
 b=MeE8jFJkV67K9/2V5Zmvqs1kRmsu4jvrcPNt7vfnBJeYyL5rMzcMtijwavKLhrO24i8RDRT/8sA6gyxkJifKS6LUxPqKRmICGFaKSICo3owDQQ/Vvy+APHdGTJyfuiqerPGqAwZ0GvH9um2kWRUwabbGQMFMxRSL+5F1ORxeqrB0R3ZEQEFF61cJ2iJptS142Aa4/KxkNlpRyhba3SY3sAUMfftpZL6x0yAljODI2AbrPeoYzhyiGUGldAsVTwlrtNzD7RGuVFw535DbhLRxZYuZvEsat3JszGFGS5GhkXZ/5/wEWva5ZTxhFvb1dAujKS2gAuV70vhDthsnHggqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWePdtTu7JA4JODm0gw9vd4vNZ83H2W2yR419H86W2A=;
 b=zInd2DDIIZe9SkETPWwt4AhEYgZVWcdQgU2YiAdVkD8RyvRtkCBZYvQW+tYCGMiVUUc8oRxwYjQVNNwNF3cfVuuv98aaEm66zaHk4A2zd56kBmdn4JfY2jVyj8O0WzIAkyN5V3Na1h8sVNv321mxMqawTCKNDYq5LxkfGeRAkBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5039.namprd12.prod.outlook.com (2603:10b6:5:38a::18)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 09:59:10 +0000
Received: from DM4PR12MB5039.namprd12.prod.outlook.com
 ([fe80::762:6408:ca99:701d]) by DM4PR12MB5039.namprd12.prod.outlook.com
 ([fe80::762:6408:ca99:701d%3]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 09:59:10 +0000
Message-ID: <42359a5d-29ca-4001-a32a-7ef14fafb643@amd.com>
Date: Wed, 22 Jul 2026 15:28:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] drm/amdgpu: Fix init ordering in
 amdgpu_vram_mgr_init()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Simona Vetter <simona@ffwll.ch>,
 David Airlie <airlied@gmail.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, linux-kernel@vger.kernel.org
References: <20260703130541.2686-1-thomas.hellstrom@linux.intel.com>
 <20260703130541.2686-2-thomas.hellstrom@linux.intel.com>
 <9eae1a5c-d2ef-4d75-a581-58299ca37a1f@amd.com>
 <92e3c9210c4038969b24c7b0f3df0a998587ff4c.camel@linux.intel.com>
Content-Language: en-US
From: Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>
In-Reply-To: <92e3c9210c4038969b24c7b0f3df0a998587ff4c.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0167.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1cf::8) To DM4PR12MB5039.namprd12.prod.outlook.com
 (2603:10b6:5:38a::18)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5039:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: d4018040-8971-4567-f2ce-08dee7d7e03e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|4143699003|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qtkPWafDbuP0p0K9gBcApDj3+niNWbx6nKli7Rlv2KzVAoNSDZoZ4N9FQQwxooIOY0KeZbPrv2AuzqDg2u9EcU20bzu/JduvKFgKAPbid39Hg0qxlKQ106QynG9tEcwAq8CW+PFDGQF5OxC8fsA2UR48ZfQB5CIe6UAgL7dwzQBBBu8uuwef2QwnqlF2/rTltNnqREHE5UtLtLcLQOhOMHjjjP1PhdfU/KbwnbyV0b4KfNi6gOe702O4Mubw+TYc/Zv/u0J7UJeJIFvkpbQZDfsvnjtZQYix0Z+E1jgqXk8H0dIN7Nt100rxD4cCcE+zd4xl3iS/976FzkaD8hz8VZToc+2FJbm+7kK5nRnS1HrOl7TwzFuw9SdP1GDE2jl0iUfCSm+zfuFMrFy7UYrHxVmMKtAjjyoIh8ltZ9r+afG05V7tfEQIp2mPc556PH/odgklHcGiJ7Cll5A06WscWf4M7i63UfHWfBkQbk2Hb4DmBtoBRV3k6aLFdqZF2pGazQV0wERxBbpJssv71dr5tuAMJeJBzW+W2ZSPj2+e+orY+csyKss25v/jFKgLhyGDYyMHKJeMoyz3UFWQbSg6tsZv3W3UhqfweFWcpaFIUGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5039.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(4143699003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0lSYWMrbFNoKys5M01sRy9lemJucnprZ214WngwZGFYRm16cnRxSVFXZlZ5?=
 =?utf-8?B?MmtzSEJhQTE2dXBOSXdYcjBlT05WeWhrWEZhR2h4U2Q2Mks0S21iaG55K3hD?=
 =?utf-8?B?bVBHSmt5UDMvOExSeVE0SVFIRW54clhCbkIyTmJUUkFnYkdoMTVLVXhVKzkr?=
 =?utf-8?B?N1ViUW16bWxFUXYwWjNpYXhpT3IwSVRYSHhKblB3OEpMMzdMaDFxTXBuMURo?=
 =?utf-8?B?QUY3QkkydHlnQkJEMUZYSUNlSXZMS1ZvTEZvSjJBTEhGaXQvVkdsaEszZTJO?=
 =?utf-8?B?SEtpNzNnS1JaYnBaaXBVbW0rYnU2dmcrUUhhVmlYY0JZTVZBS0xsTXpmZW5U?=
 =?utf-8?B?K29XeFhXVXA0ZVBXWkIzaC93WnFRdW1GRDNnTzdKZjFzWlp0M0lvd0FFbnpr?=
 =?utf-8?B?QUVZR0ZTTmJRTFRZWVp6ait5aTFjTERyekppVnNYUTVKeW5RWVpUL2FQalFD?=
 =?utf-8?B?Q01GaURZZlJoanRaQXVlUWE1cGdrbVlha2oxUXMyRnVkaVdaQm51UEdOYklR?=
 =?utf-8?B?UTUwMkZuRWtBTGU3eDhYTjFYc3dKeE5lVUZPd2ZJMVZaZXBEZ2cwS2FFRGhs?=
 =?utf-8?B?SEFMWGhOUGY5ZnJpT2xLcVZMc2hoU0pya0JiaVUxbjV3L2I3NS9OR0VEbnpz?=
 =?utf-8?B?ZitiODVHeWVWMFYwazhrZFlSNXRnakljSFpkT203WmczRFUzZlB0bGlXNlJZ?=
 =?utf-8?B?ekNSQXFNOVpJeTloc2ZaeTIvekFWOHljdkNPUVNjZWJtWVF6RXduaFNoUUNG?=
 =?utf-8?B?dTB3RWRJeXhad3FyRWVyRVhxNmtvcVIyV0JObEZNV0lYNnRvTWVEOTNFSVNp?=
 =?utf-8?B?dGd5WUw4TlJYYnVuclUxU3ZGSE9mY1Bwa3l3NDBON1l3VzBXSVlQQmZXMyti?=
 =?utf-8?B?MXh6b1RMWEI3RjRNbnhIZjIyenBZM3hPdUxuMEpwSVBnaFdmN0MwNVVicXZn?=
 =?utf-8?B?ek4wb2NsenVqUHpsZitvUEd5NmVMMHVGNkFQNWx3YUUyck1SdHk0aHdmWkZw?=
 =?utf-8?B?YXZtcm9KOEsrZEw1QnZJQXFNc1dmNjJObzkvMjdmM0plYjN2bnhIWllRS0x4?=
 =?utf-8?B?Yys5dnhCeGFoYUNaTStQTUdqQkFuRXFzOTBHZUVpbGtlbVVZMVZhUXdnS3Bx?=
 =?utf-8?B?Q3NaYmdnS0V5UEtKYU1tdEdhVmEvSm1Ea3I4dEVtRVFrK25hQ2pEWE82cjRj?=
 =?utf-8?B?Tlk2NUs4YUs3SndRWGZ6Uklqb0ZkOHBQZ0xkQ01xeWRTT3ZsbXZSV2xXS2Fx?=
 =?utf-8?B?T255Y3k0TTlnTXRLK01JODdyRDF3Z2oyQm9UVWVyb1Bxb2hnenVtUExoYVJ2?=
 =?utf-8?B?K0dMU0F5djRnZEd0cDNtRVNBRGdKRm91eHY3eEdRYzR1b3k2bUEwakN4aXI0?=
 =?utf-8?B?aFVMR0pUZVVNME05NThQcWlJQ1dudlI2ZTArOXprK2Rkcm00WC9RcUFCUTVS?=
 =?utf-8?B?TXYwYVBjSE9ZWThYbHFXdWtyTXVqRHNFWWttZ1JNSDhXZUk0V2xWQmU0ZnJD?=
 =?utf-8?B?eWwreTN1LzVPZ0lMUU93UUUrdE41dEt6Y1RIWlZoQWExczNoMzFMN09yVzlT?=
 =?utf-8?B?VHBFYkVzMmtaWUFMVnBnWCt2clpFbFZTT2QvQVZoNEZvYVFFeC9GSm4xSTVI?=
 =?utf-8?B?N3NFaWJXTXVCK2pvd2lYSUtuR0hvdGZ6S3Qydlphc21xNHEwbTFnR2ozT0pD?=
 =?utf-8?B?S1VsaTdpYytxdFZWUUEzcVplRXUyUG02RkgvcGowWEIyN3V3NXZVZmJSL0xP?=
 =?utf-8?B?UUNUKzg4Y0pYUTBlS2VuQnczRFEyaXZ5a1MyVUVuVzVzY0lmcVBOdldpWUht?=
 =?utf-8?B?Rk5IY2FqaFFGa0pKM0JHVkY1bW0xa0VnbXVHLzhNT1JjbmlPT2FwZVdOcUtR?=
 =?utf-8?B?bDR0dUF5aUphNWZSNFM2MFdBclBraHNFRXQwUittTzZJN0ZwMVAyTUtQLzBM?=
 =?utf-8?B?YXFjeUxsZ2V3dWF5VTNUdXdDM2dIL3NZNGhMOHl0QzEwRDJIam5aZStQQ21w?=
 =?utf-8?B?eXpuODhtekVCV3FlV1NJVUN2NFIzeVZJclNYOWJHRlZPQXNjVU5ITWFHek12?=
 =?utf-8?B?QWdRWjhtaXZKZnlpZjR3R2tUckRmaFg2OWZVRGFac1NTZlRwMGRaU1IrUUJ1?=
 =?utf-8?B?QkJQQWF2ampjVVpPUlhkWWxZSWVnYnNFUkxSUTFBQnYya1BWbWlmZGtTQUVZ?=
 =?utf-8?B?Q1NLeEZ6cm1lUW5FdmRUWnBwUXdrMlVHTzFrMEJLZXZwdFlFQVJ3anA2TkVC?=
 =?utf-8?B?eU5lbytmYXB2T2hkZm1WNVI0cjNPMXRORC9pTlFBRHdvQklna3l3b0twcXNo?=
 =?utf-8?B?aWlGTWJXYlZ2a0ZoV3pSQk44QmptblpqaThITU9Ra2ovWDg2UWVwQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4018040-8971-4567-f2ce-08dee7d7e03e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5039.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 09:59:10.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rv4kbp/sY+iVt6cqww+wEu0Y1nlqo8C7eQk7iwm0hz9ilYJa7R10jxtza35IbAjaa6RIIveGItp1+VpS493qgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 7/3/2026 6:41 PM, Thomas Hellström wrote:
> On Fri, 2026-07-03 at 15:08 +0200, Christian König wrote:
>> Arun please take a look at this.
>>
>> Thanks,
>> Christian.
> FWIW Sashiko claims there is yet another pre-existing bug WRT ordering
> here, but since the fix wasn't needed for the rest of the series, I
> focused on this one.
Thanks for pointing that out. I have sent a fix for the pre-existing bug 
reported by Sashiko as a separate patch.
https://patchwork.freedesktop.org/patch/741782/

Thanks,
Arun.
>
> Thanks,
> Thomas
>
>
>> On 7/3/26 15:05, Thomas Hellström wrote:
>>> drmm_cgroup_register_region() is called before INIT_LIST_HEAD() and
>>> gpu_buddy_init() in amdgpu_vram_mgr_init(). If it fails, the
>>> function
>>> returns early and bypasses those initializations.
>>>
>>> Since adev->mman.initialized is set to true before
>>> amdgpu_vram_mgr_init()
>>> is called, a failure triggers amdgpu_ttm_fini(), which calls
>>> amdgpu_vram_mgr_fini(), which then:
>>>
>>>   - Calls list_for_each_entry_safe() on reservations_pending and
>>>     reserved_pages, whose list_head::next pointers are zero-
>>> initialized
>>>     (NULL). The loop does not recognize them as empty and
>>> dereferences NULL.
>>>
>>>   - Calls gpu_buddy_fini(), which iterates free_trees[]
>>> unconditionally
>>>     via for_each_free_tree(). Since mm->free_trees is NULL
>>>     (never allocated), this dereferences NULL.
>>>
>>> Both result in a kernel panic on the module load error path.
>>>
>>> Fix by moving drmm_cgroup_register_region() to after the list and
>>> buddy
>>> allocator are fully initialized, so the teardown path is safe to
>>> run.
>>>
>>> Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
>>> Closes:
>>> https://sashiko.dev/#/patchset/20260428073116.15687-1-thomas.hellstrom@linux.intel.com?part=4
>>> Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in
>>> TTM")
>>> Cc: Friedrich Vock <friedrich.vock@gmx.de>
>>> Cc: Maarten Lankhorst <dev@lankhorst.se>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> Cc: Maxime Ripard <mripard@kernel.org>
>>> Cc: Christian König <christian.koenig@amd.com>
>>> Cc: Alex Deucher <alexander.deucher@amd.com>
>>> Cc: amd-gfx@lists.freedesktop.org
>>> Cc: dri-devel@lists.freedesktop.org
>>> Cc: <stable@vger.kernel.org> # v6.14+
>>> Assisted-by: GitHub_Copilot:claude-sonnet-4.6
>>> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>>> ---
>>>   drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> index 2a241a5b12c4..ac3f71d77140 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> @@ -918,9 +918,6 @@ int amdgpu_vram_mgr_init(struct amdgpu_device
>>> *adev)
>>>   	struct ttm_resource_manager *man = &mgr->manager;
>>>   	int err;
>>>   
>>> -	man->cg = drmm_cgroup_register_region(adev_to_drm(adev),
>>> "vram", adev->gmc.real_vram_size);
>>> -	if (IS_ERR(man->cg))
>>> -		return PTR_ERR(man->cg);
>>>   	ttm_resource_manager_init(man, &adev->mman.bdev,
>>>   				  adev->gmc.real_vram_size);
>>>   
>>> @@ -935,6 +932,10 @@ int amdgpu_vram_mgr_init(struct amdgpu_device
>>> *adev)
>>>   	if (err)
>>>   		return err;
>>>   
>>> +	man->cg = drmm_cgroup_register_region(adev_to_drm(adev),
>>> "vram", adev->gmc.real_vram_size);
>>> +	if (IS_ERR(man->cg))
>>> +		return PTR_ERR(man->cg);
>>> +
>>>   	ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM,
>>> &mgr->manager);
>>>   	ttm_resource_manager_set_used(man, true);
>>>   	return 0;

