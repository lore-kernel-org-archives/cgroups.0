Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664863BB11B;
	Tue, 21 Jul 2026 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784635839; cv=none; b=A6GNYF7ghVNps83vRrfKDJb8cBVL35BAQL6KbqLrBkfqYufljB+UQTzPWp+o96cAbifTtW0OZ6HVlr4eS3IE4yztaZqAPe8Pn1pLassNZZaUjYkCMXYxTkdOuKsdbVYZ0XdwprtRZqI54pVbGri8fKjppK95exM/5iMdixr7hn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784635839; c=relaxed/simple;
	bh=XqSUnTCT5BmpcGLO10lA1I3XmkdkD5PqInuS9MnabNY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iI8T62mLJIajYR0shvo/s4NvnW37E44Mwvi7sXj5nxqZoP2oBa/RG6DQr+kzJwUoRzyTsbZLQMYbBBK/IOBwA2Isx8MfLVKgioOWGskqi7ogrNP5f7tT1WENFvvXSzQxdC4y5apG9MxFO8MiOisHjlvvhYiVR1AWCqGhSECrHIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5DychrC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5DychrC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784635836; x=1816171836;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=XqSUnTCT5BmpcGLO10lA1I3XmkdkD5PqInuS9MnabNY=;
  b=f5DychrCnL/O5qxFedvy/xXkbzW/LX3Sgv59bxamygwot3R7ov9U6Pqh
   0mz8Jm/9I9BMQ11lH506Mm7X9eYKZLXdfelXvVbAClturjtkOpSj/a0qV
   /tpaZDxx1HVd0SvQVJihKeKEjgEoQ3AJO0xX9dyLlsaT+XmRH5OOu5nif
   IR/YjVcH0NYFrLmY3NwWSP2Agst2Sr9nnGNhGbKbZ54VxskYiHXK611DJ
   zqDwrLXJDSfSSaTLhFhBGzBcm7H+6yUgtY0brYK9lDoTmq8j8T4SOiOAY
   pI70BeG3XlHegdtKIMdrtpZ0b5iJgnd+gatfwpNrMTzEFfxOTZR6u6eK9
   w==;
X-CSE-ConnectionGUID: my6emF2bTp+uUr0AxSIU/A==
X-CSE-MsgGUID: +rf8GZgWSyGivlTVStASmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="95887128"
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="95887128"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 05:10:35 -0700
X-CSE-ConnectionGUID: 83S1zJEXSLKUsdZJTisvdA==
X-CSE-MsgGUID: ukkcRf6jQTO2hf8ogStMHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="255103335"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.57]) ([10.245.245.57])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 05:10:30 -0700
Message-ID: <60de7db0d25e387de4c13d0acb52d2dc1cc22d39.camel@linux.intel.com>
Subject: Re: [PATCH v7 1/6] drm/amdgpu: Fix init ordering in
 amdgpu_vram_mgr_init()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Arunpravin Paneer
 Selvam <arunpravin.paneerselvam@amd.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, 
	intel-xe@lists.freedesktop.org
Cc: Sashiko-bot <sashiko-bot@kernel.org>, Friedrich Vock
 <friedrich.vock@gmx.de>,  Maarten Lankhorst	 <dev@lankhorst.se>, Tejun Heo
 <tj@kernel.org>, Maxime Ripard <mripard@kernel.org>,  Alex Deucher
 <alexander.deucher@amd.com>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, 	stable@vger.kernel.org, Natalie Vock
 <natalie.vock@gmx.de>, Johannes Weiner	 <hannes@cmpxchg.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, 	cgroups@vger.kernel.org,
 Huang Rui <ray.huang@amd.com>, Matthew Brost	 <matthew.brost@intel.com>,
 Matthew Auld <matthew.auld@intel.com>, Thomas Zimmermann
 <tzimmermann@suse.de>, Simona Vetter <simona@ffwll.ch>, David Airlie
 <airlied@gmail.com>,  Thadeu Lima de Souza Cascardo	 <cascardo@igalia.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 	linux-kernel@vger.kernel.org
Date: Tue, 21 Jul 2026 14:10:28 +0200
In-Reply-To: <2e50a938-af3d-4495-926f-fbe084aaae9a@linux.intel.com>
References: <20260703130541.2686-1-thomas.hellstrom@linux.intel.com>
	 <20260703130541.2686-2-thomas.hellstrom@linux.intel.com>
	 <9eae1a5c-d2ef-4d75-a581-58299ca37a1f@amd.com>
	 <9c8b4367-c029-4731-8ea8-b8263e11ada1@amd.com>
	 <2e50a938-af3d-4495-926f-fbe084aaae9a@linux.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi, Maarten,

On Tue, 2026-07-21 at 13:46 +0200, Maarten Lankhorst wrote:
> Hey,
>=20
> Can I merge this through drm-misc-next together with the rest of the
> series?
>=20
> Kind regards
> ~Maarten

For the xe patches, Ack from me.

I do have a v8 that fixes a sashiko comment on the last patch, though,
but I was holding that awaiting a review on the other patches.

