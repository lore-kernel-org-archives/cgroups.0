Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7937B3016E0;
	Tue, 21 Jul 2026 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784636747; cv=none; b=ryZCgZbMXLmJPzDJfGPQWino5kxKug2O4b81tvmPkUdsbC01Syrm+B1Wimz3ABL+hZe7nbot29x/h0G0tgaJRyzng7kzvIIRS7e3LvAoRDDQwty+rC9vSQpU1aGDlH0H36lcqeFoXfI6ah6pRpzgZSyO2uBqpKddJy5ScmAxgq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784636747; c=relaxed/simple;
	bh=I/YKssBTmCWpxAzh41dfBNeIEMvOCor3EGtfl9H79gE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cTzehcIeavMDyLdt7w59sEHT6C726mbdVsGjNfUEDlhbyjfLO73sGX5zsvoBZWgXK+j74H8cN2ETKIURjJTNLh5flHtCa4E6RTSfyK/2cS+RTjn5A9GEg5s4pCvApzvdQQQjNmImfbfGYbFRHSRyxD5HsA0sS01cPe2TnpZg5ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AjqLv/8a; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AjqLv/8a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784636744; x=1816172744;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I/YKssBTmCWpxAzh41dfBNeIEMvOCor3EGtfl9H79gE=;
  b=AjqLv/8abUyiHtrDjb60GbyOHTnBPsAyNnLBh424IhFApmFbIZQ3/yD4
   cnQq0ZJ68i2Kp3LJqbK9d7KbZEwqYk9/ZqOPV5/rbMaLosvyAGuPyNDwk
   9+OqgY+9Rhr0kSOBibC5LrohOOM307rAs37c2RMaLwt7BjOrJ7mTWjRMG
   LBI5K4xxdv5v7vxlZLsEVaU7DHg0aEKWXi4gKqlqbwZIGu06NpYL2lvFK
   /aSs5caHRHaA5dgKU2z8/rgY+HTeUr6aWTHTLJn3K3nK6eMzYTQykC4Rm
   KvgrRK9jdsQzteRZvwzlYGiBePUOtp0VL5IyMA17k5McV+r2h8KYgFaJ/
   A==;
