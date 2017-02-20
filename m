From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 18/19] kernel: convert futex_pi_state.refcount from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:19:07 +0200
Message-ID: <1487585948-6401-19-git-send-email-elena.reshetova@intel.com>
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
 kernel/futex.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b687cb2..4ef9c10 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -65,6 +65,7 @@
 #include <linux/freezer.h>
 #include <linux/bootmem.h>
 #include <linux/fault-inject.h>
+#include <linux/refcount.h>
 
 #include <asm/futex.h>
 
@@ -207,7 +208,7 @@ struct futex_pi_state {
 	struct rt_mutex pi_mutex;
 
 	struct task_struct *owner;
-	atomic_t refcount;
+	refcount_t refcount;
 
 	union futex_key key;
 };
@@ -792,7 +793,7 @@ static int refill_pi_state_cache(void)
 	INIT_LIST_HEAD(&pi_state->list);
 	/* pi_mutex gets initialized later */
 	pi_state->owner = NULL;
-	atomic_set(&pi_state->refcount, 1);
+	refcount_set(&pi_state->refcount, 1);
 	pi_state->key = FUTEX_KEY_INIT;
 
 	current->pi_state_cache = pi_state;
@@ -821,7 +822,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 	if (!pi_state)
 		return;
 
-	if (!atomic_dec_and_test(&pi_state->refcount))
+	if (!refcount_dec_and_test(&pi_state->refcount))
 		return;
 
 	/*
@@ -845,7 +846,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 		 * refcount is at 0 - put it back to 1.
 		 */
 		pi_state->owner = NULL;
-		atomic_set(&pi_state->refcount, 1);
+		refcount_set(&pi_state->refcount, 1);
 		current->pi_state_cache = pi_state;
 	}
 }
@@ -989,7 +990,7 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
 	if (unlikely(!pi_state))
 		return -EINVAL;
 
-	WARN_ON(!atomic_read(&pi_state->refcount));
+	WARN_ON(!refcount_read(&pi_state->refcount));
 
 	/*
 	 * Handle the owner died case:
@@ -1040,7 +1041,7 @@ static int attach_to_pi_state(u32 uval, struct futex_pi_state *pi_state,
 	if (pid != task_pid_vnr(pi_state->owner))
 		return -EINVAL;
 out_state:
-	atomic_inc(&pi_state->refcount);
+	refcount_inc(&pi_state->refcount);
 	*ps = pi_state;
 	return 0;
 }
@@ -1907,7 +1908,7 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 			 * refcount on the pi_state and store the pointer in
 			 * the futex_q object of the waiter.
 			 */
-			atomic_inc(&pi_state->refcount);
+			refcount_inc(&pi_state->refcount);
 			this->pi_state = pi_state;
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
-- 
2.7.4

