Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D41A6828;
	Sat, 18 Jul 2026 08:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362665; cv=none; b=SRHcAUafdty/Ti0LeLvgT3IL/MBPtxK1jZXuA3rFmhgUZyWat6PPY5pX3nCcLcFeN9/6vASfpM5FucpV1Y/jBuqJQrC7klBw/G+6FhogY9vBiFY1yK1eCjsGZxhzh5cZdNDgBMacgyehgy/1+jL/xEZ4+A0BSuPWXR8A0fHPNO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362665; c=relaxed/simple;
	bh=xqQZMy4XXRdPHWGvSftmAUHnE9cSBSzakTm17zk+7t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB/Z2kTaJjvzREw1vDM8It7uYU6AcBkVn/ydueu5bIiTugCrSFMXBDAG/3u3/04UyS0h3FsAlpTbm670Fn2PdbXOwQo+urP5FYBNlUec/XwIsqeT9hvnycUuwBggKYFEKNZk1cI9um2kjagYvOZWKhP/DRvHPUm5Gf2aES9M96Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQwXodLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQwXodLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9860A1F000E9;
	Sat, 18 Jul 2026 08:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362655;
	bh=HPAbqPUoITD7Ran7qZOPOjkYLMXH/fK6KcRdBTS9hG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQwXodLcyANaASdTuFNT86KVHyyUT6tSIXoOmo7yOROWMTnbkgA44i/8htJ7o4s24
	 INnfPEa5zSYfWWDft5GTE7Q8gJQezTK4R3iACSxKUdrOmABBPmTKBxSIpcxYG5AQJL
	 f8cotYiyO7Ts6naAXihG0UToS8WbZFDTGGcNJWdeValP/f4QgmHKTKPqPX3BJZyRFL
	 aoBukzDMeQ8cYrj60FXf7Sui28XTfrK0IOs+m/RQE1v1VoradYx166zJV4EkDqRLL9
	 8//SKsMTRUZA3dy+2Ss1l85qaPni/BF/U2JQNPSEfYVd4UQteaKdffkmP+hMUc3N6U
	 Z/QgIChLTEy8w==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] tools/sched_ext: scx_qmap - Consume cgroup weights through set_weight
Date: Fri, 17 Jul 2026 22:17:26 -1000
Message-ID: <20260718081727.582037-8-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
References: <20260718081727.582037-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the set_* ops delivered to the parent's sched, a parent qmap instance
now receives cgroup_set_weight for its child subs' attach points. Update
the matching sub_sched_ctx weight and redistribute() in-kernel, and drop
the userspace feed_weights() polling. This exercises the knob routing end
to end.

The self weight is fixed at 100: a cgroup's weight is its parent's knob and
not the scheduler's own business. This drops the self-weight polling and the
repartition PROG_RUN poke with it.

sub_attach seeds the slot with the cgroup's current weight, read through
bpf_cgroup_from_id(), so a weight set before the sub attaches is picked up.
A write racing the attach can still be lost until the next value-changing
cpu.weight write. Acceptable for a demo.

While at it, add a traced ops.cgroup_move() so tests can observe move
delivery.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 tools/sched_ext/scx_qmap.bpf.c |  80 +++++++++++++++++++++-----
 tools/sched_ext/scx_qmap.c     | 102 +--------------------------------
 tools/sched_ext/scx_qmap.h     |   3 +-
 3 files changed, 69 insertions(+), 116 deletions(-)

diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bpf.c
index 09aee49120c2..8b8b14309466 100644
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -1019,10 +1019,32 @@ s32 BPF_STRUCT_OPS(qmap_cgroup_init, struct cgroup *cgrp, struct scx_cgroup_init
 	return 0;
 }
 
