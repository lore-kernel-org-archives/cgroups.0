Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B48F360EC0
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831965; cv=none; b=ZcMOH9rH4WrNEHwHTUq3wGVzGzYSAt0C9MxvsY1mn84h5r6SYybmgw5xkD4uyga+n/aVuDFC4qH2RleFx6w4VAdFjr8RFG4D/28nvBnE7Ky+tpBQAnJqgHHfXTbcsfctQheq0I1kvlGNxbsBZAn7ocaGDr1BmE8qi0mwUsOWWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831965; c=relaxed/simple;
	bh=6p/gDj0yZKPjD2UqTJeZH+fjH8iHPcfpfsTleFlNHqk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=LCia+yiHlaHgUOjpE5nOXkYYP9ff0m0KPxgl58Qj8ltA/0DLTM1e4ln1p4NFdskcJan1b+dSA0rWWfPxLm2m6pxjODvR4xW9eXQq3JcMVR2f+ETktjV1TBXBd7eLnt2VsgVtDsswsCSPFhZtMOS5cokD1lkylDlOqK4x4P2mYa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=kWlQWbfK; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="kWlQWbfK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831944; x=1786436744; i=natalie.vock@gmx.de;
	bh=WY0nipi9xrpmblmNCOnHd0dtUd5/eOrYGo31s2G001M=;
	h=X-UI-Sender-Class:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:To:Cc:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kWlQWbfK9Mq9tLfuHhdujxMHAi8Ni8MOQFMSGKpVpUfZkd8R4M5Z4iUfT+KGufhT
	 cC0QRg7sGgpAJhf44mBBzX6IJjKTWZfPq7utMZcOhbEUTkJLZr7TYqPqM2d7Awev2
	 q9WHI2unNv/RcKV8Vd83I9964oL14AquKhFCbH715taYp8NBohUQMIiBqSkj5SXuV
	 zxPERYZiZdRnXlkzsxMGGRu7dy+qvwq2HeOdYJeYOG2g5+nllFRNhBTxSudQzKD3j
	 LsawL6hxpBS9pwmUs6GrQCkkyiXWNJZte77prSUOOydoQDbmqeceU/EYXc/3Ax/wY
	 Nlmg6wxbTfEKAQsfbw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4QsO-1x1W7q0Bug-00sCn0; Tue, 04
 Aug 2026 10:25:44 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Subject: [PATCH v8 0/6] cgroup/dmem,drm/ttm: Improve protection in
 contended cases
Date: Tue, 04 Aug 2026 10:25:15 +0200
Message-Id: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43RwW6DMAwG4Fepcl6mOE4I9LT3mHYgjkNzoFSAU
 KeKd1+otDIu0Y6/JX/+JT/ExGPiSZxPDzHykqY0XHOo306CLu21Y5lCzkIrbVUDVoaee+pk23U
 jT1NaWN7GYWaapaWILjpwFLzI+7eRY7o/7c+vnC9pmofx+3lqgW36H3UBqaSOiBZ9pNDSR9ff3
 wOLjVz0iwFVZnRmsKqMid5w7nlgcGcAVInBrQ00MVIka7g5MOaXqZTWxTYmM4Fr41qPFmpzYOz
 OoNIlxmYmxoDtdhHVsU31hwEsMVVmHDkgAtPo4A+M2xmnocS4zDSOjM+/MAj2xazr+gOU9wJya
 QIAAA==
X-Change-ID: 20250915-dmemcg-aggressive-protect-5cf37f717cdb
To: Maarten Lankhorst <dev@lankhorst.se>, 
 Maxime Ripard <mripard@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 =?utf-8?q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:JdLd/OYx30oejeIqGDAJlD086Y8nhQtMCKre4NT/Hm5GAKvb8gY
 RLiwDNvGck2UYivn/NTEd5sburOkgkLzABHrUpaYCsdsEcL/xQHg7B5Ps0LZIwYU/Wlzz8Q
 0VeJ7phhPALpNDZDm6jIgE7dJTue6p0Kn6PSAIaCUYtaRvauveoKyLBii1zPreCtVNSYAM5
 6SrSwibSKnvT2NgWFNciA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4lhfW9MV5cw=;eKsZuXM83tGnMHin2FKSKGxUrt2
 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
 bGKtyZE9y2ZB2rELP7mRhov72vlOtVy9YVMe4=

Hi all,

I've been looking into some cases where dmem protection fails to prevent
allocations from ending up in GTT when VRAM gets scarce and apps start
competing hard.

In short, this is because other (unprotected) applications end up
filling VRAM before protected applications do. This causes TTM to back
off and try allocating in GTT before anything else, and that is where
the allocation is placed in the end. The existing eviction protection
cannot prevent this, because no attempt at evicting is ever made
(although you could consider the backing-off as an immediate eviction to
GTT).

This series tries to alleviate this by adding a special case when the
allocation is protected by cgroups: Instead of backing off immediately,
TTM will try evicting unprotected buffers from the domain to make space
for the protected one. This ensures that applications can actually use
all the memory protection awarded to them by the system, without being
prone to ping-ponging (only protected allocations can evict unprotected
ones, never the other way around).

The first two patches just add a few small utilities needed to implement
this to the dmem controller. The other patches are the TTM implementation:

