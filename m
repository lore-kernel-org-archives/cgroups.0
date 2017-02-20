From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 11/19] kernel: convert cgroup_namespace.count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:19:00 +0200
Message-ID: <1487585948-6401-12-git-send-email-elena.reshetova@intel.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/linux/cgroup.h    | 7 ++++---
 kernel/cgroup/cgroup.c    | 2 +-
 kernel/cgroup/namespace.c | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f6b43fb..4412979 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -22,6 +22,7 @@
 #include <linux/ns_common.h>
 #include <linux/nsproxy.h>
 #include <linux/user_namespace.h>
+#include <linux/refcount.h>
 
 #include <linux/cgroup-defs.h>
 
@@ -640,7 +641,7 @@ static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
 #endif	/* CONFIG_CGROUP_DATA */
 
 struct cgroup_namespace {
-	atomic_t		count;
+	refcount_t		count;
 	struct ns_common	ns;
 	struct user_namespace	*user_ns;
 	struct ucounts		*ucounts;
@@ -675,12 +676,12 @@ copy_cgroup_ns(unsigned long flags, struct user_namespace *user_ns,
 static inline void get_cgroup_ns(struct cgroup_namespace *ns)
 {
 	if (ns)
-		atomic_inc(&ns->count);
+		refcount_inc(&ns->count);
 }
 
 static inline void put_cgroup_ns(struct cgroup_namespace *ns)
 {
-	if (ns && atomic_dec_and_test(&ns->count))
+	if (ns && refcount_dec_and_test(&ns->count))
 		free_cgroup_ns(ns);
 }
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffcb310..5b94c79 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -188,7 +188,7 @@ static u16 have_canfork_callback __read_mostly;
 
 /* cgroup namespace for init task */
 struct cgroup_namespace init_cgroup_ns = {
-	.count		= { .counter = 2, },
+	.count		= REFCOUNT_INIT(2),
 	.user_ns	= &init_user_ns,
 	.ns.ops		= &cgroupns_operations,
 	.ns.inum	= PROC_CGROUP_INIT_INO,
diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index cff7ea6..86e9bbe 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -31,7 +31,7 @@ static struct cgroup_namespace *alloc_cgroup_ns(void)
 		kfree(new_ns);
 		return ERR_PTR(ret);
 	}
-	atomic_set(&new_ns->count, 1);
+	refcount_set(&new_ns->count, 1);
 	new_ns->ns.ops = &cgroupns_operations;
 	return new_ns;
 }
-- 
2.7.4

