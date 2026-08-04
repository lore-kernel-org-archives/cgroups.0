Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEE84028EE
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785857777; cv=none; b=d4vCZBOEObxCB4zHdW4IKN7ez6jKJ8nSrnIfkC41TC+yvD6MMAdCBIH+KM0CA50jiYKILEXHqpbhgtn5PzubgQ7AKngQ8KdUyawvI1+/HI9UUYvBNj3xxqamrR0COz4saBrAgNFbfZec9TwHjx+DsHajd4OVbheSr1DDGtGsIv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785857777; c=relaxed/simple;
	bh=5ko/IN4VqNVbNXafBuViG/E2qQi37mwfDTUB4rQ8/U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t21pc0qkpAZW/j6ly8gSbOOcb8xvTTkQisx7qKixZrK2MnDIidnfwpBUwBzDdLmwxAG8rdsVxdxMYgukbrQwURGje3gTu8ShW4FnhCoclnPXuRgDSIjx96Lp7Tu5CSR4LEpw43oh0P5PAZNn9iG3f0tamyhtEo/b1kpjcdNq2Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gtN2bBr6; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gtN2bBr6"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso5767832a12.1
        for <cgroups@vger.kernel.org>; Tue, 04 Aug 2026 08:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785857774; x=1786462574; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ksBlfHiQymAuiEvSzpwhdyj7GzYzB5CWn+8bkyQnsf0=;
        b=gtN2bBr6kz9/c+bc5cQl+oc2DkRBHE9Q66seI/NUysCCDRWMNLUtBmIpj9MLIn538S
         S+axzO21w2opDCBiEAcXIBU85XNDzrwuzmXCiFsz2vvIEFdXlcsYwSCDFEaj2+bJWg8q
         94pRAZOd598STXEdn8k3/byQnGme2VtoQAT8LB3DROmGDJZk95TwJk806RqqPgjQawlD
         LdMif738fanIZLJ36BP3z4g0toNZpGICTUxEr8KeU7BL2R7/XzAvHxtzm+b1zNqVg0cE
         DPc4g7Ts25vDeYVvAOxaH1e8IFuHZc67RK7cVC1C8EjFhdpEzAY6wf0An2JGh9fv5OY7
         N1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785857774; x=1786462574;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ksBlfHiQymAuiEvSzpwhdyj7GzYzB5CWn+8bkyQnsf0=;
        b=LIroUKWDfletqCtRTDyFREMkHRRogj4RpRpAC6bJGF1xRlW0v8XrUL19rk8tx5RfGq
         j2JQtF0GYyh7LZPaHpWtVT/l6ijTxfHJrnfVMI5HMyb/ngTWqfF/yYnEV1s03nxeacSL
         GGFh8d/OVL7tZg+H56E7JAGLiOP4RUfRc0xS8FAY06uaRP/A9p5eGdMcZ3C9Gqi0mfsB
         DVG6H2sXYFGZ1veyVa4iMMhyBfoRWhp287bjlOiBVUHCE2Xl7K8im7c6U/ZbWakCF/ma
         UxYWjp4xyoQCQRT83i27R2+OreRDQZEG9bLXujwlWd343EfSkrSQeQ0z2pWb1YHGiX88
         G6gQ==
X-Gm-Message-State: AOJu0YykYCpM9agFYgumVlXZblpjbUXlhIKhInFo7VrrMzBQSkJO6q5A
	qIMrxDjzuKJIMTSYyxNquZRsF3z9H9KTK6JEW1gUeNEIqdK/tTyR48uw
X-Gm-Gg: AR+sD138UBqhXklWpbcUeIVrzFetRHUwwTm0kEQgC9hqAH26pXzRLx/cAvB5e5lfVhk
	RfqXW0LUj2wOPvtC0iKgY9SG2JV0E1O4NvKpzFqZ/C7k7s+5JerLn6i/tHOvIoQqCklgHpJFo7i
	4qM2MbMODRn7/fiLtQS0SctWhCH4UlBaULXlZMQTGlnNrKkjTnwfEu8T0ze0iKqtcblXbiDkO30
	Zz3gsZ05wZ6RtfMSSNSAISCpOzAKkBT+xXIzugZoj1yhO/NngzJNySru0SlSCWSZhBKZrCJVNLf
	iWM3aThqoKfg5zhBlcIp5T5NepH86dOO67mnLSKasI0+azuvbJFPcjMPzoLzkSji+nwMF8R3/+H
	/Y+MGlhCO3A3oR8tHPmLp9USNxGUNjd/OhmMMad2CXpRs5cyspqlG2sOh07hevm7KYK8Tq2+144
	Fjxna1/230eDc+fFz8PY7l60N5/gp4I7m1bvDsIhcdjluscdk2sYDc3dQTqv6ggMXvQY1sgzZyb
	iU0qQrGV4z+8U1bcHntCGbsT55Oe2GsYiRX
