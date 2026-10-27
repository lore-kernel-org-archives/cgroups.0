Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.192
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793092368;
	b=2EU5QqU4nUI+28KQPg9GDe12sI/PR7zorYIj/mp/TJt+Q49oKBAyvQy8Ag4Ree2hubBC
	 2ABCxWMrElm9B1voV0woo4OMo0LfkehQaShAb5HQw1bzi9g5DVdaoJMTu0HwYKBZ3wELQ
	 INrWU07gnvIcmw9y4XzVSO+qYzeHbQiV98LsVscm9u3OS8kdzP30HHCoHpMF87mNDzHbj
	 Ngpi87eggIKzqfeFKhPuA9tbvaFcdwWSKRDC+9ZBusq0vH6qeuS9BEI/f7Wh1k+AqhuGc
	 xpyjKhXoqsGPKqD+Lcmumz6tCGkDJMrsM8RxzDLqPRrTtFAgRbgxe9OZU2+xQDlrhzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092368;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k/dTFSfGJ7Wol96B6/xB0ZxDvyvOOn0OtSCdq6jxfcY=;
	b=V/3WhxdoB/E8qGrB/wQnVth/Yso5ORAlmO49mvJguJVnTdMGGDsG8cJfbsxslSrecr5/
	 F2jYS60Q3iZf6H2zec/iaN0uU7/IXDhYNChkC6pVNKBwM/fVYmo9n7V3pVlngO9m/EzaZ
	 2ioJE+mRrLJ6zoL/N9lD97gZsW7GZbGaDdpbVklj0xMllBMyT7pr94fBEkVd/McLUL49S
	 JldfarPxjgA1mfVZ9N8UlDGzu/8QNME4TTQkeOg2812/VQsqIQHdz7QAm84dvAyvg+mwK
	 xpxWsvadnPI8MLd726cqE8qj0pcu1Ang6PCVIqDPr8GH922x+VUvPdC8pHK8//HCVoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FTD19RQG;
	arc=none smtp.remote-ip=91.218.175.192
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF46606A31A
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 09:12:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DF46606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FTD19RQG
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KAl5IqRhG4ZYvj+INYntsB2zYazNnfYB3228GT+ZllY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793092365; v=1; x=1793697165;
 b=FTD19RQGo1TUuC/Q2hXxyF78a3FGIMNnCkgAvrORRTJY5FLdzS04UzHvjcX3Y7eco2TNu1XK
 LSy2+E77mfX9v+LDtk+iSaDwNQ5ZsIPV+BFcID/6wVsoY7I2DdMiRiCQ9jNf1SUJxhEzjnafvDt
 1x1fk7pQ/kggm28X1mTun1bU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id dc19a8d0d3dac675;
	Tue, 27 Oct 2026 09:12:45 +0000
X-Mizu-Trace-ID: dc19a8d0d3dac675
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
Subject: [RFC PATCH 1/2] memcg_ext: add memory.low and memory.min protection policies
Date: Tue, 27 Oct 2026 17:11:59 +0800
Message-ID: <1fb433ab13bd56211b6b7c76a1e26e19e42108a1.1793086858.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1793086858.git.zhuhui@kylinos.cn>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
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

mem_cgroup_below_low() and mem_cgroup_below_min() decide whether
reclaim may touch a cgroup by comparing the effective threshold
against usage.  The comparison is fixed, so a workload that wants
protection on other terms has no way to ask for it.

Add low_policy and min_policy to bpf_memcg_ops.  A program gets a
read-only snapshot of the check: the memcg, the reclaim target, the
threshold and the usage.  It returns a request, and there is one so
far: BPF_MEMCG_PROT_BELOW treats the cgroup as below its threshold,
so reclaim skips it.

The kernel compares first and asks BPF only when it found the cgroup
unprotected.  A check runs the policies of the cgroup and of every
ancestor and ORs what they return, so a policy can only add
protection, never take it away.  Reclaim then treats the cgroup as
below its threshold throughout, which includes counting it in
memory.events.

