From: Waiman Long <longman@redhat.com>
Subject: [PATCH 1/5] cgroup/cpuset: Don't call validate_change() for some flag changes
Date: Thu,  3 Jun 2021 17:24:12 -0400
Message-ID: <20210603212416.25934-2-longman@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622755497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=r7Nr9zyNvu4ZyjMH6h4XMEahwlMJwXbItTVRKJ/5iiE=;
        b=FPsIPGmtvPRLMlwzzBbkVeBER19KNoAzD0Dn4YimNw785ik2L38W6MntZa+9xwzWxSRqQ/
        NrqR4Zr+vs8otu/bZZx9u6JWs+gOrhWQt7N+02LHhl+JP9sGdVrDrjxy0M1R0/iotHOczP
        l+WnjueowZqNFLF8lDW2+Y/A/2MWMk8=
In-Reply-To: <20210603212416.25934-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

The update_flag() is called with one flag bit change and without change
in the various cpumasks in the cpuset. Moreover, not all changes in the
flag bits are validated in validate_change().  In particular, the load
balance flag and the two spread flags are not checked there. So there
is no point in calling validate_change() if those flag bits change.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index adb5190c4429..65ad6995ad77 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1891,7 +1891,7 @@ static void update_tasks_flags(struct cpuset *cs)
  * cs:		the cpuset to update
  * turning_on: 	whether the flag is being set or cleared
  *
- * Call with cpuset_mutex held.
+ * Call with cpuset_mutex held & cpumasks remain unchanged.
  */
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
@@ -1911,16 +1911,22 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	else
 		clear_bit(bit, &trialcs->flags);
 
-	err = validate_change(cs, trialcs);
-	if (err < 0)
-		goto out;
-
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	/*
+	 * validate_change() doesn't validate changes in load balance
+	 * and spread flags.
+	 */
+	if (!balance_flag_changed && !spread_flag_changed) {
+		err = validate_change(cs, trialcs);
+		if (err < 0)
+			goto out;
+	}
+
 	spin_lock_irq(&callback_lock);
 	cs->flags = trialcs->flags;
 	spin_unlock_irq(&callback_lock);
-- 
2.18.1

