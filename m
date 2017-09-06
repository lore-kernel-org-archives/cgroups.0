From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v7 2/5] mm, oom: cgroup-aware OOM killer
Date: Wed, 6 Sep 2017 10:34:13 +0200
Message-ID: <20170906083413.4nzwc27fk3bu2ye4@dhcp22.suse.cz>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-3-guro@fb.com>
 <20170905145700.fd7jjd37xf4tb55h@dhcp22.suse.cz>
 <20170905202357.GA10535@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170905202357.GA10535@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 05-09-17 21:23:57, Roman Gushchin wrote:
> On Tue, Sep 05, 2017 at 04:57:00PM +0200, Michal Hocko wrote:
[...]
> > > @@ -810,6 +810,9 @@ static void __oom_kill_process(struct task_struct *victim)
> > >  	struct mm_struct *mm;
> > >  	bool can_oom_reap = true;
> > >  
> > > +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD))
> > > +		return;
> > > +
> > 
> > This will leak a reference to the victim AFACS
> 
> Good catch!
> I didn't fix this after moving reference dropping into __oom_kill_process().
> Fixed.

Btw. didn't you want to check
victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN

here as well? Maybe I've missed something but you still can kill a task
which is oom disabled which I thought we agreed is the wrong thing to
do.
-- 
Michal Hocko
SUSE Labs