+static void redistribute(void);
+
 void BPF_STRUCT_OPS(qmap_cgroup_set_weight, struct cgroup *cgrp, u32 weight)
 {
+	u64 cgid = cgrp->kn->id;
+	s32 i;
+
+	QMAP_TOUCH_ARENA();
+
 	if (print_msgs)
-		bpf_printk("CGRP SET %llu weight=%u", cgrp->kn->id, weight);
+		bpf_printk("CGRP SET %llu weight=%u", cgid, weight);
+
+	/*
+	 * Knobs belong to the parent, so this op carries the child subs'
+	 * attach point weights. Adjust the matching sub's share of the cid
+	 * partition. Other cgroups don't participate in the split.
+	 */
+	for (i = 0; i < MAX_SUB_SCHEDS; i++) {
+		if (qa.sub_sched_ctxs[i].cgroup_id != cgid)
+			continue;
+		if (qa.sub_sched_ctxs[i].weight != weight) {
+			qa.sub_sched_ctxs[i].weight = weight;
+			redistribute();
+		}
+		break;
+	}
 }
 
 void BPF_STRUCT_OPS(qmap_cgroup_set_bandwidth, struct cgroup *cgrp,
@@ -1033,6 +1055,14 @@ void BPF_STRUCT_OPS(qmap_cgroup_set_bandwidth, struct cgroup *cgrp,
 			   cgrp->kn->id, period_us, quota_us, burst_us);
 }
 
+void BPF_STRUCT_OPS(qmap_cgroup_move, struct task_struct *p,
+		    struct cgroup *from, struct cgroup *to)
+{
+	if (print_msgs)
+		bpf_printk("CGRP MOVE %d %llu -> %llu",
+			   p->pid, from->kn->id, to->kn->id);
+}
+
 void BPF_STRUCT_OPS(qmap_update_idle, s32 cid, bool idle)
 {
 	QMAP_TOUCH_ARENA();
@@ -1336,10 +1366,12 @@ __noinline void compute_partition(void)
 	}
 
 	/*
-	 * Snapshot membership and weights so the sum_w and share loops agree.
-	 * A mid-compute change would otherwise wrap nr_shared negative.
+	 * Snapshot membership and weights so the sum_w and share loops agree. A
+	 * mid-compute change would otherwise wrap nr_shared negative. The self
+	 * weight is fixed at the default: a cgroup's weight is its parent's
+	 * knob, not the scheduler's own business.
 	 */