Thanks,
Thomas



>=20
> On 7/7/26 20:05, Arunpravin Paneer Selvam wrote:
> >=20
> >=20
> > On 7/3/2026 6:38 PM, Christian K=C3=B6nig wrote:
> > > Arun please take a look at this.
> > Sure Christian. This fix looks correct to me.
> > Reviewed-by: Arunpravin Paneer Selvam
> > <Arunpravin.PaneerSelvam@amd.com>
> >=20
> > Thanks,
> > Arun.
> > >=20
> > > Thanks,
> > > Christian.
> > >=20
> > > On 7/3/26 15:05, Thomas Hellstr=C3=B6m wrote:
> > > > drmm_cgroup_register_region() is called before INIT_LIST_HEAD()
> > > > and
> > > > gpu_buddy_init() in amdgpu_vram_mgr_init(). If it fails, the
> > > > function
> > > > returns early and bypasses those initializations.
> > > >=20
> > > > Since adev->mman.initialized is set to true before
> > > > amdgpu_vram_mgr_init()
> > > > is called, a failure triggers amdgpu_ttm_fini(), which calls
> > > > amdgpu_vram_mgr_fini(), which then:
> > > >=20
> > > > =C2=A0 - Calls list_for_each_entry_safe() on reservations_pending
> > > > and
> > > > =C2=A0=C2=A0=C2=A0 reserved_pages, whose list_head::next pointers a=
re zero-
> > > > initialized
> > > > =C2=A0=C2=A0=C2=A0 (NULL). The loop does not recognize them as empt=
y and
> > > > dereferences NULL.
> > > >=20
> > > > =C2=A0 - Calls gpu_buddy_fini(), which iterates free_trees[]
> > > > unconditionally
> > > > =C2=A0=C2=A0=C2=A0 via for_each_free_tree(). Since mm->free_trees i=
s NULL
> > > > =C2=A0=C2=A0=C2=A0 (never allocated), this dereferences NULL.
> > > >=20
> > > > Both result in a kernel panic on the module load error path.
> > > >=20
> > > > Fix by moving drmm_cgroup_register_region() to after the list
> > > > and buddy
> > > > allocator are fully initialized, so the teardown path is safe
> > > > to run.
> > > >=20
> > > > Reported-by: Sashiko-bot <sashiko-bot@kernel.org>
> > > > Closes:
> > > > https://sashiko.dev/#/patchset/20260428073116.15687-1-thomas.hellst=
rom@linux.intel.com?part=3D4
> > > > Fixes: 2b624a2c1865 ("drm/ttm: Handle cgroup based eviction in
> > > > TTM")
> > > > Cc: Friedrich Vock <friedrich.vock@gmx.de>
> > > > Cc: Maarten Lankhorst <dev@lankhorst.se>
> > > > Cc: Tejun Heo <tj@kernel.org>
> > > > Cc: Maxime Ripard <mripard@kernel.org>
> > > > Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: amd-gfx@lists.freedesktop.org
> > > > Cc: dri-devel@lists.freedesktop.org
> > > > Cc: <stable@vger.kernel.org> # v6.14+
> > > > Assisted-by: GitHub_Copilot:claude-sonnet-4.6
> > > > Signed-off-by: Thomas Hellstr=C3=B6m
> > > > <thomas.hellstrom@linux.intel.com>
> > > > ---
> > > > =C2=A0 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 7 ++++---
> > > > =C2=A0 1 file changed, 4 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
> > > > b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
> > > > index 2a241a5b12c4..ac3f71d77140 100644
> > > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
> > > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
> > > > @@ -918,9 +918,6 @@ int amdgpu_vram_mgr_init(struct
> > > > amdgpu_device *adev)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ttm_resource_manager *man =3D=
 &mgr->manager;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err;
> > > > =C2=A0 -=C2=A0=C2=A0=C2=A0 man->cg =3D drmm_cgroup_register_region(=
adev_to_drm(adev),
> > > > "vram", adev->gmc.real_vram_size);
> > > > -=C2=A0=C2=A0=C2=A0 if (IS_ERR(man->cg))
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PTR_ERR(man->cg)=
;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ttm_resource_manager_init(man, &adev=
->mman.bdev,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 adev->gmc.real_vram_size);
> > > > =C2=A0 @@ -935,6 +932,10 @@ int amdgpu_vram_mgr_init(struct
> > > > amdgpu_device *adev)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> > > > =C2=A0 +=C2=A0=C2=A0=C2=A0 man->cg =3D drmm_cgroup_register_region(=
adev_to_drm(adev),
> > > > "vram", adev->gmc.real_vram_size);
> > > > +=C2=A0=C2=A0=C2=A0 if (IS_ERR(man->cg))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PTR_ERR(man->cg)=
;
> > > > +
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ttm_set_driver_manager(&adev->mman.b=
dev, TTM_PL_VRAM,
> > > > &mgr->manager);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ttm_resource_manager_set_used(man, t=
rue);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> >=20
