From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 18 Dec 2013 21:04:34 +0100
Message-ID: <20131218200434.GA4161@dhcp22.suse.cz>
References: <20131209124840.GC3597@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
 <20131210103827.GB20242@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
 <20131211095549.GA18741@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com>
 <20131212103159.GB2630@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
 <20131217162342.GG28991@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wsYPRmPHnT8DQVWdjLrPAEMMj0jNIEeqgGCBJ0/4gHo=;
        b=dHq1Qsr9mG0UOy5Eth+8TYZYp2x0pCYPpm5rnYGKRqxwf7LFLMlMRj2MlqXlXW3vxm
         AijUx7HUKBlONKA41CA0mV8Fi05eAEs09aCrBrE1R71dyAOOJCEBeNZ3Yl4Tc3u8yDU0
         EDdAkzW411mV9caaQclwnQ93amfmee4lMh+b2LOtTnFAQF77kp0Pp6/K7PvUz5ayOcnB
         KSMy5x/hDLSfMNnZOcnAqbJTZ31+Vzv5mEsiLBS4/04EtIULFRNVTE2uB2LLfAeYrel1
         rUGDYUhYx2X5RPBOwcV1S18D8GmmkTa1ii61kff54EdDBFCnBN9oIxFeXB5SgJHcUWOq
         5uaA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312171240541.21640-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 17-12-13 12:50:09, David Rientjes wrote:
> On Tue, 17 Dec 2013, Michal Hocko wrote:
> 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index c72b03bf9679..fee25c5934d2 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2692,7 +2693,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > > >  	 * MEMDIE process.
> > > >  	 */
> > > >  	if (unlikely(test_thread_flag(TIF_MEMDIE)
> > > > -		     || fatal_signal_pending(current)))
> > > > +		     || fatal_signal_pending(current))
> > > > +		     || current->flags & PF_EXITING)
> > > >  		goto bypass;
> > > >  
> > > >  	if (unlikely(task_in_memcg_oom(current)))
> > > > 
> > > > rather than the later checks down the oom_synchronize paths. The comment
> > > > already mentions dying process...
> > > > 
> > > 
> > > This is scary because it doesn't even try to reclaim memcg memory before 
> > > allowing the allocation to succeed.
> > 
> > Why should it reclaim in the first place when it simply is on the way to
> > release memory. In other words why should it increase the memory
> > pressure when it is in fact releasing it?
> > 
> 
> (Answering about removing the fatal_signal_pending() check as well here.)
> 
> For memory isolation, we'd only want to bypass memcg charges when 
> absolutely necessary and it seems like TIF_MEMDIE is the only case where 
> that's required.  We don't give processes with pending SIGKILLs or those 
> in the exit() path access to memory reserves in the page allocator without 
> first determining that reclaim can't make any progress for the same reason 
> and then we only do so by setting TIF_MEMDIE when calling the oom killer.  

While I do understand arguments about isolation I would also like to be
practical here. How many charges are we talking about? Dozen pages? Much
more?
Besides that all of those should be very short lived because the task
is going to die very soon and so the memory will be freed.

So from my POV I would like to see these heuristics as simple as
possible and placed at very few places. Doing a bypass before charge
- or even after a failed charge before doing reclaim sounds like an easy
enough heuristic without a big risk.
I have really hard time to see big benefits for forcing reclaim for a
very short lived charge because this might lead to different and much
worse side effects then a quantum noise.

Maybe I am missing something and we can charge a lot during exit but
then I think we should fix the exit path to not allocate that much.

> > I am really puzzled here. On one hand you are strongly arguing for not
> > notifying when we know we can prevent from OOM action and on the other
> > hand you are ok to get vmpressure/thresholds notification when an
> > exiting task triggers reclaim.
> > 
> > So I am really lost in what you are trying to achieve here. It sounds a
> > bit arbirtrary.
> > 
> 
> It's not arbitrary to define when memcg bypass is allowed and, in my 
> opinion, it should only be done in situations where it is unavoidable and 
> therefore breaking memory isolation is required.
> 
> (We wouldn't expect a 128MB memcg to be oom [and perhaps with a userspace 
> oom handler attached] when it has 100 children each 1MB in size just 
> because they all happen to be oom at the same time.  We set up the excess 

s/oom/exiting/ ?

> memory in the parent specifically for the memcg with the oom handler 
> attached.)

I am not sure I understand what you meant here.

-- 
Michal Hocko
SUSE Labs
