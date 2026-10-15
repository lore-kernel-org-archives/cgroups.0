Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66476429037
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078446; cv=none; b=QnqXVpIY5MzDuBTWJuuxUj2vjUK+5KM4O8eN2BJUDdDejYbqPMT8nPNDs4slhNJOdvsy76PFSl66pOMNR5q/S/5ZrlzLMfcEUlAMMoLZiUwMGv6W6fugHMVYa6+ied8fZvboFaskEVhujbrY2MTC3JZwOBAsTT+jfnUcWv0YeT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078446; c=relaxed/simple;
	bh=11luWlv6gP+JPj3gEyzkDgvlb/gqBUeNXgU4SHwpv2E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTGrJtx+jGnbcWE1tf7AMxW1tv3cg93GwW76TRhM1gYlwqTqMjrtNYhEkmmB5fuW9iszFsI0iph3FaMsHFt5jI8XQNPV4kfc6rdxegOHzTmD8r/uiGJlY2spQlJTmH/eWDVRwR55Ogzn93t29gxhU4Kika+H7BKSKTXcMd9MF2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=eWvbSz4z; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="eWvbSz4z"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-9906c3fc88cso555637241.2
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 08:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078426; x=1792683226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cy8uFrZ7NgoiMHkU62i+b+5hnlENX1fPhNJngUB5VQ4=;
        b=eWvbSz4zFvWNE/lRsTZiAlmUhcgcLsEnl+1NxdQLomgSKVQEQkm/s/eLmURv1Zg4DM
         lUt+UuHYkat8SmIQgLHqi2G9UJgrB4zsmDZTIyGeDrVZ3Qadqk1Eoce4uq/moT7EmQyu
         /tTFB5mvwicVtpeHNQ5b3sdfmegYKQblpq13udRD+g04/nvJ2otitbDQdUDM9Ic7zBu/
         KFf3ROELOmiLSA4RicDnQa9SXp0kLjUN/bPewxO05NPWXdBVpQt/K9ly9kKw4iLeFwpB
         wa+4QsSElxeBGl+kl3UAeW3OjNZXnwrz/m/8SznK757oHzkP1AJVQ+yxGSLaWmdTCKDX
         POOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078426; x=1792683226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cy8uFrZ7NgoiMHkU62i+b+5hnlENX1fPhNJngUB5VQ4=;
        b=sqJ+S2mODsuQ6lZHH0jLhIopUOSM9mLWjQrgH1YiZ83mRbE+qG/Ky5CbsZhKAvREbw
         ADZ+nuWU4mEx47qRSdirX0HYZ4W65d9xpwPdDcs853JLngkVKokG3/LAX3kq3uBUMz0Z
         VUxEYm6AX895W3Z38v2+ujl+3entrMxFlxeJSUfNTMIeh9YmbwMKjv0b8Dzga28K5PTJ
         Wx08E+pjXvV6S8MQ3dzo9itpipSDizvY9EI/bRCsOgTtIwlgzRxl2l0pH0grlfb7ME46
         AtYeTRlQAbgTig0A13JBxhvxw7MMl1zIGnFChjbp5TyskyPnXAbPCeGPz0q1TSm2uHaR
         Xt3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxObSgqqCgJ9NX4+CCAcClunvuDrLbxT54HQelyAMSCBUpSslO4+QjTjE4BrR9CC1xL0Jolan/b@vger.kernel.org
X-Gm-Message-State: AFq9FYKKCq+Cnac5RRqG23YiEUpUz1t436yu6JLWGhs+qwwMwOcWXWtv
	hN3YBL7LBk9HhOGA9ty3vjkHwXHj0SSax5kSMAZY2WAvC1cXdQQih2DfDadmbietwIA=
