From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Fri, 27 Oct 2017 16:05:40 -0400
Message-ID: <20171027200540.GA25191@cmpxchg.org>
References: <20171019185218.12663-1-guro@fb.com>
 <20171019194534.GA5502@cmpxchg.org>
 <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com>
 <20171026142445.GA21147@cmpxchg.org>
 <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KvAFX5vZ252xgooXwpoSyWGYlfdXVTaGHWq8l3IbSoY=; b=W7wO1Ar5VZOKAlJooSyAmDKQJW
	y6thKTkyieocoA4AkQ4ukhVKlPQCIFtrWvMNPWE3FAJMI/aBfcUbE/708q7G35C4ofcMMHMB/PT9o
	AMZv8npcJJ2Ip3AgCDltwruXWT79B1dpffXOYTUbJMQCO+0EgxSborU8DoTrfeMZdMjA=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710261359550.75887@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Thu, Oct 26, 2017 at 02:03:41PM -0700, David Rientjes wrote:
> On Thu, 26 Oct 2017, Johannes Weiner wrote:
> 
> > > The nack is for three reasons:
> > > 
> > >  (1) unfair comparison of root mem cgroup usage to bias against that mem 
> > >      cgroup from oom kill in system oom conditions,
> > > 
> > >  (2) the ability of users to completely evade the oom killer by attaching
> > >      all processes to child cgroups either purposefully or unpurposefully,
> > >      and
> > > 
> > >  (3) the inability of userspace to effectively control oom victim  
> > >      selection.
> > 
> > My apologies if my summary was too reductionist.
> > 
> > That being said, the arguments you repeat here have come up in
> > previous threads and been responded to. This doesn't change my
> > conclusion that your NAK is bogus.
> 
> They actually haven't been responded to, Roman was working through v11 and 
> made a change on how the root mem cgroup usage was calculated that was 
> better than previous iterations but still not an apples to apples 
> comparison with other cgroups.  The problem is that it the calculation for 
> leaf cgroups includes additional memory classes, so it biases against 
> processes that are moved to non-root mem cgroups.  Simply creating mem 
> cgroups and attaching processes should not independently cause them to 
> become more preferred: it should be a fair comparison between the root mem 
> cgroup and the set of leaf mem cgroups as implemented.  That is very 
> trivial to do with hierarchical oom cgroup scoring.

There is absolutely no value in your repeating the same stuff over and
over again without considering what other people are telling you.

Hierarchical oom scoring has other downsides, and most of us agree
that they aren't preferable over the differences in scoring the root
vs scoring other cgroups - in particular because the root cannot be
controlled, doesn't even have local statistics, and so is unlikely to
contain important work on a containerized system. Getting the ballpark
right for the vast majority of usecases is more than good enough here.

> Since the ability of userspace to control oom victim selection is not 
> addressed whatsoever by this patchset, and the suggested method cannot be 
> implemented on top of this patchset as you have argued because it requires 
> a change to the heuristic itself, the patchset needs to become complete 
> before being mergeable.

It is complete. It just isn't a drop-in replacement for what you've
been doing out-of-tree for years. Stop making your problem everybody
else's problem.

You can change the the heuristics later, as you have done before. Or
you can add another configuration flag and we can phase out the old
mode, like we do all the time.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
