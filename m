From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 09/15] kernel: convert uprobe.ref from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:20 +0300
Message-ID: <1500288206-12074-10-git-send-email-elena.reshetova@intel.com>
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
 kernel/events/uprobes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 456596d..ca093957 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -66,7 +66,7 @@ static struct percpu_rw_semaphore dup_mmap_sem;
 
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
-	atomic_t		ref;
+	refcount_t		ref;
 	struct rw_semaphore	register_rwsem;
 	struct rw_semaphore	consumer_rwsem;
 	struct list_head	pending_list;
@@ -371,13 +371,13 @@ set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long v
 
 static struct uprobe *get_uprobe(struct uprobe *uprobe)
 {
-	atomic_inc(&uprobe->ref);
+	refcount_inc(&uprobe->ref);
 	return uprobe;
 }
 
 static void put_uprobe(struct uprobe *uprobe)
 {
-	if (atomic_dec_and_test(&uprobe->ref))
+	if (refcount_dec_and_test(&uprobe->ref))
 		kfree(uprobe);
 }
 
@@ -459,7 +459,7 @@ static struct uprobe *__insert_uprobe(struct uprobe *uprobe)
 	rb_link_node(&uprobe->rb_node, parent, p);
 	rb_insert_color(&uprobe->rb_node, &uprobes_tree);
 	/* get access + creation ref */
-	atomic_set(&uprobe->ref, 2);
+	refcount_set(&uprobe->ref, 2);
 
 	return u;
 }
-- 
2.7.4

