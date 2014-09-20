From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Sat, 20 Sep 2014 13:28:19 -0400
Message-ID: <20140920172819.GD3681@htj.dyndns.org>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
 <541D16EA.70407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zal/m5iWQQ66uPzRlhRn5xdYsvWNntC0AxB+mw2L3Yw=;
        b=Vcwo3oHlgyXzPA2ovaJl+kYc5plJ0hstjIy/f6fJnmOQSTJXTl9rkt2Pr85QMO1NYW
         PQmGsQPAXU9WYe2nusvVDIcK0Swr6O/nGN/vrxd0XWT0cmN3roYUVHu4CxYIGH/4lkTp
         mzEBIZ1tZ3gu+ihPczziazwWHdVzSTdNO65W7unPMN+IOo4DzZgFDHEf3OeLt1vVpGG1
         2Ztb1x04cesGQB8JdR/Hg1SbgoSxy01Jje9Bz9b0Xx9zoZLvIYjHecu+uhyvLOo01a+5
         26QSoKNmx7ayGGlMiQXtuSS10JdZ7rweJyXjjexzNiimN3DbM5qYogDYaxgZWgN+P/hu
         I+ug==
Content-Disposition: inline
In-Reply-To: <541D16EA.70407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hello,

On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
> > Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
> > The user is running cgrulesengd process in order to utilize cpuset cgroup.
> > Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
> > writes someone's pid to /cgroup/cpuset/$group/tasks interface.
> > 
> > cpuset_update_task_spread_flag() is updating other thread's
> > "struct task_struct"->flags without exclusion control or atomic
> > operations!
> > 
> > ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
> > 300:/*
> > 301: * update task's spread flag if cpuset's page/slab spread flag is set
> > 302: *
> > 303: * Called with callback_mutex/cgroup_mutex held
> > 304: */
> > 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
> > 306:                                    struct task_struct *tsk)
> > 307:{
> > 308:    if (is_spread_page(cs))
> > 309:            tsk->flags |= PF_SPREAD_PAGE;
> > 310:    else
> > 311:            tsk->flags &= ~PF_SPREAD_PAGE;
> > 312:    if (is_spread_slab(cs))
> > 313:            tsk->flags |= PF_SPREAD_SLAB;
> > 314:    else
> > 315:            tsk->flags &= ~PF_SPREAD_SLAB;
> > 316:}
> 
> We should make the updating of this flag atomic.

Ugh, why do we even implement that in cpuset.  This should be handled
by MPOL_INTERLEAVE.  It feels like people have been using cpuset as
the dumpsite that people used w/o thinking much.  Going forward, let's
please confine cpuset to collective cpu and memory affinity
configuration.  It really shouldn't be implementing novel features for
scheduler or mm.

Anyways, yeah, the patch looks correct to me.  Can you please send a
version w/ proper description and sob?

Thanks.

-- 
tejun
