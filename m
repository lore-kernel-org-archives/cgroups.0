From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 11/15] kernel: convert group_info.usage from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:22 +0300
Message-ID: <1500288206-12074-12-git-send-email-elena.reshetova@intel.com>
References: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, tglx@linutronix.de, Elena Reshetova <elena.reshetova@intel.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 include/linux/cred.h | 7 ++++---
 kernel/cred.c        | 2 +-
 kernel/groups.c      | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 099058e..00948dd 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -17,6 +17,7 @@
 #include <linux/key.h>
 #include <linux/selinux.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/uidgid.h>
 #include <linux/sched.h>
 #include <linux/sched/user.h>
@@ -28,7 +29,7 @@ struct inode;
  * COW Supplementary groups list
  */
 struct group_info {
-	atomic_t	usage;
+	refcount_t	usage;
 	int		ngroups;
 	kgid_t		gid[0];
 } __randomize_layout;
@@ -44,7 +45,7 @@ struct group_info {
  */
 static inline struct group_info *get_group_info(struct group_info *gi)
 {
-	atomic_inc(&gi->usage);
+	refcount_inc(&gi->usage);
 	return gi;
 }
 
@@ -54,7 +55,7 @@ static inline struct group_info *get_group_info(struct group_info *gi)
  */
 #define put_group_info(group_info)			\
 do {							\
-	if (atomic_dec_and_test(&(group_info)->usage))	\
+	if (refcount_dec_and_test(&(group_info)->usage))	\
 		groups_free(group_info);		\
 } while (0)
 
diff --git a/kernel/cred.c b/kernel/cred.c
index ecf0365..8122d7c 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -36,7 +36,7 @@ do {									\
 static struct kmem_cache *cred_jar;
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
-struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
+struct group_info init_groups = { .usage = REFCOUNT_INIT(2) };
 
 /*
  * The initial credentials for the initial task
diff --git a/kernel/groups.c b/kernel/groups.c
index 434f666..5fc6e21 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -23,7 +23,7 @@ struct group_info *groups_alloc(int gidsetsize)
 	if (!gi)
 		return NULL;
 
-	atomic_set(&gi->usage, 1);
+	refcount_set(&gi->usage, 1);
 	gi->ngroups = gidsetsize;
 	return gi;
 }
-- 
2.7.4

