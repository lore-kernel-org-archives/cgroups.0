Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794393548;
	b=p2elfmNrW4o+C7bFwrX7eD6irWZFkBIslgqWD2u9iToNm4zazF0xrp6P+Z7Gv3zJPfTq
	 ZFnDLITd3LFB+UjDV0JRVgtlcaV3ZFnHsIz3UtCIAeV/CTkXkd+GVF0A2cL0j5P33kD1K
	 GBU8vgunbjuntvM4lLrxaugwVou9totiQ2HDZTib2sIyk7Yquey9bD9IphJvIkJ8XRTee
	 qF4K4oQgTZBSNR2335OasSc+xjbR4Yil3h0pbWJRVUc4LVbVVdOeQxvXLCB06sLHP8qND
	 MTV4dW4e0n9S6regYDkQxg65mbfrI3qomp8KQ/qfypD8lepLLkucZe0PLLdTUDbzjnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794393548;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wC+ypfVGF9dbGZrkyug3fFCYQudLINanyiWwkic2KBg=;
	b=WDWaiz6IZkivUPj9Tffzc+S82SgUD8I3dOYFuDsQ/NV6MUrGYjZAu0IwgMrD/NByE4rQ
	 P3Ii+Je++/+1ZnrrYLy3jOR+TXxPa8yscIAMYTbX+5U6vktYUpluj4AvXg2GkjwuM/Ci8
	 hQjom0pjwClF1XjC97DB80gXlAbCz8VfQOF6D3C3R9TPTeGaqhG0wTTZlvbzE1kzhbfQR
	 JuxJXlCZvuRi7PWnsvGglPRUnNM3E/AOow6u8ivu9MsHDCRR0vsexOcVJDm0m5qVYT7lW
	 KT4QKKYM2gxYcWzrgOKu3g8jWHqh8yvKPkGHkuesHF5r3WNAQaXtxAU3lO69YjgJK8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TH1bs1Gg;
	arc=none smtp.remote-ip=91.218.175.1
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65F0606A886
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 10:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A65F0606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TH1bs1Gg
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jbz0GqbDMLjQcTOreqYFSh2aWXyMruT0eu65kIuWv7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794393545; v=1; x=1794998345;
 b=TH1bs1GgYW8sLRc55dan5zOK6C8ALRGsopx31slGmYfjLO4p5laWbQ0O5hNSMObUD06AtAnM
 KBq1gk0yDpT2ddsP3EzAx12smzsOBnIC3ekZzufVNMufcfBbCa9EEz2Gni7xnG8nPi2MGDDsGD4
 yZJNpv5lmTHnf526W4RBF7qs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id c55d2b7147ad9bde;
	Wed, 11 Nov 2026 10:39:04 +0000
X-Mizu-Trace-ID: c55d2b7147ad9bde
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH v2 1/2] memcg_ext: arbitrate low protection requests like memory.low
Date: Wed, 11 Nov 2026 18:38:15 +0800
Message-ID: <dc1b5d1aa01bd71d3c2e0640bccbda2b8fda8be5.1794393349.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794393349.git.zhuhui@kylinos.cn>
References: <cover.1794393349.git.zhuhui@kylinos.cn>
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

From: Hui Zhu <zhuhui@kylinos.cn>

low_policy and min_policy ran after the effective value had already
been computed, and BELOW made reclaim skip the cgroup outright.  That
bypasses the cap effective_protection() applies at subsequent levels:
a policy attached by a delegated tenant to its own cgroup could grant
itself protection its parent never afforded.

Collect the request before the effective value is computed instead,
and arbitrate it like a declared memory.low: what a cgroup claims is
the larger of memory.low and the request, still capped by the parent's
effective protection and shared out with the siblings.  A request can
move protection around inside the parent's budget but cannot lift the
subtree above it.  What is left to the policy is when and on what
evidence to ask - every pass, where the effective value is derived -
not how much it can get.

This round covers memory.low only.  The RFC's min_policy is dropped:
hard protection has no fallback once nothing else is reclaimable, so a
request recomputed every pass could OOM cgroups that never agreed to
the policy.  A memory.min counterpart can be revisited once that has
an answer.

