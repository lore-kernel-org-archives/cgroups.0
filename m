Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0681F4CB3
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 11:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721227; cv=none; b=US7cI9UFWKJQq4IAqvlxIa6gu45cDpEq8egR/zSLnzAsso7RclAucSfJHJL9gfgxljWENgxaGEuIjqzQvvOPN0l5zU4d8Vns/zhYDJXvIExuF0X69VQS5In9XTs8L5amqDhwXRgcBZrpvrejpNC1SyBaYltK7F4IwxHIpVeHOik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721227; c=relaxed/simple;
	bh=iYMs7RNngqDNLdKkal1IsjhamRHp5KypEY/HBt/A8fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrZ8JlD7G3WxiBiXVJsFnE5ZqT1pTy8w0xcWrUzjIUkSWxsHqXoi7m6VcMmSPgyx58bfNQwb9x0/5Ma6tZCuIGsIPp5wowxM9BNpwhfnzmCett30Kql914SyUlyFLUP8n5VNurkIumLK2e4kBq7HRwUUrzHg/W9uaTdLY89VuDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lqLuVUGD; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lqLuVUGD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784721223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKx6H9tY68FCqpiKdD6mzmMC28uWm7YjX5IgYP0hdK8=;
	b=lqLuVUGDGJdaeyqm8zzweWV/LAopemMjdL9q0mQjYYELPkepJGJt270f7fN6KB1SM8O+0v
	60vEdDHmuHHaWkERk2fJK+9XNglSRAKZopL99xM0Gp7qnvp1Nnf/OS8e+tMnWTRmX/Iemo
	msCsX9koTeT5FZ1hQtK31Xw0JNN3L00=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [RFC PATCH 3/3] sched/topology: Tear down domains without active domain housekeeping CPUs
Date: Wed, 22 Jul 2026 19:52:38 +0800
Message-ID: <20260722115238.351821-4-guopeng.zhang@linux.dev>
In-Reply-To: <20260722115238.351821-1-guopeng.zhang@linux.dev>
References: <20260722115238.351821-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

During suspend, freeze_secondary_cpus() takes every CPU except the primary
offline. If the primary CPU is excluded from HK_TYPE_DOMAIN, offlining the
last domain housekeeping CPU leaves no active CPU from which to build the
fallback scheduler domain.

The frozen CPU-hotplug callback nevertheless requests one domain by
passing a non-zero domain count with a NULL domain array.
partition_sched_domains_locked() then constructs the fallback span from
cpu_active_mask and housekeeping_cpumask(HK_TYPE_DOMAIN), which is empty.
build_sched_domains() warns about the empty span, followed by a general
protection fault in build_perf_domains().

Make cpuset_reset_sched_domains(), including its !CONFIG_CPUSETS stub,
request zero domains when no active HK_TYPE_DOMAIN CPU remains.
Distinguish that explicit zero-domain request from a non-zero request with
a NULL domain array, for which the existing fallback-domain behavior must
be retained.

Fixes: d35be8bab9b0 ("CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/resume")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 include/linux/cpuset.h  | 7 ++++++-
 kernel/cgroup/cpuset.c  | 6 +++++-
 kernel/sched/topology.c | 9 ++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a67ba1b32d16..461ba4876a8e 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -10,6 +10,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/isolation.h>
 #include <linux/sched/topology.h>
 #include <linux/sched/task.h>
 #include <linux/cpumask.h>
@@ -284,7 +285,11 @@ static inline void rebuild_sched_domains(void)
 
 static inline void cpuset_reset_sched_domains(void)
 {
-	partition_sched_domains(1, NULL, NULL);
+	if (cpumask_intersects(cpu_active_mask,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN)))
+		partition_sched_domains(1, NULL, NULL);
+	else
+		partition_sched_domains(0, NULL, NULL);
 }
 
 static inline void cpuset_print_current_mems_allowed(void)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 03e82d6026f5..1e66723e01b4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1076,7 +1076,11 @@ void rebuild_sched_domains(void)
 void cpuset_reset_sched_domains(void)
 {
 	mutex_lock(&cpuset_mutex);
-	partition_sched_domains(1, NULL, NULL);
+	if (cpumask_intersects(cpu_active_mask,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN)))
+		partition_sched_domains(1, NULL, NULL);
+	else
+		partition_sched_domains(0, NULL, NULL);
 	mutex_unlock(&cpuset_mutex);
 }
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 622e2e01974c..e8d34cb1ed84 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3365,9 +3365,8 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * and partition_sched_domains() will fallback to the single partition
  * 'fallback_doms', it also forces the domains to be rebuilt.
  *
- * If doms_new == NULL it will be replaced with cpu_online_mask.
- * ndoms_new == 0 is a special case for destroying existing domains,
- * and it will not create the default domain.
+ * ndoms_new == 0 and doms_new == NULL is a special case for destroying
+ * existing domains, and it will not create the default domain.
  *
  * Call with hotplug lock and sched_domains_mutex held
  */
@@ -3387,7 +3386,7 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 	if (new_topology)
 		asym_cpu_capacity_scan();
 
-	if (!doms_new) {
+	if (ndoms_new && !doms_new) {
 		WARN_ON_ONCE(dattr_new);
 		n = 0;
 		doms_new = alloc_sched_domains(1);
@@ -3414,7 +3413,7 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 	}
 
 	n = ndoms_cur;
-	if (!doms_new) {
+	if (ndoms_new && !doms_new) {
 		n = 0;
 		doms_new = &fallback_doms;
 		cpumask_and(doms_new[0], cpu_active_mask,
-- 
2.43.0

