Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DAD31987D
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372508; cv=none; b=rIqfpGmjnl/i0g8/Df3RQ67y7tiWSL55GJ/gqCNTdO2QhDTz/nKvTdYziDPHjste91M0jqCDbz97CQuHXJ4KFJBudNH099/BUbAd7GkobZCU8J2pw4dK/7fnPi31delXtfqt/uMDIFSiz1aQWXYRCQ7JrbDOZkHEqpfdcWX5U6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372508; c=relaxed/simple;
	bh=ru9AyQml89ubvjxNWG3nugDbKBkJdvTeFYmPZp+7aIs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD715Z2XWSCApDcqxIVjcAIXE5o4yQ6JkO6ooWFLJ3WFHTwylGL92Jeut28CpUoNoqvz9MOxy92YhaC9ADxZ8tG2QrwGFlifQNLLQAf1Is5cnuqRgjqM5JIgLpq85DwLwWfDgQ+2p9v+ST2vgMasFfSZSFd3kPo1jf4lFX36b/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=hBmTOk/1; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="hBmTOk/1"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eabf7d5bbeso1054353e0c.1
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 18:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372502; x=1792977302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oOMQVB/jXsWsIeoiodYZ/B+RDWxFCBllXDVeS82fgVc=;
        b=hBmTOk/1vpAFkX/6UjQUW24qu+vD8RAqqaPCUIC2L17vJHvVjMlhWKvtGB57x8Dtje
         2gzzYJW/w7QDZqwFPeVXfml5wREb7QYjka+qk2MB1/FVTuNvE2xbNj3eQxGNzuoatiWd
         52tlH11NX577qSM6DXwfjDyFDdIAZtGk0LWeoEyCD6GGF/xOlxkymMWnFc0UYnf7ulac
         H4tzzHSp0KDbSBme87XXdOD31+OuljAI8IlZy+mxEpowYUOJlrP2+qB/ZvON7O9Lt0mu
         R+TO3B7D4TiFOXZKNiFuyKh/i85J8SyvhjfKkjmzy9hJ4WwEzAyYoWLw0gdrsNtdVFbk
         UKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372502; x=1792977302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oOMQVB/jXsWsIeoiodYZ/B+RDWxFCBllXDVeS82fgVc=;
        b=I4+Khp1VZ7wCZxJdtab8WSnOVnMwWVKWpYDQ/qIYKFvQI/XgM1QgF3M47Nie95Ilai
         gh4xbc5WdVMD3Jppkx+y7wpKhexiI3CN2eNpoxy4toazEjnjEWgSj7gYCIztiqfXGK7Y
         Ytoilmgo1nRuvQvywekX52icWv5Xcjg8QQcnwS9kFN1Ojwo3UrxxNZEMHrMhk3ryfXbK
         GZHHAXLyDfBjcaVZ4Me5Ll+77y8YG5l5z2jgDN+Z9qyU2Wlqt6UzTOOd9XaFnMz9K1RY
         rYmFMrZ9jxfNb7v4NkGF9/2BQap2VObJhhvJbkUzMjBeHYXtwGyK0SF3eyuBM7UogeQq
         O/cA==
X-Forwarded-Encrypted: i=1; AKwUvBxwVzEvex7Y2lxRh+CcPN1k0w8kx10qQyanVQzpghrWH6cjcfoRlkcAWOpS+Pq5b5qfJiWp//0b@vger.kernel.org
X-Gm-Message-State: AFq9FYI7JO80AUIJf+yfsBUqKWEN16gX+uCWA/9Qc709cy/6xj4Bs00R
	vTNhxsms9XpH7cnDqXLmgivut0GdVyd+sA2kCoOrXLtncD615d69eK2tFGUnLm2NW2o=
