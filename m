Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663B038E5DA
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018787; cv=none; b=qrz6jH4ncvhO3zq1f9v7i+kSjAagIsBcBFTbcAZ/je8RnfjfdZfP5LxQ6sMHsEM8TK/VhHEAs0YfhVvBfA6yV/gyRqJUZjzFrUWW0ZDy53IZX+rbY579AkGxt9bZSSHyZhnQX5WVmJBaN8C7PKZ98Wgy8Ke9kD29A2rggu3jWZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018787; c=relaxed/simple;
	bh=Rk6vSHsZulU3ylU3QojCy3TlgitfGn9MgxeNvIoe+1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfCM+TVpbM0Q6YjUL8Y+lrukg8gb1te5pb1nUTYc3Tu8253Jc+DtaAw7ehUFVla/4J3RUgTBKNeo9I3e2ieNljgJ7fhLGDMIpALwX4mSD2THQalZsFrdJ/rfwd7NnJvPg0+83vOjpWeoHpBJIAfjMkVgFs/xKYcHUP8NcuTwa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wFx/yzM/; arc=none smtp.client-ip=91.218.175.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wFx/yzM/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Rk6vSHsZulU3ylU3QojCy3TlgitfGn9MgxeNvIoe+1s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018782; v=1; x=1790623582;
 b=wFx/yzM/t0ddWiHKQ4sYhMKhbWztXPPDtYNJSk9Ge2JyyQsROoisSAFq8JqScjtDlQ/yFrRn
 46Zevvsy0S9rPQl8Xtb7RMP1pXdMCTGlxuxvR7QoL2e+m3WY4dtE8k4MdewwkgYgmZK4dNprhZv
 vlMLv7xnHzWqyPRliFtx8/r8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9b07036d47c80b85;
	Mon, 21 Sep 2026 19:26:21 +0000
X-Mizu-Trace-ID: 9b07036d47c80b85
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
Subject: [RFC PATCH 2/4] memcg_ext: add cgroup-attached bpf_memcg_ops
Date: Mon, 21 Sep 2026 12:25:57 -0700
Message-ID: <20260921192559.2619635-3-shakeel.butt@linux.dev>
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

Add an empty bpf_memcg_ops type for attaching memory policies to
cgroups.  This is the first patch of memcg_ext, which makes memcg
enforcement programmable one hook at a time.  Policy hooks will be added
later.

Move the cgroup BPF attach types outside CONFIG_CGROUP_BPF and fix the
struct_ops registration stub so all supported configurations build.

This does not change behavior yet.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/bpf-cgroup-defs.h |  22 ++++---
 include/linux/bpf-cgroup.h      |   2 +-
 include/linux/bpf.h             |   2 +-
 include/linux/bpf_memcontrol.h  |  17 +++++
 mm/bpf_memcontrol.c             | 108 +++++++++++++++++++++++++++++++-
 5 files changed, 140 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/bpf_memcontrol.h

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 0147b8bec973..53d2853535c6 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -2,14 +2,6 @@
 #ifndef _BPF_CGROUP_DEFS_H
 #define _BPF_CGROUP_DEFS_H
 
-#ifdef CONFIG_CGROUP_BPF
-
-#include <linux/list.h>
-#include <linux/percpu-refcount.h>
-#include <linux/workqueue.h>
-
-struct bpf_prog_array;
-
 #ifdef CONFIG_BPF_LSM
 /* Maximum number of concurrently attachable per-cgroup LSM hooks. */
 #define CGROUP_LSM_NUM 10
@@ -17,6 +9,10 @@ struct bpf_prog_array;
 #define CGROUP_LSM_NUM 0
 #endif
 
+/*
+ * Plain constants, so a subsystem can name its attach type without
+ * depending on CONFIG_CGROUP_BPF.
+ */
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
 	CGROUP_INET_INGRESS = 0,
