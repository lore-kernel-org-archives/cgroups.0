From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 21:22:07 +0100
Message-ID: <20171004202207.GB4174@castle>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <20171004192720.GC1501@cmpxchg.org>
 <20171004195110.GA18900@castle>
 <alpine.DEB.2.10.1710041316120.67374@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=N5MbtsCPT38rZ7GsZuLyGN1RhSRsoLLW4MwEHe8GLRU=;
 b=EMqVAv/TqhIbdKjTV32pS4Ge3Z7mL90Hgsl031H4hniIFGxSQjeZd3CAC0d7em1GOVbv
 vIMqCGoWQMGv6yhCzgnYBdpxbzunwpqHA3lb8VZvWQ7SkU784mDc+jJtUTMRci+aknLy
 sJo6KrvXlRGhgH9sp2E/yV265WOt9SCrQKs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=N5MbtsCPT38rZ7GsZuLyGN1RhSRsoLLW4MwEHe8GLRU=;
 b=EiAWZPZcbXwPixuXJ+5FAKjezq5EK3idlWDyhwjodeYH2IHc+tM9HoemxWCHG0D1j63HtZaSFh/jlSrbrUafp/i3NE2HqyPltyQc+GOfHbTFWrhXLwAV6LcaPrfyG3+NVSPj8iJu6WM8Mb5mqux9UjNhttxWI+ogNA0n7zipcGE=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710041316120.67374-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Oct 04, 2017 at 01:17:14PM -0700, David Rientjes wrote:
> On Wed, 4 Oct 2017, Roman Gushchin wrote:
> 
> > > > @@ -828,6 +828,12 @@ static void __oom_kill_process(struct task_struct *victim)
> > > >  	struct mm_struct *mm;
> > > >  	bool can_oom_reap = true;
> > > >  
> > > > +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD) ||
> > > > +	    victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
> > > > +		put_task_struct(victim);
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	p = find_lock_task_mm(victim);
> > > >  	if (!p) {
> > > >  		put_task_struct(victim);
> > > 
> > > Is this necessary? The callers of this function use oom_badness() to
> > > find a victim, and that filters init, kthread, OOM_SCORE_ADJ_MIN.
> > 
> > It is. __oom_kill_process() is used to kill all processes belonging
> > to the selected memory cgroup, so we should perform these checks
> > to avoid killing unkillable processes.
> > 
> 
> That's only true after the next patch in the series which uses the 
> oom_kill_memcg_member() callback to kill processes for oom_group, correct?  
> Would it be possible to move this check to that patch so it's more 
> obvious?

Sure, no problems.
