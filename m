From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v3 1/6] mm, oom: use oom_victims counter to synchronize oom
 victim selection
Date: Thu, 22 Jun 2017 17:58:58 +0100
Message-ID: <20170622165858.GA30035@castle>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
 <1498079956-24467-2-git-send-email-guro@fb.com>
 <201706220040.v5M0eSnK074332@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=JSqPHgizVFP1sqDHGqtUVVMgKhBf2gg31qL4JUshYUY=;
 b=HPIyO6UXn1+xMGEMMRZEXUzJ8acAwWM+HERthSGwCrW2sN8MY7e4pGVjNVuqM+Q8rMuN
 0Q/mvQrO+hq3q7OtUEw58c5UaE+Wben9azUGSyydswbv4S4g1oc3zR1VgZD0kd8UAgGL
 X9fpzQVW+YaQiPdSw9QeCk8UwpkmqcM/FNQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JSqPHgizVFP1sqDHGqtUVVMgKhBf2gg31qL4JUshYUY=;
 b=DLF6XpQ8KXlY4vh6PVXpSlUhxHJg0i/n7lyjOENqQPRszU3pZfxlF/Uh7CWWDSDuW8ItWHFqEnvftzbMlA4t3CapnUlZn2tdg+Qaw51icDBpW0o0LCOemYouWSCBAL1szLXQGVAo+ygUecg5bo0hxLx+ayjpfw5NwSkvEGM+LFM=
Content-Disposition: inline
In-Reply-To: <201706220040.v5M0eSnK074332-etx+eQDEXHD7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 22, 2017 at 09:40:28AM +0900, Tetsuo Handa wrote:
> Roman Gushchin wrote:
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -992,6 +992,13 @@ bool out_of_memory(struct oom_control *oc)
> >  	if (oom_killer_disabled)
> >  		return false;
> >  
> > +	/*
> > +	 * If there are oom victims in flight, we don't need to select
> > +	 * a new victim.
> > +	 */
> > +	if (atomic_read(&oom_victims) > 0)
> > +		return true;
> > +
> >  	if (!is_memcg_oom(oc)) {
> >  		blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
> >  		if (freed > 0)
> 
> Above in this patch and below in patch 5 are wrong.
> 
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -665,7 +672,13 @@ static void mark_oom_victim(struct task_struct *tsk)
> >  	 * that TIF_MEMDIE tasks should be ignored.
> >  	 */
> >  	__thaw_task(tsk);
> > -	atomic_inc(&oom_victims);
> > +
> > +	/*
> > +	 * If there are no oom victims in flight,
> > +	 * give the task an access to the memory reserves.
> > +	 */
> > +	if (atomic_inc_return(&oom_victims) == 1)
> > +		set_tsk_thread_flag(tsk, TIF_MEMDIE);
> >  }
> >  
> >  /**
> 
> The OOM reaper is not available for CONFIG_MMU=n kernels, and timeout based
> giveup is not permitted, but a multithreaded process might be selected as
> an OOM victim. Not setting TIF_MEMDIE to all threads sharing an OOM victim's
> mm increases possibility of preventing some OOM victim thread from terminating
> (e.g. one of them cannot leave __alloc_pages_slowpath() with mmap_sem held for
> write due to waiting for the TIF_MEMDIE thread to call exit_oom_victim() when
> the TIF_MEMDIE thread is waiting for the thread with mmap_sem held for write).

I agree, that CONFIG_MMU=n is a special case, and the proposed approach can't
be used directly. But can you, please, why do you find the first  chunk wrong?
Basically, it's exactly what we do now: we increment oom_victims for every oom
victim, and every process decrements this counter during it's exit path.
If there is at least one existing victim, we will select it again, so it's just
an optimization. Am I missing something? Why should we start new victim selection
if there processes that will likely quit and release memory soon?

Thanks!