X-Gm-Gg: AYBFou33LTEBsKRppNnBM6Jnm46ThaVq2xle7Cgf9Kq32/8Zi0PphPuYTUPFABqMb1J
	BZTf5yYbECur2q+MQYGea42UiJgpqerCyjBXW4FlaBY32eUgv5l6q215PSVr4jFOkZxi1ln56vY
	TNYw9icHwFG57io+ZA0r+uEJT7TpP9TkG2QxiDkOVDpaem1jSzZDT52olKljhl7Ypro6QamPT0g
	gHkdjpP90Am8j37QbhVqEqkeRVchrSpYHCxvTW7dEcFqFCHqqkFUrssafIsHZSyoa7MRf8JkPPu
	VL/kodY11npz8JNtGimhDGbyjRnqqRamIgPXbI9agiFJlUQptVpOwHmaCTVIRflmhUNuNdIq1/D
	hTS+YOzn/gk2QFD/jBS9oW0rqsp17FxmWT2Tejm+t6/C/TRzGD4axifQRm0otJUmgiRKh0JrOml
	5L9QaTFlPugQQm2+/zJElyYRrkgdc9J7o+Yf6ayXUFqh4T1bAmA07lKU3966QhF7TsyraedHUjQ
	tUZiakAy+teOIwWlenYvTZoAaub71chmI+LD8sveT3Yua3WGHrz8x7cx3b9G8cVHJVNBir7FNOl
	ixKbC7Sckaun6uCOz2E=
X-Received: by 2002:a05:6102:4186:b0:7c3:c0b9:9028 with SMTP id ada2fe7eead31-7cb373134dcmr6256034137.24.1792078425962;
        Thu, 15 Oct 2026 08:33:45 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:45 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 7/8] sched/topology: Avoid redundant percpu allocations and bitmap walks in build_sched_domains()
Date: Thu, 15 Oct 2026 11:33:30 -0400
Message-ID: <20261015153331.1872641-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During CPU hotplug, build_sched_domains() is invoked on every CPU
activation and deactivation. Profiling build_sched_domains() on a
480-CPU Intel Xeon 6985P-C and a 512-CPU AMD EPYC 9B45 shows several
sources of avoidable O(N^2) and O(N) work per step:

1. build_sched_groups() and build_overlap_sched_groups() iterate over
   every bit of sched_domain_span(sd) via for_each_cpu_wrap(i, span, cpu)
   and check cpumask_test_cpu(i, covered) one CPU at a time, even after
   entire child groups (e.g., 120-CPU NUMA nodes) have been added to
   covered. Instead, track the remaining uncovered CPUs
   (cpumask_copy(uncovered, span)), clear each built group's span with
   cpumask_andnot(), and advance directly to the next uncovered CPU.

2. __visit_domain_allocation_hell() and __free_domain_allocs() allocate
   and free 3 * nr_levels + 2 temporary per-CPU pointer arrays via
   alloc_percpu() / free_percpu() on every domain rebuild. Reuse the
   per-CPU pointer arrays across domain rebuilds under
   sched_domains_mutex, clearing entries in __free_domain_allocs() and
   only freeing the topology-level arrays when sched_domain_topology is
   replaced in sched_init_numa() / sched_reset_numa().

3. sd_init() already computes sd_weight = cpumask_weight(sd_span), so
   initialize sd->span_weight directly in sd_init() and reuse
   child->span_weight in get_group() instead of recomputing
   cpumask_weight() across all domains and groups.

