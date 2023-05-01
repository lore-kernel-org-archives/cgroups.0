From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 1 May 2023 14:18:19 -0700
Message-ID: <ZFAsm0XTqC//f4FP@P9FQF9L96D>
References: <20230501165450.15352-1-surenb@google.com>
 <ZE/7FZbd31qIzrOc@P9FQF9L96D>
 <CAJuCfpHU3ZMsNuqi1gSxzAWKr2D3VkiaTY0BEUQgM-QHNxRtSg@mail.gmail.com>
 <ZFABlUB/RZM6lUyl@P9FQF9L96D>
 <ZFAVFlrRtpVgxJ0q@moria.home.lan>
Mime-Version: 1.0
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682975916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ESr9I0e8zhQfwnabaXWJmwqboN5UgcpvA4HHb+DuoSo=;
        b=X8e/zveM3y8evn6iXFP1GQo9OkihBkN8WMX+PdxDnY3z/6lrHLFpCsMAkSpjJKhXXfOrwF
        IUeI4bLp/6VHOK8l63qdJcQBLJJOOe6I4c1Q3m33D6EX2Iby3DxkSkgglbdgCL1yyraxZj
        BHxkRt89pPHeAAb7NZCRpzeOKMHy5No=
Content-Disposition: inline
In-Reply-To: <ZFAVFlrRtpVgxJ0q-jC9Py7bek1znysI04z7BkA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook

On Mon, May 01, 2023 at 03:37:58PM -0400, Kent Overstreet wrote:
> On Mon, May 01, 2023 at 11:14:45AM -0700, Roman Gushchin wrote:
> > It's a good idea and I generally think that +25-35% for kmalloc/pgalloc
> > should be ok for the production use, which is great!
> > In the reality, most workloads are not that sensitive to the speed of
> > memory allocation.
> 
> :)
> 
> My main takeaway has been "the slub fast path is _really_ fast". No
> disabling of preemption, no atomic instructions, just a non locked
> double word cmpxchg - it's a slick piece of work.
> 
> > > For kmalloc, the overhead is low because after we create the vector of
> > > slab_ext objects (which is the same as what memcg_kmem does), memory
> > > profiling just increments a lazy counter (which in many cases would be
> > > a per-cpu counter).
> > 
> > So does kmem (this is why I'm somewhat surprised by the difference).
> > 
> > > memcg_kmem operates on cgroup hierarchy with
> > > additional overhead associated with that. I'm guessing that's the
> > > reason for the big difference between these mechanisms but, I didn't
> > > look into the details to understand memcg_kmem performance.
> > 
> > I suspect recent rt-related changes and also the wide usage of
> > rcu primitives in the kmem code. I'll try to look closer as well.
> 
> Happy to give you something to compare against :)

To be fair, it's not an apple-to-apple comparison, because:
1) memcgs are organized in a tree, these days usually with at least 3 layers,
2) memcgs are dynamic. In theory a task can be moved to a different
   memcg while performing a (very slow) allocation, and the original
   memcg can be released. To prevent this we have to perform a lot
   of operations which you can happily avoid.

That said, there is clearly a place for optimization, so thank you
for indirectly bringing this up.

Thanks!
