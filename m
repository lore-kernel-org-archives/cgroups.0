Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E635C481FBC;
	Tue, 21 Jul 2026 11:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784634328; cv=none; b=kug2j/MBDUXklRU4pSyTGGzxDx219c2RLJ86jkVAwsVaKOC1Qa5UhmSD738yizxL5d9kq36GtMO+gwINIeJnMYWYYK/gfrSaxcBhpTAabAc+LaMEhQSkK1ifQ1PVTX6y+Ob30MNC8xJw1HCzZxHFechX0EvXnOTpPjFsGPGWteU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784634328; c=relaxed/simple;
	bh=J1xsi8VIiBy3ADMhHE51f9v/YO6RpUregFBkwBXQQeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CUlqu0qeLofaHUay/wSQLa61F+lmJdNAy7J8Fep9tOxy7leOZk23UqxedEV5mxcIs+nM4dGM3cO6ogI3tSRgagozNLs/LIi7vLKBCibHZHbg7xlwGOagun0S6JrIGYkwRs3eE2mtl4awoQbBQyI/YXrd5b8iKDouXrkzEc6gQKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZnXy0sZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZnXy0sZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784634325; x=1816170325;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J1xsi8VIiBy3ADMhHE51f9v/YO6RpUregFBkwBXQQeo=;
  b=bZnXy0sZBrm++e5fp/wsZReB3T0ZDPVlLzrOiA/8+oiVk/bfVX52Kbie
   DN2Auz4z2mABSCaSIpggTwN0i6oNmc6rSTBaAhbEOt/YHz8UvFxupj2LY
   SbBlBRvZ7qW/4zEIEebxRbQsPiRodOC70bOkdyWO0YEh8nq4EIGeYc+tT
   dC41/eAGoZTc7QGHNeZi/LUYsGf10IMfxkD1JtKZzWIZt442TejGUGy/6
   4gGOArp4wXF53PRV+L9fABdXLRYkMVM6Rgjk4N0qzAGz/sIKB4VaDbzD2
   l7KVWgmf2inh/tlqIkzwu+YLGP8Or6Un5UfAy/iTWXjFzxsdlaz4s573f
   Q==;
X-CSE-ConnectionGUID: dXULuZp8RFuW3X4UzAxKJA==
X-CSE-MsgGUID: 7iw7XyrnQR23f9E+WNVPGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="85323369"
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="85323369"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 04:45:24 -0700
X-CSE-ConnectionGUID: ku8MPGn/Tp29kK3iZ9FQwg==
X-CSE-MsgGUID: 7EkwXeWOTE28ofZcw2n6qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="281016028"
Received: from rvuia-mobl.ger.corp.intel.com (HELO [10.245.245.93]) ([10.245.245.93])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 04:45:18 -0700
Message-ID: <2e50a938-af3d-4495-926f-fbe084aaae9a@linux.intel.com>
Date: Tue, 21 Jul 2026 13:46:15 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] drm/amdgpu: Fix init ordering in
 amdgpu_vram_mgr_init()
To: Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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
Content-Language: en-US
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <9c8b4367-c029-4731-8ea8-b8263e11ada1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hey,

Can I merge this through drm-misc-next together with the rest of the series?

Kind regards
~Maarten

On 7/7/26 20:05, Arunpravin Paneer Selvam wrote:
> 
> 
> On 7/3/2026 6:38 PM, Christian König wrote:
>> Arun please take a look at this.
> Sure Christian. This fix looks correct to me.
> Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
> 
> Thanks,
> Arun.
>>
>> Thanks,
>> Christian.
>>
>> On 7/3/26 15:05, Thomas Hellström wrote:
>>> drmm_cgroup_register_region() is called before INIT_LIST_HEAD() and
>>> gpu_buddy_init() in amdgpu_vram_mgr_init(). If it fails, the function
>>> returns early and bypasses those initializations.
>>>
>>> Since adev->mman.initialized is set to true before amdgpu_vram_mgr_init()
>>> is called, a failure triggers amdgpu_ttm_fini(), which calls
>>> amdgpu_vram_mgr_fini(), which then:
>>>
>>>   - Calls list_for_each_entry_safe() on reservations_pending and
>>>     reserved_pages, whose list_head::next pointers are zero-initialized
>>>     (NULL). The loop does not recognize them as empty and dereferences NULL.
>>>
>>>   - Calls gpu_buddy_fini(), which iterates free_trees[] unconditionally
>>>     via for_each_free_tree(). Since mm->free_trees is NULL
>>>     (never allocated), this dereferences NULL.
>>>
>>> Both result in a kernel panic on the module load error path.
>>>
>>> Fix by moving drmm_cgroup_register_region() to after the list and buddy
>>> allocator are fully initialized, so the teardown path is safe to run.
>>>
>>> Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
>>> Closes: https://sashiko.dev/#/patchset/20260428073116.15687-1-thomas.hellstrom@linux.intel.com?part=4
>>> Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in TTM")
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
>>>   drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> index 2a241a5b12c4..ac3f71d77140 100644
>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
>>> @@ -918,9 +918,6 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
>>>       struct ttm_resource_manager *man = &mgr->manager;
>>>       int err;
>>>   -    man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram", adev->gmc.real_vram_size);
>>> -    if (IS_ERR(man->cg))
>>> -        return PTR_ERR(man->cg);
>>>       ttm_resource_manager_init(man, &adev->mman.bdev,
>>>                     adev->gmc.real_vram_size);
>>>   @@ -935,6 +932,10 @@ int amdgpu_vram_mgr_init(struct amdgpu_device *adev)
>>>       if (err)
>>>           return err;
>>>   +    man->cg = drmm_cgroup_register_region(adev_to_drm(adev), "vram", adev->gmc.real_vram_size);
>>> +    if (IS_ERR(man->cg))
>>> +        return PTR_ERR(man->cg);
>>> +
>>>       ttm_set_driver_manager(&adev->mman.bdev, TTM_PL_VRAM, &mgr->manager);
>>>       ttm_resource_manager_set_used(man, true);
>>>       return 0;
> 

