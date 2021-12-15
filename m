From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH bpf-next v4 3/3] bpf: remove the cgroup -> bpf header dependecy
Date: Wed, 15 Dec 2021 10:12:31 -0800
Message-ID: <20211215181231.1053479-4-kuba@kernel.org>
References: <20211215181231.1053479-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639591955;
        bh=1Y4PcUqeg02UGJ8ATK+MLlEQzKo7NaDhqBzMT7gQnfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOfHbzCwnrOlpm3PQfqJmsvYwhK/Ql2nMF7LBJ5Uss8zklDHvD4eKAm9HrlqA0dzU
         gzP/6F3BnWCIqB7iJRphIbwTPQPoZ9FrRodW2UdA4zE4/GB3otSVK+c1k+yjvNB+9B
         lvc58ttju6UjNIK+H7sstYW5kQ6omgA9pRcQrgR9nPiyjYcaMzZJDiK4ZmtEtNOPGQ
         IbRXc6o7jSpdX/tu4dkybKSeMMjSTntwENdYFGwb3uMNHcXK04mnJ39vdz26xpG5EL
         zpKIvFt12Z6TOZo6XocLWp3g4US9bjV6iMXI/0aSAoBvEPJiuXaDeLjPq3WV7+4O2N
         8ofEYoNPCdWqA==
In-Reply-To: <20211215181231.1053479-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Remove the dependency from cgroup-defs.h to bpf-cgroup.h and bpf.h.
This reduces the incremental build size of x86 allmodconfig after
bpf.h was touched from ~17k objects rebuilt to ~5k objects.
bpf.h is 2.2kLoC and is modified relatively often.

We need a new header with just the definition of struct cgroup_bpf
and enum cgroup_bpf_attach_type, this is akin to cgroup-defs.h.

Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
CC: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
CC: daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org
CC: andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
CC: kafai-b10kYP2dOMg@public.gmane.org
CC: songliubraving-b10kYP2dOMg@public.gmane.org
CC: yhs-b10kYP2dOMg@public.gmane.org
CC: john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
CC: kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
CC: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
CC: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
CC: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
CC: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/bpf-cgroup-defs.h | 70 +++++++++++++++++++++++++++++++++
 include/linux/bpf-cgroup.h      | 57 +--------------------------
 include/linux/cgroup-defs.h     |  2 +-
 3 files changed, 72 insertions(+), 57 deletions(-)
 create mode 100644 include/linux/bpf-cgroup-defs.h

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
new file mode 100644
index 000000000000..695d1224a71b
--- /dev/null
+++ b/include/linux/bpf-cgroup-defs.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_CGROUP_DEFS_H
+#define _BPF_CGROUP_DEFS_H
+
+#ifdef CONFIG_CGROUP_BPF
+
+#include <linux/list.h>
+#include <linux/percpu-refcount.h>
+#include <linux/workqueue.h>
+
+struct bpf_prog_array;
+
+enum cgroup_bpf_attach_type {
+	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
+	CGROUP_INET_INGRESS = 0,
+	CGROUP_INET_EGRESS,
+	CGROUP_INET_SOCK_CREATE,
+	CGROUP_SOCK_OPS,
+	CGROUP_DEVICE,
+	CGROUP_INET4_BIND,
+	CGROUP_INET6_BIND,
+	CGROUP_INET4_CONNECT,
+	CGROUP_INET6_CONNECT,
+	CGROUP_INET4_POST_BIND,
+	CGROUP_INET6_POST_BIND,
+	CGROUP_UDP4_SENDMSG,
+	CGROUP_UDP6_SENDMSG,
+	CGROUP_SYSCTL,
+	CGROUP_UDP4_RECVMSG,
+	CGROUP_UDP6_RECVMSG,
+	CGROUP_GETSOCKOPT,
+	CGROUP_SETSOCKOPT,
+	CGROUP_INET4_GETPEERNAME,
+	CGROUP_INET6_GETPEERNAME,
+	CGROUP_INET4_GETSOCKNAME,
+	CGROUP_INET6_GETSOCKNAME,
+	CGROUP_INET_SOCK_RELEASE,
+	MAX_CGROUP_BPF_ATTACH_TYPE
+};
+
+struct cgroup_bpf {
+	/* array of effective progs in this cgroup */
+	struct bpf_prog_array __rcu *effective[MAX_CGROUP_BPF_ATTACH_TYPE];
+
+	/* attached progs to this cgroup and attach flags
+	 * when flags == 0 or BPF_F_ALLOW_OVERRIDE the progs list will
+	 * have either zero or one element
+	 * when BPF_F_ALLOW_MULTI the list can have up to BPF_CGROUP_MAX_PROGS
+	 */
+	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
+	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
+
+	/* list of cgroup shared storages */
+	struct list_head storages;
+
+	/* temp storage for effective prog array used by prog_attach/detach */
+	struct bpf_prog_array *inactive;
+
+	/* reference counter used to detach bpf programs after cgroup removal */
+	struct percpu_ref refcnt;
+
+	/* cgroup_bpf is released using a work queue */
+	struct work_struct release_work;
+};
+
+#else /* CONFIG_CGROUP_BPF */
+struct cgroup_bpf {};
+#endif /* CONFIG_CGROUP_BPF */
+
+#endif
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 11820a430d6c..b525d8cdc25b 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -3,10 +3,10 @@
 #define _BPF_CGROUP_H
 
 #include <linux/bpf.h>
