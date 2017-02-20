From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 15/19] kernel: convert audit_tree.count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:19:04 +0200
Message-ID: <1487585948-6401-16-git-send-email-elena.reshetova@intel.com>
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
 kernel/audit_tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 7b44195..7ed617b 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -9,7 +9,7 @@ struct audit_tree;
 struct audit_chunk;
 
 struct audit_tree {
-	atomic_t count;
+	refcount_t count;
 	int goner;
 	struct audit_chunk *root;
 	struct list_head chunks;
@@ -77,7 +77,7 @@ static struct audit_tree *alloc_tree(const char *s)
 
 	tree = kmalloc(sizeof(struct audit_tree) + strlen(s) + 1, GFP_KERNEL);
 	if (tree) {
-		atomic_set(&tree->count, 1);
+		refcount_set(&tree->count, 1);
 		tree->goner = 0;
 		INIT_LIST_HEAD(&tree->chunks);
 		INIT_LIST_HEAD(&tree->rules);
@@ -91,12 +91,12 @@ static struct audit_tree *alloc_tree(const char *s)
 
 static inline void get_tree(struct audit_tree *tree)
 {
-	atomic_inc(&tree->count);
+	refcount_inc(&tree->count);
 }
 
 static inline void put_tree(struct audit_tree *tree)
 {
-	if (atomic_dec_and_test(&tree->count))
+	if (refcount_dec_and_test(&tree->count))
 		kfree_rcu(tree, head);
 }
 
-- 
2.7.4

