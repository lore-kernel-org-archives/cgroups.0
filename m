Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A31934D382
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078446; cv=none; b=MosUbLuQh/hUZEKr7z+sTJQnGA5Vz/cnTlLQKbBlVFkTU27x6lp73MI5Ha2KOWWqVuUyF11et/KA8E91399bdZGzw3b7fSBeEENZCVEFymf99IF6+I+NPERlxVMPeTwXR6J/HVrvACBV2M9Cqy3ZGPn9A5R2y/PAFsOeTvafeZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078446; c=relaxed/simple;
	bh=Xg75wWV0Wkn1lUCmua4HAOXKJp5fSZzYvpL+GKbl8+M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFqofV3PjmpiilsAXEf/NmM3baXV5PuZVBUyERfnbizGiTLyViYWSfoXFK5f0Xb6McxBb+fOkiJX5cLovd1CZ7zKMStV2KNKVIag5JIgWw5CeEK5n0VICxXTWY4wQ1NETQpZUm/tXujEQbH8+GHN23KLlE/Nk2Tb6WnT60nVdgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=fwrZ6KHA; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="fwrZ6KHA"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9902a746546so65733241.1
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 08:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078425; x=1792683225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9R9JGD2gfMVINW++iTiT+sdv1KZ9FYj5h4fZmBgfwsA=;
        b=fwrZ6KHAbXqBJXGKxzlx1KsnXLhJ6sJpXSMBnPa2hb7Ai8WFEcHEptexvd87J+cAZV
         TxpAi6Y5VK+SVLPHYr1smwgEwWYawu2jtaehKCEUrq/Zozmv0n1pBxrJVcHNWNNKG75c
         bIt3FGNvlCrYvQMoBtINogkcTjdjFWWLeEfVNCmIVpU8Q5gx5aYQivwvqG+F3OEAwyan
         cmKBSbcDnKTX7fSWm9Ol/iKu2cWnoU3SWSzh3uacms0uamocgd9DBUjBkjcFnmWcecxQ
         UihwRtPeO9bFXyJKpDDrVJJaPu7ZjBpPQdDxX4FE5rMCQNMq1j7CWLEnD2eB2i+Kola7
         Le5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078425; x=1792683225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9R9JGD2gfMVINW++iTiT+sdv1KZ9FYj5h4fZmBgfwsA=;
        b=je7n0DY5ZSBuL5Fhb8fpPqmaIzCWeeJAoAj3+t3qer44VhLdoYcfaSbdcvdGgn3rsh
         yOrnuMeowoevQaj4B+ea9GkrcmwQazrwaLTcUemWBXie7XvEbRHl6q9vu1XfIwGH4UHH
         yZ96KkUdZwCU46sA4F6NN3Hgy5Y8Q83yc5AU2PZQiZhxOBXJIADuyktI8dYmq+SlfWfC
         jlad4+1xuDmF4m1zRntHHsBnaY/q7+ZSeQHctOLIf5apA0GkjwiW6AvF6xLg9+Lo+n2z
         6JwkG0L2g+QTL9nW7i9F5pNDcfIBmkoiZY87TQVqdJFxYUgUi53DYJCp0Ai5bdJ+mqFo
         8wSg==
X-Forwarded-Encrypted: i=1; AKwUvBzD3ANwRMlRfwG1kbfhrE8GchpuZzthIs+9OS8CXz6kxE0qHt9JM8co53z66IzrhPpJZ6sSjeSP@vger.kernel.org
X-Gm-Message-State: AFq9FYItJhSfbGgG6T7dXV3xXqFw/O+P394Ce/wKPHFVmYJg8QK3zltA
	1M7DioWDHw3bvwjCcRvRP//coeb7/xJhBltfcQVJyURywnlpGDs6weR11ta91atvOII=
