From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Tue, 3 Dec 2013 15:40:13 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312031531510.5946@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org> <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com> <20131127225340.GE3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com> <20131128102049.GF2761@dhcp22.suse.cz> <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com> <20131202132201.GC18838@dhcp22.suse.cz> <alpine.DEB.2.02.1312021452510.13465@chino.kir.corp.google.com>
 <20131203222511.GU3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=mlH8fK9vm/US8NuGc0RH2yhR75iQLygLVicQh2pYbIs=;
        b=cBh6ve7tPzRbfzROCec9ynyOYFT4W7uQQJcOJVcVsedmhdqblLAA3EA3x6MonfzcQr
         ElksaeAlEgYxEdKfJKFGVm+NOpF5xzA9MCyKMAW1+QmWgSYLhnz1W8zfbt4v6BRR2t06
         LLSMW3eXEDZgFOC4+tk3JJLrGso5KZ9lgj+1AMnq3mbHN+ivCD2wp4f8uJOaTUl2xr9P
         4PW2YedcGHn64UqpBGlQzgoPPDKdXFIBvDttb+VM4kcQN7UAqQo9dHm+Q0JEzZ+Kl8hZ
         BK0zJSLuID4EkOzp9UAvj6Bbyvq4/Q9DCK5HilLQQGhtFTQ48LYNAkgPg+4KQXHga5iz
         pnTg==
In-Reply-To: <20131203222511.GU3556@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Johannes Weiner wrote:

> > > Spin on which level? The whole point of this change was to not spin for
> > > ever because the caller might sit on top of other locks which might
> > > prevent somebody else to die although it has been killed.
> > 
> > See my question about the non-memcg page allocator behavior below.
> 
> No, please answer the question.
> 

The question would be answered below, by having consistency in allocation 
and charging paths between both the page allocator and memcg.

> > I'm not quite sure how significant of a point this is, though, because it 
> > depends on the caller doing the __GFP_NOFAIL allocations that allow the 
> > bypass.  If you're doing
> > 
> > 	for (i = 0; i < 1 << 20; i++)
> > 		page[i] = alloc_page(GFP_NOFS | __GFP_NOFAIL);
> 
> Hyperbole serves no one.
> 

Since this bypasses all charges to the root memcg in oom conditions as a 
result of your patch, how do you ensure the "leakage" is contained to a 
small amount of memory?  Are we currently just trusting the users of 
__GFP_NOFAIL that they aren't allocating a large amount of memory?

> > I'm referring to the generic non-memcg page allocator behavior.  Forget 
> > memcg for a moment.  What is the behavior in the _page_allocator_ for 
> > GFP_NOFS | __GFP_NOFAIL?  Do we spin forever if reclaim fails or do we 
> > bypas the per-zone min watermarks to allow it to allocate because "it 
> > needs to succeed, it may be holding filesystem locks"?
> > 
> > It's already been acknowledged in this thread that no bypassing is done 
> > in the page allocator and it just spins.  There's some handwaving saying 
> > that since the entire system is oom that there is a greater chance that 
> > memory will be freed by something else, but that's just handwaving and is 
> > certainly no guaranteed.
> 
> Do you have another explanation of why this deadlock is not triggering
> in the global case?  It's pretty obvious that there is a deadlock that
> can not be resolved unless some unrelated task intervenes, just read
> __alloc_pages_slowpath().
> 
> But we had a concrete bug report for memcg where there was no other
> task to intervene.  One was stuck in the OOM killer waiting for the
> victim to exit, the victim was stuck on locks that the killer held.
> 

I believe the page allocator would be susceptible to the same deadlock if 
nothing else on the system can reclaim memory and that belief comes from 
code inspection that shows __GFP_NOFAIL is not guaranteed to ever succeed 
in the page allocator as their charges now are (with your patch) in memcg.  
I do not have an example of such an incident.

> > So, my question again: why not bypass the per-zone min watermarks in the 
> > page allocator?
> 
> I don't even know what your argument is supposed to be.  The fact that
> we don't do it in the page allocator means that there can't be a bug
> in memcg?
> 

I'm asking if we should allow GFP_NOFS | __GFP_NOFAIL allocations in the 
page allocator to bypass per-zone min watermarks after reclaim has failed 
since the oom killer cannot be called in such a context so that the page 
allocator is not susceptible to the same deadlock without a complete 
depletion of memory reserves?

It's not an argument, it's a question.  Relax.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