Both dispatchers share one walk setup and teardown, factored out
of the high dispatcher.  The setup carries the
task_struct::in_bpf_memcg re-entry guard and a cgroup_on_dfl()
test: a v1 cgroup has no effective array and an uninitialised
cgrp->bpf.refcnt.  The memory.high debt is v2-only, so a v1 memcg
never reached the high dispatcher and no reachable path of it
changes, but it does reach the protection checks: emin and elow
stay 0 and reclaim still asks.

Guard the dispatcher declarations with CONFIG_BPF_SYSCALL and add
stubs so every supported configuration builds.  mm/bpf_memcontrol.c
is built only with struct_ops support, while CONFIG_MEMCG does not
select it, which already left bpf_memcg_high_policy() undefined at
link time.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/bpf_memcontrol.h | 104 ++++++++++++++++++++-
 include/linux/memcontrol.h     |  23 ++++-
 mm/bpf_memcontrol.c            | 162 ++++++++++++++++++++++++++-------
 3 files changed, 247 insertions(+), 42 deletions(-)

diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
index 76ea5d1c3d32..53222e57ae4a 100644
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
@@ -30,6 +30,22 @@ enum bpf_memcg_high_request {
 
 #define BPF_MEMCG_HIGH_VALID_MASK	BPF_MEMCG_HIGH_DEFER_INLINE
 
+/*
+ * What a policy can ask for when the kernel checks memory.low or memory.min
+ * protection.  The kernel ORs them, so one policy cannot undo another.
+ */
+enum bpf_memcg_prot_request {
+	BPF_MEMCG_PROT_NO_OPINION	= 0,
+	/*
+	 * Treat the cgroup as below its threshold, so reclaim skips it.  This
+	 * only adds protection: a policy cannot expose a cgroup the kernel
+	 * already considers below its threshold.
+	 */
+	BPF_MEMCG_PROT_BELOW		= 1U << 0,
+};
+
+#define BPF_MEMCG_PROT_VALID_MASK	BPF_MEMCG_PROT_BELOW
+
 /* Read-only snapshot.  Only values the caller already has. */
 struct bpf_memcg_ctx {
 	struct mem_cgroup	*memcg;			/* charged memcg */
@@ -41,6 +57,21 @@ struct bpf_memcg_ctx {
 	u32			gfp_flags;
 };
 
+/*
+ * Read-only snapshot of a protection check.  @threshold is the effective
+ * memory.low for low_policy and the effective memory.min for min_policy, and
+ * the kernel has already found it below @usage.
+ */
+struct bpf_memcg_prot_ctx {
+	struct mem_cgroup	*memcg;			/* cgroup checked */
+	struct mem_cgroup	*target;		/* NULL for global reclaim */
+	struct task_struct	*task;			/* current */
+	u64			cgroup_id;
+	u64			target_cgroup_id;	/* 0 if none */
+	u64			threshold;		/* elow or emin, pages */
+	u64			usage;			/* pages */
+};
+
 struct bpf_memcg_ops {
 	/**
 	 * high_policy - say where memory.high should be enforced
@@ -50,8 +81,35 @@ struct bpf_memcg_ops {
 	 * are dropped.
 	 */
 	u32 (*high_policy)(const struct bpf_memcg_ctx *ctx);
+
+	/**
+	 * low_policy - say whether a cgroup is below its memory.low
+	 * @ctx: snapshot of the protection check
+	 *
+	 * Only runs once the kernel has found @ctx->usage above
+	 * @ctx->threshold, so a policy can only add protection.  Reclaim then
+	 * treats the cgroup as below memory.low throughout, which includes
+	 * counting it in memory.events.
+	 *
+	 * Return: bits from enum bpf_memcg_prot_request, or 0.  Other bits
+	 * are dropped.
+	 */
+	u32 (*low_policy)(const struct bpf_memcg_prot_ctx *ctx);
+
+	/**
+	 * min_policy - say whether a cgroup is below its memory.min
+	 * @ctx: snapshot of the protection check
+	 *
+	 * Same as low_policy, for the hard memory.min protection.
+	 *
+	 * Return: bits from enum bpf_memcg_prot_request, or 0.  Other bits
+	 * are dropped.
+	 */
+	u32 (*min_policy)(const struct bpf_memcg_prot_ctx *ctx);
 };
 
+#if IS_ENABLED(CONFIG_BPF_SYSCALL)
+
 /*
  * Run every high_policy on @memcg's cgroup and its ancestors, and return the
  * combined request for the caller to act on.
@@ -63,4 +121,44 @@ struct bpf_memcg_ops {
 u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
 			  struct mem_cgroup *over_limit, gfp_t gfp_mask);
 
+/*
+ * Run every low_policy or min_policy on @memcg's cgroup and its ancestors,
+ * and return the combined request for the caller to act on.
+ *
+ * @memcg:	the memcg whose protection is being checked, never the root
+ * @target:	the reclaim root, or NULL for global reclaim
+ * @elow/@emin:	the effective threshold, in pages
+ * @usage:	the current usage, in pages
+ */
+u32 bpf_memcg_low_policy(struct mem_cgroup *memcg, struct mem_cgroup *target,
+			 unsigned long elow, unsigned long usage);
+u32 bpf_memcg_min_policy(struct mem_cgroup *memcg, struct mem_cgroup *target,
+			 unsigned long emin, unsigned long usage);
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
+static inline u32 bpf_memcg_low_policy(struct mem_cgroup *memcg,
+				       struct mem_cgroup *target,
+				       unsigned long elow, unsigned long usage)
+{
+	return BPF_MEMCG_PROT_NO_OPINION;
+}
+
+static inline u32 bpf_memcg_min_policy(struct mem_cgroup *memcg,
+				       struct mem_cgroup *target,
+				       unsigned long emin, unsigned long usage)
+{
+	return BPF_MEMCG_PROT_NO_OPINION;
+}
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 #endif /* _LINUX_BPF_MEMCONTROL_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..3f937be7b057 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/bpf_memcontrol.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -621,21 +622,35 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 					struct mem_cgroup *memcg)
 {
+	unsigned long elow, usage;
+
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.elow) >=
-		page_counter_read(&memcg->memory);
+	elow = READ_ONCE(memcg->memory.elow);
+	usage = page_counter_read(&memcg->memory);
+	if (elow >= usage)
+		return true;
+
+	return bpf_memcg_low_policy(memcg, target, elow, usage) &
+	       BPF_MEMCG_PROT_BELOW;
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 					struct mem_cgroup *memcg)
 {
+	unsigned long emin, usage;
+
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.emin) >=
-		page_counter_read(&memcg->memory);
+	emin = READ_ONCE(memcg->memory.emin);
+	usage = page_counter_read(&memcg->memory);
+	if (emin >= usage)
+		return true;
+
+	return bpf_memcg_min_policy(memcg, target, emin, usage) &
+	       BPF_MEMCG_PROT_BELOW;
 }
 
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index cfd0f1d443c9..999d2012abd4 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -255,8 +255,20 @@ static u32 high_policy_stub(const struct bpf_memcg_ctx *ctx)
 	return BPF_MEMCG_HIGH_NO_OPINION;
 }
 
