Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281400;
	b=UuSJBgZWhvbeT04RDproRoA9mfUsL4m4UZOQVUVbi2IoRZXnqH+lQwb7loFZsNDz2ZQj
	 5X2hl509m9VCNvgTtgwkM3ehrH7j6giU3PWLCT3neOCheGwH17UcLQ+tio3aMwKSra5zd
	 VO9Vcxtuj0GVp/3LUz3NXxBQCsjwblXZfuiXZRHWnE1l4wAMbzXtOdhKkjtbeP0bVVU6Q
	 9NgvjXRfdMNPlcfotBG4TtrchrIE4F1RfTA7qKP0Dgk22wGjf+5ZzfH2bLeZ458X6dRAE
	 cNYOUOOE1fllE4l2ZACIyMg4kRrVgTJipzIB1Mpre4lLpuewwevVk+EBezizwvB/Yqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281400;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TXLX0Ahxuhi7Ry1DtDpYVsi3P/H10gWiQkGDuBbmQyY=;
	b=nrXDNYgx4rIOl4tSUFblYLaZdCavoufc7EsqMkRBSOMQXSoh8VDQo+nhrmGaFMIeWyJz
	 8WI0UMgFsiAJulOFH04cptDKi44kwskB8wAZgOVMTiMlhOjPVoargQis7W3H/zfbcUce+
	 srvCajr8O/qXLx9AxM/7XQCIkoWD/p8c3qGClLYmRmVgGiOlB8FDGfRz3Ev1d5fxLBvrO
	 aGn/GPIxGWKcQxq8QaNAgOhprGOnJpm2/qdc4N5AXQBH1YwEpnxJ4cOZeT6+8w1E6GgYo
	 8RiMVb3PYeCcoANPgAEpF0xJ4tBH36to1IA61WO8noRFrTpqkkeEP1T9IdHCnZgv6VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oN4rBKQq;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D37B606A321
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:29:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D37B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oN4rBKQq
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b2382bf051so902587b3a.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 19:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281399; x=1794886199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TXLX0Ahxuhi7Ry1DtDpYVsi3P/H10gWiQkGDuBbmQyY=;
        b=oN4rBKQqmhWh8bVqvI15GTnKGIeVWB+Rnxx5533fecVRQ9hEhRab83Fto5QBSZ2hrX
         9y9vrYq3sXfAkLOCndTF+tO8mbv2N/lEFdW0X3OowjoOLFWU5JEFTScnkahrsTVfJwkp
         a4fe1LpL5OvfSDDVtgUsi1gMm9GkNqG/e82K8bZbC9bsQt9/8vqPU3NfioWhUCvHuen8
         UsT7sVbgp9oGip2yytfF3m4fY7MhPtWbVjkNe7p2ApXqsogO+zOvVdb2r6gRr4Mp/BGx
         yZFDA2pQu3kqqarXWhMgcSrXLAnnu5amhMnmNOo1M6Nau0IhtPikNTo3L53m7U9pNvGL
         XGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281399; x=1794886199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TXLX0Ahxuhi7Ry1DtDpYVsi3P/H10gWiQkGDuBbmQyY=;
        b=JcV54ZPxMZtkEAYONgDvCtknrHx9O3+f1BOWob9GG4If3SNYY5HwuX+iR3InliV1hO
         uXxMX3QwtcxN0Jz/yYcimFT1FfYEJSgZ32hszhKOO/5coMLlroERbO5vWCzsUQ+HIw9n
         6hRoHt0M0C+GdvKrUectnHFzYudFlqUnS+U7IR63pDqUV6C4TNcECM0Qk/0OrVU4QWiX
         azkga90IQlkQ/RZUgtNUO/iCV2TS/Lh4dEltQSGbcCVbaQroGftvA2E/tAsQpwRdyB+L
         R+p2tmK81rQ+Hd7fUaYrE3FN8SgSxM2umAVS1tV0ZxBDvLOY/UB3lR4jO6mhWD08ZTe9
         +spg==