-	self_w = qa.self_weight ?: 100;
+	self_w = 100;
 	bpf_for(i, 0, MAX_SUB_SCHEDS) {
 		cgid_snap[i] = qa.sub_sched_ctxs[i].cgroup_id;
 		w_snap[i] = cgid_snap[i] ? (qa.sub_sched_ctxs[i].weight ?: 100) : 0;
@@ -1565,7 +1597,7 @@ __noinline void apply_partition(void)
 
 /*
  * Recompute the split off the node's held caps and apply it. The contexts this
- * runs from (the sub-sched callbacks, the userspace poke, the rr timer) are not
+ * runs from (the sub-sched and cgroup callbacks, the rr timer) are not
  * serialized by the kernel, so a single runner does the work. A caller that
  * finds the guard held leaves part_pending set; the holder drains it before
  * releasing, with the rr timer as a backstop.
@@ -1592,14 +1624,6 @@ static void redistribute(void)
 	part_end();
 }
 
-/* userspace pokes this (PROG_RUN) to resplit after a cpu.weight change */
-SEC("syscall")
-int repartition(void *ctx)
-{
-	redistribute();
-	return 0;
-}
-
 /*
  * Userspace pokes this (PROG_RUN) to bring alloc_ns[] current before reading
  * it for the stats display. Skipping when the partition guard is held is
@@ -1849,6 +1873,33 @@ void BPF_STRUCT_OPS(qmap_exit, struct scx_exit_info *ei)
 	UEI_RECORD(uei, ei);
 }
 
+/*
+ * Seed a new sub slot with the cgroup's current weight. The kernel delivers
+ * ops.cgroup_set_weight() only on value-changing writes, so a weight set
+ * before the sub attached would otherwise go unnoticed.
+ */
+static u32 cgrp_cur_weight(u64 cgid)
+{
+	struct cgroup_subsys_state *css;
+	struct cgroup *cgrp;
+	u32 weight = 100;
+
+	cgrp = bpf_cgroup_from_id(cgid);
+	if (!cgrp)
+		return weight;
+
+	css = BPF_CORE_READ(cgrp, subsys[cpu_cgrp_id]);
+	if (css) {
+		struct task_group *tg = container_of(css, struct task_group, css);
+		u32 w = BPF_CORE_READ(tg, scx.weight);
+
+		if (w)
+			weight = w;
+	}
+	bpf_cgroup_release(cgrp);
+	return weight;
+}
+
 s32 BPF_STRUCT_OPS(qmap_sub_attach, struct scx_sub_attach_args *args)
 {
 	s32 i;
@@ -1862,7 +1913,7 @@ s32 BPF_STRUCT_OPS(qmap_sub_attach, struct scx_sub_attach_args *args)
 			continue;
 
 		qa.sub_sched_ctxs[i].cgroup_id = args->ops->sub_cgroup_id;
-		qa.sub_sched_ctxs[i].weight = 100;	/* until userspace feeds it */
+		qa.sub_sched_ctxs[i].weight = cgrp_cur_weight(args->ops->sub_cgroup_id);
 		qa.nr_sub_scheds++;
 		bpf_printk("attaching sub-sched[%d] on %s", i, args->cgroup_path);
 		redistribute();
@@ -1926,6 +1977,7 @@ SCX_OPS_CID_DEFINE(qmap_ops,
 	       .cgroup_init		= (void *)qmap_cgroup_init,
 	       .cgroup_set_weight	= (void *)qmap_cgroup_set_weight,
 	       .cgroup_set_bandwidth	= (void *)qmap_cgroup_set_bandwidth,
+	       .cgroup_move		= (void *)qmap_cgroup_move,
 	       .sub_attach		= (void *)qmap_sub_attach,
 	       .sub_detach		= (void *)qmap_sub_detach,
 	       .sub_caps_updated	= (void *)qmap_sub_caps_updated,
diff --git a/tools/sched_ext/scx_qmap.c b/tools/sched_ext/scx_qmap.c
index dda3ddf5b749..105745f51b8e 100644
--- a/tools/sched_ext/scx_qmap.c
+++ b/tools/sched_ext/scx_qmap.c
@@ -24,11 +24,6 @@
 #include "scx_qmap.h"
 #include "scx_qmap.bpf.skel.h"
 
-/* kernfs file-handle type for open_by_handle_at(), from linux/exportfs.h */
-#ifndef FILEID_KERNFS
-#define FILEID_KERNFS	0xfe
-#endif
-
 const char help_fmt[] =
 "A simple five-level FIFO queue sched_ext scheduler.\n"
 "\n"
@@ -72,7 +67,7 @@ const char help_fmt[] =
 "  -I            Turn on SCX_OPS_ALWAYS_ENQ_IMMED\n"
 "  -F COUNT      IMMED stress: force every COUNT'th enqueue to a busy local DSQ (use with -I)\n"
 "  -C MODE       cid-override test (shuffle|bad-dup|bad-range|bad-mono)\n"
-"  -i SEC        Stats and weight-refresh interval, seconds (default 5)\n"
+"  -i SEC        Stats interval, seconds (default 5)\n"
 "  -R MS         Round-robin period for time-shared cpus, ms (default 200)\n"
 "  -J MODE       Fault injection (wrong-cid: dispatch to a cid not held)\n"
 "  -v            Print libbpf debug messages\n"
@@ -93,83 +88,6 @@ static void sigint_handler(int dummy)
 	exit_req = 1;
 }
 
-/*
- * Open a cgroup directory directly from its id. In cgroup2 the cgroup id is the
- * kernfs node id, so a FILEID_KERNFS handle built from the id resolves to the
- * directory via open_by_handle_at() against the cgroup mount.
- */
-static int open_cgroup_by_id(u64 cgid)
-{
-	static int mnt_fd = -1;
-	struct {
-		struct file_handle fh;
-		u64 id;
-	} h;
-
-	if (mnt_fd < 0) {
-		mnt_fd = open("/sys/fs/cgroup", O_RDONLY | O_DIRECTORY);
-		if (mnt_fd < 0)
-			return -1;
-	}
-	h.fh.handle_bytes = sizeof(h.id);
-	h.fh.handle_type = FILEID_KERNFS;
-	h.id = cgid;
-	return open_by_handle_at(mnt_fd, &h.fh, O_RDONLY | O_DIRECTORY);
-}
-
-/* read a cgroup's cpu.weight (1-10000) by id, 0 if unavailable */
-static u32 read_cgroup_weight(u64 cgid)
-{
-	char buf[32];
-	int dfd, wfd;
-	u32 w = 0;
-	ssize_t n;
-
-	dfd = open_cgroup_by_id(cgid);
-	if (dfd < 0)
-		return 0;
-	wfd = openat(dfd, "cpu.weight", O_RDONLY);
-	close(dfd);
-	if (wfd < 0)
-		return 0;
-	n = read(wfd, buf, sizeof(buf) - 1);
-	close(wfd);
-	if (n > 0) {
-		buf[n] = '\0';
-		w = strtoul(buf, NULL, 10);
-	}
-	return w;
-}
-
-/* read each direct child's cpu.weight into the arena, true if any changed */
-static bool feed_weights(struct qmap_arena *qa)
-{
-	bool changed = false;
-	int i;
-
-	for (i = 0; i < MAX_SUB_SCHEDS; i++) {
-		u64 cgid = qa->sub_sched_ctxs[i].cgroup_id;
-		u32 w;
-
-		if (!cgid)
-			continue;
-		/* racy against slot reuse but weight is advisory and self-corrects */
-		w = read_cgroup_weight(cgid);
-		if (w && w != qa->sub_sched_ctxs[i].weight) {
-			qa->sub_sched_ctxs[i].weight = w;
-			changed = true;
-		}
-	}
-	return changed;
-}
-
-static void invoke_repartition(struct scx_qmap *skel)
-{
-	LIBBPF_OPTS(bpf_test_run_opts, opts);
-
-	bpf_prog_test_run_opts(bpf_program__fd(skel->progs.repartition), &opts);
-}
-
 static void invoke_flush_alloc(struct scx_qmap *skel)
 {
 	LIBBPF_OPTS(bpf_test_run_opts, opts);
@@ -281,7 +199,7 @@ static void print_hier(struct qmap_arena *qa, struct hier_prev *prev, u64 own_cg
 
 	format_cid_ranges(qa, CID_SELF, ranges, sizeof(ranges));
 	printf("hier   : %-4s %10llu %4u %6.2f %8s  %s\n", "self",
-	       (unsigned long long)own_cgid, qa->self_weight,
+	       (unsigned long long)own_cgid, 100,
 	       secs > 0 ? (qa->self_alloc_ns - prev->self_alloc_ns) / (secs * 1e9) : 0.0,
 	       "-", ranges);
 	prev->self_alloc_ns = qa->self_alloc_ns;
@@ -505,8 +423,6 @@ int main(int argc, char **argv)
 	while (!exit_req && !UEI_EXITED(skel, uei)) {
 		long nr_enqueued = qa->nr_enqueued;
 		long nr_dispatched = qa->nr_dispatched;
-		u32 self_weight;
-		bool repart;
 
 		printf("---- %s ----\n",
 		       tstamp(tbuf, sizeof(tbuf)));
@@ -531,20 +447,6 @@ int main(int argc, char **argv)
 			       qa->cpuperf_target_avg,
 			       qa->cpuperf_target_max);
 
-		self_weight = own_cgid ? read_cgroup_weight(own_cgid) : 100;
-		if (!self_weight)
-			self_weight = 100;
-
-		repart = feed_weights(qa);
-
-		if (self_weight != qa->self_weight) {
-			qa->self_weight = self_weight;
-			repart = true;
-		}
-
-		if (repart)
-			invoke_repartition(skel);
-
 		invoke_flush_alloc(skel);
 		print_hier(qa, &hprev, own_cgid);
 		fflush(stdout);
diff --git a/tools/sched_ext/scx_qmap.h b/tools/sched_ext/scx_qmap.h
index 87642d21fce3..6db2ea4bdc85 100644
--- a/tools/sched_ext/scx_qmap.h
+++ b/tools/sched_ext/scx_qmap.h
@@ -90,7 +90,7 @@ struct task_ctx;
 /* per-direct-child state for the sub-scheduler */
 struct sub_sched_ctx {
 	u64 cgroup_id;
-	u32 weight;			/* cpu.weight, fed by userspace */
+	u32 weight;			/* cpu.weight, seeded at attach, then set_weight */
 	u64 nr_dsps;
 	struct qmap_cmask granted_cids;	/* cids granted excl to this child */
 	struct qmap_cmask prev_granted;	/* last grant, for delta calculation */
@@ -147,7 +147,6 @@ struct qmap_arena {
 
 	struct sub_sched_ctx sub_sched_ctxs[MAX_SUB_SCHEDS]; /* per-child context */
 	u64 nr_sub_scheds;		/* number of attached children */
-	u32 self_weight;		/* this node's cpu.weight, fed by userspace */
 
 	/* bpf-internal per-cid state */
 	u8 cid_shared[SCX_QMAP_MAX_CPUS]; /* per cid: 1 if held shared (ENQ_IMMED-only) */
-- 
2.55.0

