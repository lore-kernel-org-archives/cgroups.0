From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Date: Tue, 10 May 2022 00:18:06 +0000
Message-ID: <20220510001807.4132027-9-yosryahmed@google.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1DdKbbzvRaz5T1jHgNMHWUuX5VoFw/KcWqMsFaoDHew=;
        b=Qdk/uVBN5FirguzUtk6YBSinwsbw0mWLPIMl0G6mPkw3WWKgrwiYgoK2MxCAb9/0xG
         QkEsszD9SqFMBanTKgXAEsSdCXcNQfoJwo18x+pQSYtGhq6nE+P+f4ulCSi33EYn4MlA
         G2Q8OuGBLOBBi6hp/LY8ttDQ8lHKcgBTudw/sc3UqJXiAKv/2awpINYR3jNu1K9oLHfh
         RJwCDneJtlrFR6mbkc92+QNjjK3m4kLSgCtJq1OiuWLKlhGf99TYFFpyluxL8obtigKi
         EcI5syCaQZqsDAxsU/qL0n/Uue7arYAcP6eocXGX1W4fn+HyN3Tr1WCHNZBzSZcd5uP2
         Y0CA==
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

From: Hao Luo <haoluo@google.com>

Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
iter doesn't iterate a set of kernel objects. Instead, it is supposed to
be parameterized by a cgroup id and prints only that cgroup. So one
needs to specify a target cgroup id when attaching this iter. The target
cgroup's state can be read out via a link of this iter.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf.h            |   2 +
 include/uapi/linux/bpf.h       |   6 ++
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/cgroup_iter.c       | 148 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   6 ++
 5 files changed, 163 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/cgroup_iter.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f6fa35ffe311..f472f43521d2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -43,6 +43,7 @@ struct kobject;
 struct mem_cgroup;
 struct module;
 struct bpf_func_state;
+struct cgroup;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1601,6 +1602,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
 
 struct bpf_iter_aux_info {
 	struct bpf_map *map;
+	struct cgroup *cgroup;
 };
 
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 015ed402c642..096c521e34de 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -91,6 +91,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		__u64	cgroup_id;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -5963,6 +5966,9 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+				struct {
+					__u64 cgroup_id;
+				} cgroup;
 			};
 		} iter;
 		struct  {
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 6caf4a61e543..07a715b54190 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
-obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
+obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o cgroup_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
new file mode 100644
index 000000000000..86bdfe135d24
--- /dev/null
+++ b/kernel/bpf/cgroup_iter.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Google */
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+
+struct bpf_iter__cgroup {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct cgroup *, cgroup);
+};
+
+static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	/* Only one session is supported. */
+	if (*pos > 0)
+		return NULL;
+
+	if (*pos == 0)
+		++*pos;
+
+	return *(struct cgroup **)seq->private;
+}
+
+static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter__cgroup ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	ctx.meta = &meta;
+	ctx.cgroup = v;
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, false);
+	if (prog)
+		ret = bpf_iter_run_prog(prog, &ctx);
+
+	return ret;
+}
+
+static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static const struct seq_operations cgroup_iter_seq_ops = {
+	.start  = cgroup_iter_seq_start,
+	.next   = cgroup_iter_seq_next,
+	.stop   = cgroup_iter_seq_stop,
+	.show   = cgroup_iter_seq_show,
+};
+
+BTF_ID_LIST_SINGLE(bpf_cgroup_btf_id, struct, cgroup)
+
+static int cgroup_iter_seq_init(void *priv_data, struct bpf_iter_aux_info *aux)
+{
+	*(struct cgroup **)priv_data = aux->cgroup;
+	return 0;
+}
+
+static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
+	.seq_ops                = &cgroup_iter_seq_ops,
+	.init_seq_private       = cgroup_iter_seq_init,
+	.seq_priv_size          = sizeof(struct cgroup *),
+};
+
+static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
+				  union bpf_iter_link_info *linfo,
+				  struct bpf_iter_aux_info *aux)
+{
+	struct cgroup *cgroup;
+
+	cgroup = cgroup_get_from_id(linfo->cgroup.cgroup_id);
+	if (!cgroup)
+		return -EBUSY;
+
+	aux->cgroup = cgroup;
+	return 0;
+}
+
+static void bpf_iter_detach_cgroup(struct bpf_iter_aux_info *aux)
+{
+	if (aux->cgroup)
+		cgroup_put(aux->cgroup);
+}
+
+static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
+					struct seq_file *seq)
+{
+	char *buf;
+
+	seq_printf(seq, "cgroup_id:\t%llu\n", cgroup_id(aux->cgroup));
+
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf) {
+		seq_puts(seq, "cgroup_path:\n");
+		return;
+	}
+
+	/* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
+	 * will print nothing.
+	 *
+	 * Cgroup_path is the path in the calliing process's cgroup namespace.
+	 */
+	cgroup_path_ns(aux->cgroup, buf, sizeof(buf),
+		       current->nsproxy->cgroup_ns);
+	seq_printf(seq, "cgroup_path:\t%s\n", buf);
+	kfree(buf);
+}
+
+static int bpf_iter_cgroup_fill_link_info(const struct bpf_iter_aux_info *aux,
+					  struct bpf_link_info *info)
+{
+	info->iter.cgroup.cgroup_id = cgroup_id(aux->cgroup);
+	return 0;
+}
+
+DEFINE_BPF_ITER_FUNC(cgroup, struct bpf_iter_meta *meta,
+		     struct cgroup *cgroup)
+
+static struct bpf_iter_reg bpf_cgroup_reg_info = {
+	.target			= "cgroup",
+	.attach_target		= bpf_iter_attach_cgroup,
+	.detach_target		= bpf_iter_detach_cgroup,
+	.show_fdinfo		= bpf_iter_cgroup_show_fdinfo,
+	.fill_link_info		= bpf_iter_cgroup_fill_link_info,
+	.ctx_arg_info_size	= 1,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__cgroup, cgroup),
+		  PTR_TO_BTF_ID },
+	},
+	.seq_info		= &cgroup_iter_seq_info,
+};
+
+static int __init bpf_cgroup_iter_init(void)
+{
+	bpf_cgroup_reg_info.ctx_arg_info[0].btf_id = bpf_cgroup_btf_id[0];
+	return bpf_iter_reg_target(&bpf_cgroup_reg_info);
+}
+
+late_initcall(bpf_cgroup_iter_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 015ed402c642..096c521e34de 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -91,6 +91,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		__u64	cgroup_id;
+	} cgroup;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -5963,6 +5966,9 @@ struct bpf_link_info {
 				struct {
 					__u32 map_id;
 				} map;
+				struct {
+					__u64 cgroup_id;
+				} cgroup;
 			};
 		} iter;
 		struct  {
-- 
2.36.0.512.ge40c2bad7a-goog

