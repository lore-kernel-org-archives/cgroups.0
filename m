From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Mon, 20 Dec 2021 01:47:54 +0100
Message-ID: <86617be0-8aa8-67d2-08bd-1e06c3d12785@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <Ybk+0LKrsAJatILE@carbon.dhcp.thefacebook.com>
 <Ybp8a5JNndgCLy2w@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639961275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GljbjGESLyxg+ngLc7mhGY1oQBxex2sK+C5XSkEFVyI=;
        b=bXsxoOzcRRIip4e3u7ZMJHBHCqpqGoHvghX+Qod90rITqgkPX6WlwwmBkBzLIQgnPM3M7l
        siGEY6tKIftLy8gm6P7tCtEhJhPH5+N420SWQ7CGJk78g/87i2iR5inofquN9kpBkcJNuF
        Zi+LVig8LSExmO4XED1Ps1yp2oNnfR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639961275;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GljbjGESLyxg+ngLc7mhGY1oQBxex2sK+C5XSkEFVyI=;
        b=d+lrN53wSmcr6AJTW2rR1oZX3qGUcCXsDSsgdtTCVT7nNW2HNB8UytrIeq4FK+FkuQdmV5
        dAxQM4ms+6JZ/yCg==
Content-Language: en-US
In-Reply-To: <Ybp8a5JNndgCLy2w-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes@cmpxchg>

On 12/16/21 00:38, Roman Gushchin wrote:
> Part 2:
> 
> * mm: Convert check_heap_object() to use struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Convert detached_freelist to use a struct slab
> How about to convert free_nonslab_page() to free_nonslab_folio()?
> And maybe rename it to something like free_large_kmalloc()?
> If I'm not missing something, large kmallocs is the only way how we can end up
> there with a !slab folio/page.

Good point, thanks! But did at as part of the following patch, where it fits
logically better.

> * mm/slub: Convert kfree() to use a struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Didn't add your tag because of the addition of free_large_kmalloc() change.

> * mm/slub: Convert __slab_lock() and __slab_unlock() to struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Convert print_page_info() to print_slab_info()
> Do we really need to explicitly convert slab_folio()'s result to (struct folio *)?

Unfortunately yes, as long as folio_flags() don't take const struct folio *,
which will need some yak shaving.

> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Convert alloc_slab_page() to return a struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Convert __free_slab() to use struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Convert pfmemalloc_match() to take a struct slab
> Cool! Removing pfmemalloc_unsafe() is really nice.
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Convert most struct page to struct slab by spatch
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Finish struct page to struct slab conversion
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks again!

> * mm/slab: Convert most struct page to struct slab by spatch
> 
> Another patch with the same title? Rebase error?
> 
> * mm/slab: Finish struct page to struct slab conversion
> 
> And this one too?
> 
> 
> Thanks!
> 
> Roman