X-Gm-Gg: AYBFou0cVHKt2XxpEUWk77YfL8b1LuboXIQnAgoa1/E5k2y59C4WTCWp/J64PRfCNTW
	JB/DqvkO9b0Y7FYWBPSQhKjBfZCJ7GtflK/9aNCVTcf4nbC2T5DKKFXDkWdrzIR9zOxoavfr9Y1
	6HHvoJpwScfI5QbZ9H3y4kOI3hZdAEGCHtWgVCOHUmWW17nGMRju/tu7+QgK4z/iraSbvRelD3S
	gpIOZvUGTiQ/TFcQmXTZaahfpPD8uKOMQ8SoCseKc3mDfnMoSQrfrEihzZmQNO9U+ZGlcEMITlM
	5H44/H/NLtvvGSm0weY6hmkS5thytAPiRn3mm2C7kOprnTuXj6NFdizRJEy495UP23jyscFJx/l
	3UzJZtnwZKXKPWf8b/DMlEo55YStdlAls6FepzaOQNZ2mK7SlFpfh7JbMxVjt+qBXkrGrwQt/H2
	7FtviQiWnLy33c7hN1hV+MWfCmoRN0RBrbTyVUgldXnqycyYIhZbo9F9CySNnrewr1xRGb6uMxs
	1i7NL/+sjdd41pYwyXQ2ptTDQQboDV9arN0qVZ8hqQIOXG+Y45PAC6FaQillLt5qZtKnJXFPv6B
	dpiHvCh3IYWjTKRZle4=
X-Received: by 2002:a05:6122:78e:b0:5ea:389c:51e4 with SMTP id 71dfb90a1353d-5eaaa0c78fcmr2260825e0c.2.1792372502039;
        Sun, 18 Oct 2026 18:15:02 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:15:01 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 5/8] sched/topology: Avoid redundant O(N^3) group capacity walks and unused allocations in build_sched_domains()
Date: Sun, 18 Oct 2026 21:14:43 -0400
Message-ID: <20261019011446.834487-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During sequential CPU hotplug on large systems, build_sched_domains() is
invoked for every CPU offline and online step. Two bottlenecks in the
domain construction path scale poorly with CPU count:

1. On non-overlapping topology levels, all CPUs sharing a domain span
   share the same circular ring of sched_group instances, and on
   overlapping NUMA levels, groups with identical spans share
   sched_group_capacity (sgc). However, init_sched_groups_capacity()
   walks the entire group ring for every CPU in the domain and repeatedly
   recomputes group_weight, cores (walking the group cpumask and clearing
   cpu_smt_mask), and asym_prefer_cpu (O(N^3) bitmap operations per
   hotplug step). Similarly, init_overlap_sched_group() recomputes
   build_balance_mask() and cpumask_weight(sg_span) even when the shared
   sgc was already initialized.

2. __sdt_alloc() and __sds_alloc() upfront-allocate a sched_group,
   sched_group_capacity, and sched_domain_shared for every CPU in cpu_map
   at every topology level, even though get_group() only uses the entry
   for the first CPU of each child domain and d.sds is only used once per
   LLC (plus at most once per SD_ASYM_CPUCAPACITY_FULL domain). All other
   per-CPU allocations are immediately freed unused by
   __free_domain_allocs().

