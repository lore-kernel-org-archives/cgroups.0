Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E2B154425;
	Wed, 22 Jul 2026 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784713792; cv=fail; b=hr5adOUEaPYqAMthHc+BGvs2DO2LWSG56D3hp+lPRBhR8IaTnQfTiD/69Wmvub7zulHgza/rMqrys3ILv11+j5RUkFuxGBlLs+gOiYfUGxAOfc3UHDBrVcXGoUWPz9R13H1yD4zxAsnRNySI18CGgjdeIlg0CR0c0gkGJ0GNTqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784713792; c=relaxed/simple;
	bh=KkAm/ByUEdlEvhGMbD4NoyM9V1MBdSexPB+9oIWaX4I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aU7PViftZ+2g/kJmlcdlIMmryiSGMKFIjF9iHKp2QdzFIn9wLxG+FH55zukZxCVsFr9L78Z++aEvDRy1A1uMEtaxC65IWtKB/n0Of5gvisIC2/v6MaGRWc+p4duVNjh6Hpi5QaAg0o00TzxO9cYod4z5nu8NDR7h0ARM+ho4qoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SOysxWJW; arc=fail smtp.client-ip=52.101.52.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SOysxWJW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=btm75pNYbgoDruBrlJbwO/zssoPAbcbPmesYJEe11l8LXcPt7ce79iXDzqnuSuiaaPoQefRIssphYSkwRAs9zWHMCkfgIQQJ3M4c8M3PvGcLAmiu+GVsKNi7u0O8DnhSULGMQaxUDqcD3bQ2RGFgvMhXmPyBAzqbDXBPEBwRVIOeaQlbHhqo0ms92vxvBJsLJzZTmnyuEXwqmfXggY8AjDkCXeZ9+OaVImHsLNMWo9+Vr0e2mjFgg02SHxMHGbZJPCv96wE5O7hIF6jQs/bOn2E6oU7lglSXgGq8GmU5ZZrl0NL0vj7xEmbsvK57IeCmf0+M+XWkCFDRJt42n5uBsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7vmdZcTo+shrGIK/XXIJZw2P2eIlfdtw8hzsAzKmbQ=;
 b=oPR+/edRoTlZlSaymFoo6ZDSTfGhwEfVjA2L2blzNFMf7wLKCWuC0J5aYlkM5qhzppxm5qgImZgKiOvesFNWRedsWWrIJPmPWiHQhh8gW5kGy4hc8h5R4rnCBnkCaFL+fxjYUoP8M2rUCpdE3G2F8UscWd/CgLXhum7Q9rTrZCOr4GP6PwsNVyaLg64WGwHYOT/H+OcxVlCffcRQxkGAACrOoylMGScqDZYtNk2BL0HklCR/r2vjZWAzooOFZcioGfoQ1y2XW5it0d7E9xp6T+iYs+X2kJ/9vbVKyWln8HFnqMp4Fu0qlbscxrM3eXLKq+zOfsyqLGp0O8gIbbaKZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7vmdZcTo+shrGIK/XXIJZw2P2eIlfdtw8hzsAzKmbQ=;
 b=SOysxWJWbjdpm6jCTOaMcUrYQpt9QfVhX1/QgZqr9FXww+qMu3cZvMJaTXXVyQriJ/5iOsSjojWGA1RU17Hz/y9A72nOhF1w2WrMOgHHbOSRsbe0g3ZNXl6amOFMxx8LDrPOhlVQNh01JFyJZbU/LqJEWS6PLzZ0VgLWd4qsDog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5039.namprd12.prod.outlook.com (2603:10b6:5:38a::18)
 by CY5PR12MB6108.namprd12.prod.outlook.com (2603:10b6:930:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 09:49:45 +0000
Received: from DM4PR12MB5039.namprd12.prod.outlook.com
 ([fe80::762:6408:ca99:701d]) by DM4PR12MB5039.namprd12.prod.outlook.com
 ([fe80::762:6408:ca99:701d%3]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 09:49:45 +0000
Message-ID: <e408f057-4c7b-4778-8dc8-f9e44e2f0d86@amd.com>
Date: Wed, 22 Jul 2026 15:19:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] drm/amdgpu: Fix init ordering in
 amdgpu_vram_mgr_init()
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
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
 Thomas Zimmermann <tzimmermann@suse.de>, Simona Vetter <simona@ffwll.ch>,
 David Airlie <airlied@gmail.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, linux-kernel@vger.kernel.org
References: <20260703130541.2686-1-thomas.hellstrom@linux.intel.com>
 <20260703130541.2686-2-thomas.hellstrom@linux.intel.com>
 <9eae1a5c-d2ef-4d75-a581-58299ca37a1f@amd.com>
 <9c8b4367-c029-4731-8ea8-b8263e11ada1@amd.com>
 <2e50a938-af3d-4495-926f-fbe084aaae9a@linux.intel.com>
 <60de7db0d25e387de4c13d0acb52d2dc1cc22d39.camel@linux.intel.com>
 <06bcc2e8-a7fd-483d-8c73-2a253b433840@linux.intel.com>
Content-Language: en-US
From: Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>
In-Reply-To: <06bcc2e8-a7fd-483d-8c73-2a253b433840@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0244.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:223::15) To DM4PR12MB5039.namprd12.prod.outlook.com
 (2603:10b6:5:38a::18)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5039:EE_|CY5PR12MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fbf301d-8eaa-4882-1cfc-08dee7d68f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|4143699003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	gS/vfhADQt72/OnboSN10eLx63a2tsjHB2UQHcx0zkvagOeilMYrLcGLESzhHBkp/ZVn4owy5f47oCQVacGxsxRqdhYvI42WEe+pHjwxxC6m0H3gU7oVtCP2HXoFjNjQWLLHEOiMi9oz+8+ZwCKryv6XMD1f4F1nRTd42nn3SnnBt/G6sTKHbUk7+fYRYLmUwiW3ymZWThn/9sPxe7fzv4rL+4WhCwmVaA8PuA+FarUI/BBiuiMG/9osykbFqV114Ef7AYivvu4ib+XASU4YABxZbQlsjq43mwOizK1OWsbl4IDHhelsTGj1F1DAbLAJV6hLH5Spf30pA4Knspf1PdnOOjq5scy97wr7bAedWqeWCNGI/AK43SVbYTbvFwfGkAZy9x74xAPgaDqickbO72bnpohVpQ8TEG42pqYVM4RZjVIKATW/8RCSE81rVT6X7rupIBJMzEPQ7Bk+43nfvLXXY6Gjal6GSK37FNzoH9CO1H2T10pzRLvHm23Je7lpqLjg1GEAfMOI7lgkqqw8S19UhepJ1gDt4iGsxYB5PKg1z7Ed1kCDQvszhB7wGE5BlvTBuzVtBSajY21LHjut58HMeRH1qAaYmvd4PFEUZeU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5039.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2JScWNXczdRWkJxaFpnN0RBVkJrZE5UTTlrUEhEVUlDbHowaVJNL2JNRVR3?=
 =?utf-8?B?OG5JUkhGMDVTK2VXYWVNMlBiYm52UWZiRnVQbGRmZ1FMd3lNRGNkWGVTMDFT?=
 =?utf-8?B?WmVGNjlEYWVnTk1mK09rKzFpSkZETS9OU091ckZkeGJJQjR4ZkVwRFZGSmtK?=
 =?utf-8?B?NGZsUmpEREZaWERrYmpVbEduU1FOWi9QT1NiSG5jbGFhMllaSDRuZ0ExOVBK?=
 =?utf-8?B?SWRocVJVR01sa1lTQVVVNm5idVpMTWt1VFlkQ3dkZTlxZmprYVlrNkZYd2Nx?=
 =?utf-8?B?bmtqRmp1d2QvdGppNEdiOStZZWhaNWFoNEdsQ3gzY1U4TXJ2VGZheVpLemZ4?=
 =?utf-8?B?TlF6akNQcTdsTWh3TkgxVTFMWm9JL1pqRHhjazBpd21kd2NTZDFjM0QrMmRN?=
 =?utf-8?B?K1B1M1ZIZzRlam1jMU1PRE1oVU1Rbm5JOEFLeCtDN3puVnBzcjRBclRRcVFF?=
 =?utf-8?B?R1FSNStzQmRDZnJnbEFlTUU3UXJzdmVibE1lUElONU9maHZWb0J5eDVEcVYr?=
 =?utf-8?B?Vm9UU3NwTHh4SmhTcmtNOU5iOTM0eXhLVktGYzdhZGg5emJndTdiSmsyOHU0?=
 =?utf-8?B?TmV1SnY0VmhHbnE3R1NQczNxbkJYajBMVTc2dWh2SWpxU3pLL2NvcWVCaEZO?=
 =?utf-8?B?aGcya1JBSzRDRU5xOE9KMmhIb0Y4eCt3TGxwcmFCc2x2WU1xZzFHbENHVkJN?=
 =?utf-8?B?bUxGTjV0N2kxbXdhL0ZueG1DcFROVGFKS0dKZXBoYmdwWlZHOGVRRi9RU0NJ?=
 =?utf-8?B?TldXZmxNMmtYZ3hlMjJ0NDVzVVpBZXdMZFJ1QllrQ0p1eEliSWRMRENOZFRO?=
 =?utf-8?B?bG9KTS9XcTM3bUJMbU1aekpJVFpXU0dwTTF5UDYvQ2VtRVQxUmt3ZENZa3JL?=
 =?utf-8?B?ck90SmtxbHMvWGlPUCtFLy9FeVBVQmR3bExyUHZrUTE0RTBDdlRnUjdyYkFl?=
 =?utf-8?B?blBVMnYxaVpzOFJNVERSVHVJN3lQa2d0ZkxwOWpEcnJYR0orcFRKNWZMUXo3?=
 =?utf-8?B?WlhYWkowYjRNbHNCa1ZnRTVhQWtxakNHY01KQ2pPVjVJRGFITDNJREdkem55?=
 =?utf-8?B?ZlpYZmMvTXVGMUszZmNINjFDdlZMaHVobCtnZHY2R1pMa3lLeUgzNVRUNnJB?=
 =?utf-8?B?Q3pJanhJYlR2aVVlTk1ycmFtSjBsb3FaMUZnSlVEakl5cjBXR3BXeTM3RnJT?=
 =?utf-8?B?Zmwzbllkdkx2SFdyVkRGK2wreldKNng0bW9mbVBCdXBJZU53OTllbHlNNWk3?=
 =?utf-8?B?bmxsd3hCWnlYZ25STWhIUGxURjQ0Yi9LYktwYzRaN0kxWHVhOHZ3dERST3hR?=
 =?utf-8?B?Zkk5UHprWlFnRWFSN0daUzVyS2ZNRDZxY09aTVllTUs1cEpScGhtNDFsdlB5?=
 =?utf-8?B?dmRpUENiRUk2eXNiWWpyVFlsUTgyd0MrRUZ4QkdIbWZHRWRmUzNzaWFQU1JN?=
 =?utf-8?B?MEE5b29ubXhNVVBrempqYmY2aS9PS0NmNXNvU2dZYkNMdzJDeTlkZG05RnQy?=
 =?utf-8?B?aWRKdzEyYU0yUDZ0ZEE0bzhLWW5leFJIWEV3WnorZE13bEJZMDBXOHNZeWl1?=
 =?utf-8?B?QWpMVUJBNk9SZHY2d1VhVEx3YmFCTGUxQkZQTFFQZ0ZEVEdNd2plYXpLelc3?=
 =?utf-8?B?N01FNFlBSjNETmpnSHZzVGZ0dFI1UlRnb3lIc3R6cGlCUGtHbC81ZDN4Yjlm?=
 =?utf-8?B?b3RQSGl4TXdta1NCYXBLa2ZIU3psWU85SW1lYkNydlhoOTJSdTZTTWNnamVB?=
 =?utf-8?B?TVJpQkczZ09ENFFod0U5cmdYQXRIMEdFM3o3ajllVEtINU9WM1V2UnY5Wk5U?=
 =?utf-8?B?WXFLSnZQTkVzb2ZaZDd4QVg0b0cyQXJZOC9PRDhKdzBSOXUrUmFZZ3VMWFlh?=
 =?utf-8?B?RWhkYTFZcjJBMDFGdmtubFFTRVdIVlcrYkZMRk9BdFduOW5CSDgzL1FtOUQ2?=
 =?utf-8?B?VVlMV255S1lQQXpFWVdkSHJ1cXpybTNaU1h4eXpiZDVrcTcveEh6aUhyelFu?=
 =?utf-8?B?K2R3V0pFQStsQitycFdvOFlBcVJtaFZaSHR1Rjh6eDUxa1V5V3haNUgzODJk?=
 =?utf-8?B?TEloUmM4Mlk5aVQrUTVhb2wzSkp6MDliUzdPc2kxZEFaNUs4U0NxUUF1U21k?=
 =?utf-8?B?RXZnVWhQVDN5NlJ5d0xrUEJ5bU9IMWhyMXprenBiUmloMlJNRWQ0SHRPLy8w?=
 =?utf-8?B?OVk1UkN1Y3ZNWkNSVVN1WG9xWi9KQ2NURUJ6MUxEOG4wWXg0VjE3MzlNa3dE?=
 =?utf-8?B?d25MZUxydkpIS1NyT0x2K0RCelZUTS83RU0zRzAyVGt0SzRFWEQ5NUhVU2Zy?=
 =?utf-8?B?Z1c1NkRWd2I3K3pkZ28vY3lqZjJlV2pNVm5TbEF6N25Cc01HY2c3QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbf301d-8eaa-4882-1cfc-08dee7d68f5e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5039.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 09:49:45.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w03tZvsmr2OS8ZNMVP1+NFkQPXOZnW45Ts9UPRi2f0hOz/sxOqP/4NQO5FB3FlqIz4xtn5L1tXgXwQRKsOOYUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6108



