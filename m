From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.12 1/2] cgroup: fix cgroup_write_event_control()
Date: Thu, 15 Aug 2013 11:40:32 -0400
Message-ID: <20130815154032.GE14606@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=uHOD/En9kqywCsWUGzPkahD/JuU2M7x4iXaQoyW/CqI=;
        b=WmWwEp+AeKo/ppB+1/bhyX/tSimmDEllGeUHVY463BYzA/8A+CSr3Aen7S9XErX3fZ
         xolZmIxX3uaYkARvxucDLpGq4LD1X3REILMAAVc2xhmt+2t4Tt+EkP+WhRKJKNcj/9Jv
         6iRvyGGcKRSauBZcIaOuHV0xh1o7RRPoNeH4/RV4VpEXtiYp3Q6JCL8k3rQNknSvehca
         3w0UPL+HfUOVbkxGDcDlE97SQFgrHaZm4ICgttazMdiigJFhRIl/lm19I27MDhXhzCDn
         ys/8AjcGor1Fv4vRim7saAv2k/Gpk+KBKbxprD5dZPlWf7ieUc+JvXt17qy2eF8qEfCZ
         53iw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 994a762080e4b136171c82ac78f7d7bbf17a451d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 14 Aug 2013 23:38:21 -0400

81eeaf0411 ("cgroup: make cftype->[un]register_event() deal with
cgroup_subsys_state inst ead of cgroup") updated the cftype event
methods to take @css (cgroup_subsys_state) instead of @cgroup;
however, it incorrectly used @css passed to
cgroup_write_event_control(), which the dummy_css for the cgroup as
the file is a cgroup core file.  This leads to oops on event
registration.

Fix it by using the css matching the event target file.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 66d0107..ef93bfd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4044,10 +4044,10 @@ static void cgroup_event_ptable_queue_proc(struct file *file,
  * Input must be in format '<event_fd> <control_fd> <args>'.
  * Interpretation of args is defined by control file implementation.
  */
-static int cgroup_write_event_control(struct cgroup_subsys_state *css,
+static int cgroup_write_event_control(struct cgroup_subsys_state *dummy_css,
 				      struct cftype *cft, const char *buffer)
 {
-	struct cgroup *cgrp = css->cgroup;
+	struct cgroup *cgrp = dummy_css->cgroup;
 	struct cgroup_event *event;
 	struct cgroup *cgrp_cfile;
 	unsigned int efd, cfd;
@@ -4069,7 +4069,7 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
-	event->css = css;
+
 	INIT_LIST_HEAD(&event->list);
 	init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
 	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
@@ -4105,6 +4105,18 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 		goto out_put_cfile;
 	}
 
+	/* determine the css of @cfile and associate @event with it */
+	rcu_read_lock();
+
+	ret = -EINVAL;
+	event->css = cgroup_css(cgrp, event->cft->ss);
+	if (event->css)
+		ret = 0;
+
+	rcu_read_unlock();
+	if (ret)
+		goto out_put_cfile;
+
 	/*
 	 * The file to be monitored must be in the same cgroup as
 	 * cgroup.event_control is.
@@ -4120,7 +4132,7 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 		goto out_put_cfile;
 	}
 
-	ret = event->cft->register_event(css, event->cft,
+	ret = event->cft->register_event(event->css, event->cft,
 			event->eventfd, buffer);
 	if (ret)
 		goto out_put_cfile;
-- 
1.8.3.1