The callback moves from mem_cgroup_below_low() to
mem_cgroup_calculate_protection() and its _path() variant; both
helpers keep their signatures and memcontrol.h drops the include.  The
request is recomputed on every pass and reported as none when no
program can run, so detaching the last program drops what it asked for
on the next pass - nothing to clean up.  The cost is a callback for
every cgroup reclaim visits (with MGLRU, every memcg on the node);
with nothing attached that is a page counter read, a static key check
and one comparison.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/bpf_memcontrol.h |  97 ++++++++++++++++++++-
 include/linux/page_counter.h   |   8 ++
 mm/bpf_memcontrol.c            | 155 +++++++++++++++++++++++++--------
 mm/memcontrol.c                |  30 +++++++
 mm/page_counter.c              |  51 ++++++++++-
 5 files changed, 299 insertions(+), 42 deletions(-)

diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
index 76ea5d1c3d32..23ee0d29bd24 100644
--- a/include/linux/bpf_memcontrol.h
+++ b/include/linux/bpf_memcontrol.h
@@ -2,9 +2,9 @@
 /*
  * BPF policy hooks for the memory controller.
  *
- * A bpf_memcg_ops is attached to a cgroup.  A charge runs the policies of
- * that cgroup and of every ancestor, and the kernel combines what they
- * return.  BPF only picks between things the kernel already does.
+ * A bpf_memcg_ops is attached to a cgroup.  A hook runs the policies of that
+ * cgroup and of every ancestor, and the kernel combines what they return.
+ * BPF only picks between things the kernel already does.
  */
 #ifndef _LINUX_BPF_MEMCONTROL_H
 #define _LINUX_BPF_MEMCONTROL_H