"drm/ttm: Be more aggressive..." decouples cgroup charging from resource
allocation to allow us to hold on to the charge even if allocation fails
on first try, and adds a path to call ttm_bo_evict_alloc when the
charged allocation falls within min/low protection limits.

"drm/ttm: Use common ancestor..." is a more general improvement in
correctly implementing cgroup protection semantics. With recursive
protection rules, unused memory protection afforded to a parent node is
transferred to children recursively, which helps protect entire
subtrees from stealing each others' memory without needing to protect
each cgroup individually. This doesn't apply when considering direct
siblings inside the same subtree, so in order to not break
prioritization between these siblings, we need to consider the
relationship of evictor and evictee when calculating protection.
In practice, this fixes cases where a protected cgroup cannot steal
memory from unprotected siblings (which, in turn, leads to eviction
failures and new allocations being placed in GTT).

Thanks,
Natalie

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
=2D--
Changes in v8:
- Fix a few Sashiko complaints
- Link to v7: https://patch.msgid.link/20260721-dmemcg-aggressive-protect-=
v7-0-97c4b1014315@gmx.de

Changes in v7:
- Fix incorrect refcounting/locking around dmem_cgroup_common_ancestor
  (Cascardo)
- Rebase on latest drm-misc-next
- Link to v6: https://lore.kernel.org/r/20260313-dmemcg-aggressive-protect=
-v6-0-7c71cc1492db@gmx.de

Changes in v6:
- Rename dmem_cgroup_common_ancestor to dmem_cgroup_get_common_ancestor
  (Maarten)
- Use ttm_bo_alloc_at_place in eviction cb as well (Tvrtko)
- Clean up the more aggressive eviction logic (Tvrtko)
- Link to v5: https://lore.kernel.org/r/20260302-dmemcg-aggressive-protect=
-v5-0-ffd3a2602309@gmx.de

Changes in v5:
- Added cgroup_common_ancestor helper to use with
  dmem_cgroup_common_ancestor (Tejun)
- Note: "drm/ttm: Use common ancestor..." needed minor changes since
  dmem_cgroup_common_ancestor now grabs a reference to the ancestor
  pool which needs to be dropped after use
- Removed extraneous whitespaces in "drm/ttm: Split cgroup charge..."
  and unnecessary changes done in "drm/ttm: Extract code..." (Tvrtko)
- Applied a comment from v3 about below_low not needing to be
  initialized in "drm/ttm: Be more aggressive..." (Tvrtko)
- Fixed uncharging the cgroup on allocation failure (Tvrtko)
- Fixed a typo in the message of "drm/ttm: Split cgroup charge..."
  (Tvrtko)
- Added case in ttm_bo_evict_cb for when charging fails, since we need
  to retry the charge (found myself)
- Link to v4: https://lore.kernel.org/r/20260225-dmemcg-aggressive-protect=
-v4-0-de847ab35184@gmx.de

Changes in v4:
- Split cgroup charge decoupling and eviction logic changes into
  separate commits (Tvrtko)
- Fix two cases of errno handling in ttm_bo_alloc_place and its caller
  (Tvrtko)
- Improve commit message/description of "drm/ttm: Make a helper..." (now
  "drm/ttm: Extract code...") (Tvrtko)
- Documentation improvements for new TTM eviction logic (Tvrtko)
- Formatting fixes (Tvrtko)
- Link to v3: https://lore.kernel.org/r/20251110-dmemcg-aggressive-protect=
-v3-0-219ffcfc54e9@gmx.de

Changes in v3:
- Improved documentation around cgroup queries and TTM eviction helpers
  (Maarten)
- Fixed up ttm_alloc_at_place charge failure logic to return either
  -EBUSY or -ENOSPC, not -EAGAIN (found this myself)
- Link to v2: https://lore.kernel.org/r/20251015-dmemcg-aggressive-protect=
-v2-0-36644fb4e37f@gmx.de

Changes in v2:
- Factored out the ttm logic for charging/allocating/evicting into a
  separate helper to keep things simpler
- Link to v1: https://lore.kernel.org/r/20250915-dmemcg-aggressive-protect=
-v1-0-2f3353bfcdac@gmx.de

=2D--
Natalie Vock (6):
      cgroup/dmem: Add queries for protection values
      cgroup,cgroup/dmem: Add (dmem_)cgroup_common_ancestor helper
      drm/ttm: Extract code for attempting allocation in a place
      drm/ttm: Split cgroup charge and resource allocation
      drm/ttm: Be more aggressive when allocating below protection limit
      drm/ttm: Use common ancestor of evictor and evictee as limit pool

 drivers/gpu/drm/ttm/ttm_bo.c       | 223 ++++++++++++++++++++++++++++++++=
=2D----
 drivers/gpu/drm/ttm/ttm_resource.c |  51 ++++++---
 include/drm/ttm/ttm_resource.h     |   6 +-
 include/linux/cgroup.h             |  21 ++++
 include/linux/cgroup_dmem.h        |  25 +++++
 kernel/cgroup/dmem.c               | 103 +++++++++++++++++
 6 files changed, 383 insertions(+), 46 deletions(-)
=2D--
base-commit: 44e9eb5a762142a4aa46c0b5da7c39bfeb78910e
change-id: 20250915-dmemcg-aggressive-protect-5cf37f717cdb

Best regards,
=2D- =20
Natalie Vock <natalie.vock@gmx.de>

