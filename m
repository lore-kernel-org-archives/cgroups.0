From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 12:38:33 -0400
Message-ID: <20200521163833.GA813446@cmpxchg.org>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o36CaISTnvijJ/qQX5jxoX3WQi5azGFV4Q25YhraOzw=;
        b=nS1wPFI9dyRqaRovfmrrquMIh4Z2CSdLmfaWzOWxKk91CazeUR302QfgGYYGXZMwb/
         EgEwdvrWxnrjJM8YvZlDPzx+jiDY+07Td9ZjHSL0y8tZsSENL+FS3n3p6T1nW1dh6Yij
         fPQ3I88P3C7fCbp2CsEyy0jEzgeZ68+A2nQEO+qDmVSz4FV5ZOnipJeATfD2tXDsYwRL
         bJ4hwDpODF5FaPbGzVE7Nh0fsqdOxuurNVONAu99Zyy/gHNqnwYH4S/eKXJLFHwfUVlZ
         2kHp5+EZ3xOnx04v/HtKKMP7CkzWzrW3Qn8i4KufQpqK6FXeoMr0iBxiQx+XuH+g4sU4
         D3kw==
Content-Disposition: inline
In-Reply-To: <20200521143515.GU6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, May 21, 2020 at 04:35:15PM +0200, Michal Hocko wrote:
> On Thu 21-05-20 09:51:52, Johannes Weiner wrote:
> > On Thu, May 21, 2020 at 09:32:45AM +0200, Michal Hocko wrote:
> [...]
> > > I am not saying the looping over try_to_free_pages is wrong. I do care
> > > about the final reclaim target. That shouldn't be arbitrary. We have
> > > established a target which is proportional to the requested amount of
> > > memory. And there is a good reason for that. If any task tries to
> > > reclaim down to the high limit then this might lead to a large
> > > unfairness when heavy producers piggy back on the active reclaimer(s).
> > 
> > Why is that different than any other form of reclaim?
> 
> Because the high limit reclaim is a best effort rather than must to
> either get over reclaim watermarks and continue allocation or meet the
> hard limit requirement to continue.

It's not best effort. It's a must-meet or get put to sleep. You are
mistaken about what memory.high is.

> In an ideal world even the global resp. hard limit reclaim should
> consider fairness. They don't because that is easier but that sucks. I
> have been involved in debugging countless of issues where direct reclaim
> was taking too long because of the unfairness. Users simply see that as
> bug and I am not surprised.

Then there should be a generic fix to this problem (like the page
capturing during reclaim).

You're bringing anecdotal evidence that reclaim has a generic problem,
which nobody has seriously tried to fix in recent times, and then ask
people to hack around it in a patch that only brings the behavior for
this specific instance in line with everybody else.

I'm sorry, but this IS a black and white issue, and I think you're out
of line here. If you think reclaim fairness is a problem, it should be
on you to provide concrete data for that and propose changes on how we
do reclaim, instead of asking to hack around it in one callsite -
thereby introducing inconsistencies to userspace between different
limits, as well as inconsistencies and complications for the kernel
developers that actually work on this code (take a look at git blame).

> > > I wouldn't mind to loop over try_to_free_pages to meet the requested
> > > memcg_nr_pages_over_high target.
> > 
> > Should we do the same for global reclaim? Move reclaim to userspace
> > resume where there are no GFP_FS, GFP_NOWAIT etc. restrictions and
> > then have everybody just reclaim exactly what they asked for, and punt
> > interrupts / kthread allocations to a worker/kswapd?
> 
> This would be quite challenging considering the page allocator wouldn't
> be able to make a forward progress without doing any reclaim. But maybe
> you can be creative with watermarks.

I clarified in the follow-up email that I meant limit reclaim.

> > > > > > > Also if the current high reclaim scaling is insufficient then we should
> > > > > > > be handling that via memcg_nr_pages_over_high rather than effectivelly
> > > > > > > unbound number of reclaim retries.
> > > > > > 
> > > > > > ???
> > > > > 
> > > > > I am not sure what you are asking here.
> > > > 
> > > > You expressed that some alternate solution B would be preferable,
> > > > without any detail on why you think that is the case.
> > > > 
> > > > And it's certainly not obvious or self-explanatory - in particular
> > > > because Chris's proposal *is* obvious and self-explanatory, given how
> > > > everybody else is already doing loops around page reclaim.
> > > 
> > > Sorry, I could have been less cryptic. I hope the above and my response
> > > to Chris goes into more details why I do not like this proposal and what
> > > is the alternative. But let me summarize. I propose to use memcg_nr_pages_over_high
> > > target. If the current calculation of the target is unsufficient - e.g.
> > > in situations where the high limit excess is very large then this should
> > > be reflected in memcg_nr_pages_over_high.
> > > 
> > > Is it more clear?
> > 
> > Well you haven't made a good argument why memory.high is actually
> > different than any other form of reclaim, and why it should be the
> > only implementation of page reclaim that has special-cased handling
> > for the inherent "unfairness" or rather raciness of that operation.
> > 
> > You cut these lines from the quote:
> > 
> >   Under pressure, page reclaim can struggle to satisfy the reclaim
> >   goal and may return with less pages reclaimed than asked to.
> > 
> >   Under concurrency, a parallel allocation can invalidate the reclaim
> >   progress made by a thread.
> > 
> > Even if we *could* invest more into trying to avoid any unfairness,
> > you haven't made a point why we actually should do that here
> > specifically, yet not everywhere else.
> 
> I have tried to explain my thinking elsewhere in the thread. The bottom
> line is that high limit is a way of throttling rather than meeting a
> specific target.

That's an incorrect assumption. Of course it should meet the specific
target that the user specified.

> > (And people have tried to do it for global reclaim[1], but clearly
> > this isn't a meaningful problem in practice.)
> > 
> > I have a good reason why we shouldn't: because it's special casing
> > memory.high from other forms of reclaim, and that is a maintainability
> > problem. We've recently been discussing ways to make the memory.high
> > implementation stand out less, not make it stand out even more. There
> > is no solid reason it should be different from memory.max reclaim,
> > except that it should sleep instead of invoke OOM at the end. It's
> > already a mess we're trying to get on top of and straighten out, and
> > you're proposing to add more kinks that will make this work harder.
> 
> I do see your point of course. But I do not give the code consistency
> a higher priority than the potential unfairness aspect of the user
> visible behavior for something that can do better.

Michal, you have almost no authorship stake in this code base. Would
it be possible to defer judgement on maintainability to people who do?
