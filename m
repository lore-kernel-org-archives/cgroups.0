Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE23B27D6
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355817; cv=none; b=t0qa7mhT3Yi9oYBvluojWWHL63kMlH+nHiVnB4EyTamHUHlPQbtlfc0YKqjgAtaAWUE/aw9Z29RVw6Kk/YoZ/4imeby78CjSSkuRaQ7XcleOrMdGxZ8h/BSxfYys8SF75g+ePk7o5ORhwvRMk4JrGuUjWICYlsasomVlHj5M0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355817; c=relaxed/simple;
	bh=N98Glw7fzm+si6a/JEfOpfgOIRv6Hi/ePenpOsg3CJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jbt20XYCvr2r8D0zWXomMDJHIm6XWBe2cpMKkpyZ9jdLrus/aCPjLIjqdkJOA2X4d5tCfRG4/XQ0/8y9HP+nqbD5HekOJqRYDBhFl+PqvwNsJhkxSyKyk6MiQ7hAW8pd2eEix4QYOTwxTnAsRJ6JsEs6I+iCcr8rjlnBqHK0TcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jsTnHhJc; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jsTnHhJc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786355813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sIUdxZwJbsMGly/QpWlxTdxLz5Bu0i7T/uXcG2nnb2Y=;
	b=jsTnHhJcAmnsjrP0OP+HJOoteyIOFLfN8kJ7tMqYesX7YcyJ8s9k9QT9oDkiK4MDTvjtnf
	U280FwGwZYf+69BrnL3lyxgxUjmyzVn85rkzbDNXIXivtk6vANJBP1MH/IwBhJTIao//bx
	shcGWMy8Rm9RVDr4YTkPY5A4QCbua18=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	ridong.chen@linux.dev,
	cgroups@vger.kernel.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] cgroup/cpuset: Use WRITE_ONCE() for shared prs_err updates
Date: Mon, 10 Aug 2026 17:55:59 +0800
Message-ID: <20260810095559.77345-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

cpuset_partition_show() reads cs->prs_err without cpuset_mutex using
READ_ONCE(). The field is documented as not lock protected, but several
updates to live cpusets still use plain stores.

Convert the remaining prs_err stores on live cpusets to WRITE_ONCE().

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Assisted-by: LLM
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0a0fffb5673c..2f7faa795664 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1587,7 +1587,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
 	spin_unlock_irq(&callback_lock);
 	cpuset_force_rebuild();
-	cs->prs_err = 0;
+	WRITE_ONCE(cs->prs_err, 0);
 
 	/*
 	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
@@ -1661,7 +1661,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
 
 	if (cpumask_empty(excpus)) {
-		cs->prs_err = PERR_CPUSEMPTY;
+		WRITE_ONCE(cs->prs_err, PERR_CPUSEMPTY);
 		goto invalidate;
 	}
 
@@ -1676,13 +1676,13 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	if (adding) {
 		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
 		if (!capable(CAP_SYS_ADMIN))
-			cs->prs_err = PERR_ACCESS;
+			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
-			cs->prs_err = PERR_NOCPUS;
+			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
 		else if ((prs == PRS_ISOLATED) &&
 			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
-			cs->prs_err = PERR_HKEEPING;
+			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -2110,13 +2110,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 * partition root.
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
-		child->prs_err = 0;
+		WRITE_ONCE(child->prs_err, 0);
 		if (!cpumask_subset(child->effective_xcpus,
 				    cs->effective_xcpus))
-			child->prs_err = PERR_INVCPUS;
+			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
 		else if (populated &&
 			 cpumask_subset(new_ecpus, child->effective_xcpus))
-			child->prs_err = PERR_NOCPUS;
+			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
 
 		if (child->prs_err) {
 			int old_prs = child->partition_root_state;
@@ -2420,8 +2420,10 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
-	if (prs_err)
-		trialcs->prs_err = cs->prs_err = prs_err;
+	if (prs_err) {
+		WRITE_ONCE(cs->prs_err, prs_err);
+		trialcs->prs_err = prs_err;
+	}
 
 	if (is_remote_partition(cs)) {
 		if (trialcs->prs_err)
@@ -3944,7 +3946,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (remote && (cpumask_empty(subpartitions_cpus) ||
 			(cpumask_empty(&new_cpus) &&
 			 partition_is_populated(cs, NULL)))) {
-		cs->prs_err = PERR_HOTPLUG;
+		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
 		remote = false;
-- 
2.43.0

