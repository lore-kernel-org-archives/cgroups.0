From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Tue, 3 Dec 2013 22:01:01 -0500
Message-ID: <20131204030101.GV3556@cmpxchg.org>
References: <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
 <20131127225340.GE3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com>
 <20131128102049.GF2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com>
 <20131202132201.GC18838@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021452510.13465@chino.kir.corp.google.com>
 <20131203222511.GU3556@cmpxchg.org>
 <alpine.DEB.2.02.1312031531510.5946@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=9opmOpP1inKkkwt/K4QFeM1H+oMthfXzvc2iY8MBRBo=;
	b=Kxf+LRYpZP4GDiSSiDr6TN1wXIopb3hc0/EOoVaThny9S/TNJhD57Ixk1Kk4nBZ65IlRgrx2VgVdrY4Dftz1K3CHVxonJG86MX8BnHlGYVrKzFHvCdJVcS7RlwdBTE58llqKj6HtYqElFlvNr0Q6UQ5kTDDbcROXvmDSIvPancs=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312031531510.5946@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 03:40:13PM -0800, David Rientjes wrote:
> On Tue, 3 Dec 2013, Johannes Weiner wrote:
> 
> > > > Spin on which level? The whole point of this change was to not spin for
> > > > ever because the caller might sit on top of other locks which might
> > > > prevent somebody else to die although it has been killed.
> > > 
> > > See my question about the non-memcg page allocator behavior below.
> > 
> > No, please answer the question.
> > 
> 
> The question would be answered below, by having consistency in allocation 
> and charging paths between both the page allocator and memcg.
> 
> > > I'm not quite sure how significant of a point this is, though, because it 
> > > depends on the caller doing the __GFP_NOFAIL allocations that allow the 
> > > bypass.  If you're doing
> > > 
> > > 	for (i = 0; i < 1 << 20; i++)
> > > 		page[i] = alloc_page(GFP_NOFS | __GFP_NOFAIL);
> > 
> > Hyperbole serves no one.
> > 
> 
> Since this bypasses all charges to the root memcg in oom conditions as a 
> result of your patch, how do you ensure the "leakage" is contained to a 
> small amount of memory?  Are we currently just trusting the users of 
> __GFP_NOFAIL that they aren't allocating a large amount of memory?

Yes, as answered in my first reply to you:

---

> Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
> bypass") which just bypasses all of these allocations and charges the root 
> memcg.  So if allocations want to bypass memcg isolation they just have to 
> be __GFP_NOFAIL?

I don't think we have another option.

---

Is there a specific reason you keep repeating the same questions?

> > > I'm referring to the generic non-memcg page allocator behavior.  Forget 
> > > memcg for a moment.  What is the behavior in the _page_allocator_ for 
> > > GFP_NOFS | __GFP_NOFAIL?  Do we spin forever if reclaim fails or do we 
> > > bypas the per-zone min watermarks to allow it to allocate because "it 
> > > needs to succeed, it may be holding filesystem locks"?
> > > 
> > > It's already been acknowledged in this thread that no bypassing is done 
> > > in the page allocator and it just spins.  There's some handwaving saying 
> > > that since the entire system is oom that there is a greater chance that 
> > > memory will be freed by something else, but that's just handwaving and is 
> > > certainly no guaranteed.
> > 
> > Do you have another explanation of why this deadlock is not triggering
> > in the global case?  It's pretty obvious that there is a deadlock that
> > can not be resolved unless some unrelated task intervenes, just read
> > __alloc_pages_slowpath().
> > 
> > But we had a concrete bug report for memcg where there was no other
> > task to intervene.  One was stuck in the OOM killer waiting for the
> > victim to exit, the victim was stuck on locks that the killer held.
> > 
> 
> I believe the page allocator would be susceptible to the same deadlock if 
> nothing else on the system can reclaim memory and that belief comes from 
> code inspection that shows __GFP_NOFAIL is not guaranteed to ever succeed 
> in the page allocator as their charges now are (with your patch) in memcg.  
> I do not have an example of such an incident.

Me neither.

> > > So, my question again: why not bypass the per-zone min watermarks in the 
> > > page allocator?
> > 
> > I don't even know what your argument is supposed to be.  The fact that
> > we don't do it in the page allocator means that there can't be a bug
> > in memcg?
> > 
> 
> I'm asking if we should allow GFP_NOFS | __GFP_NOFAIL allocations in the 
> page allocator to bypass per-zone min watermarks after reclaim has failed 
> since the oom killer cannot be called in such a context so that the page 
> allocator is not susceptible to the same deadlock without a complete 
> depletion of memory reserves?

Yes, I think so.

> It's not an argument, it's a question.  Relax.

Right.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