X-Forwarded-Encrypted: i=1; AL+hErFDErM2hgNvlMYk7MLs2vRVvlcCRIfqckxOZdT+OSPkZ5ZM3a9DoBjkDYPG+k7LFrtU81hXtLJI@vger.kernel.org
X-Gm-Message-State: APuU4Z81Wz4JSNtqUeDb2UphdShJRFc+rz6dMbjnQ0ZTV5v4FOEFQX+T
	8Hv/ZoqxblM92KlVKZ9b3Idg10y7tq8k6q+2JUWkFeDcaDL6/MBLUQWU
X-Gm-Gg: AYBFou22QQwTOsTgEZyh1+rfK1nlh4D37JjqLuOQOP28sPNgH4cfqN959JlMZYtYaQm
	mjZ4jg1tIgI9uHDMEk50jTG+G998Mw0fZUveXAM/CXTFQ3nK+C2WFWlQ3lhCWMgAvXuBAjCwSTK
	Ot4kOfClfvCmLRnWsrTWjuERAH0ZHW++MX3wML+ppwhcaWntbTdOhoMw+1E9pdadB2xbgYKBbHb
	a1bNasP2pTNC2GJVffqO/dAga11V7KJWZgl6zOrtl5I+OJ+9zxaTCTadeNl7x9ja+rbCsEj4v8Y
	cbKc8rWBreU3DjWe7KgJaRFj/xtSN1HIes7/QZpIfKoKC3ylB8ztTOzGXSC/L6aYF2id52LbGZ4
	cPGK6+jmokoEoLCZ4FB9BJt0AiOBxTfUn42dD+I7jEjclAgmd5h8eXb+ObIcSJ3tNIlUN+Hg+rJ
	a6yuqsNaPZal6lUun/+9wQVgFQcZYIFoYErynvG75/1r/eGvYwx1LXCUyMo+W/SRIa+ZYXyMWWJ
	TFqd2O5Si8LCZlm5EHPQYhYLRH3TYsbpTpXsnHMTL2014Z294tLZRCePitm4V2p9RqUrygoU6Fy
	qmuH0M9jnuao93AhTeYfsap31prdB9/tUXzPwBHve14Fy1PNrFcchLC0KaoJUVOr1T0PPmyUUU3
	m6knG3dVteuPnLIs0LpvXWjSj
X-Received: by 2002:a05:6a00:390b:b0:8a0:6905:248 with SMTP id d2e1a72fcca58-8ba83bd70bamr1752498b3a.3.1794281398643;
        Mon, 09 Nov 2026 19:29:58 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:29:57 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 2/4] sched: sample NUMA balancing mode once per path
Date: Tue, 10 Nov 2026 11:29:11 +0800
Message-ID: <20261110032913.71974-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Take one snapshot per path and pass it down.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/sched/fair.c | 77 ++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 672dda541458..18b976a47afa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1422,7 +1422,8 @@ static inline int get_sched_cache_scale(int mul)
 	return (1 + (tol - 1) * mul);
 }
 
-static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
+static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu,
+				bool numab_enabled)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned long llc, footprint;
@@ -1435,7 +1436,7 @@ static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
 	if (!sd)
 		return true;
 