+#include <linux/bpf-cgroup-defs.h>
 #include <linux/errno.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
-#include <linux/percpu-refcount.h>
 #include <linux/rbtree.h>
 #include <uapi/linux/bpf.h>
 
@@ -23,33 +23,6 @@ struct ctl_table_header;
 struct task_struct;
 
 #ifdef CONFIG_CGROUP_BPF
-enum cgroup_bpf_attach_type {
-	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
-	CGROUP_INET_INGRESS = 0,
-	CGROUP_INET_EGRESS,
-	CGROUP_INET_SOCK_CREATE,
-	CGROUP_SOCK_OPS,
-	CGROUP_DEVICE,
-	CGROUP_INET4_BIND,
-	CGROUP_INET6_BIND,
-	CGROUP_INET4_CONNECT,
-	CGROUP_INET6_CONNECT,
-	CGROUP_INET4_POST_BIND,
-	CGROUP_INET6_POST_BIND,
-	CGROUP_UDP4_SENDMSG,
-	CGROUP_UDP6_SENDMSG,
-	CGROUP_SYSCTL,
-	CGROUP_UDP4_RECVMSG,
-	CGROUP_UDP6_RECVMSG,
-	CGROUP_GETSOCKOPT,
-	CGROUP_SETSOCKOPT,
-	CGROUP_INET4_GETPEERNAME,
-	CGROUP_INET6_GETPEERNAME,
-	CGROUP_INET4_GETSOCKNAME,
-	CGROUP_INET6_GETSOCKNAME,
-	CGROUP_INET_SOCK_RELEASE,
-	MAX_CGROUP_BPF_ATTACH_TYPE
-};
 
 #define CGROUP_ATYPE(type) \
 	case BPF_##type: return type
@@ -127,33 +100,6 @@ struct bpf_prog_list {
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 };
 
-struct bpf_prog_array;
-
-struct cgroup_bpf {
-	/* array of effective progs in this cgroup */
-	struct bpf_prog_array __rcu *effective[MAX_CGROUP_BPF_ATTACH_TYPE];
-
-	/* attached progs to this cgroup and attach flags
-	 * when flags == 0 or BPF_F_ALLOW_OVERRIDE the progs list will
-	 * have either zero or one element
-	 * when BPF_F_ALLOW_MULTI the list can have up to BPF_CGROUP_MAX_PROGS
-	 */
-	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
-	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
-
-	/* list of cgroup shared storages */
-	struct list_head storages;
-
-	/* temp storage for effective prog array used by prog_attach/detach */
-	struct bpf_prog_array *inactive;
-
-	/* reference counter used to detach bpf programs after cgroup removal */
-	struct percpu_ref refcnt;
-
-	/* cgroup_bpf is released using a work queue */
-	struct work_struct release_work;
-};
-
 int cgroup_bpf_inherit(struct cgroup *cgrp);
 void cgroup_bpf_offline(struct cgroup *cgrp);
 
@@ -451,7 +397,6 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr);
 #else
 
-struct cgroup_bpf {};
 static inline int cgroup_bpf_inherit(struct cgroup *cgrp) { return 0; }
 static inline void cgroup_bpf_offline(struct cgroup *cgrp) {}
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index db2e147e069f..411684c80cf3 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -19,7 +19,7 @@
 #include <linux/percpu-rwsem.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/workqueue.h>
-#include <linux/bpf-cgroup.h>
+#include <linux/bpf-cgroup-defs.h>
 #include <linux/psi_types.h>
 
 #ifdef CONFIG_CGROUPS
-- 
2.31.1

