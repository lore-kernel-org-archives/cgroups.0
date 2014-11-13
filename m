From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.19 3/3] cgroup: fix the async css offline wait
 logic in cgroup_subtree_control_write()
Date: Thu, 13 Nov 2014 16:59:21 -0500
Message-ID: <20141113215921.GC2598@htj.dyndns.org>
References: <20141113215813.GA2598@htj.dyndns.org>
 <20141113215848.GB2598@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MQVwJ1aIvt8jYucEOQ2/Czr28G3Y13QqSc4SRJ11+pE=;
        b=bvQ0yVVkNgJ9ukPsu7PW7mBMoHIZqCgIfVIdz9e43QN2iFJOgJHAqD/l2lFFK6J4CS
         ZYy1ylsGdSBE7anT/nKo5d5uEHr5/FYleRqbv2Jzw4JRlukr9e0ubEbnIHWKYbSVDtfW
         Xz380t2TCy4ApDWM9ucxaXNUsCLo+RKjDlr1f2LHuOAiWR1dO6O2zc8VXMuvXjztb6GW
         JFza0Rm7xhgkAN1XtAtTTNi3AMZj6WdholspMnWojMmXsBaMXUoS+PhfLmG52F+DYiE2
         siQy4BUnPxxgD7dK9CyWQScXQPpzfGu3JxpaSxkT2B+K7bTQ4oVE9NpGXnMB4JwsTcLs
         +I1g==
Content-Disposition: inline
In-Reply-To: <20141113215848.GB2598-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When a subsystem is offlined, its entry on @cgrp->subsys[] is cleared
asynchronously.  If cgroup_subtree_control_write() is requested to
enable the subsystem again before the entry is cleared, it has to wait
for the previous offlining to finish and clear the @cgrp->subsys[]
entry before trying to enable the subsystem again.

This is currently done while verifying the input enable / disable
parameters.  This used to be correct but f63070d350e3 ("cgroup: make
interface files visible iff enabled on cgroup->subtree_control")
breaks it.  The commit is one of the commits implementing subsystem
dependency.

Through subsystem dependency, some subsystems may be enabled and
disabled implicitly in addition to the explicitly requested ones.  The
actual subsystems to be enabled and disabled are determined during
@css_enable/disable calculation.  The current offline wait logic skips
the ones which are already implicitly enabled and then waits for
subsystems in @enable; however, this misses the subsystems which may
be implicitly enabled through dependency from @enable.  If such
implicitly subsystem hasn't yet finished offlining yet, the function
ends up trying to create a css when its @cgrp->subsys[] slot is
already occupied triggering BUG_ON() in init_and_link_css().

Fix it by moving the wait logic after @css_enable is calculated and
waiting for all the subsystems in @css_enable.  This fixes the above
bug as the mask contains all subsystems which are to be enabled
including the ones enabled through dependencies.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: f63070d350e3 ("cgroup: make interface files visible iff enabled on cgroup->subtree_control")
---
 kernel/cgroup.c |   58 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2705,36 +2705,6 @@ static ssize_t cgroup_subtree_control_wr
 				ret = -ENOENT;
 				goto out_unlock;
 			}
-
-			/*
-			 * @ss is already enabled through dependency and
-			 * we'll just make it visible.  Skip draining.
-			 */
-			if (cgrp->child_subsys_mask & (1 << ssid))
-				continue;
-
-			/*
-			 * Because css offlining is asynchronous, userland
-			 * might try to re-enable the same controller while
-			 * the previous instance is still around.  In such
-			 * cases, wait till it's gone using offline_waitq.
-			 */
-			cgroup_for_each_live_child(child, cgrp) {
-				DEFINE_WAIT(wait);
-
-				if (!cgroup_css(child, ss))
-					continue;
-
-				cgroup_get(child);
-				prepare_to_wait(&child->offline_waitq, &wait,
-						TASK_UNINTERRUPTIBLE);
-				cgroup_kn_unlock(of->kn);
-				schedule();
-				finish_wait(&child->offline_waitq, &wait);
-				cgroup_put(child);
-
-				return restart_syscall();
-			}
 		} else if (disable & (1 << ssid)) {
 			if (!(cgrp->subtree_control & (1 << ssid))) {
 				disable &= ~(1 << ssid);
@@ -2780,6 +2750,34 @@ static ssize_t cgroup_subtree_control_wr
 	enable |= css_enable;
 	disable |= css_disable;
 
+	/*
+	 * Because css offlining is asynchronous, userland might try to
+	 * re-enable the same controller while the previous instance is
+	 * still around.  In such cases, wait till it's gone using
+	 * offline_waitq.
+	 */
+	for_each_subsys(ss, ssid) {
+		if (!(css_enable & (1 << ssid)))
+			continue;
+
+		cgroup_for_each_live_child(child, cgrp) {
+			DEFINE_WAIT(wait);
+
+			if (!cgroup_css(child, ss))
+				continue;
+
+			cgroup_get(child);
+			prepare_to_wait(&child->offline_waitq, &wait,
+					TASK_UNINTERRUPTIBLE);
+			cgroup_kn_unlock(of->kn);
+			schedule();
+			finish_wait(&child->offline_waitq, &wait);
+			cgroup_put(child);
+
+			return restart_syscall();
+		}
+	}
+
 	cgrp->subtree_control = new_sc;
 	cgrp->child_subsys_mask = new_ss;
 