X-Received: by 2002:a05:6402:4541:b0:6a0:a505:1b54 with SMTP id 4fb4d7f45d1cf-6a0a7ca981bmr10891559a12.16.1785857773324;
        Tue, 04 Aug 2026 08:36:13 -0700 (PDT)
Received: from timur-hyperion.localnet (5401D2B5.dsl.pool.telekom.hu. [84.1.210.181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1462c4f8fsm265025a12.29.2026.08.04.08.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:36:11 -0700 (PDT)
From: Timur =?UTF-8?B?S3Jpc3TDs2Y=?= <timur.kristof@gmail.com>
To: Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal =?UTF-8?B?S291dG7DvQ==?= <mkoutny@suse.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Natalie Vock <natalie.vock@gmx.de>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject:
 Re: [PATCH v8 0/6] cgroup/dmem,drm/ttm: Improve protection in contended cases
Date: Tue, 04 Aug 2026 17:36:07 +0200
Message-ID: <lpofhPXuQVOAKGLqOkO7sA@gmail.com>
In-Reply-To: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, August 4, 2026 10:25:15=E2=80=AFAM Central European Summer Time=
 Natalie=20
Vock wrote:
> Hi all,
>=20
> I've been looking into some cases where dmem protection fails to prevent
> allocations from ending up in GTT when VRAM gets scarce and apps start
> competing hard.
>=20
> In short, this is because other (unprotected) applications end up
> filling VRAM before protected applications do. This causes TTM to back
> off and try allocating in GTT before anything else, and that is where
> the allocation is placed in the end. The existing eviction protection
> cannot prevent this, because no attempt at evicting is ever made
> (although you could consider the backing-off as an immediate eviction to
> GTT).
>=20
> This series tries to alleviate this by adding a special case when the
> allocation is protected by cgroups: Instead of backing off immediately,
> TTM will try evicting unprotected buffers from the domain to make space
> for the protected one. This ensures that applications can actually use
> all the memory protection awarded to them by the system, without being
> prone to ping-ponging (only protected allocations can evict unprotected
> ones, never the other way around).
>=20
> The first two patches just add a few small utilities needed to implement
> this to the dmem controller. The other patches are the TTM implementation:
>=20
> "drm/ttm: Be more aggressive..." decouples cgroup charging from resource
> allocation to allow us to hold on to the charge even if allocation fails
> on first try, and adds a path to call ttm_bo_evict_alloc when the
> charged allocation falls within min/low protection limits.
>=20
> "drm/ttm: Use common ancestor..." is a more general improvement in
> correctly implementing cgroup protection semantics. With recursive
> protection rules, unused memory protection afforded to a parent node is
> transferred to children recursively, which helps protect entire
> subtrees from stealing each others' memory without needing to protect
> each cgroup individually. This doesn't apply when considering direct
> siblings inside the same subtree, so in order to not break
> prioritization between these siblings, we need to consider the
> relationship of evictor and evictee when calculating protection.
> In practice, this fixes cases where a protected cgroup cannot steal
> memory from unprotected siblings (which, in turn, leads to eviction
> failures and new allocations being placed in GTT).
>=20
> Thanks,
> Natalie
>=20
> Signed-off-by: Natalie Vock <natalie.vock@gmx.de>

Very nice work!

Reviewed-by: Timur Krist=C3=B3f <timur.kristof@gmail.com>

for the whole series.

> ---
> Changes in v8:
> - Fix a few Sashiko complaints
> - Link to v7:
> https://patch.msgid.link/20260721-dmemcg-aggressive-protect-v7-0-97c4b101=
43
> 15@gmx.de
>=20
> Changes in v7:
> - Fix incorrect refcounting/locking around dmem_cgroup_common_ancestor
>   (Cascardo)
> - Rebase on latest drm-misc-next
> - Link to v6:
> https://lore.kernel.org/r/20260313-dmemcg-aggressive-protect-v6-0-7c71cc1=
49
> 2db@gmx.de
>=20
> Changes in v6:
> - Rename dmem_cgroup_common_ancestor to dmem_cgroup_get_common_ancestor
>   (Maarten)
> - Use ttm_bo_alloc_at_place in eviction cb as well (Tvrtko)
> - Clean up the more aggressive eviction logic (Tvrtko)
> - Link to v5:
> https://lore.kernel.org/r/20260302-dmemcg-aggressive-protect-v5-0-ffd3a26=
02
> 309@gmx.de
>=20
> Changes in v5:
> - Added cgroup_common_ancestor helper to use with
>   dmem_cgroup_common_ancestor (Tejun)
> - Note: "drm/ttm: Use common ancestor..." needed minor changes since
>   dmem_cgroup_common_ancestor now grabs a reference to the ancestor
>   pool which needs to be dropped after use
> - Removed extraneous whitespaces in "drm/ttm: Split cgroup charge..."
>   and unnecessary changes done in "drm/ttm: Extract code..." (Tvrtko)
> - Applied a comment from v3 about below_low not needing to be
>   initialized in "drm/ttm: Be more aggressive..." (Tvrtko)
> - Fixed uncharging the cgroup on allocation failure (Tvrtko)
> - Fixed a typo in the message of "drm/ttm: Split cgroup charge..."
>   (Tvrtko)
> - Added case in ttm_bo_evict_cb for when charging fails, since we need
>   to retry the charge (found myself)
> - Link to v4:
> https://lore.kernel.org/r/20260225-dmemcg-aggressive-protect-v4-0-de847ab=
35
> 184@gmx.de
>=20
> Changes in v4:
> - Split cgroup charge decoupling and eviction logic changes into
>   separate commits (Tvrtko)
> - Fix two cases of errno handling in ttm_bo_alloc_place and its caller
>   (Tvrtko)
> - Improve commit message/description of "drm/ttm: Make a helper..." (now
>   "drm/ttm: Extract code...") (Tvrtko)
> - Documentation improvements for new TTM eviction logic (Tvrtko)
> - Formatting fixes (Tvrtko)
> - Link to v3:
> https://lore.kernel.org/r/20251110-dmemcg-aggressive-protect-v3-0-219ffcf=
c5
> 4e9@gmx.de
>=20
> Changes in v3:
> - Improved documentation around cgroup queries and TTM eviction helpers
>   (Maarten)
> - Fixed up ttm_alloc_at_place charge failure logic to return either
>   -EBUSY or -ENOSPC, not -EAGAIN (found this myself)
> - Link to v2:
> https://lore.kernel.org/r/20251015-dmemcg-aggressive-protect-v2-0-36644fb=
4e
> 37f@gmx.de
>=20
> Changes in v2:
> - Factored out the ttm logic for charging/allocating/evicting into a
>   separate helper to keep things simpler
> - Link to v1:
> https://lore.kernel.org/r/20250915-dmemcg-aggressive-protect-v1-0-2f3353b=
fc
> dac@gmx.de
>=20
> ---
> Natalie Vock (6):
>       cgroup/dmem: Add queries for protection values
>       cgroup,cgroup/dmem: Add (dmem_)cgroup_common_ancestor helper
>       drm/ttm: Extract code for attempting allocation in a place
>       drm/ttm: Split cgroup charge and resource allocation
>       drm/ttm: Be more aggressive when allocating below protection limit
>       drm/ttm: Use common ancestor of evictor and evictee as limit pool
>=20
>  drivers/gpu/drm/ttm/ttm_bo.c       | 223
> ++++++++++++++++++++++++++++++++----- drivers/gpu/drm/ttm/ttm_resource.c =
|=20
> 51 ++++++---
>  include/drm/ttm/ttm_resource.h     |   6 +-
>  include/linux/cgroup.h             |  21 ++++
>  include/linux/cgroup_dmem.h        |  25 +++++
>  kernel/cgroup/dmem.c               | 103 +++++++++++++++++
>  6 files changed, 383 insertions(+), 46 deletions(-)
> ---
> base-commit: 44e9eb5a762142a4aa46c0b5da7c39bfeb78910e
> change-id: 20250915-dmemcg-aggressive-protect-5cf37f717cdb
>=20
> Best regards,
> --
> Natalie Vock <natalie.vock@gmx.de>




