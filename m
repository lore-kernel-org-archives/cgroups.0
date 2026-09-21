Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA03939C9
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 19:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018792; cv=none; b=Uxzir/f4l1UZzlddA1idsJuV39B2S5sM9VdRuJFHwtm7tllF7rNMFhcI0pKUr5IoR1+YTNOWaMO0bP5wf213zLA81doMmzl7jOiIDcqVIDCjbwAJXaM15gOv0IIFgsyqpRVAfyKbHgJpGeIfn21oIYG/rnQsMcwqH2FHataNlqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018792; c=relaxed/simple;
	bh=4jN9R36egL4VbLgEQnL5XK49Oe5ZOfWY6kBaMsR1BSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlqwUzOPKP0GeSsa2U/f+cb4XXQjixPArBLkjO3lLZvW1zXWu6v/rHoXSaHG5COmX6pdSXlmNz1npPTJ/IzMOcK6sO5/JNbMWQaZWSIQPo5ImTm6vZ+YPlf3WTgX9ULvhdUg++OfzrXFGt+ZtRfxiHDl59fZ3lKGUu9wGlLGSaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fd30Z+xm; arc=none smtp.client-ip=95.215.58.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fd30Z+xm"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4jN9R36egL4VbLgEQnL5XK49Oe5ZOfWY6kBaMsR1BSA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018787; v=1; x=1790623587;
 b=fd30Z+xmERNSfxlCfvTJoTqWMA5iM2XfUDK4VqaRQut2kOI9t5JsbEkSJuBV0qJOGbu1nsZF
 ceg5yKYs5LEm5G0maUdWO+xdwJJAG6oGyS9uyt9pArfZTp5gpGI843uYd11JzkHnG7TKAQZOQYk
 dsDFRQOAwpYXTH4aZsN3nfco=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5760c232baafb0d6;
	Mon, 21 Sep 2026 19:26:27 +0000
X-Mizu-Trace-ID: 5760c232baafb0d6
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/4] memcg_ext: allow BPF to defer memory.high enforcement
Date: Mon, 21 Sep 2026 12:25:58 -0700
Message-ID: <20260921192559.2619635-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before it returns, try_charge_memcg() calls __mem_cgroup_handle_over_high(),
which reclaims and can throttle the task.  That happens wherever the charge
happens, so a task holding a kernel lock can be stuck there, and everything
waiting on the lock is stuck behind it.

Let's add high_policy ops through which a program gets a read-only snapshot
of the charge and returns a request.  There is one so far:
BPF_MEMCG_HIGH_DEFER_INLINE skips the inline call.

A charge runs the policies of its cgroup and of every ancestor.
task_struct::in_bpf_memcg stops a program that allocates from re-entering
the charge path and the dispatcher with it.

A memcg outlives its cgroup while it has charges, and cgroup_bpf_release()
frees the arrays when the cgroup goes. Take the reference for the walk.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 MAINTAINERS                    |  1 +
 include/linux/bpf-cgroup.h     |  3 ++
 include/linux/bpf_memcontrol.h | 53 +++++++++++++++++++++-
 include/linux/cgroup.h         |  7 +++
 include/linux/sched.h          |  4 ++
 mm/bpf_memcontrol.c            | 82 +++++++++++++++++++++++++++++++++-
 mm/memcontrol.c                | 31 ++++++++++++-
 7 files changed, 176 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6215fcb07770..0c84beab396f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5032,6 +5032,7 @@ L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/bpf_memcontrol.c
+F:	include/linux/bpf_memcontrol.h
 
 BPF [MISC]
 L:	bpf@vger.kernel.org
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 4e8150848bd2..e19cf83e58f3 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -517,6 +517,9 @@ static inline int cgroup_bpf_struct_ops_attach(struct bpf_map *map,
 
 #define cgroup_bpf_enabled(atype) (0)
 #define cgroup_bpf_enabled_runtime(atype) (0)
+/* Nothing can be attached, so the walk has nothing to walk. */
+#define bpf_cgroup_struct_ops_foreach(var, item, cgrp, atype)		\
+	for ((void)(cgrp), (item) = NULL, (var) = NULL; 0; )
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) ({ 0; })
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
index 8204d894761e..76ea5d1c3d32 100644
--- a/include/linux/bpf_memcontrol.h
+++ b/include/linux/bpf_memcontrol.h
@@ -5,13 +5,62 @@
  * A bpf_memcg_ops is attached to a cgroup.  A charge runs the policies of
  * that cgroup and of every ancestor, and the kernel combines what they
  * return.  BPF only picks between things the kernel already does.
