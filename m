From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 14/15] kernel: convert futex_pi_state.refcount from atomic_t to refcount_t
Date: Fri,  7 Jul 2017 12:04:28 +0300
Message-ID: <1499418269-3686-15-git-send-email-elena.reshetova@intel.com>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

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
 kernel/futex.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 16dbe4c..7458dfc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -67,6 +67,7 @@
 #include <linux/freezer.h>
 #include <linux/bootmem.h>
 #include <linux/fault-inject.h>
+#include <linux/refcount.h>
 
 #include <asm/futex.h>
 
@@ -209,7 +210,7 @@ struct futex_pi_state {
 	struct rt_mutex pi_mutex;
 
 	struct task_struct *owner;
-	atomic_t refcount;
+	refcount_t refcount;
 
 	union futex_key key;
 } __randomize_layout;
@@ -794,7 +795,7 @@ static int refill_pi_state_cache(void)
 	INIT_LIST_HEAD(&pi_state->list);
 	/* pi_mutex gets initialized later */
 	pi_state->owner = NULL;
-	atomic_set(&pi_state->refcount, 1);
+	refcount_set(&pi_state->refcount, 1);
 	pi_state->key = FUTEX_KEY_INIT;
 
 	current->pi_state_cache = pi_state;
@@ -814,7 +815,7 @@ static struct futex_pi_state *alloc_pi_state(void)
 
 static void get_pi_state(struct futex_pi_state *pi_state)
 {
-	WARN_ON_ONCE(!atomic_inc_not_zero(&pi_state->refcount));
+	WARN_ON_ONCE(!refcount_inc_not_zero(&pi_state->refcount));
 }
 
 /*
@@ -828,7 +829,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 	if (!pi_state)
 		return;
 
-	if (!atomic_dec_and_test(&pi_state->refcount))
+	if (!refcount_dec_and_test(&pi_state->refcount))
 		return;
 
 	/*
@@ -852,7 +853,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 		 * refcount is at 0 - put it back to 1.
 		 */
 		pi_state->owner = NULL;
-		atomic_set(&pi_state->refcount, 1);
+		refcount_set(&pi_state->refcount, 1);
 		current->pi_state_cache = pi_state;
 	}
 }
@@ -1046,7 +1047,7 @@ static int attach_to_pi_state(u32 __user *uaddr, u32 uval,
 	 * and futex_wait_requeue_pi() as it cannot go to 0 and consequently
 	 * free pi_state before we can take a reference ourselves.
 	 */
-	WARN_ON(!atomic_read(&pi_state->refcount));
+	WARN_ON(!refcount_read(&pi_state->refcount));
 
 	/*
 	 * Now that we have a pi_state, we can acquire wait_lock
-- 
2.7.4