-	if (task_numab_enabled()) {
+	if (numab_enabled) {
 		/*
 		 * TBD: RDT exclusive LLC ways reserved should be
 		 * excluded.
@@ -1801,7 +1802,8 @@ static unsigned long fraction_mm_sched(struct rq *rq,
 	return div64_u64(NICE_0_LOAD * pcpu_sched->runtime, rq->cpu_runtime + 1);
 }
 
-static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
+static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp,
+			bool numab_enabled)
 {
 	int mm_sched_llc = -1, mm_sched_cpu;
 
@@ -1823,7 +1825,7 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 		 * than sched_setnuma() at least -- and thus the
 		 * conflict only exists for a short period of time.
 		 */
-		if (task_numab_enabled() &&
+		if (numab_enabled &&
 		    p->numa_preferred_nid >= 0 &&
 		    cpu_to_node(mm_sched_cpu) != p->numa_preferred_nid)
 			mm_sched_llc = -1;
@@ -1842,6 +1844,7 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	struct sched_cache_time *pcpu_sched;
 	int mm_sched_llc = -1;
 	unsigned long epoch;
+	bool numab_enabled;
 
 	if (!sched_cache_enabled())
 		return;
@@ -1875,14 +1878,19 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * its preferred state.
 	 */
 	if ((long)(epoch - READ_ONCE(grp->epoch)) > llc_epoch_affinity_timeout ||
-	    invalid_llc_nr(grp, p, cpu_of(rq)) ||
-	    exceed_llc_capacity(grp, cpu_of(rq))) {
+	    invalid_llc_nr(grp, p, cpu_of(rq))) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
+	} else {
+		numab_enabled = task_numab_enabled();
+		if (exceed_llc_capacity(grp, cpu_of(rq), numab_enabled)) {
+			if (READ_ONCE(grp->cpu) != -1)
+				WRITE_ONCE(grp->cpu, -1);
+		} else {
+			mm_sched_llc = get_pref_llc(p, grp, numab_enabled);
+		}
 	}
 
-	mm_sched_llc = get_pref_llc(p, grp);
-
 	/* task not on rq accounted later in account_entity_enqueue() */
 	if (task_running_on_cpu(rq->cpu, p) &&
 	    READ_ONCE(p->preferred_llc) != mm_sched_llc) {
@@ -1919,12 +1927,12 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
 }
 
 static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p,
-			      struct sched_cache_group *grp)
+			      struct sched_cache_group *grp, bool numab_enabled)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	int cpu, curr_cpu, nid, pref_nid;
 
-	if (!task_numab_enabled())
+	if (!numab_enabled)
 		goto out;
 
 	cpu = READ_ONCE(grp->cpu);
@@ -1991,6 +1999,7 @@ static void task_cache_work(struct callback_head *work)
 	struct task_struct *p = current, *cur;
 	unsigned long curr_m_a_occ = 0;
 	unsigned long m_a_occ = 0;
+	bool numab_enabled;
 
 	WARN_ON_ONCE(work != &p->cache_work);
 
@@ -2019,11 +2028,16 @@ static void task_cache_work(struct callback_head *work)
 		return;
 
 	curr_cpu = task_cpu(p);
-	if (invalid_llc_nr(grp, p, curr_cpu) ||
-	    exceed_llc_capacity(grp, curr_cpu)) {
+	if (invalid_llc_nr(grp, p, curr_cpu)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
+		return;
+	}
 
+	numab_enabled = task_numab_enabled();
+	if (exceed_llc_capacity(grp, curr_cpu, numab_enabled)) {
+		if (READ_ONCE(grp->cpu) != -1)
+			WRITE_ONCE(grp->cpu, -1);
 		return;
 	}
 
@@ -2033,7 +2047,7 @@ static void task_cache_work(struct callback_head *work)
 	scoped_guard (cpus_read_lock) {
 		guard(rcu)();
 
-		get_scan_cpumasks(cpus, p, grp);
+		get_scan_cpumasks(cpus, p, grp, numab_enabled);
 
 		for_each_cpu(cpu, cpus) {
 			/* XXX sched_cluster_active */
@@ -2138,7 +2152,8 @@ void init_sched_mm(struct task_struct *p) { }
 static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
 
 static inline int get_pref_llc(struct task_struct *p,
-			       struct sched_cache_group *grp)
+			       struct sched_cache_group *grp,
+			       bool numab_enabled)
 {
 	return -1;
 }
@@ -2867,6 +2882,9 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	struct numa_group *ng = deref_curr_numa_group(p);
 	int dst_nid = cpu_to_node(dst_cpu);
 	int last_cpupid, this_cpupid;
+	bool tiering;
+
+	tiering = numab_in_tiering_mode();
 
 	/*
 	 * Cannot migrate to memoryless nodes.
@@ -2878,7 +2896,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (folio_use_access_time(folio)) {
+	if (tiering && !node_is_toptier(folio_nid(folio))) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
@@ -2907,7 +2925,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!numab_in_tiering_mode() && !node_is_toptier(src_nid) &&
+	if (!tiering && !node_is_toptier(src_nid) &&
 	    !cpupid_valid(last_cpupid))
 		return false;
 
@@ -10696,13 +10714,14 @@ static int task_hot(struct task_struct *p, struct lb_env *env)
  * Returns 0, if task migration is not affected by locality.
  * Returns a negative value, if task migration improves locality i.e migration preferred.
  */
-static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
+static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env,
+				      bool numab_enabled)
 {
 	struct numa_group *numa_group = rcu_dereference_all(p->numa_group);
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!task_numab_enabled())
+	if (!numab_enabled)
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -10744,7 +10763,8 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 
 #else /* !CONFIG_NUMA_BALANCING: */
 static inline long migrate_degrades_locality(struct task_struct *p,
-					     struct lb_env *env)
+					     struct lb_env *env,
+					     bool numab_enabled)
 {
 	return 0;
 }