X-Gm-Gg: AYBFou1db/f8DThKvDnOIIXXha+B9ztrCeVhnByN0sZVdfL+xtp/g+nVvGfE5Qc/SW0
	1iPkr8xt0sMxqap4D4GnCUlMzvuIGjF9BMBSnl4RKOumwtknEgcafjzlfM7KptuqxQYOqDRxsA1
	uDxRojuQSX+V8NAf43T9vOSDyipmTx3UaS/LyOCgIldwKnqy62xHt0mLXrZi3VGdSwgdXQq+4Gg
	sljeJQnYiP/valqSRtFRmYpCs+WTfkYpUZadegm2BW00V2/Bp50mIIFfFuANHc9XfpfvmCiFKKo
	L7h9fpV0vjiQGPGHxShGvS5VoCwC27ro1w7EPa0MHJHoaq8uZianrr8BhWxlpyH4Ia0e6U3fOoE
	qw5lX8vw0aoCIVJzBZB/0nDEuE7x1VAJXIbTRoSN5bg4GCGTZp7xnfhhC8IyDjHLk22Hk/NHUwC
	CasXN7dqn1pd1UycQFC6AwXiBfXHG+2jFScYO9CcwuzAmNFuX5eJPFRyTYURJ3mY+uw8O6vhlXr
	l7lqLKmbPzeah9DziJU4biFUKVWPPBITCvO+v/lPpJzTgn4aQrwy4bjIrhyMmxsZ3PIlBnTQLQi
	docI296P3dmJeXMgBYw=
X-Received: by 2002:a05:6102:292b:b0:7bd:ce85:b00f with SMTP id ada2fe7eead31-7cc18271943mr139071137.40.1792078424660;
        Thu, 15 Oct 2026 08:33:44 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:44 -0700 (PDT)
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
Subject: [PATCH v1 6/8] sched/deadline, topology: Avoid O(N^2) dl_server bandwidth walks during root_domain rebuilds
Date: Thu, 15 Oct 2026 11:33:29 -0400
Message-ID: <20261015153331.1872641-7-pasha.tatashin@soleen.com>
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

Every CPU runqueue has a fair_server (and optionally an ext_server)
deadline entity enabled by default. Whenever a root_domain is rebuilt on
CPU hotplug or cpuset changes, partition_sched_domains_locked() currently
performs three O(N^2) remote runqueue bandwidth updates across all N
active CPUs (O(N^3) across sequential hotplug of N CPUs):

1. detach_destroy_domains() calls
   cpu_attach_domain(NULL, &def_root_domain, i) -> rq_attach_root() ->
   __dl_server_attach_root() for each of the N CPUs. Each call recomputes
   cpumask_weight_and(rd->span, cpu_active_mask) twice and calls
   __dl_add() -> __dl_update(), walking all active CPUs attached to
   def_root_domain so far to update rq->dl.extra_bw, only for
   def_root_domain to be detached milliseconds later.

2. build_sched_domains() calls cpu_attach_domain(sd, d.rd, i) ->
   rq_attach_root() -> __dl_server_attach_root() for each of the N CPUs,
   performing another N*(N+1)/2 remote rq->dl.extra_bw updates using
   intermediate partial span weights (1..N) that are immediately
   discarded at the end of partition_sched_domains_locked().

3. dl_rebuild_rd_accounting() -> dl_clear_root_domain() resets
   rd->dl_bw.total_bw = 0 and cpu_rq(i)->dl.extra_bw = max_bw, and then
   calls dl_server_add_bw(rd, i) -> __dl_add() -> __dl_update() in a
   nested O(N^2) loop over rd->span with interrupts disabled.

Remove the redundant __dl_server_attach_root() calls from rq_attach_root()
(since partition_sched_domains_locked() always rebuilds root_domain
accounting via dl_rebuild_rd_accounting() once domain attachment is
complete), and replace the nested O(N^2) loop in dl_clear_root_domain()
with a single O(N) accumulation pass and a single O(N) extra_bw update
pass.

