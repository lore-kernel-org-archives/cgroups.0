Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D7F47011A
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663070; cv=none; b=gCpH6SO2Xy48AKVPFHEQ0538ObL9fHYUw79c7S6iOudhWSktJLG3+dqDI6EECs+YokyfjQe1roTnDvPujksoPWCMQQbPOPJNcAQv68VFmn4vyW3d9g6GeeCR0tkSnklB+Er30p3CfRHKOX4NzKav5j4nXhcGMnj9OmMc1zRxmpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663070; c=relaxed/simple;
	bh=c6npDirL7D982YhbXT68xACW7xLrrTCL14WS/Wx+Qdw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hkBMus3yzTP/1MvkwNB1C+KE5ubTegady3m/0r3eI0Cg+0JsyW82jVVQnry0uY2j8VZz032vSwVw5hVkwDJppzYlERpnP5ffb6DYT3QrOzD+zUwLhkGbNRag9mfqGGEJqOZ99hKLpCx7bI83AoTTSvF6uFy062tJkEyxnsvRuHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=CBwRQo3R; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="CBwRQo3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663043; x=1785267843; i=natalie.vock@gmx.de;
	bh=3T4gTCdUfE1lcG+GEx1hDuaP25QQ6iV1ht2Bj/531dY=;
	h=X-UI-Sender-Class:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:To:Cc:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CBwRQo3R7NQghjD/MYzHD6qbHAqaX+Y5cbDfiqDCozQtdfKqEmjzfJHQJ+KE29rI
	 nR1tt6b/gu6wy17YORxMdRYZYr295SboeauQMeq+VTwq4vH9gu5o7rFXaO058Jrkn
	 r7Zc1CgAeqpsYBD+S6S129B7g23lHgGtkzzwtw+fjEQxPoo4Uo/a3qECyOlyI2tZ6
	 DnZTIIEj9hzITC5eKVdHFrjw6F0E+pkoDZbdR9is/VFiBTExb8ziPRsi/RYruLyg1
	 BEbGH6R6XCPgIqKoNWlMMNjY8842rKWBhrsSqlLTcu+sTGZLIeXNHMW1mOZS3ddok
	 cdznI+Vy19IPWOHPhg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M2f9b-1wi83J43Xb-000sHd; Tue, 21
 Jul 2026 21:44:03 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Subject: [PATCH v7 0/6] cgroup/dmem,drm/ttm: Improve protection in
 contended cases
Date: Tue, 21 Jul 2026 21:43:19 +0200
Message-Id: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43OQW7DIBAF0KtErEvFMGDirHqPqgt7GBwWjiOwU
 KrIdy+O1KTeWF3+keb9fxeZU+QsToe7SFxijtOlBvd2EHTuLgPL6GsWWmmrWrDSjzzSILthSJx
 zLCyvaZqZZmkpoAsOHPle1P9r4hBvD/vzq+ZzzPOUvh9VBdbrf9QCUkkdEC32gXxHH8N4e/csV
 rLoJwNqn9GVwaYxJvSG684Ngy8GQO0xuK6BNgQKZA23G8b8Mo3SeneNqYzno3FdjxaOZsPYF4N
 K7zG2MiF47NZGVNs1zR8GcI9pKuPIARGYVvv+ySzL8gMMOi9KIgIAAA==
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
 Natalie Vock <natalie.vock@gmx.de>, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:E/BJQDGEyBWOGshON8wnvAaiQe0he9M2FbVaKL9SSKvlVDzgAB4
 b7dAkiDsXeAZ5o5CGNGGucPsBcgJKUXIYexEnrw+cviPfKIuaQf9o/RYktigFeSY+cpSa6+
 Yx8XO+VhH/wVPoLg135vAxG/dRwYaVMKeaBJTx1+Pgthsuh1nx/7QAUD8BN9MXouJaLnD9R
 52nhpBsLf94LV3qMZYUVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jchl1gW2SEU=;G4V4gdXEnk27unrzUdQTAxKbMoZ
 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
 =

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

 drivers/gpu/drm/ttm/ttm_bo.c       | 221 ++++++++++++++++++++++++++++++++=
=2D----
 drivers/gpu/drm/ttm/ttm_resource.c |  51 ++++++---
 include/drm/ttm/ttm_resource.h     |   6 +-
 include/linux/cgroup.h             |  21 ++++
 include/linux/cgroup_dmem.h        |  25 +++++
 kernel/cgroup/dmem.c               |  98 ++++++++++++++++
 6 files changed, 376 insertions(+), 46 deletions(-)
=2D--
base-commit: 7296004bd2ceb1284fb557399f0134361f8e34af
change-id: 20250915-dmemcg-aggressive-protect-5cf37f717cdb

Best regards,
=2D- =20
Natalie Vock <natalie.vock@gmx.de>