+static u32 low_policy_stub(const struct bpf_memcg_prot_ctx *ctx)
+{
+	return BPF_MEMCG_PROT_NO_OPINION;
+}
+
+static u32 min_policy_stub(const struct bpf_memcg_prot_ctx *ctx)
+{
+	return BPF_MEMCG_PROT_NO_OPINION;
+}
+
 static struct bpf_memcg_ops __bpf_memcg_ops = {
 	.high_policy = high_policy_stub,
+	.low_policy = low_policy_stub,
+	.min_policy = min_policy_stub,
 };
 
 static const struct bpf_func_proto *
@@ -264,7 +276,7 @@ bpf_memcg_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	/*
 	 * The base set is all a policy needs today, and none of it sleeps.
-	 * Anything added here must be safe from the charge path.
+	 * Anything added here must be safe from the charge and reclaim paths.
 	 */
 	return bpf_base_func_proto(func_id, prog);
 }
@@ -293,7 +305,7 @@ static int bpf_memcg_check_member(const struct btf_type *t,
 				  const struct btf_member *member,
 				  const struct bpf_prog *prog)
 {
-	/* Members run from the charge path, which cannot sleep. */
+	/* Members run from the charge and reclaim paths, which cannot sleep. */
 	if (prog->sleepable)
 		return -EINVAL;
 
@@ -335,6 +347,62 @@ static struct bpf_struct_ops bpf_memcg_ops_desc = {
 	 */
 };
 
+/*
+ * Prepare to run the policies attached to @memcg's cgroup and its ancestors.
+ *
+ * On success returns the cgroup with its bpf reference held, inside the RCU
+ * section the effective array walk needs; the caller finishes with
+ * bpf_memcg_walk_end().  NULL means no policy can run and the caller keeps
+ * the request it started with: nothing is attached anywhere, the cgroup is
+ * on a v1 hierarchy, this task is already inside a policy, or the cgroup is
+ * going.
+ */
+static inline struct cgroup *bpf_memcg_walk_begin(struct mem_cgroup *memcg)
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
+	 * A program can allocate and re-enter the charge path, and reclaim
+	 * with it.  Skip the nested call.  This guards the callbacks only.
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
@@ -358,36 +426,9 @@ u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
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
 
@@ -397,15 +438,66 @@ u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
 			       BPF_MEMCG_HIGH_VALID_MASK;
 	}
 
