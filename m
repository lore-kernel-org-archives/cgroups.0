Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7564538DC71;
	Mon, 31 Aug 2026 05:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788155842; cv=none; b=fqfGcheXVBGvgaobRGGBEjCCYrBiJPxXlGV0w7tX1jbrwI2IVL/6WWGKlWxI27xF8ArBEG4NYlcut/WRnoOu6EfvUvhZxp1coCxtuBHBWiLo8iGAbsZyYFj6wywKaZrWIsRGcUybt7EbiJhNZWneqk/VgNm8GKQ32FbBqygzUkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788155842; c=relaxed/simple;
	bh=cKK22JY6o1/GYcTB1hR0UNrqPfLsqQak1zI8LrKAR0U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n1QCMo0/etnKGPNpxiItcEAU16AaPY9UCzYoLJH6Dlffx/dfN9A7xoWy8itc2MZmMGazYWynR7oqe/2vUMNJV2m0urkyLilqvQhwdSx3oypbm6oHZz2AyMlSIZIelmlu68ik7lu5hkJrU4LNzNkOcDipkaHFj7j7lHKTGeyazJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCXihJmR; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCXihJmR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788155841; x=1819691841;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cKK22JY6o1/GYcTB1hR0UNrqPfLsqQak1zI8LrKAR0U=;
  b=HCXihJmRAiP1G++VffMiBLgyA1Fp9yjkQsOyaOWUjU3UmHIeDPnw6nOB
   RbUBU1sj+yaIY5x95nuWgGZ+gFsw7taPT2awtcvb0VKvAUAZcHVwsCxgK
   Cj3AhI+Dhnx9BOph1EujU126+r5SdkGbQ8DVPrxPF4wjWS6R/cczFz1ZB
   5lg2FmqYT6X6uoI+Izk+UyZkcorgBmpr/iSURJMZOq+RAM9hS/2qtAtSY
   mqneqZppoE4r5bQXFZS/DnUrIDKpgSRGmFY9cUtbQPjKmQ9y+qI5ZCRUN
   2z7evwRW7qJFtfrFSfQGG0qKIxmlwAXFXTOl3JnFLSoeBtCvKBn+ebDVo
   w==;
X-CSE-ConnectionGUID: PaIF3/EMTZKgw07/2RuzDw==
X-CSE-MsgGUID: nAyX0XeAR2i6ZbCdLzyjDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="87685507"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="87685507"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 22:57:20 -0700
X-CSE-ConnectionGUID: LfU/4KPFS1y5kPly/KzuDg==
X-CSE-MsgGUID: G8hsJwG+QAG/YwLNFozcZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="266127689"
Received: from tester.sh.intel.com ([10.112.106.126])
  by fmviesa008.fm.intel.com with ESMTP; 30 Aug 2026 22:57:17 -0700
From: Tao Yu <tao1.yu@intel.com>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Yu <tao1.yu@intel.com>,
	syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] blk-cgroup: use GFP_NOIO for radix tree preload in blkg_conf_prep
Date: Mon, 31 Aug 2026 13:57:16 +0800
Message-Id: <20260831055716.773354-1-tao1.yu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blkg_conf_prep() allocates a new blkg with GFP_NOIO after dropping
queue_lock, but still preloads the radix tree node with GFP_KERNEL while
q->blkcg_mutex is held.

GFP_KERNEL may enter direct reclaim and acquire fs_reclaim, which adds
the dependency

  q->blkcg_mutex -> fs_reclaim

This completes a circular locking dependency with the existing path

  fs_reclaim -> q->q_usage_counter -> q->blkcg_mutex

and triggers a lockdep warning when configuring blkcg policies.

Use GFP_NOIO for radix_tree_preload() so that the preload context matches
the rest of this allocation path and does not recurse into reclaim while
q->blkcg_mutex is held.

Reported-by: syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=144a1c0e22e53a08ef5a
Fixes: f255c19b3ab46 ("blk-cgroup: Pre-allocate tree node on blkg_conf_prep")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Yu <tao1.yu@intel.com>
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2b5c29434e426..27e00180e4cc1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -873,7 +873,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			parent = blkcg_parent(parent);
 		}
 
-		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
+		/* Drop queue_lock to do new blkg allocation with GFP_NOIO. */
 		spin_unlock_irq(&q->queue_lock);
 
 		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
@@ -882,7 +882,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail_exit;
 		}
 
-		if (radix_tree_preload(GFP_KERNEL)) {
+		if (radix_tree_preload(GFP_NOIO)) {
 			blkg_free(new_blkg);
 			ret = -ENOMEM;
 			goto fail_exit;
-- 
2.34.1