@@ -30,6 +30,25 @@ enum bpf_memcg_high_request {
 
 #define BPF_MEMCG_HIGH_VALID_MASK	BPF_MEMCG_HIGH_DEFER_INLINE
 
+/*
+ * What a policy can ask for when reclaim computes memory.low protection.
+ * The kernel takes the requests of the cgroup and of every ancestor and acts
+ * on the largest, so one policy cannot take back what another asked for, nor
+ * what the user declared in memory.low.
+ */
+enum bpf_memcg_prot_request {
+	BPF_MEMCG_PROT_NO_REQUEST	= 0,
+	/*
+	 * Ask that this cgroup's current usage be taken as its declared
+	 * memory.low for this pass.  Arbitrated exactly like a declared
+	 * value: capped by the parent's effective protection and shared
+	 * with the siblings.
+	 */
+	BPF_MEMCG_PROT_REQUEST_USAGE	= 1U << 0,
+};
+
+#define BPF_MEMCG_PROT_VALID_MASK	BPF_MEMCG_PROT_REQUEST_USAGE
+
 /* Read-only snapshot.  Only values the caller already has. */
 struct bpf_memcg_ctx {
 	struct mem_cgroup	*memcg;			/* charged memcg */
@@ -41,6 +60,22 @@ struct bpf_memcg_ctx {
 	u32			gfp_flags;
 };
 
+/*
+ * Read-only snapshot taken while reclaim is about to compute memory.low
+ * protection.  @threshold is the effective memory.low left behind by the
+ * previous calculation, not what this pass will end up with - that also
+ * depends on the request.
+ */
+struct bpf_memcg_prot_ctx {
+	struct mem_cgroup	*memcg;			/* cgroup checked */
+	struct mem_cgroup	*target;		/* NULL for global reclaim */
+	struct task_struct	*task;			/* current */
+	u64			cgroup_id;
+	u64			target_cgroup_id;	/* 0 if none */
+	u64			threshold;		/* previous elow, pages */
+	u64			usage;			/* pages */
+};
+
 struct bpf_memcg_ops {
 	/**
 	 * high_policy - say where memory.high should be enforced
@@ -50,8 +85,31 @@ struct bpf_memcg_ops {
 	 * are dropped.
 	 */
 	u32 (*high_policy)(const struct bpf_memcg_ctx *ctx);
+
+	/**
+	 * low_request - ask for memory.low protection for this pass
+	 * @ctx: snapshot of the cgroup protection is about to be computed for
+	 *
+	 * Runs before the effective memory.low is calculated, for every cgroup
+	 * reclaim visits, whether or not it is already protected.  What a
+	 * policy asks for is arbitrated together with the memory.low declared
+	 * by the cgroup and by its siblings, so a request can move protection
+	 * around inside the parent's budget but can never take the subtree
+	 * above what its parent affords.
+	 *
+	 * Only memory.low is covered for now; a memory.min counterpart is
+	 * left for later.  Hard protection has no fallback once nothing else
+	 * is reclaimable, so a request recomputed every pass needs more
+	 * thought before it is safe.
+	 *
+	 * Return: bits from enum bpf_memcg_prot_request, or 0.  Other bits
+	 * are dropped.
+	 */
+	u32 (*low_request)(const struct bpf_memcg_prot_ctx *ctx);
 };
 
+#if IS_ENABLED(CONFIG_BPF_SYSCALL)
+
 /*
  * Run every high_policy on @memcg's cgroup and its ancestors, and return the
  * combined request for the caller to act on.
@@ -63,4 +121,37 @@ struct bpf_memcg_ops {
 u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
 			  struct mem_cgroup *over_limit, gfp_t gfp_mask);
 
+/*
+ * Run every low_request on @memcg's cgroup and its ancestors, and return the
+ * protection they ask for, in pages: @usage if any of them requested it, 0 if
+ * none did.  The caller feeds the result to page_counter_set_low_req() before
+ * the effective value is computed.
+ *
+ * @memcg:	the memcg protection is about to be computed for, never the root
+ * @target:	the reclaim root, or NULL for global reclaim
+ * @usage:	the current usage, in pages
+ */
+unsigned long bpf_memcg_low_request(struct mem_cgroup *memcg,
+				    struct mem_cgroup *target,
+				    unsigned long usage);
+
+#else /* CONFIG_BPF_SYSCALL */
+
+/* mm/bpf_memcontrol.c is only built with struct_ops support. */
+static inline u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
+					struct mem_cgroup *over_limit,
+					gfp_t gfp_mask)
+{
+	return BPF_MEMCG_HIGH_NO_OPINION;
+}
+
+static inline unsigned long bpf_memcg_low_request(struct mem_cgroup *memcg,
+						  struct mem_cgroup *target,
+						  unsigned long usage)
+{
+	return 0;
+}
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 #endif /* _LINUX_BPF_MEMCONTROL_H */
diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 2baf7a2b29b2..4b03e4cafea9 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -38,6 +38,12 @@ struct page_counter {
 	bool track_failcnt;
 	unsigned long min;
 	unsigned long low;
+	/*
+	 * Protection requested for this pass by an attached policy, in pages.
+	 * Arbitrated exactly like @low - see effective_protection() - so a
+	 * request can redistribute the parent's budget but never exceed it.
+	 */
+	unsigned long low_req;
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
@@ -77,6 +83,8 @@ bool page_counter_try_charge(struct page_counter *counter,
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
+void page_counter_set_low_req(struct page_counter *counter,
+			      unsigned long nr_pages);
 
 static inline void page_counter_set_high(struct page_counter *counter,
 					 unsigned long nr_pages)
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index cfd0f1d443c9..50c243cdc7d2 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -255,8 +255,14 @@ static u32 high_policy_stub(const struct bpf_memcg_ctx *ctx)
 	return BPF_MEMCG_HIGH_NO_OPINION;
 }
 
+static u32 low_request_stub(const struct bpf_memcg_prot_ctx *ctx)
+{
+	return BPF_MEMCG_PROT_NO_REQUEST;
+}
+
 static struct bpf_memcg_ops __bpf_memcg_ops = {
 	.high_policy = high_policy_stub,
+	.low_request = low_request_stub,
 };
 
 static const struct bpf_func_proto *
@@ -264,7 +270,7 @@ bpf_memcg_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	/*
 	 * The base set is all a policy needs today, and none of it sleeps.
-	 * Anything added here must be safe from the charge path.
+	 * Anything added here must be safe from the charge and reclaim paths.
 	 */
 	return bpf_base_func_proto(func_id, prog);
 }
@@ -293,7 +299,7 @@ static int bpf_memcg_check_member(const struct btf_type *t,
 				  const struct btf_member *member,
 				  const struct bpf_prog *prog)
 {
-	/* Members run from the charge path, which cannot sleep. */
+	/* Members run from the charge and reclaim paths, which cannot sleep. */
 	if (prog->sleepable)
 		return -EINVAL;
 
@@ -335,6 +341,62 @@ static struct bpf_struct_ops bpf_memcg_ops_desc = {
 	 */
 };
 
+/*
+ * Prepare to run the policies attached to @memcg's cgroup and its ancestors.
+ *
+ * On success returns the cgroup with its bpf reference held, inside the RCU
+ * section the effective array walk needs; the caller finishes with
+ * bpf_memcg_walk_end().  NULL means no policy can run - nothing attached, a
+ * v1 hierarchy, re-entry from a policy, or a dying cgroup - and a caller
+ * collecting a request reports none.  Reporting none rather than "unchanged"
+ * is what lets a request expire on the next pass, with no detach hook.
+ */
+static inline struct cgroup *bpf_memcg_walk_begin(const struct mem_cgroup *memcg)
+{
+	struct cgroup *cgrp = memcg->css.cgroup;
+
+	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
+		return NULL;
+
+	/*
+	 * Only the default hierarchy has a cgroup_bpf, and the static key is
+	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
+	 * v1 cgroup has no effective array and an uninitialised
+	 * cgrp->bpf.refcnt.
+	 */
+	if (!cgroup_on_dfl(cgrp))
+		return NULL;
+
+	/*
+	 * A program can allocate or reclaim and re-enter a hook.  Skip the
+	 * nested call.
+	 */
+	if (current->in_bpf_memcg)
+		return NULL;
+	current->in_bpf_memcg = 1;
+
+	rcu_read_lock_dont_migrate();
+
+	/*
+	 * A memcg outlives its cgroup while it has charges, and
+	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
+	 */
+	if (!cgroup_bpf_tryget_live(cgrp)) {
+		rcu_read_unlock_migrate();
+		current->in_bpf_memcg = 0;
+		return NULL;
+	}
+
+	return cgrp;
+}
+
+static inline void bpf_memcg_walk_end(struct cgroup *cgrp)
+{
+	cgroup_bpf_put(cgrp);
+	rcu_read_unlock_migrate();
+	current->in_bpf_memcg = 0;
+}
+
 static void bpf_memcg_ctx_init(struct bpf_memcg_ctx *ctx,
 			       struct mem_cgroup *memcg,
 			       struct mem_cgroup *over_limit, gfp_t gfp_mask)
@@ -358,36 +420,9 @@ u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
 	u32 acc = BPF_MEMCG_HIGH_NO_OPINION;
 	struct cgroup *cgrp;
 
-	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
-		return acc;
-
-	/*
-	 * Only the default hierarchy has a cgroup_bpf, and the static key is
-	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
-	 * v1 memcg still cannot get here, because memory.high and swap.high
-	 * are both v2-only and so it never builds the debt that leads to this
-	 * call.  A hook on a path v1 can reach needs its own cgroup_on_dfl()
-	 * test: a v1 cgroup has no effective array and an uninitialised
-	 * cgrp->bpf.refcnt.
-	 */
-	cgrp = memcg->css.cgroup;
-
-	/*
-	 * A program can allocate and re-enter the charge path.  Skip the
-	 * nested call.  This guards the callbacks only.
-	 */
-	if (current->in_bpf_memcg)
+	cgrp = bpf_memcg_walk_begin(memcg);
+	if (!cgrp)
 		return acc;
-	current->in_bpf_memcg = 1;
-
-	rcu_read_lock_dont_migrate();
-
-	/*
-	 * A memcg outlives its cgroup while it has charges, and
-	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
-	 */
-	if (!cgroup_bpf_tryget_live(cgrp))
-		goto out;
 
 	bpf_memcg_ctx_init(&ctx, memcg, over_limit, gfp_mask);
 
@@ -397,15 +432,63 @@ u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
 			       BPF_MEMCG_HIGH_VALID_MASK;
 	}
 
-	cgroup_bpf_put(cgrp);
-out:
-	rcu_read_unlock_migrate();
-
-	current->in_bpf_memcg = 0;
+	bpf_memcg_walk_end(cgrp);
 
 	return acc;
 }
 
