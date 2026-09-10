Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FCB3D45E5
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033612; cv=none; b=YcofJr0DzvbVEptD7m66h53NcRUwJjYCGTyCNFr5jNtmKh6fwnNhGhNF5oag8iEpuv2PLsFe55gnzoe3ApzAsHx4v9a747cIUTKX4/9QGEcJ3AHbdcNSNvP8U97BfgyEIoWziU6wgn5vg8Bl4AVI1h/B0rPvudA2qhlJid32qxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033612; c=relaxed/simple;
	bh=Pwm1u3+lX/pmOZ9lXdY5RK0JV39zkhvnKlA3b/Gza+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldl1R3/m0KhT4johrpmh38M7A4oCb0EXnK7ut/8uUQetTLH6hmBDceIjq/1WrRfJhlo46u5Pxn/60D6vHIcy4j+0o4OeZZVsEvsWHPgWkEg8bwXtsHqsiDDzIU6heql1hahTI9h1Hl7kF3d1EreJmJ3nR0lOAiZRJUbRomVRvuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZBGpIZN1; arc=none smtp.client-ip=91.218.175.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZBGpIZN1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Pwm1u3+lX/pmOZ9lXdY5RK0JV39zkhvnKlA3b/Gza+I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033603; v=1; x=1789638403;
 b=ZBGpIZN1yT7pLZRbiectZfteDBI7F140PciDUyQx3SDw2hcdvI1vPIXXHWEb7pIm8yfnVHsM
 jGqEBFmn4dISqiufhUHn/ADg/7EUOszd/4ZuFOw3mT6vnBSceuEICtofKwsdUQiwgZ+Nh+iA3o7
 7lQGeTh+siQshaUu/+8kLkeE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id be5942a5d437b643;
	Thu, 10 Sep 2026 09:46:43 +0000
X-Mizu-Trace-ID: be5942a5d437b643
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v4 3/7] cgroup/cpuset: Release CPUs when type-change validation fails
Date: Thu, 10 Sep 2026 17:45:42 +0800
Message-ID: <20260910094546.5852-4-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910094546.5852-1-guopeng.zhang@linux.dev>
References: <20260910094546.5852-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

When housekeeping validation fails during a root/isolated type change,
update_prstate() marks the requested state invalid without running the
partition-disable path. The failed partition's effective_xcpus may be
cleared, but its CPUs remain unavailable to the partition which owns the
invalidated subtree.

This can be reproduced on a cgroup v2 system booted with
isolcpus=domain,15:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir type-fail-repro
    echo 15 > type-fail-repro/cpuset.cpus
    echo isolated > type-fail-repro/cpuset.cpus.partition
    echo root > type-fail-repro/cpuset.cpus.partition
    cat type-fail-repro/cpuset.cpus.partition
    cat cpuset.cpus.effective

The requested root state is recorded as invalid, but CPU 15 remains
unavailable to the top cpuset.

Run the common partition-disable path when housekeeping validation fails.
Disable remote partitions with remote_partition_disable() and return local
partition CPUs to their parent. If that would consume the last housekeeping
CPU, invalidate the outermost isolated ancestor instead.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 994ddb79272d..7e8b167a29ed 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3050,6 +3050,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *invalidated = NULL;
 	struct cpumask *isolcpus_update_cpus = cs->effective_xcpus;
 	struct tmpmasks tmpmask;
+	bool disable_partition = false;
 	bool isolcpus_updated = false;
 
 	if (old_prs == new_prs)
@@ -3115,6 +3116,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
 		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
 			err = PERR_HKEEPING;
+			disable_partition = true;
 		} else {
 			/*
 			 * Only directly owned CPUs change isolation state for a
@@ -3130,6 +3132,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * parent would consume the last housekeeping CPU, invalidate
 		 * the outermost isolated ancestor and return its CPUs instead.
 		 */
+		disable_partition = true;
+	}
+
+	if (disable_partition) {
 		if (old_prs == PRS_ROOT &&
 		    parent->partition_root_state == PRS_ISOLATED &&
 		    !isolated_cpus_can_update(cs->effective_xcpus, NULL))
-- 
2.43.0