@@ -10946,7 +10966,8 @@ static inline bool sched_asym(struct sched_domain *sd, int dst_cpu, int src_cpu)
  * destination LLC in terms of cache aware load balance.
  */
 static enum llc_mig can_migrate_llc_task(struct lb_env *env,
-					 struct task_struct *p)
+					 struct task_struct *p,
+					 bool numab_enabled)
 {
 	struct sched_cache_group *grp;
 	bool to_pref;
@@ -10971,7 +10992,7 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 
 	/* skip cache aware load balance for too many threads */
 	if (invalid_llc_nr(grp, p, dst_cpu) ||
-	    exceed_llc_capacity(grp, dst_cpu)) {
+	    exceed_llc_capacity(grp, dst_cpu, numab_enabled)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
 		return mig_unrestricted;
@@ -11060,7 +11081,8 @@ migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
  * Check if migrating task p from env->src_cpu to
  * env->dst_cpu breaks LLC localiy.
  */
-static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
+static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env,
+				 bool numab_enabled)
 {
 	if (!sched_cache_enabled())
 		return false;
@@ -11087,7 +11109,7 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	if (migrate_llc_task_wrong_dst(p, env))
 		return true;
 
-	if (can_migrate_llc_task(env, p) != mig_forbid)
+	if (can_migrate_llc_task(env, p, numab_enabled) != mig_forbid)
 		return false;
 
 	return true;
@@ -11113,7 +11135,8 @@ migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
 }
 
 static inline bool
-migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
+migrate_degrades_llc(struct task_struct *p, struct lb_env *env,
+		     bool numab_enabled)
 {
 	return false;
 }
@@ -11125,6 +11148,7 @@ static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	long degrades, hot;
+	bool numab_enabled;
 
 	lockdep_assert_rq_held(env->src_rq);
 	if (p->sched_task_hot)
@@ -11213,14 +11237,15 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (env->flags & LBF_ACTIVE_LB)
 		return !migrate_llc_task_wrong_dst(p, env);
 
-	degrades = migrate_degrades_locality(p, env);
+	numab_enabled = task_numab_enabled();
+	degrades = migrate_degrades_locality(p, env, numab_enabled);
 	if (!degrades) {
 		/*
 		 * If the NUMA locality is not broken,
 		 * further check if migration would hurt
 		 * LLC locality.
 		 */
-		if (migrate_degrades_llc(p, env)) {
+		if (migrate_degrades_llc(p, env, numab_enabled)) {
 			/*
 			 * If regular load balancing fails to pull a task
 			 * due to LLC locality, this is expected behavior
-- 
2.52.0

