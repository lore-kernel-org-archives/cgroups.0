From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 09/14] cgroup: bounce cgroup_subsys_state ref kill confirmation to a work item
Date: Thu,  8 Aug 2013 16:13:46 -0400
Message-ID: <1375992831-4650-10-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xftLf4lFWcM81jXhRv3M6M69jOLuDmShzjALoy9HSnw=;
        b=QJhylDKJk14NaXR9odsZE2yrKf/7xsG1mSdcAt5wbIaGpvjM/FOpVT6PibzKYlHQSN
         ch2mJGOcHEEQ6m/6o/40+iVxbqJAYRKeQ+9AyDFpIrATlP7WECl9cyRN97KpD+jRQCNp
         WqTah7i1I5ZQKip6ka3o7J2KUiT/tcjcg3YGewtdIGBZQbgaOSteQQU98NsB6yQrQPiE
         f8gCF6o9H1DllSDj3wV7fiwVgxTYRTxDgxTwn6+NlUqbJpdpNEfJYIN4oDXi/mz64vkQ
         Po3NYA8s3oKXYhiU1d4D+gH5fq2pkRaNzw1fplctQP28oUsw3rbLtyJSR+c2AYyMp9Yc
         JbKA==
In-Reply-To: <1375992831-4650-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

css (cgroup_subsys_state) offlining, which requires process context,
will be moved to ref kill confirmation.  In preparation, bounce
css_killed handling through css->destroy_work.

css_ref_killed_fn() is renamed to css_killed_ref_fn() so that it's
consistent with the new css_killed_work_fn().

This patch adds an additional work item bouncing but doesn't change
the actual logic.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 06ba664..88b1095 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4551,12 +4551,27 @@ static void cgroup_css_killed(struct cgroup *cgrp)
 	schedule_work(&cgrp->destroy_work);
 }
 
-static void css_ref_killed_fn(struct percpu_ref *ref)
+/*
+ * This is called when the refcnt of a css is confirmed to be killed.
+ * css_tryget() is now guaranteed to fail.
+ */
+static void css_killed_work_fn(struct work_struct *work)
+{
+	struct cgroup_subsys_state *css =
+		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup *cgrp = css->cgroup;
+
+	cgroup_css_killed(cgrp);
+}
+
+/* css kill confirmation processing requires process context, bounce */
+static void css_killed_ref_fn(struct percpu_ref *ref)
 {
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	cgroup_css_killed(css->cgroup);
+	INIT_WORK(&css->destroy_work, css_killed_work_fn);
+	schedule_work(&css->destroy_work);
 }
 
 /**
@@ -4630,7 +4645,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		percpu_ref_get(&css->refcnt);
 
 		atomic_inc(&cgrp->css_kill_cnt);
-		percpu_ref_kill_and_confirm(&css->refcnt, css_ref_killed_fn);
+		percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
 	}
 	cgroup_css_killed(cgrp);
 
-- 
1.8.3.1
