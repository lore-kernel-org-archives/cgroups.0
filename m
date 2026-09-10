Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937623C3F56
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033645; cv=none; b=gLhW/zE9O09ciEsFXZw7s4GzcBtQTWhPIp3LWLMGvHv7coqtDKQ8GUf3oD4jUTW0vUxMob1pugw+stgMQNflyV617A6DJrQfMIKyu2vXTiuuGtLVK8LMlC3szyJUVfKII9rGRxe0gQqJZP4NlxFSfXtCiNeGz0dDdSMiKjsIMog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033645; c=relaxed/simple;
	bh=HolPMd8/7+8zon78gTwvmMPvfZlvri2GRivOncH46xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YberMz8aYMJIxqZxf2sazKFLEoHmqn2qhfqEZX8GQqpNG9CbAMmGFaYjZwk7xif7vSTyCFiDSJVyfjfLik/HGY6wjAoPYzQCbVVpdBTejlu7Tqap9BjQ/bbegCfoejMWom1LMVU35uORiCs1Q1NmKQCkiflTN5H0fOc1ein1x2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iPEhwuL0; arc=none smtp.client-ip=95.215.58.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iPEhwuL0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HolPMd8/7+8zon78gTwvmMPvfZlvri2GRivOncH46xI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033638; v=1; x=1789638438;
 b=iPEhwuL0bcM/pn0RHtXKiIZtCCEqE4DrFIabYllKx/zCPdxZNxQ2XlEkZC/JEBzg3jS4Nivh
 JRp9Gx9JLPyX51aI1IpuMcygDi3SX8ljsvpJeLUOn0bVwuHPtAcl89uYz7QcuTC4MXV8CKvpZoV
 49liJKoozG8Q2YNYJ7hF1uiI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d8f0ac91ae137753;
	Thu, 10 Sep 2026 09:47:18 +0000
X-Mizu-Trace-ID: d8f0ac91ae137753
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
Subject: [PATCH v4 7/7] cgroup/cpuset: Publish exclusive_cpus before partition updates
Date: Thu, 10 Sep 2026 17:45:46 +0800
Message-ID: <20260910094546.5852-8-guopeng.zhang@linux.dev>
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

update_exclusive_cpumask() calls partition_cpus_change() before publishing
the new exclusive_cpus mask. When an invalid partition is recovered,
update_parent_effective_cpumask() therefore gets the old mask from
user_xcpus(). If that mask contains only offline CPUs and the partition is
populated, the valid replacement is rejected with PERR_NOCPUS.

This can be reproduced on a cgroup v2 system with CPUs 1-4 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir exclusive-repro
    echo 1-4 > exclusive-repro/cpuset.cpus
    echo isolated > exclusive-repro/cpuset.cpus.partition
    echo +cpuset > exclusive-repro/cgroup.subtree_control
    mkdir exclusive-repro/child
    echo 4 > exclusive-repro/child/cpuset.cpus.exclusive
    echo isolated > exclusive-repro/child/cpuset.cpus.partition
    sleep 1000 & task=$!
    echo $task > exclusive-repro/child/cgroup.procs
    echo 0 > /sys/devices/system/cpu/cpu4/online
    echo 3 > exclusive-repro/child/cpuset.cpus.exclusive
    cat exclusive-repro/child/cpuset.cpus.partition
    echo 1 > /sys/devices/system/cpu/cpu4/online
    kill $task

Without this fix, the child remains invalid after CPU 3 is written because
the recovery path still validates the old CPU 4 mask.

Publish exclusive_cpus after all fallible preparation and before
partition_cpus_change(), as update_cpumask() already does for cpus_allowed.
Keep effective_xcpus unchanged until the partition update has computed the
old-to-new difference.

Fixes: c49b5e89c45f ("cpuset: use partition_cpus_change for setting exclusive cpus")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 80a709bfa4b7..94c56ec8d4f8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2690,10 +2690,18 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		return -ENOMEM;
 
 	trialcs->prs_err = PERR_NONE;
-	partition_cpus_change(cs, trialcs, &tmp);
 
+	/*
+	 * partition_cpus_change() may inspect user_xcpus(cs). Publish the
+	 * configured mask that was used to compute trialcs->effective_xcpus.
+	 */
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
+	spin_unlock_irq(&callback_lock);
+
+	partition_cpus_change(cs, trialcs, &tmp);
+
+	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
 	if ((old_prs > 0) && !is_partition_valid(cs))
 		reset_partition_data(cs);
-- 
2.43.0

