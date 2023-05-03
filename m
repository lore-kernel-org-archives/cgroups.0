From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 08:19:24 -1000
Message-ID: <ZFKlrP7nLn93iIRf@slm.duckdns.org>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683137967; x=1685729967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b8EyOQL7PrYcjENM7voIrei4tZKK2YZzqm7TQH+pwlU=;
        b=aZNjJ0sKerUq7u8EB+b0HNpoznz9cBQhrzzOvNvOKeztEz5atXm5CLpSRLxWpTflSR
         bxO698PfKyTFFeXOCQw+L4viOYGAfhQwycSh4dwa8tVAX89FbIuNkNMzVF/32CZveUnN
         lmZCFzArGY1PfzDmPf0qgKFQkNfkLEuxrzW+qQ+ci+jVIdPpjFyLGv4gyshMjEWMn+PU
         6c620nyXugQ2Wyt655L7CulVWSS+LO7irrkNzBdN5DIP2Vi2A2FOlTEtiS0NgBoGOQ5u
         6Yk7eTdeaMiyAwzgTLQwCB5153Vyr42Hf0ig6bVEn7Dn5xAQCmOPEPEY1yGnR7rX1ltt
         av/A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230503180726.GA196054-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells@r

Hello,

On Wed, May 03, 2023 at 02:07:26PM -0400, Johannes Weiner wrote:
...
> > * Because tracking starts when the script starts running, it doesn't know
> >   anything which has happened upto that point, so you gotta pay attention to
> >   handling e.g. handling frees which don't match allocs. It's kinda annoying
> >   but not a huge problem usually. There are ways to build in BPF progs into
> >   the kernel and load it early but I haven't experiemnted with it yet
> >   personally.
> 
> Yeah, early loading is definitely important, especially before module
> loading etc.
> 
> One common usecase is that we see a machine in the wild with a high
> amount of kernel memory disappearing somewhere that isn't voluntarily
> reported in vmstat/meminfo. Reproducing it isn't always
> practical. Something that records early and always (with acceptable
> runtime overhead) would be the holy grail.
> 
> Matching allocs to frees is doable using the pfn as the key for pages,
> and virtual addresses for slab objects.
> 
> The biggest issue I had when I tried with bpf was losing updates to
> the map. IIRC there is some trylocking going on to avoid deadlocks
> from nested contexts (alloc interrupted, interrupt frees). It doesn't
> sound like an unsolvable problem, though.

(cc'ing Alexei and Andrii)

This is the same thing that I hit with sched_ext. BPF plugged it for
struct_ops but I wonder whether it can be done for specific maps / progs -
ie. just declare that a given map or prog is not to be accessed from NMI and
bypass the trylock deadlock avoidance mechanism. But, yeah, this should be
addressed from BPF side.

> Another minor thing was the stack trace map exploding on a basically
> infinite number of unique interrupt stacks. This could probably also
> be solved by extending the trace extraction API to cut the frames off
> at the context switch boundary.
> 
> Taking a step back though, given the multitude of allocation sites in
> the kernel, it's a bit odd that the only accounting we do is the tiny
> fraction of voluntary vmstat/meminfo reporting. We try to cover the
> biggest consumers with this of course, but it's always going to be
> incomplete and is maintenance overhead too. There are on average
> several gigabytes in unknown memory (total - known vmstats) on our
> machines. It's difficult to detect regressions easily. And it's per
> definition the unexpected cornercases that are the trickiest to track
> down. So it might be doable with BPF, but it does feel like the kernel
> should do a better job of tracking out of the box and without
> requiring too much plumbing and somewhat fragile kernel allocation API
> tracking and probing from userspace.

Yeah, easy / default visibility argument does make sense to me.

Thanks.

-- 
tejun
