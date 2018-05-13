From: Alban Crequy <alban.crequy@gmail.com>
Subject: [PATCH] [RFC] bpf: tracing: new helper bpf_get_current_cgroup_ino
Date: Sun, 13 May 2018 19:33:18 +0200
Message-ID: <20180513173318.21680-1-alban@kinvolk.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=/O07zhqyJhf3SAVB/WUi61oEU5pZYsjEzjRZ4QBWLpg=;
        b=VSgEba+u7EPMQJIJXczxnlunLEyvcBdQaWI8+4zDznyNL/vLYOGafUuCEvjlBkVUHE
         FQtb1tjg2uBC6Ze3g8qvhGbkyny4mPoxlvN8cFnfGKwRvDuQzwch9ah9KqYaTv3z65E2
         ulQr6L6tqovzvObvj5jTAZC+Mg1rV748PsuTz1I1fsSWq+plEReniSyyE+eZgSMpGGSP
         mVP1/edPSJeuB+lAUK7eU5Oe13eZ91qSlvY/r5zv0mHWm5X6Jc2hCvWCfWI+2J27C5nS
         11szM3hDTgxC4ToF5jSgldmTR4etISICZSX9ISTL5s5Sk3LpBfxDX/n/fl8tlUeFD7zL
         gUFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: Alban Crequy <alban@kinvolk.io>

From: Alban Crequy <alban@kinvolk.io>

bpf_get_current_cgroup_ino() allows BPF trace programs to get the inode
of the cgroup where the current process resides.

My use case is to get statistics about syscalls done by a specific
Kubernetes container. I have a tracepoint on raw_syscalls/sys_enter and
a BPF map containing the cgroup inode that I want to trace. I use
bpf_get_current_cgroup_ino() and I quickly return from the tracepoint if
the inode is not in the BPF hash map.

Without this BPF helper, I would need to keep track of all pids in the
container. The Netlink proc connector can be used to follow process
creation and destruction but it is racy.

This patch only looks at the memory cgroup, which was enough for me
since each Kubernetes container is placed in a different mem cgroup.
For a generic implementation, I'm not sure how to proceed: it seems I
would need to use 'for_each_root(root)' (see example in
proc_cgroup_show() from kernel/cgroup/cgroup.c) but I don't know if
taking the cgroup mutex is possible in the BPF helper function. It might
be ok in the tracepoint raw_syscalls/sys_enter but could the mutex
already be taken in some other tracepoints?

Signed-off-by: Alban Crequy <alban@kinvolk.io>
---
 include/uapi/linux/bpf.h | 11 ++++++++++-
 kernel/trace/bpf_trace.c | 25 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c5ec89732a8d..38ac3959cdf3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -755,6 +755,14 @@ union bpf_attr {
  *     @addr: pointer to struct sockaddr to bind socket to
  *     @addr_len: length of sockaddr structure
  *     Return: 0 on success or negative error code
+ *
+ * u64 bpf_get_current_cgroup_ino(hierarchy, flags)
+ *     Get the cgroup{1,2} inode of current task under the specified hierarchy.
+ *     @hierarchy: cgroup hierarchy
+ *     @flags: reserved for future use
+ *     Return:
+ *       == 0 error
+ *        > 0 inode of the cgroup
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -821,7 +829,8 @@ union bpf_attr {
 	FN(msg_apply_bytes),		\
 	FN(msg_cork_bytes),		\
 	FN(msg_pull_data),		\
-	FN(bind),
+	FN(bind),			\
+	FN(get_current_cgroup_ino),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 56ba0f2a01db..9bf92a786639 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -524,6 +524,29 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_get_current_cgroup_ino, u32, hierarchy, u64, flags)
+{
+	// TODO: pick the correct hierarchy instead of the mem controller
+	struct cgroup *cgrp = task_cgroup(current, memory_cgrp_id);
+
+	if (unlikely(!cgrp))
+		return -EINVAL;
+	if (unlikely(hierarchy))
+		return -EINVAL;
+	if (unlikely(flags))
+		return -EINVAL;
+
+	return cgrp->kn->id.ino;
+}
+
+static const struct bpf_func_proto bpf_get_current_cgroup_ino_proto = {
+	.func           = bpf_get_current_cgroup_ino,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_DONTCARE,
+	.arg2_type      = ARG_DONTCARE,
+};
+
 static const struct bpf_func_proto *
 tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -564,6 +587,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_prandom_u32_proto;
 	case BPF_FUNC_probe_read_str:
 		return &bpf_probe_read_str_proto;
+	case BPF_FUNC_get_current_cgroup_ino:
+		return &bpf_get_current_cgroup_ino_proto;
 	default:
 		return NULL;
 	}
-- 
2.14.3