Also provide a !CONFIG_CPUSETS implementation of
dl_rebuild_rd_accounting() (using a lockless dl_prio(READ_ONCE(p->prio))
pre-check before dl_add_task_root_domain(p)). Previously,
dl_rebuild_rd_accounting() was a no-op stub when CONFIG_CPUSETS=n, which
left root_domain rebuilds without SCHED_DEADLINE task bandwidth
accounting and left inconsistent per-CPU extra_bw values computed from
partial active CPU counts in rq_attach_root().

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   5.15 s ->  3.88 s (-24.7%)
  Online:    4.05 s ->  2.51 s (-38.0%)
  Total:     9.20 s ->  6.39 s (-30.5%)
  dl_clear_root_domain() / dl_rebuild_rd_accounting() (cpu479):
    5,537.0 us -> 58.1 us (-99.0%) / 5,176.2 us -> 61.9 us (-98.8%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   3.26 s ->  2.77 s (-15.0%)
  Online:    2.03 s ->  1.53 s (-24.6%)
  Total:     5.29 s ->  4.30 s (-18.7%)
  dl_clear_root_domain() / dl_rebuild_rd_accounting() (cpu511):
    1,880.5 us -> 27.5 us (-98.5%) / 1,762.3 us -> 22.6 us (-98.7%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/cpuset.h         |  6 +--
 include/linux/sched/deadline.h |  1 -
 kernel/sched/deadline.c        | 89 +++++++++++++++++++++-------------
 kernel/sched/sched.h           |  1 -
 kernel/sched/topology.c        | 13 -----
 5 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 914983387e955..8baa99308f49e 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -129,7 +129,7 @@ static inline int cpuset_do_page_mem_spread(void)
 
 extern bool current_cpuset_is_being_rebound(void);
 
-extern void dl_rebuild_rd_accounting(void);
+void dl_rebuild_rd_accounting(void);
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
@@ -273,9 +273,7 @@ static inline bool current_cpuset_is_being_rebound(void)
 	return false;
 }
 
-static inline void dl_rebuild_rd_accounting(void)
-{
-}
+void dl_rebuild_rd_accounting(void);
 
 static inline void rebuild_sched_domains(void)
 {
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 273538200a445..6f03357f05c76 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -31,7 +31,6 @@ static inline bool dl_time_before(u64 a, u64 b)
 
 struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
-extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domain_cpu(int cpu);
 /*
  * Return whether moving DL task @p to @new_mask requires moving DL
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 857dbe3519a86..01f2f24e3b814 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1885,24 +1885,6 @@ void sched_init_dl_servers(void)
 	}
 }
 
-void __dl_server_attach_root(struct sched_dl_entity *dl_se, struct rq *rq)
-{
-	u64 new_bw = dl_se->dl_bw;
-	int cpu = cpu_of(rq);
-	struct dl_bw *dl_b;
-
-	if (!dl_se->dl_bw_attached)
-		return;
-
-	dl_b = dl_bw_of(cpu_of(rq));
-	guard(raw_spinlock)(&dl_b->lock);
-
-	if (!dl_bw_cpus(cpu))
-		return;
-
-	__dl_add(dl_b, new_bw, dl_bw_cpus(cpu));
-}
-
 int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 period, bool init)
 {
 	u64 old_bw = (init || !dl_se->dl_bw_attached) ? 0 :
@@ -3448,18 +3430,22 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 }
 
-static void dl_server_add_bw(struct root_domain *rd, int cpu)
+static void dl_server_sum_bw(int cpu, int cpus, u64 *total_bw, s64 *extra_bw)
 {
 	struct sched_dl_entity *dl_se;
 
 	dl_se = &cpu_rq(cpu)->fair_server;
-	if (dl_server(dl_se) && dl_se->dl_bw_attached && cpu_active(cpu))
-		__dl_add(&rd->dl_bw, dl_se->dl_bw, dl_bw_cpus(cpu));
+	if (dl_server(dl_se) && dl_se->dl_bw_attached) {
+		*total_bw += dl_se->dl_bw;
+		*extra_bw -= (s32)dl_se->dl_bw / cpus;
+	}
 
 #ifdef CONFIG_SCHED_CLASS_EXT
 	dl_se = &cpu_rq(cpu)->ext_server;
-	if (dl_server(dl_se) && dl_se->dl_bw_attached && cpu_active(cpu))
-		__dl_add(&rd->dl_bw, dl_se->dl_bw, dl_bw_cpus(cpu));
+	if (dl_server(dl_se) && dl_se->dl_bw_attached) {
+		*total_bw += dl_se->dl_bw;
+		*extra_bw -= (s32)dl_se->dl_bw / cpus;
+	}
 #endif
 }
 
@@ -3480,26 +3466,32 @@ static u64 dl_server_read_bw(int cpu)
 	return dl_bw;
 }
 
-void dl_clear_root_domain(struct root_domain *rd)
+static void dl_clear_root_domain(struct root_domain *rd)
 {
-	int i;
+	u64 total_bw = 0;
+	s64 extra_bw = 0;
+	int i, cpus;
 
 	guard(raw_spinlock_irqsave)(&rd->dl_bw.lock);
 
-	/*
-	 * Reset total_bw to zero and extra_bw to max_bw so that next
-	 * loop will add dl-servers contributions back properly,
-	 */
-	rd->dl_bw.total_bw = 0;
-	for_each_cpu(i, rd->span)
-		cpu_rq(i)->dl.extra_bw = cpu_rq(i)->dl.max_bw;
-
 	/*
 	 * dl_servers are not tasks. Since dl_add_task_root_domain ignores
 	 * them, we need to account for them here explicitly.
 	 */
-	for_each_cpu(i, rd->span)
-		dl_server_add_bw(rd, i);
+	cpus = cpumask_weight_and(rd->span, cpu_active_mask);
+	if (cpus) {
+		for_each_cpu_and(i, rd->span, cpu_active_mask)
+			dl_server_sum_bw(i, cpus, &total_bw, &extra_bw);
+	}
+
+	rd->dl_bw.total_bw = total_bw;
+	for_each_cpu(i, rd->span) {
+		struct rq *rq = cpu_rq(i);
+
+		rq->dl.extra_bw = rq->dl.max_bw;
+		if (cpu_active(i))
+			rq->dl.extra_bw += extra_bw;
+	}
 }
 
 void dl_clear_root_domain_cpu(int cpu)
@@ -3507,6 +3499,33 @@ void dl_clear_root_domain_cpu(int cpu)
 	dl_clear_root_domain(cpu_rq(cpu)->rd);
 }
 