X-CSE-ConnectionGUID: uIRJlM+QQNawce5QeMx3Vw==
X-CSE-MsgGUID: Au1TkbzORtWtHBrkRRyhyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="85251822"
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="85251822"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 05:25:43 -0700
X-CSE-ConnectionGUID: TRZNSRRfRZmcBxvcQyaQxA==
X-CSE-MsgGUID: PHvGZ7zoS+u3lvSXILpcyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="258396724"
Received: from rvuia-mobl.ger.corp.intel.com (HELO [10.245.245.93]) ([10.245.245.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 05:25:38 -0700
Message-ID: <06bcc2e8-a7fd-483d-8c73-2a253b433840@linux.intel.com>
Date: Tue, 21 Jul 2026 14:26:34 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] drm/amdgpu: Fix init ordering in
 amdgpu_vram_mgr_init()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
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
Content-Language: en-US
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <60de7db0d25e387de4c13d0acb52d2dc1cc22d39.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hey,

On 7/21/26 14:10, Thomas Hellström wrote:
> Hi, Maarten,
> 
> On Tue, 2026-07-21 at 13:46 +0200, Maarten Lankhorst wrote:
>> Hey,
>>
>> Can I merge this through drm-misc-next together with the rest of the
>> series?
>>
>> Kind regards
>> ~Maarten
> 
> For the xe patches, Ack from me.
> 
> I do have a v8 that fixes a sashiko comment on the last patch, though,
> but I was holding that awaiting a review on the other patches.
Yeah seems about right. Patches themselves look good to me now, so would be nice if amd can ack here or in v8.

Series themselves look good, so feel free to add my r-b to entire series: (and Thadeu's t-b)

Reviewed-By: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

> 
> Thanks,
> Thomas
> 
> 
> 
>>
>> On 7/7/26 20:05, Arunpravin Paneer Selvam wrote:
>>>
>>>
>>> On 7/3/2026 6:38 PM, Christian König wrote:
>>>> Arun please take a look at this.
>>> Sure Christian. This fix looks correct to me.
>>> Reviewed-by: Arunpravin Paneer Selvam
>>> <Arunpravin.PaneerSelvam@amd.com>
>>>
>>> Thanks,
>>> Arun.
>>>>
>>>> Thanks,
>>>> Christian.
>>>>
>>>> On 7/3/26 15:05, Thomas Hellström wrote:
>>>>> drmm_cgroup_register_region() is called before INIT_LIST_HEAD()
>>>>> and
>>>>> gpu_buddy_init() in amdgpu_vram_mgr_init(). If it fails, the
>>>>> function
>>>>> returns early and bypasses those initializations.
>>>>>
>>>>> Since adev->mman.initialized is set to true before
>>>>> amdgpu_vram_mgr_init()
>>>>> is called, a failure triggers amdgpu_ttm_fini(), which calls
>>>>> amdgpu_vram_mgr_fini(), which then:
>>>>>
>>>>>   - Calls list_for_each_entry_safe() on reservations_pending
>>>>> and
>>>>>     reserved_pages, whose list_head::next pointers are zero-
>>>>> initialized
>>>>>     (NULL). The loop does not recognize them as empty and
>>>>> dereferences NULL.
>>>>>
>>>>>   - Calls gpu_buddy_fini(), which iterates free_trees[]
>>>>> unconditionally
>>>>>     via for_each_free_tree(). Since mm->free_trees is NULL
>>>>>     (never allocated), this dereferences NULL.
>>>>>
>>>>> Both result in a kernel panic on the module load error path.
>>>>>
>>>>> Fix by moving drmm_cgroup_register_region() to after the list
>>>>> and buddy
>>>>> allocator are fully initialized, so the teardown path is safe
>>>>> to run.
>>>>>
>>>>> Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
>>>>> Closes:
>>>>> https://sashiko.dev/#/patchset/20260428073116.15687-1-thomas.hellstrom@linux.intel.com?part=4
>>>>> Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in
>>>>> TTM")
>>>>> Cc: Friedrich Vock <friedrich.vock@gmx.de>
>>>>> Cc: Maarten Lankhorst <dev@lankhorst.se>
>>>>> Cc: Tejun Heo <tj@kernel.org>
>>>>> Cc: Maxime Ripard <mripard@kernel.org>
>>>>> Cc: Christian König <christian.koenig@amd.com>
>>>>> Cc: Alex Deucher <alexander.deucher@amd.com>
>>>>> Cc: amd-gfx@lists.freedesktop.org
>>>>> Cc: dri-devel@lists.freedesktop.org
>>>>> Cc: <stable@vger.kernel.org> # v6.14+
>>>>> Assisted-by: GitHub_Copilot:claude-sonnet-4.6
>>>>> Signed-off-by: Thomas Hellström
>>>>> <thomas.hellstrom@linux.intel.com>
>>>>> ---
>>>>>   drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 7 ++++---
>>>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>> index 2a241a5b12c4..ac3f71d77140 100644
>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>>>> @@ -918,9 +918,6 @@ int amdgpu_vram_mgr_init(struct
>>>>> amdgpu_device *adev)
>>>>>       struct ttm_resource_manager *man = &mgr->manager;
>>>>>       int err;
>>>>>   -    man->cg = drmm_cgroup_register_region(adev_to_drm(adev),
>>>>> "vram", adev->gmc.real_vram_size);
>>>>> -    if (IS_ERR(man->cg))
>>>>> -        return PTR_ERR(man->cg);
>>>>>       ttm_resource_manager_init(man, &adev->mman.bdev,
>>>>>                     adev->gmc.real_vram_size);
>>>>>   @@ -935,6 +932,10 @@ int amdgpu_vram_mgr_init(struct
>>>>> amdgpu_device *adev)
>>>>>       if (err)
>>>>>           return err;
>>>>>   +    man->cg = drmm_cgroup_register_region(adev_to_drm(adev),
>>>>> "vram", adev->gmc.real_vram_size);
>>>>> +    if (IS_ERR(man->cg))
>>>>> +        return PTR_ERR(man->cg);
>>>>> +
>>>>>       ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM,
>>>>> &mgr->manager);
>>>>>       ttm_resource_manager_set_used(man, true);
>>>>>       return 0;
>>>

