From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 16/19] kernel: convert audit_watch.count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:19:05 +0200
Message-ID: <1487585948-6401-17-git-send-email-elena.reshetova@intel.com>
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
 kernel/audit_watch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index f79e465..8ca9e6c 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -46,7 +46,7 @@
  */
 
 struct audit_watch {
-	atomic_t		count;	/* reference count */
+	refcount_t		count;	/* reference count */
 	dev_t			dev;	/* associated superblock device */
 	char			*path;	/* insertion path */
 	unsigned long		ino;	/* associated inode number */
@@ -111,12 +111,12 @@ static inline struct audit_parent *audit_find_parent(struct inode *inode)
 
 void audit_get_watch(struct audit_watch *watch)
 {
-	atomic_inc(&watch->count);
+	refcount_inc(&watch->count);
 }
 
 void audit_put_watch(struct audit_watch *watch)
 {
-	if (atomic_dec_and_test(&watch->count)) {
+	if (refcount_dec_and_test(&watch->count)) {
 		WARN_ON(watch->parent);
 		WARN_ON(!list_empty(&watch->rules));
 		kfree(watch->path);
@@ -178,7 +178,7 @@ static struct audit_watch *audit_init_watch(char *path)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&watch->rules);
-	atomic_set(&watch->count, 1);
+	refcount_set(&watch->count, 1);
 	watch->path = path;
 	watch->dev = AUDIT_DEV_UNSET;
 	watch->ino = AUDIT_INO_UNSET;
-- 
2.7.4

