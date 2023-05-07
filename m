From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Sun, 7 May 2023 13:20:55 -0400
Message-ID: <ZFfd99w9vFTftB8D@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
 <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683480068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hurdbnJwUJqK07Lm+4BMc/GcG+c58gJSfQAtVR+cBkY=;
        b=t9HPg37zepSR1RnzhSUKFRxBUu28FVu1Yi23jFUki7ZMbwLSC/NiT3n7wFBZNUFaL6UoyB
        zJPC7zS/i2KkcdGtaRgLAJgrWe5jboQdCOvInvXLMeR4wfr6JjMe/ufK6pDB5akkqqXdTQ
        ldiDYd0e9CxSI40mvUKNrcXC5Ki5rqQ=
Content-Disposition: inline
In-Reply-To: <ZFN1yswCd9wRgYPR-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, May 04, 2023 at 11:07:22AM +0200, Michal Hocko wrote:
> No. I am mostly concerned about the _maintenance_ overhead. For the
> bare tracking (without profiling and thus stack traces) only those
> allocations that are directly inlined into the consumer are really
> of any use. That increases the code impact of the tracing because any
> relevant allocation location has to go through the micro surgery. 
> 
> e.g. is it really interesting to know that there is a likely memory
> leak in seq_file proper doing and allocation? No as it is the specific
> implementation using seq_file that is leaking most likely. There are
> other examples like that See?

So this is a rather strange usage of "maintenance overhead" :)

But it's something we thought of. If we had to plumb around a _RET_IP_
parameter, or a codetag pointer, it would be a hassle annotating the
correct callsite.

Instead, alloc_hooks() wraps a memory allocation function and stashes a
pointer to a codetag in task_struct for use by the core slub/buddy
allocator code.

That means that in your example, to move tracking to a given seq_file
function, we just:
 - hook the seq_file function with alloc_hooks
 - change the seq_file function to call non-hooked memory allocation
   functions.

> It would have been more convincing if you had some numbers at hands.
> E.g. this is a typical workload we are dealing with. With the compile
> time tags we are able to learn this with that much of cost. With a dynamic
> tracing we are able to learn this much with that cost. See? As small as
> possible is a rather vague term that different people will have a very
> different idea about.

Engineers don't prototype and benchmark everything as a matter of
course, we're expected to have the rough equivealent of a CS education
and an understanding of big O notation, cache architecture, etc.

The slub fast path is _really_ fast - double word non locked cmpxchg.
That's what we're trying to compete with. Adding a big globally
accessible hash table is going to tank performance compared to that.

I believe the numbers we already posted speak for themselves. We're
considerably faster than memcg, fast enough to run in production.

I'm not going to be switching to a design that significantly regresses
performance, sorry :)

> TBH I am much more concerned about the maintenance burden on the MM side
> than the actual code tagging itslef which is much more self contained. I
> haven't seen other potential applications of the same infrastructure and
> maybe the code impact would be much smaller than in the MM proper. Our
> allocator API is really hairy and convoluted.

You keep saying "maintenance burden", but this is a criticism that can
be directed at _any_ patchset that adds new code; it's generally
understood that that is the accepted cost for new functionality.

If you have specific concerns where you think we did something that
makes the code harder to maintain, _please point them out in the
appropriate patch_. I don't think you'll find too much - the
instrumentation in the allocators simply generalizes what memcg was
already doing, and the hooks themselves are a bit boilerplaty but hardly
the sort of thing people will be tripping over later.

TL;DR - put up or shut up :)