Cache group_weight, cores, and asym_prefer_cpu on struct
sched_group_capacity so init_sched_groups_capacity() computes them once
per shared group capacity, reuse already-initialized sgc instances in
init_overlap_sched_group(), and allocate sdd->sg, sdd->sgc, and d->sds
lazily on demand.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   9.85 s ->  5.15 s (-47.7%)
  Online:    8.69 s ->  4.05 s (-53.4%)
  Total:    18.54 s ->  9.20 s (-50.4%)
  build_sched_domains() (cpu479 offline / online):
    35.65 ms -> 10.39 ms (-70.9%) / 35.68 ms -> 9.58 ms (-73.2%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   4.51 s ->  3.26 s (-27.7%)
  Online:    3.15 s ->  2.03 s (-35.6%)
  Total:     7.66 s ->  5.29 s (-30.9%)
  build_sched_domains() (cpu511 offline / online):
    11.69 ms -> 5.61 ms (-52.0%) / 12.24 ms -> 5.84 ms (-52.3%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/sched/sched.h    |   9 ++
 kernel/sched/topology.c | 218 ++++++++++++++++++++++++++--------------
 2 files changed, 150 insertions(+), 77 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 499a5649582e..314fcad94668 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2262,6 +2262,15 @@ struct sched_group_capacity {
 
 	int			id;
 
+	/*
+	 * Build-time cache shared by all groups using this sgc while
+	 * build_sched_domains() runs; not maintained afterwards (e.g. by
+	 * sched_update_asym_prefer_cpu()). Use the sched_group copies.
+	 */
+	unsigned int		group_weight;
+	unsigned int		cores;
+	int			asym_prefer_cpu;
+
 	unsigned long		cpumask[];		/* Balance mask */
 };
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 919d0fb00bd9..a5a5d1378ce2 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1207,6 +1207,33 @@ int group_balance_cpu(struct sched_group *sg)
  */
 
 
+/* Find the group_balance_cpu() */
+static int find_group_balance_cpu(struct sched_domain *sd, struct sched_group *sg)
+{
+	const struct cpumask *sg_span = sched_group_span(sg);
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *sibling;
+	int i;
+
+	for_each_cpu(i, sg_span) {
+		sibling = *per_cpu_ptr(sdd->sd, i);
+
+		/*
+		 * Can happen in the asymmetric case, where these siblings are
+		 * unused. The mask will not be empty because those CPUs that
+		 * do have the top domain _should_ span the domain.
+		 */
+		if (!sibling->child)
+			continue;
+
+		/* If we would not end up here, we can't continue from here */
+		if (cpumask_equal(sg_span, sched_domain_span(sibling->child)))
+			return i;
+	}
+
+	return nr_cpu_ids;
+}
+
 /*
  * Build the balance mask; it contains only those CPUs that can arrive at this
  * group and should be considered to continue balancing.
@@ -1216,17 +1243,19 @@ int group_balance_cpu(struct sched_group *sg)
  * can fully construct this using the sched_domain bits (which are already
  * complete).
  */
-static void
-build_balance_mask(struct sched_domain *sd, struct sched_group *sg, struct cpumask *mask)
+static void build_balance_mask(int group_balance_cpu,
+			       struct sched_domain *sd,
+			       struct sched_group *sg,
+			       struct cpumask *mask)
 {
 	const struct cpumask *sg_span = sched_group_span(sg);
 	struct sd_data *sdd = sd->private;
 	struct sched_domain *sibling;
-	int i;
+	int i = group_balance_cpu;
 
 	cpumask_clear(mask);
 
-	for_each_cpu(i, sg_span) {
+	for_each_cpu_from(i, sg_span) {
 		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/*
@@ -1277,32 +1306,51 @@ build_group_from_child_sched_domain(struct sched_domain *sd, int cpu)
 	return sg;
 }
 
-static void init_overlap_sched_group(struct sched_domain *sd,
-				     struct sched_group *sg)
+static int init_overlap_sched_group(struct sched_domain *sd,
+				    struct sched_group *sg)
 {
 	struct cpumask *mask = sched_domains_tmpmask2;
 	struct sd_data *sdd = sd->private;
-	struct cpumask *sg_span;
+	struct cpumask *sg_span = sched_group_span(sg);
+	struct sched_group_capacity *sgc;
 	int cpu;
 
-	build_balance_mask(sd, sg, mask);
-	cpu = cpumask_first(mask);
+	cpu = find_group_balance_cpu(sd, sg);
+	if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
+		return -ENOENT;
 
-	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
-	if (atomic_inc_return(&sg->sgc->ref) == 1)
-		cpumask_copy(group_balance_mask(sg), mask);
-	else
-		WARN_ON_ONCE(!cpumask_equal(group_balance_mask(sg), mask));
+	sgc = *per_cpu_ptr(sdd->sgc, cpu);
+	if (sgc && atomic_read(&sgc->ref)) {
+		atomic_inc(&sgc->ref);
+		sg->sgc = sgc;
+		return 0;
+	}
+
+	if (!sgc) {
+		sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
+				   GFP_KERNEL, cpu_to_node(cpu));
+		if (!sgc)
+			return -ENOMEM;
+		sgc->id = cpu;
+		*per_cpu_ptr(sdd->sgc, cpu) = sgc;
+	}
+
+	build_balance_mask(cpu, sd, sg, mask);
+
+	sg->sgc = sgc;
+	atomic_set(&sgc->ref, 1);
+	cpumask_copy(group_balance_mask(sg), mask);
 
 	/*
 	 * Initialize sgc->capacity such that even if we mess up the
 	 * domains and no possible iteration will get us here, we won't
 	 * die on a /0 trap.
 	 */
-	sg_span = sched_group_span(sg);
-	sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
-	sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
-	sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
+	sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
+	sgc->min_capacity = SCHED_CAPACITY_SCALE;
+	sgc->max_capacity = SCHED_CAPACITY_SCALE;
+
+	return 0;
 }
 
 static struct sched_domain *
@@ -1405,7 +1453,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		sg_span = sched_group_span(sg);
 		cpumask_or(covered, covered, sg_span);
 
-		init_overlap_sched_group(sibling, sg);
+		if (init_overlap_sched_group(sibling, sg)) {
+			kfree(sg);
+			goto fail;
+		}
 
 		if (!first)
 			first = sg;
@@ -1507,6 +1558,25 @@ static struct sched_group *get_group(int cpu, struct sd_data *sdd)
 		cpu = cpumask_first(sched_domain_span(child));
 
 	sg = *per_cpu_ptr(sdd->sg, cpu);
+	if (!sg) {
+		sg = kzalloc_node(sizeof(*sg) + cpumask_size(),
+				  GFP_KERNEL, cpu_to_node(cpu));
+		if (!sg)
+			return NULL;
+		sg->next = sg;
+		*per_cpu_ptr(sdd->sg, cpu) = sg;
+	}
+
+	if (!*per_cpu_ptr(sdd->sgc, cpu)) {
+		struct sched_group_capacity *sgc;
+
+		sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
+				   GFP_KERNEL, cpu_to_node(cpu));
+		if (!sgc)
+			return NULL;
+		sgc->id = cpu;
+		*per_cpu_ptr(sdd->sgc, cpu) = sgc;
+	}
 	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
 
 	/* Increase refcounts for claim_allocations: */
@@ -1562,6 +1632,8 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		sg = get_group(i, sdd);
+		if (!sg)
+			return -ENOMEM;
 
 		cpumask_or(covered, covered, sched_group_span(sg));
 
@@ -1595,27 +1667,40 @@ static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
 	WARN_ON(!sg);
 
 	do {
-		int cpu, cores = 0, max_cpu = -1;
+		int i, cores = 0, max_cpu = -1;
+
+		if (sg->group_weight)
+			goto next;
+
+		if (sg->sgc->group_weight) {
+			sg->group_weight = sg->sgc->group_weight;
+			sg->cores = sg->sgc->cores;
+			sg->asym_prefer_cpu = sg->sgc->asym_prefer_cpu;
+			goto next;
+		}
 
 		sg->group_weight = cpumask_weight(sched_group_span(sg));
 
 		cpumask_copy(mask, sched_group_span(sg));
-		for_each_cpu(cpu, mask) {
+		for_each_cpu(i, mask) {
 			cores++;
-			cpumask_andnot(mask, mask, cpu_smt_mask(cpu));
+			cpumask_andnot(mask, mask, cpu_smt_mask(i));
 		}
 		sg->cores = cores;
 
-		if (!(sd->flags & SD_ASYM_PACKING))
-			goto next;
-
-		for_each_cpu(cpu, sched_group_span(sg)) {
-			if (max_cpu < 0)
-				max_cpu = cpu;
-			else if (sched_asym_prefer(cpu, max_cpu))
-				max_cpu = cpu;
+		if (sd->flags & SD_ASYM_PACKING) {
+			for_each_cpu(i, sched_group_span(sg)) {
+				if (max_cpu < 0)
+					max_cpu = i;
+				else if (sched_asym_prefer(i, max_cpu))
+					max_cpu = i;
+			}
+			sg->asym_prefer_cpu = max_cpu;
 		}
-		sg->asym_prefer_cpu = max_cpu;
+
+		sg->sgc->group_weight = sg->group_weight;
+		sg->sgc->cores = sg->cores;
+		sg->sgc->asym_prefer_cpu = sg->asym_prefer_cpu;
 
 next:
 		sg = sg->next;
@@ -1889,7 +1974,8 @@ static void claim_allocations(int cpu, struct s_data *d)
 {
 	struct sched_domain *sd;
 
-	if (atomic_read(&(*per_cpu_ptr(d->sds, cpu))->ref))
+	if (*per_cpu_ptr(d->sds, cpu) &&
+	    atomic_read(&(*per_cpu_ptr(d->sds, cpu))->ref))
 		*per_cpu_ptr(d->sds, cpu) = NULL;
 
 	for (sd = *per_cpu_ptr(d->sd, cpu); sd; sd = sd->parent) {
@@ -1898,10 +1984,12 @@ static void claim_allocations(int cpu, struct s_data *d)
 		WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
 		*per_cpu_ptr(sdd->sd, cpu) = NULL;
 
-		if (atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
+		if (*per_cpu_ptr(sdd->sg, cpu) &&
+		    atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
 			*per_cpu_ptr(sdd->sg, cpu) = NULL;
 
-		if (atomic_read(&(*per_cpu_ptr(sdd->sgc, cpu))->ref))
+		if (*per_cpu_ptr(sdd->sgc, cpu) &&
+		    atomic_read(&(*per_cpu_ptr(sdd->sgc, cpu))->ref))
 			*per_cpu_ptr(sdd->sgc, cpu) = NULL;
 	}
 }
@@ -2700,8 +2788,6 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
-			struct sched_group *sg;
-			struct sched_group_capacity *sgc;
 
 			sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -2709,24 +2795,6 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sd, j) = sd;
-
-			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
-			if (!sg)
-				return -ENOMEM;
-
-			sg->next = sg;
-
-			*per_cpu_ptr(sdd->sg, j) = sg;
-
-			sgc = kzalloc_node(sizeof(struct sched_group_capacity) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
-			if (!sgc)
-				return -ENOMEM;
-
-			sgc->id = j;
-
-			*per_cpu_ptr(sdd->sgc, j) = sgc;
 		}
 	}
 
@@ -2767,23 +2835,10 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
 static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map)
 {
-	int j;
-
 	d->sds = alloc_percpu(struct sched_domain_shared *);
 	if (!d->sds)
 		return -ENOMEM;
 
-	for_each_cpu(j, cpu_map) {
-		struct sched_domain_shared *sds;
-
-		sds = kzalloc_node(sizeof(struct sched_domain_shared),
-				GFP_KERNEL, cpu_to_node(j));
-		if (!sds)
-			return -ENOMEM;
-
-		*per_cpu_ptr(d->sds, j) = sds;
-	}
-
 	return 0;
 }
 
@@ -2954,7 +3009,7 @@ static void adjust_numa_imbalance(struct sched_domain *sd_llc)
 	}
 }
 
-static void
+static int
 init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 {
 	struct sched_domain_shared *sds = NULL;
@@ -2976,6 +3031,13 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 	 */
 	for_each_cpu(cpu, sched_domain_span(sd)) {
 		sds = *per_cpu_ptr(d->sds, cpu);
+		if (!sds) {
+			sds = kzalloc_node(sizeof(*sds),
+					   GFP_KERNEL, cpu_to_node(cpu));
+			if (!sds)
+				return -ENOMEM;
+			*per_cpu_ptr(d->sds, cpu) = sds;
+		}
 
 		if (!sds->alloc_flags ||
 		    sd->span_weight == 1 ||
@@ -3000,6 +3062,8 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 	 */
 	atomic_set(&sd->shared->nr_busy_cpus, sd->span_weight);
 	atomic_inc(&sd->shared->ref);
+
+	return 0;
 }
 
 /*
@@ -3015,25 +3079,24 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
  * degenerate into a single-capacity group. The relevant edge cases are instead
  * covered by the caveats above.
  *
- * Return true if this CPU's asym path claimed sd->shared, false otherwise.
+ * Return 0 on success or if not claimed, -ENOMEM on allocation failure.
  */
-static bool claim_asym_sched_domain_shared(struct s_data *d, int cpu)
+static int claim_asym_sched_domain_shared(struct s_data *d, int cpu)
 {
 	struct sched_domain *sd = *per_cpu_ptr(d->sd, cpu);
 	struct sched_domain *sd_asym;
 
 	if (!sd)
-		return false;
+		return 0;
 
 	sd_asym = sd;
 	while (sd_asym && !(sd_asym->flags & SD_ASYM_CPUCAPACITY_FULL))
 		sd_asym = sd_asym->parent;
 
 	if (!sd_asym || (sd_asym->flags & SD_NUMA))
-		return false;
+		return 0;
 
-	init_sched_domain_shared(d, sd_asym, SD_ASYM_CPUCAPACITY);
-	return true;
+	return init_sched_domain_shared(d, sd_asym, SD_ASYM_CPUCAPACITY);
 }
 
 static int __sched_domains_alloc_llc_id(void)
@@ -3179,15 +3242,16 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 		if (!sd)
 			continue;
 
-		if (has_asym)
-			claim_asym_sched_domain_shared(&d, i);
+		if (has_asym && claim_asym_sched_domain_shared(&d, i))
+			goto error;
 
 		/* First, find the topmost SD_SHARE_LLC domain */
 		while (sd->parent && (sd->parent->flags & SD_SHARE_LLC))
 			sd = sd->parent;
 
 		if (sd->flags & SD_SHARE_LLC) {
-			init_sched_domain_shared(&d, sd, SD_SHARE_LLC);
+			if (init_sched_domain_shared(&d, sd, SD_SHARE_LLC))
+				goto error;
 
 			/*
 			 * In presence of higher domains, adjust the
-- 
2.56.0.176.g3575e65682-goog

