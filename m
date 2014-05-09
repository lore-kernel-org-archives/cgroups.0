From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/9] cgroup: separate out cgroup_has_live_children() from cgroup_destroy_locked()
Date: Fri,  9 May 2014 17:13:29 -0400
Message-ID: <1399670015-23463-4-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sFDp9uiO5Po46JV9FuQ7tFvS/t9UsQh+va/BhduJzHI=;
        b=XbKqSp5ipBR45ebVw5NfU9g+LWEhyYP2ccPGROuxEsP1noJlUrZArhLwBtJDj4kKyw
         TCafiCTKVac30eQxSTa3XwjiFHOYDAU1fRCnMY6U3MA+SUF/Ze27xzOTiH3YEueuWgag
         NssDP9+H099izBcsVFX50CAQBQChDDBZFV+ONcFzoinWip1GKyo3TTP24HANQlEEXPl8
         X1Ub7n5Wtp/QvWrKPsjCIxCJsn/cZnsS6I3fWsKf2WT9XVGm5oNlq5s5ydxUXkrEU4yT
         7+yBbV0UBgn4HPD6J4yUdQ7/FcclRxR2gGwGSaHWwZbmQS+OP1GzZpuG2YZ9Ox4p77Wy
         3kNg==
In-Reply-To: <1399670015-23463-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We're expecting another user.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b3708a8..d369f19 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3294,6 +3294,21 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 	return css_parent(pos);
 }
 
+static bool cgroup_has_live_children(struct cgroup *cgrp)
+{
+	struct cgroup *child;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+		if (!cgroup_is_dead(child)) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+	return false;
+}
+
 /**
  * css_advance_task_iter - advance a task itererator to the next css_set
  * @it: the iterator to advance
@@ -4464,7 +4479,6 @@ static void kill_css(struct cgroup_subsys_state *css)
 static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
-	struct cgroup *child;
 	struct cgroup_subsys_state *css;
 	bool empty;
 	int ssid;
@@ -4486,15 +4500,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * emptiness as dead children linger on it while being destroyed;
 	 * otherwise, "rmdir parent/child parent" may fail with -EBUSY.
 	 */
-	empty = true;
-	rcu_read_lock();
-	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
-		empty = cgroup_is_dead(child);
-		if (!empty)
-			break;
-	}
-	rcu_read_unlock();
-	if (!empty)
+	if (cgroup_has_live_children(cgrp))
 		return -EBUSY;
 
 	/*
-- 
1.9.0
