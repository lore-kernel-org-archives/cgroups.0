From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 10/19] kernel: convert nsproxy.count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:59 +0200
Message-ID: <1487585948-6401-11-git-send-email-elena.reshetova@intel.com>
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
 include/linux/nsproxy.h | 6 +++---
 kernel/nsproxy.c        | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index ac0d65b..f862ba8 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -28,7 +28,7 @@ struct fs_struct;
  * nsproxy is copied.
  */
 struct nsproxy {
-	atomic_t count;
+	refcount_t count;
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
@@ -74,14 +74,14 @@ int __init nsproxy_cache_init(void);
 
 static inline void put_nsproxy(struct nsproxy *ns)
 {
-	if (atomic_dec_and_test(&ns->count)) {
+	if (refcount_dec_and_test(&ns->count)) {
 		free_nsproxy(ns);
 	}
 }
 
 static inline void get_nsproxy(struct nsproxy *ns)
 {
-	atomic_inc(&ns->count);
+	refcount_inc(&ns->count);
 }
 
 #endif
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 782102e..435a0f9 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -30,7 +30,7 @@
 static struct kmem_cache *nsproxy_cachep;
 
 struct nsproxy init_nsproxy = {
-	.count			= ATOMIC_INIT(1),
+	.count			= REFCOUNT_INIT(1),
 	.uts_ns			= &init_uts_ns,
 #if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
 	.ipc_ns			= &init_ipc_ns,
@@ -51,7 +51,7 @@ static inline struct nsproxy *create_nsproxy(void)
 
 	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
 	if (nsproxy)
-		atomic_set(&nsproxy->count, 1);
+		refcount_set(&nsproxy->count, 1);
 	return nsproxy;
 }
 
@@ -224,7 +224,7 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	p->nsproxy = new;
 	task_unlock(p);
 
-	if (ns && atomic_dec_and_test(&ns->count))
+	if (ns && refcount_dec_and_test(&ns->count))
 		free_nsproxy(ns);
 }
 
-- 
2.7.4

