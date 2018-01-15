From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Mon, 15 Jan 2018 11:25:00 -0500
Message-ID: <20180115162500.GA26120@cmpxchg.org>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130123930.cf3217c816fd270fa35a40cb@linux-foundation.org>
 <alpine.DEB.2.10.1801091556490.173445@chino.kir.corp.google.com>
 <20180110131143.GB26913@castle.DHCP.thefacebook.com>
 <20180110113345.54dd571967fd6e70bfba68c3@linux-foundation.org>
 <20180113171432.GA23484@cmpxchg.org>
 <alpine.DEB.2.10.1801141536380.131380@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4jnQ4smSClFPdH76jKxUymELmSPRHmY+tcvSLWwcss4=; b=xConK4lQko+ahGVblKG66Zy8Hs
	hePZXCnXIWYrrAMdLw9WwRO/+oUxAEVW6VaqU82HrobpIBIKiqwqoCfkL8T6LOkl1+33+zmKbbS+A
	wfrhx+Wgok5K+AY8Dq0zpgq/5vaG6WjFkjsOn774JOysKfZLJc8PhAE8xDKTUp2ywTQY=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1801141536380.131380@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, linux-mm@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Sun, Jan 14, 2018 at 03:44:09PM -0800, David Rientjes wrote:
> On Sat, 13 Jan 2018, Johannes Weiner wrote:
> 
> > You don't have any control and no accounting of the stuff situated
> > inside the root cgroup, so it doesn't make sense to leave anything in
> > there while also using sophisticated containerization mechanisms like
> > this group oom setting.
> > 
> > In fact, the laptop I'm writing this email on runs an unmodified
> > mainstream Linux distribution. The only thing in the root cgroup are
> > kernel threads.
> > 
> > The decisions are good enough for the rare cases you forget something
> > in there and it explodes.
> 
> It's quite trivial to allow the root mem cgroup to be compared exactly the 
> same as another cgroup.  Please see 
> https://marc.info/?l=linux-kernel&m=151579459920305.

This only says "that will be fixed" and doesn't address why I care.

> > This assumes you even need one. Right now, the OOM killer picks the
> > biggest MM, so you can evade selection by forking your MM. This patch
> > allows picking the biggest cgroup, so you can evade by forking groups.
> 
> It's quite trivial to prevent any cgroup from evading the oom killer by 
> either forking their mm or attaching all their processes to subcontainers.  
> Please see https://marc.info/?l=linux-kernel&m=151579459920305.

This doesn't address anything I wrote.

> > It's not a new vector, and clearly nobody cares. This has never been
> > brought up against the current design that I know of.
> 
> As cgroup v2 becomes more popular, people will organize their cgroup 
> hierarchies for all controllers they need to use.  We do this today, for 
> example, by attaching some individual consumers to child mem cgroups 
> purely for the rich statistics and vmscan stats that mem cgroup provides 
> without any limitation on those cgroups.

There is no connecting tissue between what I wrote and what you wrote.

> > Note, however, that there actually *is* a way to guard against it: in
> > cgroup2 there is a hierarchical limit you can configure for the number
> > of cgroups that are allowed to be created in the subtree. See
> > 1a926e0bbab8 ("cgroup: implement hierarchy limits").
> 
> Not allowing the user to create subcontainers to track statistics to paper 
> over an obvious and acknowledged shortcoming in the design of the cgroup 
> aware oom killer seems like a pretty nasty shortcoming itself.

It's not what I proposed. There is a big difference between cgroup
fork bombs and having a couple of groups for statistics.

> > > > > I proposed a solution in 
> > > > > https://marc.info/?l=linux-kernel&m=150956897302725, which was never 
> > > > > responded to, for all of these issues.  The idea is to do hierarchical 
> > > > > accounting of mem cgroup hierarchies so that the hierarchy is traversed 
> > > > > comparing total usage at each level to select target cgroups.  Admins and 
> > > > > users can use memory.oom_score_adj to influence that decisionmaking at 
> > > > > each level.
> > 
> > We did respond repeatedly: this doesn't work for a lot of setups.
> 
> We need to move this discussion to the active proposal at 
> https://marc.info/?l=linux-kernel&m=151579459920305, because it does 
> address your setup, so it's not good use of anyones time to further 
> discuss simply memory.oom_score_adj.

No, we don't.

We have a patch set that was developed, iterated and improved over 10+
revisions, based on evaluating and weighing trade-offs. It's reached a
state where the memcg maintainers are happy with it and don't have any
concern about future extendabilty to cover more specialized setups.

You've had nine months to contribute and shape this patch series
productively, and instead resorted to a cavalcade of polemics,
evasion, and repetition of truisms and refuted points. A ten paragraph
proposal of vague ideas at this point is simply not a valid argument.

You can send patches to replace or improve on Roman's code and make
the case for them.

Thanks

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
