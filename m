Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005AE3921CE;
	Tue,  1 Sep 2026 01:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788225827; cv=none; b=s4Ro612nELyFpl5bPBqkutilXKPVMCOCW0Efe+1ZaYelZ1XpB3wn3/KMFmOsc5Vc2YfxoCPFMkVzq2aSu3yzkHLLLe7q6OdBDb8MtIlWm43DNyuYrNKKQxmHtUZ/UZVzn/lJr4uouruzjno5ZnHtoXH9eQhrLt7rO6tg+HK/Jdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788225827; c=relaxed/simple;
	bh=jvL8s4sRjuHKostLJ5wltrklxxOsv6ymzdGE1Jx0d8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=APVfVJirQ+KiVU2c67/ta1yPpdlOOJJp16Wip3IWER/6Qnx9j2yTKLWeunpvNrewvCOHd+P8wSs1yayNVz3dycBR050X+owirhJ+ax/Wf2k4Gd31XbdWAVQ7LBzrOVDEvM2dCdzbbmA+NPdCFW3v5BRv8Z3RgkXk/wIEgoUlCVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gUKKIDLB; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gUKKIDLB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788225826; x=1819761826;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jvL8s4sRjuHKostLJ5wltrklxxOsv6ymzdGE1Jx0d8U=;
  b=gUKKIDLBzEPH/pcBThdenheULofysbuS0V0STj2+KTCyxFrQ6AKVlyN2
   K6Kl4yU3ZhC5FuM2G45Rjht0viXA62xzqSUSXL6f+rDQ4vQJu6jkXiVOd
   fNAIGfrXdCPujSe4I44MmArJM1jTMu/CmlKB8yttkFEvO2fghZMHr07q0
   wv8hwLi6wPEKTfr/MQR7A084d/tUTLl9G64gidN3PxdAIgGxfVsxGJ3BN
   mivM28NSBLL4vjJ65hOhJY6j06TUMfLul94NeW1o9F/3SYdacYItdehJz
   UB4MQnatAvVnszeH9YNjd7G5YSkO2lQ7IZgRg/i1aYIgrmIjuEHBA96us
   g==;
X-CSE-ConnectionGUID: hK3RV5lGSNqX9oBTGCSCZA==
X-CSE-MsgGUID: IQFxeENPSFq35+H9qQCXqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="76190678"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="76190678"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 18:23:45 -0700
X-CSE-ConnectionGUID: aplSqfJuQoeJ0IH9cB/tXg==
X-CSE-MsgGUID: IypmSCzZQv+5Yb2qGacs4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="272730977"
Received: from tester.sh.intel.com ([10.112.106.126])
  by orviesa004.jf.intel.com with ESMTP; 31 Aug 2026 18:23:43 -0700
From: Tao Yu <tao1.yu@intel.com>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Yu <tao1.yu@intel.com>,
	syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com
Subject: [PATCH] cgroup: reject controller re-enable while css teardown is pending
Date: Tue,  1 Sep 2026 09:23:42 +0800
Message-Id: <20260901012342.855056-1-tao1.yu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Writing cgroup.subtree_control currently calls cgroup_kn_lock_live() with
drain_offline=true and can therefore block in cgroup_lock_and_drain_offline()
before taking cgroup_mutex.

After 1dffd95575eb ("cgroup: Defer kill_css_finish() in
cgroup_apply_control_disable()"), disabling a controller can leave CSS_DYING
csses behind until the subtree is fully drained. If userspace re-enables a
controller before that teardown completes, the write path may wait
indefinitely from kernfs context. syzbot reported this as hung tasks stuck in
cgroup_subtree_control_write().

The write side does not need to synchronously drain all pending teardowns. It
only needs to avoid reusing controller state whose css teardown is still in
flight. Blocking the user-visible write path in TASK_UNINTERRUPTIBLE is the
wrong tradeoff here.

Stop draining offline csses from subtree_control and cgroup.type writes.
Instead, reject the operation with -EBUSY if it would reuse a subsystem which
still has dying csses in the target subtree. Limit the subtree_control check
to controllers being newly enabled, and use the current subtree controller
mask for cgroup.type because threaded conversion re-applies that state.

This preserves the asynchronous teardown model, avoids hung writers in D
state, and keeps the rejection scoped to the controllers that are actually
racing with teardown.

Fixes: 1dffd95575eb ("cgroup: Defer kill_css_finish() in cgroup_apply_control_disable()")
Reported-by: syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb2e19a1190a556c01b1
Signed-off-by: Tao Yu <tao1.yu@intel.com>
---
 kernel/cgroup/cgroup.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c3a12fee7528f..129a9b0752416 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3356,6 +3356,20 @@ void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 	}
 }
 
+static bool cgroup_has_dying_csses(struct cgroup *cgrp, u32 ss_mask)
+{
+	int ssid;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	for (ssid = 0; ssid < CGROUP_SUBSYS_COUNT; ssid++) {
+		if ((ss_mask & (1 << ssid)) && cgrp->nr_dying_subsys[ssid])
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * cgroup_save_control - save control masks and dom_cgrp of a subtree
  * @cgrp: root of the target subtree
@@ -3649,7 +3663,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			return -EINVAL;
 	}
 
-	cgrp = cgroup_kn_lock_live(of->kn, true);
+	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
 
@@ -3689,6 +3703,17 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * Disabled controllers are offlined asynchronously. Don't sleep here
+	 * waiting for them to drain while holding the kernfs write context.
+	 * Report the in-flight teardown and let userspace retry once the dying
+	 * csses have gone away.
+	 */
+	if (enable && cgroup_has_dying_csses(cgrp, enable)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	/* save and update control masks and prepare csses */
 	cgroup_save_control(cgrp);
 
@@ -3788,14 +3813,23 @@ static ssize_t cgroup_type_write(struct kernfs_open_file *of, char *buf,
 	if (strcmp(strstrip(buf), "threaded"))
 		return -EINVAL;
 
-	/* drain dying csses before we re-apply (threaded) subtree control */
-	cgrp = cgroup_kn_lock_live(of->kn, true);
+	/*
+	 * Threaded conversion re-applies subtree control, so reject it while a
+	 * prior controller disable is still offlining csses in the subtree.
+	 */
+	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENOENT;
 
+	if (cgroup_has_dying_csses(cgrp, cgrp->subtree_ss_mask)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	/* threaded can only be enabled */
 	ret = cgroup_enable_threaded(cgrp);
 
+out_unlock:
 	cgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;
 }
-- 
2.34.1