4. Reuse the first LLC sibling's computed llc_bytes in alloc_sd_llc()
   and hoist get_effective_llc_bytes() out of the sibling loop in
   sched_update_llc_bytes().

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   3.88 s ->  3.37 s (-13.1%)
  Online:    2.51 s ->  2.06 s (-17.9%)
  Total:     6.39 s ->  5.43 s (-15.0%)
  build_sched_domains() (cpu479 offline / online):
    7.91 ms -> 3.96 ms (-50.0%) / 7.51 ms -> 4.26 ms (-43.3%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   2.77 s ->  2.34 s (-15.5%)
  Online:    1.53 s ->  1.12 s (-26.8%)
  Total:     4.30 s ->  3.46 s (-19.5%)
  build_sched_domains() (cpu511 offline / online):
    6.55 ms -> 3.04 ms (-53.7%) / 5.28 ms -> 3.20 ms (-39.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/sched/topology.c | 147 ++++++++++++++++++++++++++--------------
 1 file changed, 98 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index fe7ecee041f5b..a9122dbff379d 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -903,9 +903,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 			top_llc = parent;
 
 		if (top_llc->flags & SD_SHARE_LLC) {
+			int first = cpumask_first(sched_domain_span(top_llc));
+
 			sd->llc_max = max_lid + 1;
 			sd->llc_counts = p;
-			sd->llc_bytes = get_effective_llc_bytes(i, top_llc);
+			/* All CPUs in top_llc share the same LLC size and weight. */
+			if (first < i)
+				sd->llc_bytes = (*per_cpu_ptr(d->sd, first))->llc_bytes;
+			else
+				sd->llc_bytes = get_effective_llc_bytes(i, top_llc);
 		} else {
 			/* avoid memory leak */
 			kfree(p);
@@ -986,6 +992,7 @@ void sched_cache_active_set(void)
 void sched_update_llc_bytes(unsigned int cpu)
 {
 	struct sched_domain *sd, *sdp;
+	unsigned long llc_bytes;
 	unsigned int i;
 
 	sched_domains_mutex_lock();
@@ -1002,10 +1009,11 @@ void sched_update_llc_bytes(unsigned int cpu)
 	 * sibling on each online event corrects this once the full
 	 * shared_cpu_map is known.
 	 */
+	llc_bytes = get_effective_llc_bytes(cpu, sdp);
 	for_each_cpu(i, sched_domain_span(sdp)) {
 		sd = rcu_dereference_sched_domain(cpu_rq(i)->sd);
 		if (sd)
-			sd->llc_bytes = get_effective_llc_bytes(i, sdp);
+			sd->llc_bytes = llc_bytes;
 	}
 
 unlock:
@@ -1321,19 +1329,18 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 {
 	struct sched_group *first = NULL, *last = NULL, *sg;
 	const struct cpumask *span = sched_domain_span(sd);
-	struct cpumask *covered = sched_domains_tmpmask;
+	struct cpumask *uncovered = sched_domains_tmpmask;
 	struct sd_data *sdd = sd->private;
 	struct sched_domain *sibling;
 	int i;
 
-	cpumask_clear(covered);
+	cpumask_copy(uncovered, span);
 
-	for_each_cpu_wrap(i, span, cpu) {
+	for (i = cpu; i < nr_cpu_ids;
+	     i = cpumask_next(i, uncovered),
+	     i = i < nr_cpu_ids ? i : cpumask_first(uncovered)) {
 		struct cpumask *sg_span;
 
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
 		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/*
@@ -1346,8 +1353,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * Domains should always include the CPU they're built on, so
 		 * check that.
 		 */
-		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling))) {
+			__cpumask_clear_cpu(i, uncovered);
 			continue;
+		}
 
 		/*
 		 * Usually we build sched_group by sibling's child sched_domain
@@ -1389,7 +1398,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_span(sg);
-		cpumask_or(covered, covered, sg_span);
+		cpumask_andnot(uncovered, uncovered, sg_span);
 
 		if (init_overlap_sched_group(sibling, sg)) {
 			kfree(sg);
@@ -1530,12 +1539,13 @@ static struct sched_group *get_group(int cpu, struct sd_data *sdd)
 		cpumask_copy(sched_group_span(sg), sched_domain_span(child));
 		cpumask_copy(group_balance_mask(sg), sched_group_span(sg));
 		sg->flags = child->flags;
+		sg->sgc->capacity = SCHED_CAPACITY_SCALE * child->span_weight;
 	} else {
 		cpumask_set_cpu(cpu, sched_group_span(sg));
 		cpumask_set_cpu(cpu, group_balance_mask(sg));
+		sg->sgc->capacity = SCHED_CAPACITY_SCALE;
 	}
 
-	sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sched_group_span(sg));
 	sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
 	sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
 
@@ -1555,25 +1565,24 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 	struct sched_group *first = NULL, *last = NULL;
 	struct sd_data *sdd = sd->private;
 	const struct cpumask *span = sched_domain_span(sd);
-	struct cpumask *covered;
+	struct cpumask *uncovered;
 	int i;
 
 	lockdep_assert_held(&sched_domains_mutex);
-	covered = sched_domains_tmpmask;
+	uncovered = sched_domains_tmpmask;
 
-	cpumask_clear(covered);
+	cpumask_copy(uncovered, span);
 
-	for_each_cpu_wrap(i, span, cpu) {
+	for (i = cpu; i < nr_cpu_ids;
+	     i = cpumask_next(i, uncovered),
+	     i = i < nr_cpu_ids ? i : cpumask_first(uncovered)) {
 		struct sched_group *sg;
 
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
 		sg = get_group(i, sdd);
 		if (!sg)
 			return -ENOMEM;
 
-		cpumask_or(covered, covered, sched_group_span(sg));
+		cpumask_andnot(uncovered, uncovered, sched_group_span(sg));
 
 		if (!first)
 			first = sg;
@@ -1862,16 +1871,21 @@ static int __sdt_alloc(const struct cpumask *cpu_map);
 static void __sds_free(struct s_data *d, const struct cpumask *cpu_map);
 static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map);
 
+static struct sched_domain * __percpu *sched_domains_sd;
+
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
 {
+	int j;
+
 	switch (what) {
 	case sa_rootdomain:
 		if (!atomic_read(&d->rd->refcount))
 			free_rootdomain(&d->rd->rcu);
 		fallthrough;
 	case sa_sd:
-		free_percpu(d->sd);
+		for_each_cpu(j, cpu_map)
+			*per_cpu_ptr(d->sd, j) = NULL;
 		fallthrough;
 	case sa_sd_shared:
 		__sds_free(d, cpu_map);
@@ -1893,9 +1907,12 @@ __visit_domain_allocation_hell(struct s_data *d, const struct cpumask *cpu_map)
 		return sa_sd_storage;
 	if (__sds_alloc(d, cpu_map))
 		return sa_sd_shared;
-	d->sd = alloc_percpu(struct sched_domain *);
-	if (!d->sd)
-		return sa_sd_shared;
+	if (!sched_domains_sd) {
+		sched_domains_sd = alloc_percpu(struct sched_domain *);
+		if (!sched_domains_sd)
+			return sa_sd_shared;
+	}
+	d->sd = sched_domains_sd;
 	d->rd = alloc_rootdomain();
 	if (!d->rd)
 		return sa_sd;
@@ -2019,6 +2036,7 @@ sd_init(struct sched_domain_topology_level *tl,
 
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.span_weight		= sd_weight,
 
 		/* 50% success rate */
 		.newidle_call		= 512,
@@ -2159,6 +2177,22 @@ void __init set_sched_topology(struct sched_domain_topology_level *tl)
 }
 
 #ifdef CONFIG_NUMA
+static void __sdt_free_percpu(void)
+{
+	struct sched_domain_topology_level *tl;
+
+	for_each_sd_topology(tl) {
+		struct sd_data *sdd = &tl->data;
+
+		free_percpu(sdd->sd);
+		sdd->sd = NULL;
+		free_percpu(sdd->sg);
+		sdd->sg = NULL;
+		free_percpu(sdd->sgc);
+		sdd->sgc = NULL;
+	}
+}
+
 static int cpu_numa_flags(void)
 {
 	return SD_NUMA;
@@ -2449,6 +2483,7 @@ void sched_init_numa(int offline_node)
 	/*
 	 * Copy the default topology bits..
 	 */
+	__sdt_free_percpu();
 	for (i = 0; sched_domain_topology[i].mask; i++)
 		tl[i] = sched_domain_topology[i];
 
@@ -2507,6 +2542,7 @@ static void sched_reset_numa(void)
 		kfree(masks);
 	}
 	if (sched_domain_topology_saved) {
+		__sdt_free_percpu();
 		kfree(sched_domain_topology);
 		sched_domain_topology = sched_domain_topology_saved;
 		sched_domain_topology_saved = NULL;
@@ -2708,17 +2744,23 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
-		sdd->sd = alloc_percpu(struct sched_domain *);
-		if (!sdd->sd)
-			return -ENOMEM;
+		if (!sdd->sd) {
+			sdd->sd = alloc_percpu(struct sched_domain *);
+			if (!sdd->sd)
+				return -ENOMEM;
+		}
 
-		sdd->sg = alloc_percpu(struct sched_group *);
-		if (!sdd->sg)
-			return -ENOMEM;
+		if (!sdd->sg) {
+			sdd->sg = alloc_percpu(struct sched_group *);
+			if (!sdd->sg)
+				return -ENOMEM;
+		}
 
-		sdd->sgc = alloc_percpu(struct sched_group_capacity *);
-		if (!sdd->sgc)
-			return -ENOMEM;
+		if (!sdd->sgc) {
+			sdd->sgc = alloc_percpu(struct sched_group_capacity *);
+			if (!sdd->sgc)
+				return -ENOMEM;
+		}
 
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
@@ -2748,30 +2790,36 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
 			if (sdd->sd) {
 				sd = *per_cpu_ptr(sdd->sd, j);
-				if (sd && (sd->flags & SD_NUMA))
-					free_sched_groups(sd->groups, 0);
-				kfree(*per_cpu_ptr(sdd->sd, j));
+				if (sd) {
+					if (sd->flags & SD_NUMA)
+						free_sched_groups(sd->groups, 0);
+					kfree(sd);
+					*per_cpu_ptr(sdd->sd, j) = NULL;
+				}
 			}
 
-			if (sdd->sg)
+			if (sdd->sg) {
 				kfree(*per_cpu_ptr(sdd->sg, j));
-			if (sdd->sgc)
+				*per_cpu_ptr(sdd->sg, j) = NULL;
+			}
+			if (sdd->sgc) {
 				kfree(*per_cpu_ptr(sdd->sgc, j));
+				*per_cpu_ptr(sdd->sgc, j) = NULL;
+			}
 		}
-		free_percpu(sdd->sd);
-		sdd->sd = NULL;
-		free_percpu(sdd->sg);
-		sdd->sg = NULL;
-		free_percpu(sdd->sgc);
-		sdd->sgc = NULL;
 	}
 }
 
+static struct sched_domain_shared * __percpu *sched_domains_sds;
+
 static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map)
 {
-	d->sds = alloc_percpu(struct sched_domain_shared *);
-	if (!d->sds)
-		return -ENOMEM;
+	if (!sched_domains_sds) {
+		sched_domains_sds = alloc_percpu(struct sched_domain_shared *);
+		if (!sched_domains_sds)
+			return -ENOMEM;
+	}
+	d->sds = sched_domains_sds;
 
 	return 0;
 }
@@ -2783,10 +2831,11 @@ static void __sds_free(struct s_data *d, const struct cpumask *cpu_map)
 	if (!d->sds)
 		return;
 
-	for_each_cpu(j, cpu_map)
+	for_each_cpu(j, cpu_map) {
 		kfree(*per_cpu_ptr(d->sds, j));
+		*per_cpu_ptr(d->sds, j) = NULL;
+	}
 
-	free_percpu(d->sds);
 	d->sds = NULL;
 }
 
@@ -2810,6 +2859,7 @@ static struct sched_domain *build_sched_domain(struct sched_domain_topology_leve
 			cpumask_or(sched_domain_span(sd),
 				   sched_domain_span(sd),
 				   sched_domain_span(child));
+			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 		}
 
 	}
@@ -3160,7 +3210,6 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	/* Build the groups for the domains */
 	for_each_cpu(i, cpu_map) {
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
-			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 			if (sd->flags & SD_NUMA) {
 				if (build_overlap_sched_groups(sd, i))
 					goto error;
-- 
2.56.0.385.gd3acb90ef8-goog