- *
- * The type has no members yet; they come with the policies that use them.
  */
 #ifndef _LINUX_BPF_MEMCONTROL_H
 #define _LINUX_BPF_MEMCONTROL_H
 
+#include <linux/types.h>
+#include <linux/gfp_types.h>
+
+struct mem_cgroup;
+struct task_struct;
+
+/*
+ * What a policy can ask for when a cgroup is over memory.high.  The kernel
+ * ORs them, so one policy cannot undo another.
+ */
+enum bpf_memcg_high_request {
+	BPF_MEMCG_HIGH_NO_OPINION	= 0,
+	/*
+	 * Skip the inline reclaim and throttle.  The debt is kept and paid on
+	 * the way back to userspace, where no kernel locks are held.
+	 */
+	BPF_MEMCG_HIGH_DEFER_INLINE	= 1U << 0,
+};
+
+#define BPF_MEMCG_HIGH_VALID_MASK	BPF_MEMCG_HIGH_DEFER_INLINE
+
+/* Read-only snapshot.  Only values the caller already has. */
+struct bpf_memcg_ctx {
+	struct mem_cgroup	*memcg;			/* charged memcg */
+	struct mem_cgroup	*memcg_over_limit;	/* NULL if none found */
+	struct task_struct	*task;			/* current */
+	u64			cgroup_id;
+	u64			over_limit_cgroup_id;	/* 0 if none */
+	u64			nr_pages_over_high;
+	u32			gfp_flags;
+};
+
 struct bpf_memcg_ops {
+	/**
+	 * high_policy - say where memory.high should be enforced
+	 * @ctx: snapshot of the charge
+	 *
+	 * Return: bits from enum bpf_memcg_high_request, or 0.  Other bits
+	 * are dropped.
+	 */
+	u32 (*high_policy)(const struct bpf_memcg_ctx *ctx);
 };
 
+/*
+ * Run every high_policy on @memcg's cgroup and its ancestors, and return the
+ * combined request for the caller to act on.
+ *
+ * @memcg:	the memcg being charged, never NULL
+ * @over_limit:	first memcg found over memory.high or swap.high, or NULL
+ * @gfp_mask:	the charge's gfp mask
+ */
+u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
+			  struct mem_cgroup *over_limit, gfp_t gfp_mask);
+
 #endif /* _LINUX_BPF_MEMCONTROL_H */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5dfa915a630e..cf92b6cec819 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -959,10 +959,17 @@ static inline void cgroup_bpf_put(struct cgroup *cgrp)
 	percpu_ref_put(&cgrp->bpf.refcnt);
 }
 
+/* Fails once the cgroup is gone and its bpf state has been freed. */
+static inline bool cgroup_bpf_tryget_live(struct cgroup *cgrp)
+{
+	return percpu_ref_tryget_live_rcu(&cgrp->bpf.refcnt);
+}
+
 #else /* CONFIG_CGROUP_BPF */
 
 static inline void cgroup_bpf_get(struct cgroup *cgrp) {}
 static inline void cgroup_bpf_put(struct cgroup *cgrp) {}
+static inline bool cgroup_bpf_tryget_live(struct cgroup *cgrp) { return false; }
 
 #endif /* CONFIG_CGROUP_BPF */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b3d47a325cc..4b20a346aaa8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1031,6 +1031,10 @@ struct task_struct {
 #ifdef CONFIG_MEMCG_V1
 	unsigned			in_user_fault:1;
 #endif
+#ifdef CONFIG_MEMCG
+	/* A bpf_memcg_ops program is running; do not recurse into policy */
+	unsigned			in_bpf_memcg:1;
+#endif
 #ifdef CONFIG_LRU_GEN
 	/* whether the LRU algorithm may apply to this access */
 	unsigned			in_lru_fault:1;
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index fd6dff150f01..cfd0f1d443c9 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -246,8 +246,17 @@ static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
  * request and the kernel acts on it.  Nothing here reclaims or sleeps.
  */
 
-/* CFI stubs.  A slot points at these while its policy is being detached. */
+/*
+ * CFI stubs.  These really run: a slot points at them while its policy is
+ * being detached.  Return 0, the identity for the kernel's OR.
+ */
+static u32 high_policy_stub(const struct bpf_memcg_ctx *ctx)
+{
+	return BPF_MEMCG_HIGH_NO_OPINION;
+}
+
 static struct bpf_memcg_ops __bpf_memcg_ops = {
+	.high_policy = high_policy_stub,
 };
 
 static const struct bpf_func_proto *
