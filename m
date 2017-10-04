From: David Rientjes <rientjes@google.com>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 13:17:14 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710041316120.67374@chino.kir.corp.google.com>
References: <20171004154638.710-1-guro@fb.com> <20171004154638.710-4-guro@fb.com> <20171004192720.GC1501@cmpxchg.org> <20171004195110.GA18900@castle>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=cwJquq3+brcTcp/LRTk9vlUwXNb1FkWX958Jy42PNJ4=;
        b=p97G3iPSGy/kE4iQB8x3iX9khBPC1VVJe7t4DtMLaSes64D38VSzM4UeWQgIVk6xXX
         qlKXAdbpiJZsgF+5bTY3QUwKkgmKIJ611OpKM8MryODwyEMDCqgkx8m6jQUH6awjZnSp
         LOnytLI15rFYeKCO2sDN9u4XPc/7igSKHYmT8BQ6+IdFNnf7mkKSS5Ku4xihavjyE2vm
         BXrBnvWW2hd6LPwfPb85UpSF3E1S9FjCPbalvQZxrYQjz7+p6H3/bgCUot4wKzwhrqLa
         D+mnGnmSpsKOkrhPgcQY3VjboAzRXzDPfPpYIXsz79m4Ct6KuewmscNXPgpQBUeADpuI
         Yfvw==
In-Reply-To: <20171004195110.GA18900@castle>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 4 Oct 2017, Roman Gushchin wrote:

> > > @@ -828,6 +828,12 @@ static void __oom_kill_process(struct task_struct *victim)
> > >  	struct mm_struct *mm;
> > >  	bool can_oom_reap = true;
> > >  
> > > +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD) ||
> > > +	    victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
> > > +		put_task_struct(victim);
> > > +		return;
> > > +	}
> > > +
> > >  	p = find_lock_task_mm(victim);
> > >  	if (!p) {
> > >  		put_task_struct(victim);
> > 
> > Is this necessary? The callers of this function use oom_badness() to
> > find a victim, and that filters init, kthread, OOM_SCORE_ADJ_MIN.
> 
> It is. __oom_kill_process() is used to kill all processes belonging
> to the selected memory cgroup, so we should perform these checks
> to avoid killing unkillable processes.
> 

That's only true after the next patch in the series which uses the 
oom_kill_memcg_member() callback to kill processes for oom_group, correct?  
Would it be possible to move this check to that patch so it's more 
obvious?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