@@ -48,11 +44,21 @@ enum cgroup_bpf_attach_type {
 	CGROUP_UNIX_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
 	CGROUP_TCP_SOCK_OPS,
+	CGROUP_MEMCG_OPS,
 	CGROUP_LSM_START,
 	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
+#ifdef CONFIG_CGROUP_BPF
+
+#include <linux/list.h>
+#include <linux/percpu-refcount.h>
+#include <linux/workqueue.h>
+
+struct bpf_prog_array;
+
+
 struct cgroup_bpf {
 	/* array of effective progs in this cgroup */
 	struct bpf_prog_array __rcu *effective[MAX_CGROUP_BPF_ATTACH_TYPE];
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 3b2c127d401d..4e8150848bd2 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -127,7 +127,7 @@ struct bpf_prog_list {
 
 static inline bool cgroup_bpf_is_struct_ops_atype(enum cgroup_bpf_attach_type atype)
 {
-	return atype == CGROUP_TCP_SOCK_OPS;
+	return atype == CGROUP_TCP_SOCK_OPS || atype == CGROUP_MEMCG_OPS;
 }
 void cgroup_bpf_struct_ops_register(int atype, u32 type_id, void *cfi_stubs, bool mult_trace);
 int cgroup_bpf_struct_ops_attach(struct bpf_map *map, const union bpf_attr *attr);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5033b934ffd9..f8eb102e7fc4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2331,7 +2331,7 @@ int bpf_struct_ops_desc_init(struct bpf_struct_ops_desc *st_ops_desc,
 void bpf_map_struct_ops_info_fill(struct bpf_map_info *info, struct bpf_map *map);
 void bpf_struct_ops_desc_release(struct bpf_struct_ops_desc *st_ops_desc);
 #else
-#define register_bpf_struct_ops(st_ops, type) ({ (void *)(st_ops); 0; })
+#define register_bpf_struct_ops(st_ops, type) ({ (void)(st_ops); 0; })
 static inline bool bpf_try_module_get(const void *data, struct module *owner)
 {
 	return try_module_get(owner);
diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
new file mode 100644
index 000000000000..8204d894761e
--- /dev/null
+++ b/include/linux/bpf_memcontrol.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * BPF policy hooks for the memory controller.
+ *
+ * A bpf_memcg_ops is attached to a cgroup.  A charge runs the policies of
+ * that cgroup and of every ancestor, and the kernel combines what they
+ * return.  BPF only picks between things the kernel already does.
+ *
+ * The type has no members yet; they come with the policies that use them.
+ */
+#ifndef _LINUX_BPF_MEMCONTROL_H
+#define _LINUX_BPF_MEMCONTROL_H
+
+struct bpf_memcg_ops {
+};
+
+#endif /* _LINUX_BPF_MEMCONTROL_H */
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..fd6dff150f01 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -7,6 +7,12 @@
 
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
+#include <linux/bpf-cgroup.h>
+#include <linux/bpf_memcontrol.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+#include <linux/sched.h>
 
 #include "internal.h"
 
@@ -235,6 +241,100 @@ static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
 	.set            = &bpf_memcontrol_reclaim_kfuncs,
 };
 
+/*
+ * bpf_memcg_ops: memcg policy attached to a cgroup.  A program returns a
+ * request and the kernel acts on it.  Nothing here reclaims or sleeps.
+ */
+
+/* CFI stubs.  A slot points at these while its policy is being detached. */
+static struct bpf_memcg_ops __bpf_memcg_ops = {
+};
+
+static const struct bpf_func_proto *
+bpf_memcg_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	/*
+	 * The base set is all a policy needs today, and none of it sleeps.
+	 * Anything added here must be safe from the charge path.
+	 */
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static bool bpf_memcg_is_valid_access(int off, int size,
+				      enum bpf_access_type type,
+				      const struct bpf_prog *prog,
+				      struct bpf_insn_access_aux *info)
+{
+	/* The context is read-only. */
+	if (type != BPF_READ)
+		return false;
+
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_memcg_init_member(const struct btf_type *t,
+				 const struct btf_member *member,
+				 void *kdata, const void *udata)
+{
+	/* Mandatory: the core calls it without a NULL check. */
+	return 0;
+}
+
+static int bpf_memcg_check_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  const struct bpf_prog *prog)
+{
+	/* Members run from the charge path, which cannot sleep. */
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int bpf_memcg_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_memcg_validate(void *kdata)
+{
+	return 0;
+}
+
+static const struct bpf_verifier_ops bpf_memcg_verifier_ops = {
+	.get_func_proto		= bpf_memcg_get_func_proto,
+	.is_valid_access	= bpf_memcg_is_valid_access,
+};
+
+static struct bpf_struct_ops bpf_memcg_ops_desc = {
+	.verifier_ops	= &bpf_memcg_verifier_ops,
+	.init		= bpf_memcg_init,
+	.init_member	= bpf_memcg_init_member,
+	.check_member	= bpf_memcg_check_member,
+	.validate	= bpf_memcg_validate,
+	.name		= "bpf_memcg_ops",
+	.cgroup_atype	= CGROUP_MEMCG_OPS,
+	.cfi_stubs	= &__bpf_memcg_ops,
+	.owner		= THIS_MODULE,
+	/*
+	 * .reg/.unreg stay NULL: the cgroup layer does attach and detach, and
+	 * registration fails if a cgroup_atype comes with either.
+	 *
+	 * .free_after_mult_rcu_gp stays false while no member sleeps.  A
+	 * sleepable one would also need a tasks-trace RCU version of
+	 * bpf_cgroup_struct_ops_foreach().
+	 */
+};
+
+static int __init bpf_memcg_ops_register(void)
+{
+	/*
+	 * register_bpf_struct_ops() is a no-op without struct_ops support, so
+	 * this needs no guard of its own.
+	 */
+	return register_bpf_struct_ops(&bpf_memcg_ops_desc, bpf_memcg_ops);
+}
+
 static int __init bpf_memcontrol_init(void)
 {
 	int err;
@@ -248,8 +348,14 @@ static int __init bpf_memcontrol_init(void)
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
 					&bpf_memcontrol_reclaim_kfunc_set);
-	if (err)
+	if (err) {
 		pr_warn("error registering bpf reclaim kfuncs: %d\n", err);
+		return err;
+	}
+
+	err = bpf_memcg_ops_register();
+	if (err)
+		pr_warn("error while registering bpf_memcg_ops: %d", err);
 
 	return err;
 }
-- 
2.53.0-Meta