@@ -326,6 +335,77 @@ static struct bpf_struct_ops bpf_memcg_ops_desc = {
 	 */
 };
 
+static void bpf_memcg_ctx_init(struct bpf_memcg_ctx *ctx,
+			       struct mem_cgroup *memcg,
+			       struct mem_cgroup *over_limit, gfp_t gfp_mask)
+{
+	ctx->memcg = memcg;
+	ctx->memcg_over_limit = over_limit;
+	ctx->task = current;
+	ctx->cgroup_id = cgroup_id(memcg->css.cgroup);
+	ctx->over_limit_cgroup_id = over_limit ?
+		cgroup_id(over_limit->css.cgroup) : 0;
+	ctx->nr_pages_over_high = current->memcg_nr_pages_over_high;
+	ctx->gfp_flags = (__force u32)gfp_mask;
+}
+
+u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
+			  struct mem_cgroup *over_limit, gfp_t gfp_mask)
+{
+	const struct bpf_prog_array_item *item;
+	const struct bpf_memcg_ops *ops;
+	struct bpf_memcg_ctx ctx;
+	u32 acc = BPF_MEMCG_HIGH_NO_OPINION;
+	struct cgroup *cgrp;
+
+	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
+		return acc;
+
+	/*
+	 * Only the default hierarchy has a cgroup_bpf, and the static key is
+	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
+	 * v1 memcg still cannot get here, because memory.high and swap.high
+	 * are both v2-only and so it never builds the debt that leads to this
+	 * call.  A hook on a path v1 can reach needs its own cgroup_on_dfl()
+	 * test: a v1 cgroup has no effective array and an uninitialised
+	 * cgrp->bpf.refcnt.
+	 */
+	cgrp = memcg->css.cgroup;
+
+	/*
+	 * A program can allocate and re-enter the charge path.  Skip the
+	 * nested call.  This guards the callbacks only.
+	 */
+	if (current->in_bpf_memcg)
+		return acc;
+	current->in_bpf_memcg = 1;
+
+	rcu_read_lock_dont_migrate();
+
+	/*
+	 * A memcg outlives its cgroup while it has charges, and
+	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
+	 */
+	if (!cgroup_bpf_tryget_live(cgrp))
+		goto out;
+
+	bpf_memcg_ctx_init(&ctx, memcg, over_limit, gfp_mask);
+
+	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {
+		if (ops->high_policy)
+			acc |= ops->high_policy(&ctx) &
+			       BPF_MEMCG_HIGH_VALID_MASK;
+	}
+
+	cgroup_bpf_put(cgrp);
+out:
+	rcu_read_unlock_migrate();
+
+	current->in_bpf_memcg = 0;
+
+	return acc;
+}
+
 static int __init bpf_memcg_ops_register(void)
 {
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..bc283680640b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -28,6 +28,7 @@
 #include <linux/cgroup-defs.h>
 #include <linux/page_counter.h>
 #include <linux/memcontrol.h>
+#include <linux/bpf_memcontrol.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/sched/mm.h>
@@ -2642,9 +2643,26 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+/*
+ * Ask the attached bpf_memcg_ops whether to skip the inline memory.high
+ * reclaim and throttle.
+ *
+ * @memcg:	the memcg being charged
+ * @over_limit:	first memcg found over memory.high or swap.high, starting at
+ *		the charged one, or NULL if the walk found none
+ */
+static bool bpf_memcg_high_defer(struct mem_cgroup *memcg,
+				 struct mem_cgroup *over_limit, gfp_t gfp_mask)
+{
+	u32 req = bpf_memcg_high_policy(memcg, over_limit, gfp_mask);
+
+	return req & BPF_MEMCG_HIGH_DEFER_INLINE;
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
+	struct mem_cgroup *leaf_memcg = memcg;
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
@@ -2846,8 +2864,17 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
+	    gfpflags_allow_blocking(gfp_mask)) {
+		/*
+		 * The loop above left @memcg as the first memcg it found over
+		 * memory.high or swap.high -- possibly the charged one itself
+		 * -- or NULL if it found none.  Note the debt can be left over
+		 * from an earlier charge, so NULL does not mean no pressure.
+		 * The policy wants the memcg we charged.
+		 */
+		if (!bpf_memcg_high_defer(leaf_memcg, memcg, gfp_mask))
+			__mem_cgroup_handle_over_high(gfp_mask);
+	}
 	return 0;
 }
 
-- 
2.53.0-Meta

