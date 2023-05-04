From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] sched/cpuset: Bring back cpuset_mutex
Date: Thu, 4 May 2023 10:13:37 +0200
Message-ID: <ZFNpMT+gLbETz8Mp@localhost.localdomain>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230503072228.115707-3-juri.lelli@redhat.com>
 <20230504061842.GC1734100@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683188024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=StIZClLvWq1Og9t6DHx1Hzd3Kvv2y6bvz7gxny+91MY=;
        b=ZXqyK89zi8HFk4Ly6aPmIrWt/bgtyfJN7WNZ/9NKAQ37tywrrixO77kMZg1h4XAb26pMjC
        kpSSJT9SDO7HHqBVRCwNZCWSfkdjIjtBr6cYZ/Z94tkxaDj5ESQo3pGH2CYEJubWupXltM
        m75Xq+huZrPnwj+PviHYscFWz10ZDyQ=
Content-Disposition: inline
In-Reply-To: <20230504061842.GC1734100-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On 04/05/23 08:18, Peter Zijlstra wrote:
> On Wed, May 03, 2023 at 09:22:24AM +0200, Juri Lelli wrote:
> 
> >  /*
> > - * There are two global locks guarding cpuset structures - cpuset_rwsem and
> > + * There are two global locks guarding cpuset structures - cpuset_mutex and
> >   * callback_lock. We also require taking task_lock() when dereferencing a
> >   * task's cpuset pointer. See "The task_lock() exception", at the end of this
> > - * comment.  The cpuset code uses only cpuset_rwsem write lock.  Other
> > - * kernel subsystems can use cpuset_read_lock()/cpuset_read_unlock() to
> > - * prevent change to cpuset structures.
> > + * comment.  The cpuset code uses only cpuset_mutex. Other kernel subsystems
> > + * can use cpuset_lock()/cpuset_unlock() to prevent change to cpuset
> > + * structures.
> >   *
> >   * A task must hold both locks to modify cpusets.  If a task holds
> > - * cpuset_rwsem, it blocks others wanting that rwsem, ensuring that it
> > - * is the only task able to also acquire callback_lock and be able to
> > - * modify cpusets.  It can perform various checks on the cpuset structure
> > - * first, knowing nothing will change.  It can also allocate memory while
> > - * just holding cpuset_rwsem.  While it is performing these checks, various
> > - * callback routines can briefly acquire callback_lock to query cpusets.
> > - * Once it is ready to make the changes, it takes callback_lock, blocking
> > - * everyone else.
> > + * cpuset_mutex, it blocks others, ensuring that it is the only task able to
> > + * also acquire callback_lock and be able to modify cpusets.  It can perform
> > + * various checks on the cpuset structure first, knowing nothing will change.
> > + * It can also allocate memory while just holding cpuset_mutex.  While it is
> > + * performing these checks, various callback routines can briefly acquire
> > + * callback_lock to query cpusets.  Once it is ready to make the changes, it
> > + * takes callback_lock, blocking everyone else.
> >   *
> >   * Calls to the kernel memory allocator can not be made while holding
> >   * callback_lock, as that would risk double tripping on callback_lock
> > @@ -403,16 +402,16 @@ static struct cpuset top_cpuset = {
> >   * guidelines for accessing subsystem state in kernel/cgroup.c
> >   */
> >  
> > -DEFINE_STATIC_PERCPU_RWSEM(cpuset_rwsem);
> > +static DEFINE_MUTEX(cpuset_mutex);
> 
> Perhaps extend the comment to state you explicitly want a mutex for PI
> etc.. ?
> 

Sure, can do that.

Thanks!

