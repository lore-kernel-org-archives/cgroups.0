From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 18 Dec 2013 22:09:12 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
References: <20131209124840.GC3597@dhcp22.suse.cz> <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com> <20131210103827.GB20242@dhcp22.suse.cz> <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz> <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=0dIjo2jY3PTdkxRRlFS0qmkDoRJSMJ9p2thvLZwWhlA=;
        b=U9CRkYOwaSK50bWfSCS3e3PhisCIvcbsVUbkt8u660WmlW5ASXMu7jiQdes0ZPftmT
         ZuUxTV14Qs5cZhP8uqXQRR764YNgaUj89as/9/yKrDQ4WYeOb/Z2V6M4A/LVqD4iVwxu
         VYfr3eHkWo4LLFhEMTs5ZIu3osLzdI5BGqm28gL2PwdnSVxLtFLHS15bvgo4Z5+wgPW0
         IvT2sCrAWAy6Yilzxp4Wp13A4tYHSyF8oGUiQDbw08Rqypbs0z3PPecpLSGa6B//QJ5N
         any9DouE+oQrmUOdyy11SKuoPUstM9Ru+k6Z20EJ0yZgkgMvgvAQSfIckNp7wtkDtAl2
         vb8Q==
In-Reply-To: <20131218200434.GA4161@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed, 18 Dec 2013, Michal Hocko wrote:

> > For memory isolation, we'd only want to bypass memcg charges when 
> > absolutely necessary and it seems like TIF_MEMDIE is the only case where 
> > that's required.  We don't give processes with pending SIGKILLs or those 
> > in the exit() path access to memory reserves in the page allocator without 
> > first determining that reclaim can't make any progress for the same reason 
> > and then we only do so by setting TIF_MEMDIE when calling the oom killer.  
> 
> While I do understand arguments about isolation I would also like to be
> practical here. How many charges are we talking about? Dozen pages? Much
> more?

The PF_EXITING bypass is indeed much less concerning than the 
fatal_signal_pending() bypass.

> Besides that all of those should be very short lived because the task
> is going to die very soon and so the memory will be freed.
> 

We don't know how much memory is being allocated while 
fatal_signal_pending() is true before the process can handle the SIGKILL, 
so this could potentially bypass a significant amount of memory.  If we 
are to have a configuration such as what Tejun recommended for oom 
handling:

			 _____root______
			/		\
		    user		 oom
		   /    \		/   \
		  A	 B	       a     b

where the limit of A + B can be greater than the limit of user for 
overcommit, and the limit of user is the amount of RAM minus whatever is 
reserved for the oom hierarchy, then significant bypass to the root memcg 
will cause memcgs in the oom hierarchy to actually not be able to allocate 
memory from the page allocator.

The PF_EXITING bypass is much less concerning because we shouldn't be 
doing significant memory allocation in the exit() path, but it's also true 
that neither the PF_EXITING nor the fatal_signal_pending() bypass is 
required.  In Tejun's suggested configuration above, we absolutely do want 
to reclaim from the user hierarchy before declaring oom and setting 
TIF_MEMDIE, otherwise the oom hierarchy cannot allocate.

> So from my POV I would like to see these heuristics as simple as
> possible and placed at very few places. Doing a bypass before charge
> - or even after a failed charge before doing reclaim sounds like an easy
> enough heuristic without a big risk.

It's a very significant risk of depleting memory that is available for oom 
handling in the suggested configuration.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
