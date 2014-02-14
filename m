From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 cgroup/for-3.15] cgroup: make
 cgroup_enable_task_cg_lists() to grab siglock
Date: Fri, 14 Feb 2014 15:47:09 -0500
Message-ID: <20140214204709.GB2851@mtj.dyndns.org>
References: <20140213182931.GB17608@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hOs+520yfzzFJlvRe6cHmjjtkPR0nRWSOSO/QZdpV5E=;
        b=CjUGQIwbiGQugSmKQLOJmDqEDJb9SdJIff8D+D40pffrLvbf1o0msTb6tSaMstcHJb
         P528411U0hA/fDW1DBI2C5O8lBMrFeFPQP5MEms7p39hEq7Yy612lEuz5fC4dayR/WH7
         rkKXIiS81m4PmyE8lXQIfDHdSkUWsKd1HcdEKzqI6UI9b6+uKRtwrLGuyQ5GuE0Ixv1j
         0Y6anpefaL7a+5/GEmJ5B4xAHEgXWZaulHBrUv08eJhWgDNMUt9EAgacOB44WWozJ2tK
         Cuc0luYjW/OznBMDFz19fTQRnF3ftqjDRsBkIwx/WcCPJg2Blo2xcO3eaVEQHOQuAVNA
         bnWQ==
Content-Disposition: inline
In-Reply-To: <20140213182931.GB17608-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently, there's nothing explicitly preventing
cgroup_enable_task_cg_lists() from missing set PF_EXITING and race
against cgroup_exit(), and, depending on the timing, cgroup_exit()
seemingly may finish with the task still linked on css_set leading to
list corruption because cgroup_enable_task_cg_lists() can end up
linking it after list_empty(&tsk->cg_list) test in cgroup_exit().

This can't really happen because exit_mm() grabs and release
task_lock() between setting of PF_EXITING and cgroup_exit(), and
cgroup_enable_task_cg_lists() synchronizes against task_lock too;
however, this is fragile and more of a happy accident.  Let's make the
synchronization explicit by making cgroup_enable_task_cg_lists() grab
siglock around PF_EXITING testing.

This whole on-demand cg_list optimization is extremely fragile and has
ample possibility to lead to bugs which can cause things like
once-a-year oops during boot.  I'm wondering whether the better
approach would be just adding "cgroup_disable=all" handling which
disables the whole cgroup rather than tempting fate with this dynamic
optimization craziness.

v2: Li pointed out that the race condition can't actually happen due
    to task_lock locking in exit_mm().  Updated the patch description
    accordingly and dropped -stable cc.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1331,9 +1331,13 @@ static void cgroup_enable_task_cg_lists(
 		 * We should check if the process is exiting, otherwise
 		 * it will race with cgroup_exit() in that the list
 		 * entry won't be deleted though the process has exited.
+		 * Do it while holding siglock so that we don't end up
+		 * racing against cgroup_exit().
 		 */
+		spin_lock_irq(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING))
 			list_add(&p->cg_list, &task_css_set(p)->tasks);
+		spin_unlock_irq(&p->sighand->siglock);
 
 		task_unlock(p);
 	} while_each_thread(g, p);
