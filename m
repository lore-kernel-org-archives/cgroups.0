From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 10:22:31 -0400
Message-ID: <20200521142231.GA812233@cmpxchg.org>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U/6NedCyVsI+0YkMzEAK7ggM0PF9cTiNN+iBTzo3mhQ=;
        b=HKlbWpODtHg46IMgN/NvH6FHVnVIIjO+J/a63pC9b5E8qEo5aU4nEbChPuBFMpCyzS
         TZdAmtPN3MdK2G+W0S4bW0S7kozkbXR16HNI+POPVjncQgo89V2PyXe0xb6R84F06zTl
         ESDfjA+WhdaK/1aDO72ui3jORP0g8vDjoyqESndrZ2THE81f5SjJFrMWqjRK5P/QagSN
         QH3prFs99TDjrdbJyhmuyEcnxysJl7MePDKj6S5KWxsr/66EnaT7ASNBv0te5t26Vrdy
         lQqjVxigICd6uukzUcO1FSOZVnOM5OJDDb8ZHaroStLqqWiSjIQbuZI25txwkGM+fdEv
         9+uQ==
Content-Disposition: inline
In-Reply-To: <20200521135152.GA810429@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, May 21, 2020 at 09:51:55AM -0400, Johannes Weiner wrote:
> On Thu, May 21, 2020 at 09:32:45AM +0200, Michal Hocko wrote:
> > I wouldn't mind to loop over try_to_free_pages to meet the requested
> > memcg_nr_pages_over_high target.
> 
> Should we do the same for global reclaim? Move reclaim to userspace
> resume where there are no GFP_FS, GFP_NOWAIT etc. restrictions and
> then have everybody just reclaim exactly what they asked for, and punt
> interrupts / kthread allocations to a worker/kswapd?

Oof, typo: I meant limit reclaim by memory.max and
memory.limit_in_bytes. Not physical memory reclaim of course.

> > > > > > Also if the current high reclaim scaling is insufficient then we should
> > > > > > be handling that via memcg_nr_pages_over_high rather than effectivelly
> > > > > > unbound number of reclaim retries.
> > > > > 
> > > > > ???
> > > > 
> > > > I am not sure what you are asking here.
> > > 
> > > You expressed that some alternate solution B would be preferable,
> > > without any detail on why you think that is the case.
> > > 
> > > And it's certainly not obvious or self-explanatory - in particular
> > > because Chris's proposal *is* obvious and self-explanatory, given how
> > > everybody else is already doing loops around page reclaim.
> > 
> > Sorry, I could have been less cryptic. I hope the above and my response
> > to Chris goes into more details why I do not like this proposal and what
> > is the alternative. But let me summarize. I propose to use memcg_nr_pages_over_high
> > target. If the current calculation of the target is unsufficient - e.g.
> > in situations where the high limit excess is very large then this should
> > be reflected in memcg_nr_pages_over_high.
> > 
> > Is it more clear?
> 
> Well you haven't made a good argument why memory.high is actually
> different than any other form of reclaim, and why it should be the
> only implementation of page reclaim that has special-cased handling
> for the inherent "unfairness" or rather raciness of that operation.
> 
> You cut these lines from the quote:
> 
>   Under pressure, page reclaim can struggle to satisfy the reclaim
>   goal and may return with less pages reclaimed than asked to.
> 
>   Under concurrency, a parallel allocation can invalidate the reclaim
>   progress made by a thread.
> 
> Even if we *could* invest more into trying to avoid any unfairness,
> you haven't made a point why we actually should do that here
> specifically, yet not everywhere else.
> 
> (And people have tried to do it for global reclaim[1], but clearly
> this isn't a meaningful problem in practice.)
> 
> I have a good reason why we shouldn't: because it's special casing
> memory.high from other forms of reclaim, and that is a maintainability
> problem. We've recently been discussing ways to make the memory.high
> implementation stand out less, not make it stand out even more. There
> is no solid reason it should be different from memory.max reclaim,
> except that it should sleep instead of invoke OOM at the end. It's
> already a mess we're trying to get on top of and straighten out, and
> you're proposing to add more kinks that will make this work harder.
> 
> I have to admit, I'm baffled by this conversation. I consider this a
> fairly obvious, idiomatic change, and I cannot relate to the
> objections or counter-proposals in the slightest.
> 
> [1] http://lkml.iu.edu/hypermail//linux/kernel/0810.0/0169.html