On 7/21/2026 5:56 PM, Maarten Lankhorst wrote:
> Hey,
>
> On 7/21/26 14:10, Thomas Hellström wrote:
>> Hi, Maarten,
>>
>> On Tue, 2026-07-21 at 13:46 +0200, Maarten Lankhorst wrote:
>>> Hey,
>>>
>>> Can I merge this through drm-misc-next together with the rest of the
>>> series?
>>>
>>> Kind regards
>>> ~Maarten
>> For the xe patches, Ack from me.
>>
>> I do have a v8 that fixes a sashiko comment on the last patch, though,
>> but I was holding that awaiting a review on the other patches.
> Yeah seems about right. Patches themselves look good to me now, so would be nice if amd can ack here or in v8.
I have already sent my Reviewed-by for this patch.
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

Thanks,
Arun.
>
> Series themselves look good, so feel free to add my r-b to entire series: (and Thadeu's t-b)
>
> Reviewed-By: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>
>> Thanks,
>> Thomas
>>
>>
>>
>>> On 7/7/26 20:05, Arunpravin Paneer Selvam wrote:
>>>>
>>>> On 7/3/2026 6:38 PM, Christian König wrote:
>>>>> Arun please take a look at this.
>>>> Sure Christian. This fix looks correct to me.
>>>> Reviewed-by: Arunpravin Paneer Selvam
>>>> <Arunpravin.PaneerSelvam@amd.com>
>>>>
>>>> Thanks,
>>>> Arun.
>>>>> Thanks,
>>>>> Christian.
>>>>>
>>>>> On 7/3/26 15:05, Thomas Hellström wrote:
>>>>>> drmm_cgroup_register_region() is called before INIT_LIST_HEAD()
>>>>>> and
>>>>>> gpu_buddy_init() in amdgpu_vram_mgr_init(). If it fails, the
>>>>>> function
>>>>>> returns early and bypasses those initializations.
>>>>>>
>>>>>> Since adev->mman.initialized is set to true before
>>>>>> amdgpu_vram_mgr_init()
>>>>>> is called, a failure triggers amdgpu_ttm_fini(), which calls
>>>>>> amdgpu_vram_mgr_fini(), which then:
>>>>>>
>>>>>>    - Calls list_for_each_entry_safe() on reservations_pending
>>>>>> and
>>>>>>      reserved_pages, whose list_head::next pointers are zero-
>>>>>> initialized
>>>>>>      (NULL). The loop does not recognize them as empty and
>>>>>> dereferences NULL.
>>>>>>
>>>>>>    - Calls gpu_buddy_fini(), which iterates free_trees[]
>>>>>> unconditionally
>>>>>>      via for_each_free_tree(). Since mm->free_trees is NULL
>>>>>>      (never allocated), this dereferences NULL.
>>>>>>
>>>>>> Both result in a kernel panic on the module load error path.
>>>>>>
>>>>>> Fix by moving drmm_cgroup_register_region() to after the list
>>>>>> and buddy
>>>>>> allocator are fully initialized, so the teardown path is safe
>>>>>> to run.
>>>>>>
>>>>>> Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
>>>>>> Closes:
>>>>>> https://sashiko.dev/#/patchset/20260428073116.15687-1-thomas.hellstrom@linux.intel.com?part=4
>>>>>> Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in
>>>>>> TTM")
>>>>>> Cc: Friedrich Vock <friedrich.vock@gmx.de>
>>>>>> Cc: Maarten Lankhorst <dev@lankhorst.se>
>>>>>> Cc: Tejun Heo <tj@kernel.org>
>>>>>> Cc: Maxime Ripard <mripard@kernel.org>
>>>>>> Cc: Christian König <christian.koenig@amd.com>
>>>>>> Cc: Alex Deucher <alexander.deucher@amd.com>
>>>>>> Cc: amd-gfx@lists.freedesktop.org
>>>>>> Cc: dri-devel@lists.freedesktop.org
>>>>>> Cc: <stable@vger.kernel.org> # v6.14+
>>>>>> Assisted-by: GitHub_Copilot:claude-sonnet-4.6
>>>>>> Signed-off-by: Thomas Hellström
>>>>>> <thomas.hellstrom@linux.intel.com>
>>>>>> ---
>>>>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 7 ++++---
>>>>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>>> index 2a241a5b12c4..ac3f71d77140 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>>> @@ -918,9 +918,6 @@ int amdgpu_vram_mgr_init(struct
>>>>>> amdgpu_device *adev)
>>>>>>        struct ttm_resource_manager *man = &mgr->manager;
>>>>>>        int err;
>>>>>>    -    man->cg = drmm_cgroup_register_region(adev_to_drm(adev),
>>>>>> "vram", adev->gmc.real_vram_size);
>>>>>> -    if (IS_ERR(man->cg))
>>>>>> -        return PTR_ERR(man->cg);
>>>>>>        ttm_resource_manager_init(man, &adev->mman.bdev,
>>>>>>                      adev->gmc.real_vram_size);
>>>>>>    @@ -935,6 +932,10 @@ int amdgpu_vram_mgr_init(struct
>>>>>> amdgpu_device *adev)
>>>>>>        if (err)
>>>>>>            return err;
>>>>>>    +    man->cg = drmm_cgroup_register_region(adev_to_drm(adev),
>>>>>> "vram", adev->gmc.real_vram_size);
>>>>>> +    if (IS_ERR(man->cg))
>>>>>> +        return PTR_ERR(man->cg);
>>>>>> +
>>>>>>        ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM,
>>>>>> &mgr->manager);
>>>>>>        ttm_resource_manager_set_used(man, true);
>>>>>>        return 0;

