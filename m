From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 10:03:32 -0800
Message-ID: <20130307180332.GE29601@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=TEoTdfj+evaZu3B4oud+L6Hzd4sBs8cEPF16gvLNE90=;
        b=Ry0hRZbqoy1AZNo9tA0pqaK0OwCi6iXAZxgGzEwrcHFJR9B+3Rb5UbDb3c5gakYeAm
         BC6unnEyIWOo4Zghp42kzaTbw802DDKviKeEbt2oI1UhGnu2sNLKRjo8l9Cp0QnRozDR
         AYOzZmkMGMs2eYwRDmLXfcUe4jLfoplanE4OxCS4N5mDtxdyPOB85MTR1R5PvAErDYcD
         cF4kpEn0QICAY5/QYHIEoX4Z5vB0PKv9m3yzGCksLrNVJr0LvtNPqeAxxCOUlQ2ZaAUh
         pYY6D+4XSG+ObzSTUiey/7md598I9viYe/eGQckJbsuZkBgOKErvWM3bADIeitWbINDc
         Gq7w==
Content-Disposition: inline
In-Reply-To: <20130307180139.GD29601-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 07, 2013 at 10:01:39AM -0800, Tejun Heo wrote:
> Hello, Oleg.
> 
> On Thu, Mar 07, 2013 at 06:25:45PM +0100, Oleg Nesterov wrote:
> > > [  944.011126] Chain exists of:
> > >   &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex
> > >
> > > [  944.012745]  Possible unsafe locking scenario:
> > >
> > > [  944.013617]        CPU0                    CPU1
> > > [  944.014280]        ----                    ----
> > > [  944.014942]   lock(&sig->cred_guard_mutex);
> > > [  944.021332]                                lock(cgroup_mutex);
> > > [  944.028094]                                lock(&sig->cred_guard_mutex);
> > > [  944.035007]   lock(&sb->s_type->i_mutex_key#9);
> > > [  944.041602]
> > 
> > And cgroup_mount() does i_mutex -> cgroup_mutex...
> 
> Hmmm...
> 
> > Add cc's. I do not think we can move open_exec() outside of cred_guard_mutex.
> > We can change do_execve_common(), but binfmt->load_binary() does open() too.
> > 
> > And it is not easy to avoid ->cred_guard_mutex in threadgroup_lock(), we can't
> > change de_thread() to do threadgroup_change_begin/end...
> > 
> > Or perhaps we can? It doesn't need to sleep under ->group_rwsem, we only
> > need it around ->group_leader changing. Otherwise cgroup_attach_proc()
> > can rely on do_exit()->threadgroup_change_begin() ?
> 
> Using cred_guard_mutex was mostly to avoid adding another locking in
> de_thread() path as it already had one.  We can add group_rwsem
> locking deeper inside and avoid this problem.
> 
> > But perhaps someone can suggest another fix in cgroup.c.
> 
> Another possibility is moving cgroup_lock outside threadgroup_lock(),
> which was impossible before because of cgroup_lock abuses in specific
> controller implementations but most of that have been updated and we
> should now be pretty close to being able to make cgroup_lock outer to
> most other locks.  Appending a completely untested patch below.
> 
> Li, what do you think?

Oops, it was the wrong patch.  Here's the correct one.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..e7e5e57 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2193,17 +2193,13 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 	const struct cred *cred = current_cred(), *tcred;
 	int ret;
 
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
-
 retry_find_task:
 	rcu_read_lock();
 	if (pid) {
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
 			rcu_read_unlock();
-			ret= -ESRCH;
-			goto out_unlock_cgroup;
+			return -ESRCH;
 		}
 		/*
 		 * even if we're attaching all tasks in the thread group, we
@@ -2214,8 +2210,7 @@ retry_find_task:
 		    !uid_eq(cred->euid, tcred->uid) &&
 		    !uid_eq(cred->euid, tcred->suid)) {
 			rcu_read_unlock();
-			ret = -EACCES;
-			goto out_unlock_cgroup;
+			return -EACCES;
 		}
 	} else
 		tsk = current;
@@ -2229,36 +2224,37 @@ retry_find_task:
 	 * with no rt_runtime allocated.  Just say no.
 	 */
 	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
-		ret = -EINVAL;
 		rcu_read_unlock();
-		goto out_unlock_cgroup;
+		return -EINVAL;
 	}
 
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
 	threadgroup_lock(tsk);
-	if (threadgroup) {
-		if (!thread_group_leader(tsk)) {
-			/*
-			 * a race with de_thread from another thread's exec()
-			 * may strip us of our leadership, if this happens,
-			 * there is no choice but to throw this task away and
-			 * try again; this is
-			 * "double-double-toil-and-trouble-check locking".
-			 */
-			threadgroup_unlock(tsk);
-			put_task_struct(tsk);
-			goto retry_find_task;
-		}
-		ret = cgroup_attach_proc(cgrp, tsk);
-	} else
-		ret = cgroup_attach_task(cgrp, tsk);
-	threadgroup_unlock(tsk);
+	if (threadgroup && !thread_group_leader(tsk)) {
+		/*
+		 * a race with de_thread from another thread's exec() may
+		 * strip us of our leadership, if this happens, there is no
+		 * choice but to throw this task away and try again; this
+		 * is "double-double-toil-and-trouble-check locking".
+		 */
+		threadgroup_unlock(tsk);
+		put_task_struct(tsk);
+		goto retry_find_task;
+	}
 
+	ret = -ENODEV;
+	if (cgroup_lock_live_group(cgrp)) {
+		if (threadgroup)
+			ret = cgroup_attach_proc(cgrp, tsk);
+		else 
+			ret = cgroup_attach_task(cgrp, tsk);
+		cgroup_unlock();
+	}
+
+	threadgroup_unlock(tsk);
 	put_task_struct(tsk);
-out_unlock_cgroup:
-	cgroup_unlock();
 	return ret;
 }
 
