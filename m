From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Tue, 17 Dec 2013 12:50:09 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
References: <20131204111318.GE8410@dhcp22.suse.cz> <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com> <20131209124840.GC3597@dhcp22.suse.cz> <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com> <20131210103827.GB20242@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz> <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz> <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
 <20131217162342.GG28991@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Cj6u7yGZXmzQNlt3Th7zIBqrH3PDs7GZL4kAp3oy3lY=;
        b=LPIYURDqwDjS2gwKgh0izcv5BgCMVHSohNI8kaQt8Li3o55LLKgnkYi3ftWNYThQzE
         AK3eucsf8akqImQD77DyDk+yHA+1VLjQMrhfe8hP6/+QAw8EgJCtw5xo2B8Ys0F8B/8U
         BfrAt+1pv0xvaOSZbQWc6itoUQRZK0KVoG2Aa4VrVWRviH8NS+su7YSYqge3fiyQ6PFY
         44lb1sQgfQAWIXYf17s1FiV3tQZSkt/lv2XBoddYFYJ+azVh46BDVe/JrxLfWuh96Dv7
         DdYHhmBVXs56TE8Aj+1wGPcXv3d3ReTanajsaZFjchkKbmbGPozo6WGl2AAO3CWzvvZR
         fs4Q==
In-Reply-To: <20131217162342.GG28991@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, 17 Dec 2013, Michal Hocko wrote:

> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index c72b03bf9679..fee25c5934d2 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2692,7 +2693,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > >  	 * MEMDIE process.
> > >  	 */
> > >  	if (unlikely(test_thread_flag(TIF_MEMDIE)
> > > -		     || fatal_signal_pending(current)))
> > > +		     || fatal_signal_pending(current))
> > > +		     || current->flags & PF_EXITING)
> > >  		goto bypass;
> > >  
> > >  	if (unlikely(task_in_memcg_oom(current)))
> > > 
> > > rather than the later checks down the oom_synchronize paths. The comment
> > > already mentions dying process...
> > > 
> > 
> > This is scary because it doesn't even try to reclaim memcg memory before 
> > allowing the allocation to succeed.
> 
> Why should it reclaim in the first place when it simply is on the way to
> release memory. In other words why should it increase the memory
> pressure when it is in fact releasing it?
> 

(Answering about removing the fatal_signal_pending() check as well here.)

For memory isolation, we'd only want to bypass memcg charges when 
absolutely necessary and it seems like TIF_MEMDIE is the only case where 
that's required.  We don't give processes with pending SIGKILLs or those 
in the exit() path access to memory reserves in the page allocator without 
first determining that reclaim can't make any progress for the same reason 
and then we only do so by setting TIF_MEMDIE when calling the oom killer.  

> I am really puzzled here. On one hand you are strongly arguing for not
> notifying when we know we can prevent from OOM action and on the other
> hand you are ok to get vmpressure/thresholds notification when an
> exiting task triggers reclaim.
> 
> So I am really lost in what you are trying to achieve here. It sounds a
> bit arbirtrary.
> 

It's not arbitrary to define when memcg bypass is allowed and, in my 
opinion, it should only be done in situations where it is unavoidable and 
therefore breaking memory isolation is required.

(We wouldn't expect a 128MB memcg to be oom [and perhaps with a userspace 
oom handler attached] when it has 100 children each 1MB in size just 
because they all happen to be oom at the same time.  We set up the excess 
memory in the parent specifically for the memcg with the oom handler 
attached.)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