-	cgroup_bpf_put(cgrp);
-out:
-	rcu_read_unlock_migrate();
+	bpf_memcg_walk_end(cgrp);
 
-	current->in_bpf_memcg = 0;
+	return acc;
+}
+
+/*
+ * Run every low_policy (@is_min false) or min_policy (@is_min true) on
+ * @memcg's cgroup and its ancestors, and return the combined request.
+ */
+static u32 bpf_memcg_prot_policy(struct mem_cgroup *memcg,
+				 struct mem_cgroup *target,
+				 unsigned long threshold, unsigned long usage,
+				 bool is_min)
+{
+	const struct bpf_prog_array_item *item;
+	const struct bpf_memcg_ops *ops;
+	struct bpf_memcg_prot_ctx ctx;
+	u32 acc = BPF_MEMCG_PROT_NO_OPINION;
+	struct cgroup *cgrp;
+
+	cgrp = bpf_memcg_walk_begin(memcg);
+	if (!cgrp)
+		return acc;
+
+	ctx = (struct bpf_memcg_prot_ctx) {
+		.memcg			= memcg,
+		.target			= target,
+		.task			= current,
+		.cgroup_id		= cgroup_id(cgrp),
+		.target_cgroup_id	= target ?
+					cgroup_id(target->css.cgroup) : 0,
+		.threshold		= threshold,
+		.usage			= usage,
+	};
+
+	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {
+		u32 (*policy)(const struct bpf_memcg_prot_ctx *ctx);
+
+		policy = is_min ? ops->min_policy : ops->low_policy;
+		if (policy)
+			acc |= policy(&ctx) & BPF_MEMCG_PROT_VALID_MASK;
+	}
+
+	bpf_memcg_walk_end(cgrp);
 
 	return acc;
 }
 
+u32 bpf_memcg_low_policy(struct mem_cgroup *memcg, struct mem_cgroup *target,
+			 unsigned long elow, unsigned long usage)
+{
+	return bpf_memcg_prot_policy(memcg, target, elow, usage, false);
+}
+
+u32 bpf_memcg_min_policy(struct mem_cgroup *memcg, struct mem_cgroup *target,
+			 unsigned long emin, unsigned long usage)
+{
+	return bpf_memcg_prot_policy(memcg, target, emin, usage, true);
+}
+
 static int __init bpf_memcg_ops_register(void)
 {
 	/*
-- 
2.43.0