+/*
+ * Run every low_request on @memcg's cgroup and its ancestors, and return the
+ * protection they ask for, in pages.
+ *
+ * The requests are ORed: the combination is monotone, a policy can raise
+ * what a cgroup claims but never take back what the user declared or
+ * another policy asked for.
+ */
+unsigned long bpf_memcg_low_request(struct mem_cgroup *memcg,
+				    struct mem_cgroup *target,
+				    unsigned long usage)
+{
+	const struct bpf_prog_array_item *item;
+	const struct bpf_memcg_ops *ops;
+	struct bpf_memcg_prot_ctx ctx;
+	u32 acc = BPF_MEMCG_PROT_NO_REQUEST;
+	struct cgroup *cgrp;
+
+	cgrp = bpf_memcg_walk_begin(memcg);
+	if (!cgrp)
+		return 0;
+
+	/*
+	 * @threshold is the elow the last calculation left behind: the
+	 * request has to be known before effective_protection() runs, so
+	 * this pass's value does not exist yet.  The ctx is not const
+	 * because a program may hand ctx->memcg to the memcg kfuncs.
+	 */
+	ctx = (struct bpf_memcg_prot_ctx) {
+		.memcg			= memcg,
+		.target			= target,
+		.task			= current,
+		.cgroup_id		= cgroup_id(cgrp),
+		.target_cgroup_id	= target ?
+					cgroup_id(target->css.cgroup) : 0,
+		.threshold		= READ_ONCE(memcg->memory.elow),
+		.usage			= usage,
+	};
+
+	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {
+		u32 (*request)(const struct bpf_memcg_prot_ctx *ctx);
+
+		request = ops->low_request;
+		if (request)
+			acc |= request(&ctx) & BPF_MEMCG_PROT_VALID_MASK;
+	}
+
+	bpf_memcg_walk_end(cgrp);
+
+	return (acc & BPF_MEMCG_PROT_REQUEST_USAGE) ? usage : 0;
+}
+
 static int __init bpf_memcg_ops_register(void)
 {
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b937835d5cb7..93be8f84c0ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4490,6 +4490,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	page_counter_set_low_req(&memcg->memory, 0);
 
 	zswap_memcg_offline_cleanup(memcg);
 
@@ -4572,6 +4573,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 #endif
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	page_counter_set_low_req(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
@@ -5333,6 +5335,7 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 	bool recursive_protection =
 		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+	struct mem_cgroup *target = root;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -5340,6 +5343,19 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
+	/*
+	 * Collect the request before elow is computed: it is an input to the
+	 * arbitration.  The reclaim root's own protection is ignored, so
+	 * there is nothing to ask for there.  @target keeps the caller's
+	 * NULL, which is how a policy recognises global reclaim.
+	 */
+	if (root != memcg) {
+		unsigned long usage = page_counter_read(&memcg->memory);
+		unsigned long req = bpf_memcg_low_request(memcg, target, usage);
+
+		page_counter_set_low_req(&memcg->memory, req);
+	}
+
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
@@ -5358,6 +5374,8 @@ void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 {
 	bool recursive_protection =
 		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+	struct mem_cgroup *target = root;
+	unsigned long usage, req;
 	struct cgroup *cg;
 	int root_level, i;
 
@@ -5370,6 +5388,18 @@ void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 	if (memcg == root)
 		return;
 
+	/*
+	 * Ask for @memcg only: shrink_one() calls this per memcg, so asking
+	 * per level would multiply the cost by the depth of the tree.  The
+	 * ancestors keep the request the last top-down traversal left them
+	 * with; their elow - the cap @memcg is arbitrated against - is no
+	 * more stale than it already is for a value computed outside the
+	 * reclaim iteration.
+	 */
+	usage = page_counter_read(&memcg->memory);
+	req = bpf_memcg_low_request(memcg, target, usage);
+	page_counter_set_low_req(&memcg->memory, req);
+
 	root_level = root->css.cgroup->level;
 	cg = memcg->css.cgroup;
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 5293460831f8..e19e6cd8bebc 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -19,6 +19,16 @@ static bool track_protection(struct page_counter *c)
 	return c->protection_support;
 }
 
+/*
+ * What a counter claims as low protection: what the user declared, or what a
+ * policy requested for this pass, whichever is larger.  A request can only
+ * raise the claim, never take back what memory.low already grants.
+ */
+static unsigned long low_setting(const struct page_counter *c)
+{
+	return max(READ_ONCE(c->low), READ_ONCE(c->low_req));
+}
+
 static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
@@ -37,7 +47,7 @@ static void propagate_protected_usage(struct page_counter *c,
 			atomic_long_add(delta, &c->parent->children_min_usage);
 	}
 
-	protected = min(usage, READ_ONCE(c->low));
+	protected = min(usage, low_setting(c));
 	old_protected = atomic_long_read(&c->low_usage);
 	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->low_usage, protected);
@@ -281,6 +291,36 @@ void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
 }
 
