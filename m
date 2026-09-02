Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD60A4483A2
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 10:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344835; cv=none; b=IAzKUl2IENBPjSKkYoqqYF7YRUGdeuB8CaOtJYgPGhqE3ALZawCAKkFbm4y5CW75rQAqhJmVwn7x4rcLmBIYrtdjkAZB9EVlPd3vKIZvc1Jarm4Ebe00NxqpFCIFc5aPs1j/kAFiPvYUg6HuO+YyMrRLg+ltzLTRluobw0iq8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344835; c=relaxed/simple;
	bh=+0zvnt4F50BkbJRzuovmFvfMHcY1XlEE3MUtbFEME9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLKRlaHhljJR7tlDX0bfylhnyjefHlo8yhbxYR9WyXaZ7AHRlBr3sZnR5GaQzLu5z7E8Ufwt967lGqpOFs1Sd4QcoBboFcSako2RgA+FmHmKgAX4RxdwTEvAqY6/a1b1/Lyu2+Y2wbyqwm7wttuNuR9Bfn3u8esrXMdUDao1Csg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ecb8Gaws; arc=none smtp.client-ip=91.218.175.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ecb8Gaws"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+0zvnt4F50BkbJRzuovmFvfMHcY1XlEE3MUtbFEME9I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788344827; v=1; x=1788949627;
 b=Ecb8GawsHAdDxiR2kluHMiWRyiOq9wGoMQ1E/BPPZFa3OMXOltgN+t1dIF/RVfuq0OrYFzS4
 YKoIaqoXc4ctRojGLvt5fgaZbSbbm1PaxjUnBLPgKsX+gc9SRzrwvOXSg+x1BwQZQs9WtePabl9
 xQQh0P/kOUNe1daOAGzCc0Gc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8e989ec727cfae15;
	Wed, 02 Sep 2026 10:27:07 +0000
X-Mizu-Trace-ID: 8e989ec727cfae15
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: cgroups@vger.kernel.org,
	longman@redhat.com,
	ridong.chen@linux.dev
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 6/7] cgroup/cpuset: Release CPUs when type-change validation fails
Date: Wed,  2 Sep 2026 18:26:14 +0800
Message-ID: <20260902102615.79189-7-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902102615.79189-1-guopeng.zhang@linux.dev>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
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
index 19efa62bb694..30d9ea5f3859 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3042,6 +3042,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *invalidated = NULL;
 	struct cpumask *isolcpus_update_cpus = cs->effective_xcpus;
 	struct tmpmasks tmpmask;
+	bool disable_partition = false;
 	bool isolcpus_updated = false;
 
 	if (old_prs == new_prs)
@@ -3107,6 +3108,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
 		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
 			err = PERR_HKEEPING;
+			disable_partition = true;
 		} else {
 			/*
 			 * Only directly owned CPUs change isolation state for a
@@ -3122,6 +3124,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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

