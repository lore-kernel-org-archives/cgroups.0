From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.14-fixes] cgroup: update
 cgroup_enable_task_cg_lists() to grab siglock
Date: Thu, 13 Feb 2014 13:29:31 -0500
Message-ID: <20140213182931.GB17608@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=mGfG2Hh7FTnTYVT6HHBuZuuiV8GlziTDTzyU4Cw8QTo=;
        b=y6fD1AW1RW2nZ13Qz4oIIlLURnSbw7aloWJm4lDiHvZgq5rsu6cty5DRIaqNCY2a4f
         6QDjoZfgyabeaTEWnaq1I9Jx+K4/jafxflqamTm2VvqhHwLyW/UDO4HGeVPOIcqwwWbF
         8jaJ7eqpEUApSFxTkDolINQXbxJ9kTyv8K0RMVmauDktjqzhNOVhfgECdRHhk2Of0+CL
         rbW29bL7y1BNCcPZc5Qbmi2R/D36eK0K+vtCfYtZktMU0c7QbOSkNzKSxOwIqcLxLCpR
         58KE9yLnI0oATfKbiexADaOj32IOTGKKide7cZ+foOHbOSi3B7RC4gnpimhv3AB9MBgh
         alfQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently, there's nothing preventing cgroup_enable_task_cg_lists()
from missing set PF_EXITING and race against cgroup_exit().  Depending
on the timing, cgroup_exit() may finish with the task still linked on
css_set leading to list corruption.  Fix it by grabbing siglock in
cgroup_enable_task_cg_lists() so that PF_EXITING is guaranteed to be
visible.

This whole on-demand cg_list optimization is extremely fragile and has
ample possibility to lead to bugs which can cause things like
once-a-year oops during boot.  I'm wondering whether the better
approach would be just adding "cgroup_disable=all" handling which
disables the whole cgroup rather than tempting fate with this
on-demand craziness.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 68d8710..105f273 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2905,9 +2905,14 @@ static void cgroup_enable_task_cg_lists(void)
 		 * We should check if the process is exiting, otherwise
 		 * it will race with cgroup_exit() in that the list
 		 * entry won't be deleted though the process has exited.
+		 * Do it while holding siglock so that we don't end up
+		 * racing against cgroup_exit().
 		 */
+		spin_lock_irq(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
 			list_add(&p->cg_list, &task_css_set(p)->tasks);
+		spin_unlock_irq(&p->sighand->siglock);
+
 		task_unlock(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
