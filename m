From: Roman Gushchin <guro@fb.com>
Subject: Re: [v7 2/5] mm, oom: cgroup-aware OOM killer
Date: Wed, 6 Sep 2017 13:33:45 +0100
Message-ID: <20170906123345.GA12904@castle>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-3-guro@fb.com>
 <20170905145700.fd7jjd37xf4tb55h@dhcp22.suse.cz>
 <20170905202357.GA10535@castle.DHCP.thefacebook.com>
 <20170906083413.4nzwc27fk3bu2ye4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=cVc0Ut8yO/xvKU6P9haqSHnlsKmfG4yOgHdtfUwWKbE=;
 b=bxgPDaF/9laX4eadABZA5IXpXUeagNFt/xc+mZ+3JTiS0awRPC+mLxWvX8wNYYwHOGSv
 oqoFYKmlTKLEBBOEqZ9qgg1Vs+7OKHpyW6HtmDifgYVtyqkwg07BcIYXjuRuUV+/QSRW
 qbtS6iwu0mrQyYnzZXB2EXwsJ4pyuM2LJKA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cVc0Ut8yO/xvKU6P9haqSHnlsKmfG4yOgHdtfUwWKbE=;
 b=gjZpH0he9+gv8k2beVRWYaS/Nf6idw3WHslJZjb7oiQnW3cBYYS4aS0LFSQIfIz0fj+pYIgdNx6NTOUJ1WV9rgRwwIMPtwfWmAQmRWxDmauMrnntrXkE7bc/Fqo6S7MYl5hHsCUMSC1RWeBHIjd0vMHICWJIQqgRLsdccUPZPj4=
Content-Disposition: inline
In-Reply-To: <20170906083413.4nzwc27fk3bu2ye4@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 06, 2017 at 10:34:13AM +0200, Michal Hocko wrote:
> On Tue 05-09-17 21:23:57, Roman Gushchin wrote:
> > On Tue, Sep 05, 2017 at 04:57:00PM +0200, Michal Hocko wrote:
> [...]
> > > > @@ -810,6 +810,9 @@ static void __oom_kill_process(struct task_struct *victim)
> > > >  	struct mm_struct *mm;
> > > >  	bool can_oom_reap = true;
> > > >  
> > > > +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD))
> > > > +		return;
> > > > +
> > > 
> > > This will leak a reference to the victim AFACS
> > 
> > Good catch!
> > I didn't fix this after moving reference dropping into __oom_kill_process().
> > Fixed.
> 
> Btw. didn't you want to check
> victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN
> 
> here as well? Maybe I've missed something but you still can kill a task
> which is oom disabled which I thought we agreed is the wrong thing to
> do.

Added. Thanks!
