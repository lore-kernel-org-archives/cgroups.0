From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 16:31:38 -0400
Message-ID: <20171004203138.GA2632@cmpxchg.org>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <20171004192720.GC1501@cmpxchg.org>
 <20171004195110.GA18900@castle>
 <alpine.DEB.2.10.1710041316120.67374@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zlU+4zrDwluanoDTAx04ucNWn+inRvYa5zpwEYt8784=; b=B2VAqKl7UK6/xmeBxDKCTJayFq
	6vwGiPIze2ja1HGAxyiclWPhXTKJ4vOBZiprXONuQxXSJwxnDGO3Y/8W6fKcvvK/cTAEVNKJu5FSg
	j7nn6gsY3uAxMjtHzw2OlhBvfM+PI5hnakt+jmeDl9ehklNLiKYPvborm9ZRJPuOExrw=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710041316120.67374@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

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

Yup, I realized it when reviewing the next patch. Moving this hunk to
the next patch would probably make sense. Although, us reviewers have
been made aware of this now, so I don't feel strongly about it. Won't
make much of a difference once the patches are merged.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
