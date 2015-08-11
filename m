From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: replace "cgroup.populated" with "cgroup.events"
Date: Tue, 11 Aug 2015 13:58:02 -0400
Message-ID: <1439315889-3492-2-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p5RbZuCb67p3iUUuBTUW/io0sIiXux52MD152J2FnM4=;
        b=OtYrSt3Z3hYIIhuWsHpf7USW3HQ3HP+jBwZiHgQs0OUrm58McLt/YrMJ2zaMpINqml
         OB4/vWVqX17DkFhhMIx5qTWtyyJ1fVPmaGA2ePfamkpR5w+psC0Yn7kecXrUyQ+wHKsV
         rEWT/tJ9s0KaD69p36gHBjfSTEiXAsq2AC4hW3agC4wQA4iRaLiCuUqKah222Yj01jIs
         BzaAHXmvPATp6z+mWEWgX+3MLMzGsM/MUU6MbGy6MFMbSpLRCW3HG9R9pTVBCVfnOj4d
         Mb3T2gHha3/hA3/uiE21yJA7ek0JP8tHQclAdYW7CZuGJCrOBNUd6HtZnZILfcjO3ZZG
         fbgg==
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

memcg already uses "memory.events" for event reporting and other
controllers may need event reporting too.  Let's standardize on
"$SUBSYS.events" interface file for reporting events which don't
happen too frequently and thus can share event notification.

"cgroup.populated" is replaced with "populated" field in
"cgroup.events" and documentation is updated accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroups/unified-hierarchy.txt | 15 ++++++++++-----
 include/linux/cgroup-defs.h                 |  2 +-
 kernel/cgroup.c                             | 17 +++++++++--------
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 1ee9caf..7ea2bc1 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -341,11 +341,11 @@ is riddled with issues.
   unnecessarily complicated and probably done this way because event
   delivery itself was expensive.
 
-Unified hierarchy implements an interface file "cgroup.populated"
-which can be used to monitor whether the cgroup's subhierarchy has
-tasks in it or not.  Its value is 0 if there is no task in the cgroup
-and its descendants; otherwise, 1.  poll and [id]notify events are
-triggered when the value changes.
+Unified hierarchy implements "populated" field in "cgroup.events"
+interface file which can be used to monitor whether the cgroup's
+subhierarchy has tasks in it or not.  Its value is 0 if there is no
+task in the cgroup and its descendants; otherwise, 1.  poll and
+[id]notify events are triggered when the value changes.
 
 This is significantly lighter and simpler and trivially allows
 delegating management of subhierarchy - subhierarchy monitoring can
@@ -435,6 +435,11 @@ may be specified in any order and not all pairs have to be specified.
   the first entry in the file.  Specific entries can use "default" as
   its value to indicate inheritance of the default value.
 
+- For events which are not very high frequency, an interface file
+  "events" should be created which lists event key value pairs.
+  Whenever a notifiable event happens, file modified event should be
+  generated on the file.
+
 
 5-4. Per-Controller Changes
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 5294f1f..74d241d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -226,7 +226,7 @@ struct cgroup {
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct kernfs_node *procs_kn;	/* kn for "cgroup.procs" */
-	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
+	struct kernfs_node *events_kn;	/* kn for "cgroup.events" */
 
 	/*
 	 * The bitmask of subsystems enabled on the child cgroups.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c4d94a5..43535fc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -519,8 +519,8 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 		if (!trigger)
 			break;
 
-		if (cgrp->populated_kn)
-			kernfs_notify(cgrp->populated_kn);
+		if (cgrp->events_kn)
+			kernfs_notify(cgrp->events_kn);
 		cgrp = cgroup_parent(cgrp);
 	} while (cgrp);
 }
@@ -2944,9 +2944,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	goto out_unlock;
 }
 
-static int cgroup_populated_show(struct seq_file *seq, void *v)
+static int cgroup_events_show(struct seq_file *seq, void *v)
 {
-	seq_printf(seq, "%d\n", (bool)seq_css(seq)->cgroup->populated_cnt);
+	seq_printf(seq, "populated %d\n",
+		   (bool)seq_css(seq)->cgroup->populated_cnt);
 	return 0;
 }
 
@@ -3113,8 +3114,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 
 	if (cft->write == cgroup_procs_write)
 		cgrp->procs_kn = kn;
-	else if (cft->seq_show == cgroup_populated_show)
-		cgrp->populated_kn = kn;
+	else if (cft->seq_show == cgroup_events_show)
+		cgrp->events_kn = kn;
 	return 0;
 }
 
@@ -4287,9 +4288,9 @@ static struct cftype cgroup_dfl_base_files[] = {
 		.write = cgroup_subtree_control_write,
 	},
 	{
-		.name = "cgroup.populated",
+		.name = "cgroup.events",
 		.flags = CFTYPE_NOT_ON_ROOT,
-		.seq_show = cgroup_populated_show,
+		.seq_show = cgroup_events_show,
 	},
 	{ }	/* terminate */
 };
-- 
2.4.3
