From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v10 29/35] memcg: per-memcg kmem shrinking
Date: Thu, 6 Jun 2013 15:23:15 -0700
Message-ID: <20130606152315.69603127cca33e54b1ed428e@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-30-git-send-email-glommer@openvz.org>
	<20130605160841.909420c06bfde62039489d2e@linux-foundation.org>
	<51B049D5.2020809@parallels.com>
	<20130606024906.e5b85b28.akpm@linux-foundation.org>
	<51B07BEC.9010205@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B07BEC.9010205-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, 6 Jun 2013 16:09:16 +0400 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> >>> then waiting for it to complete is equivalent to calling it directly.
> >>>
> >> Not in this case. We are in wait-capable context (we check for this
> >> right before we reach this), but we are not in fs capable context.
> >>
> >> So the reason we do this - which I tried to cover in the changelog, is
> >> to escape from the GFP_FS limitation that our call chain has, not the
> >> wait limitation.
> > 
> > But that's equivalent to calling the code directly.  Look:
> > 
> > some_fs_function()
> > {
> > 	lock(some-fs-lock);
> > 	...
> > }
> > 
> > some_other_fs_function()
> > {
> > 	lock(some-fs-lock);
> > 	alloc_pages(GFP_NOFS);
> > 	->...
> > 	  ->schedule_work(some_fs_function);
> > 	    flush_scheduled_work();
> > 
> > that flush_scheduled_work() won't complete until some_fs_function() has
> > completed.  But some_fs_function() won't complete, because we're
> > holding some-fs-lock.
> > 
> 
> In my experience during this series, most of the kmem allocation here

"most"?

> will be filesystem related. This means that we will allocate that with
> GFP_FS on.

eh?  filesystems do a tremendous amount of GFP_NOFS allocation.  

akpm3:/usr/src/25> grep GFP_NOFS fs/*/*.c|wc -l
898

> If we don't do anything like that, reclaim is almost
> pointless since it will never free anything (only once here and there
> when the allocation is not from fs).

It depends what you mean by "reclaim".  There are a lot of things which
vmscan can do for a GFP_NOFS allocation.  Scraping clean pagecache,
clean swapcache, well-behaved (ahem) shrinkable caches.

> It tend to work just fine like this. It may very well be because fs
> people just mark everything as NOFS out of safety and we aren't *really*
> holding any locks in common situations, but it will blow in our faces in
> a subtle way (which none of us want).
> 
> That said, suggestions are more than welcome.

At a minimum we should remove all the schedule_work() stuff, call the
callback function synchronously and add

	/* This code is full of deadlocks */


Sorry, this part of the patchset is busted and needs a fundamental
rethink.