+/**
+ * page_counter_set_low_req - set the low protection a policy requested
+ * @counter: counter
+ * @nr_pages: value to set, in pages
+ *
+ * Unlike page_counter_set_low(), this runs from reclaim and may be called
+ * for the same counter concurrently: the request is last-writer-wins, and
+ * propagate_protected_usage() keeps the parent's aggregate with an
+ * xchg-and-delta, so racing callers converge rather than leak.  A stale
+ * aggregate can skew how the siblings share the budget for one pass, but
+ * each cgroup's cap still comes from parent->elow, so no cgroup is ever
+ * protected beyond what the parent affords.
+ *
+ * Returns early when unchanged: reclaim asks on every pass for every
+ * cgroup, and re-walking to the root each time is not free.
+ */
+void page_counter_set_low_req(struct page_counter *counter,
+			      unsigned long nr_pages)
+{
+	struct page_counter *c;
+
+	if (READ_ONCE(counter->low_req) == nr_pages)
+		return;
+
+	WRITE_ONCE(counter->low_req, nr_pages);
+
+	for (c = counter; c; c = c->parent)
+		propagate_protected_usage(c, atomic_long_read(&c->usage));
+}
+
 /**
  * page_counter_memparse - memparse() for page counter limits
  * @buf: string to parse
@@ -354,6 +394,11 @@ int page_counter_memparse(const char *buf, const char *max,
  * Note that 4. and 5. are not in conflict: 4. is about protecting
  * against immediate siblings whereas 5. is about protecting against
  * neighboring subtrees.
+ *
+ * For memory.low, @setting is the larger of what the user declared and what
+ * an attached policy requested for this pass; see low_setting().  A request
+ * goes through every rule above, so it can redistribute the parent's budget
+ * among siblings but cannot lift the cap rule 2 puts on the subtree.
  */
 static unsigned long effective_protection(unsigned long usage,
 					  unsigned long parent_usage,
@@ -473,7 +518,7 @@ void page_counter_calculate_protection(struct page_counter *root,
 
 	if (parent == root) {
 		WRITE_ONCE(counter->emin, READ_ONCE(counter->min));
-		WRITE_ONCE(counter->elow, READ_ONCE(counter->low));
+		WRITE_ONCE(counter->elow, low_setting(counter));
 		return;
 	}
 
@@ -486,7 +531,7 @@ void page_counter_calculate_protection(struct page_counter *root,
 			recursive_protection));
 
 	WRITE_ONCE(counter->elow, effective_protection(usage, parent_usage,
-			READ_ONCE(counter->low),
+			low_setting(counter),
 			READ_ONCE(parent->elow),
 			atomic_long_read(&parent->children_low_usage),
 			recursive_protection));
-- 
2.43.0

