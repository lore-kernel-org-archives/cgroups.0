From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 09:51:49 +0200
Message-ID: <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683100310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LbOettp3UaJGbcC185AxqMHgcSABvOiPPaXvjwmoDVE=;
        b=u+JdKhxmNSEcTLgJetAiyE5+DpLX9lfGaxfRYrwtA1OwKYk88K/+nmG6d/2esV+aCUUtPR
        h+gvAGPKGWUp3TxdEFsKmHv+uIDk2Y2kKg6agFx7Z77jX1G45rhNx3IzfsIMW/fcqrejJk
        PfnqrxsJUonlqQD4TEfvThhG0FK+lVs=
Content-Disposition: inline
In-Reply-To: <ZFIOfb6/jHwLqg6M-jC9Py7bek1znysI04z7BkA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed 03-05-23 03:34:21, Kent Overstreet wrote:
> On Wed, May 03, 2023 at 09:25:29AM +0200, Michal Hocko wrote:
> > On Mon 01-05-23 09:54:10, Suren Baghdasaryan wrote:
> > > Memory allocation profiling infrastructure provides a low overhead
> > > mechanism to make all kernel allocations in the system visible. It can be
> > > used to monitor memory usage, track memory hotspots, detect memory leaks,
> > > identify memory regressions.
> > > 
> > > To keep the overhead to the minimum, we record only allocation sizes for
> > > every allocation in the codebase. With that information, if users are
> > > interested in more detailed context for a specific allocation, they can
> > > enable in-depth context tracking, which includes capturing the pid, tgid,
> > > task name, allocation size, timestamp and call stack for every allocation
> > > at the specified code location.
> > [...]
> > > Implementation utilizes a more generic concept of code tagging, introduced
> > > as part of this patchset. Code tag is a structure identifying a specific
> > > location in the source code which is generated at compile time and can be
> > > embedded in an application-specific structure. A number of applications
> > > for code tagging have been presented in the original RFC [1].
> > > Code tagging uses the old trick of "define a special elf section for
> > > objects of a given type so that we can iterate over them at runtime" and
> > > creates a proper library for it. 
> > > 
> > > To profile memory allocations, we instrument page, slab and percpu
> > > allocators to record total memory allocated in the associated code tag at
> > > every allocation in the codebase. Every time an allocation is performed by
> > > an instrumented allocator, the code tag at that location increments its
> > > counter by allocation size. Every time the memory is freed the counter is
> > > decremented. To decrement the counter upon freeing, allocated object needs
> > > a reference to its code tag. Page allocators use page_ext to record this
> > > reference while slab allocators use memcg_data (renamed into more generic
> > > slabobj_ext) of the slab page.
> > [...]
> > > [1] https://lore.kernel.org/all/20220830214919.53220-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> > [...]
> > >  70 files changed, 2765 insertions(+), 554 deletions(-)
> > 
> > Sorry for cutting the cover considerably but I believe I have quoted the
> > most important/interesting parts here. The approach is not fundamentally
> > different from the previous version [1] and there was a significant
> > discussion around this approach. The cover letter doesn't summarize nor
> > deal with concerns expressed previous AFAICS. So let me bring those up
> > back. At least those I find the most important:
> 
> We covered this previously, I'll just be giving the same answers I did
> before:

Your answers have shown your insight into tracing is very limited. I
have a clear recollection there were many suggestions on how to get what
you need and willingness to help out. Repeating your previous position
will not help much to be honest with you.

> > - This is a big change and it adds a significant maintenance burden
> >   because each allocation entry point needs to be handled specifically.
> >   The cost will grow with the intended coverage especially there when
> >   allocation is hidden in a library code.
> 
> We've made this as clean and simple as posssible: a single new macro
> invocation per allocation function, no calling convention changes (that
> would indeed have been a lot of churn!)

That doesn't really make the concern any less relevant. I believe you
and Suren have made a great effort to reduce the churn as much as
possible but looking at the diffstat the code changes are clearly there
and you have to convince the rest of the community that this maintenance
overhead is really worth it. The above statement hasn't helped to
convinced me to be honest.

> > - It has been brought up that this is duplicating functionality already
> >   available via existing tracing infrastructure. You should make it very
> >   clear why that is not suitable for the job
> 
> Tracing people _claimed_ this, but never demonstrated it.

The burden is on you and Suren. You are proposing the implement an
alternative tracing infrastructure.

> Tracepoints
> exist but the tooling that would consume them to provide this kind of
> information does not exist;

Any reasons why an appropriate tooling cannot be developed?

> it would require maintaining an index of
> _every outstanding allocation_ so that frees could be accounted
> correctly - IOW, it would be _drastically_ higher overhead, so not at
> all comparable.

Do you have any actual data points to prove your claim?

> > - We already have page_owner infrastructure that provides allocation
> >   tracking data. Why it cannot be used/extended?
> 
> Page owner is also very high overhead,

Is there any data to prove that claim? I would be really surprised that
page_owner would give higher overhead than page tagging with profiling
enabled (there is an allocation for each allocation request!!!). We can
discuss the bare bone page tagging comparision to page_owner because of
the full stack unwinding but is that overhead really prohibitively costly?
Can we reduce that by trimming the unwinder information?

> and the output is not very user
> friendly (tracking full call stack means many related overhead gets
> split, not generally what you want), and it doesn't cover slab.

Is this something we cannot do anything about? Have you explored any
potential ways?

> This tracks _all_ memory allocations - slab, page, vmalloc, percpu.

-- 
Michal Hocko
SUSE Labs
