Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB68443E53
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229758; cv=none; b=o0fx3DJsD3mH2KtmNuRCxMVDlS5T2eaLU80cryIELF4rta/7t6GsndUA7J1RGic6CuHG2126zTSLpAvdxLFBNV+eBEk6ZuqOfUhVKTASIVG2XEOpQkuV1ZQLFknCwXOxEHkP7OvvlNcoecmreDlPxuHnvY+ecwkawzKzs8ZduLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229758; c=relaxed/simple;
	bh=oFZgfIMHevFj2+IBJHSs6dHXo5XbyNHl4nAKqNst6ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvPiFwTl51b0yCKKnKq20X4N5tlFpTmuU+qqgWZfgaidw5GarMs4c1qIQ08IzhVPZSXqjsz2MnShGnfulltYoAihGLQDfXJiepTtWeDH04cwFRwdF78SOpSpyFj6NgVg7xGg0ujNz3RpZMpg+lNIHbYpjYE9LYhIP/rqkW4TH2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ie/9Qw2B; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ie/9Qw2B"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oFZgfIMHevFj2+IBJHSs6dHXo5XbyNHl4nAKqNst6ug=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229754; v=1; x=1787834554;
 b=Ie/9Qw2Budo1m8OcowcXyg9PoqHauwxldP/Z384d61wMt767dIcUFQRiS5/AXgnCMVgTUf3r
 wn5wYqb7A2MYwZnRJMf77B9v4aQU8x1qsBWvlLk9SThJJJUA8g+PSDr4c9qYfUSjN6diwAevAUH
 j/B5nnwk0kHdL6WUW3RacIWg=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 0f29dd2d16ed27f9;
	Thu, 20 Aug 2026 12:42:34 +0000
X-Mizu-Trace-ID: 0f29dd2d16ed27f9
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 04/17] cgroup/cpuset: Limit type-change accounting to owned CPUs
Date: Thu, 20 Aug 2026 20:41:49 +0800
Message-ID: <20260820124202.517160-5-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

effective_xcpus includes CPUs granted to valid child partitions. Passing
the whole mask to isolated_cpus_update() during a root-to-isolated or
isolated-to-root change applies the parent's new state to child-owned
CPUs as well.

Build a mask of CPUs owned by the partition by subtracting the
effective_xcpus of valid children. Use this mask when updating
isolated_cpus for a partition type change.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2538faac9aba..468272baadb2 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2155,6 +2155,30 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	rcu_read_unlock();
 }
 
+/*
+ * Compute CPUs owned directly by a partition.
+ *
+ * effective_xcpus includes CPUs granted to valid child partitions. Exclude
+ * those CPUs when changing only this partition's type.
+ */
+static void compute_partition_owned_cpumask(struct cpuset *cs,
+					    struct cpumask *owned_cpus)
+{
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+
+	lockdep_assert_held(&cpuset_mutex);
+	cpumask_copy(owned_cpus, cs->effective_xcpus);
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, cs) {
+		if (is_partition_valid(child))
+			cpumask_andnot(owned_cpus, owned_cpus,
+				       child->effective_xcpus);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2990,8 +3014,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	} else if (old_prs && new_prs) {
 		/*
 		 * A change in load balance state only, no change in cpumasks.
-		 * Need to update isolated_cpus.
+		 * Need to update isolated_cpus for CPUs owned by this partition,
+		 * excluding CPUs distributed to valid child partitions.
 		 */
+		compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
 		if (((new_prs == PRS_ISOLATED) &&
 		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
 		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
@@ -3030,7 +3056,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (!is_partition_valid(cs))
 		reset_partition_data(cs);
 	else if (isolcpus_updated)
-		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
+		isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
 	spin_unlock_irq(&callback_lock);
 
 	/* Force update if switching back to member & update effective_xcpus */
-- 
2.43.0