+#ifndef CONFIG_CPUSETS
+void dl_rebuild_rd_accounting(void)
+{
+	struct task_struct *g, *p;
+	u64 cookie = ++dl_cookie;
+	int cpu;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_held(&sched_domains_mutex);
+
+	rcu_read_lock();
+	for_each_possible_cpu(cpu) {
+		if (dl_bw_visited(cpu, cookie))
+			continue;
+
+		dl_clear_root_domain_cpu(cpu);
+	}
+	for_each_process_thread(g, p) {
+		/* Racy pre-check; dl_add_task_root_domain() rechecks under pi_lock. */
+		if (!dl_prio(READ_ONCE(p->prio)))
+			continue;
+		dl_add_task_root_domain(p);
+	}
+	rcu_read_unlock();
+}
+#endif
+
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b76e2cd695025..e76a6876ac4e8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -418,7 +418,6 @@ extern void sched_init_dl_servers(void);
 
 extern void fair_server_init(struct rq *rq);
 extern void ext_server_init(struct rq *rq);
-extern void __dl_server_attach_root(struct sched_dl_entity *dl_se, struct rq *rq);
 extern int dl_server_apply_params(struct sched_dl_entity *dl_se,
 		    u64 runtime, u64 period, bool init);
 extern int dl_server_attach_bw(struct sched_dl_entity *dl_se);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 02c38089a80c9..fe7ecee041f5b 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -502,19 +502,6 @@ void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
-	/*
-	 * Because the rq is not a task, dl_add_task_root_domain() did not
-	 * move the fair server bw to the rd if it already started.
-	 * Add it now.
-	 */
-	if (rq->fair_server.dl_server)
-		__dl_server_attach_root(&rq->fair_server, rq);
-
-#ifdef CONFIG_SCHED_CLASS_EXT
-	if (rq->ext_server.dl_server)
-		__dl_server_attach_root(&rq->ext_server, rq);
-#endif
-
 	rq_unlock_irqrestore(rq, &rf);
 
 	if (old_rd)
-- 
2.56.0.385.gd3acb90ef8-goog

