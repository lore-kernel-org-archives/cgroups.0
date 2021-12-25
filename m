From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Sat, 25 Dec 2021 17:53:23 +0000
Message-ID: <Ycdak5J48i7CGkHU@casper.infradead.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e@suse.cz>
 <Ycbhh5n8TBODWHR+@ip-172-31-30-232.ap-northeast-1.compute.internal>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DsB14TIFCiBAdP7rD7EHBmZ2vEchTQE1iQvq9NRvB9w=; b=P8eHkVObvPl/+oE4RPc6QOntRY
        /de/u2l0W5mC3WRBpFK4be27bPrWJfdkv1FuPLbMrayZv+0guT03DnIrQ/xL3ldKXn+hP73WRranJ
        BzynHSKSXf1ouyx0LrktgopeQyRdndjcLtl7c/XkqALfMs9N7wE6eV9QGeWSvaR3pq7XUuXx2IYyP
        iN7kRcmN7F4B5szTaLh5wURmvRCOqzWou5PnMz2K4MRAAWjoExqrZE1+3Ev5rn5sBWZqpj5Oq7sda
        DGBdHlvxWH9UnXyu0o4m5b7pRDFJ0SNAdOIkV/egmPglIrpj5BKAwgN6thX544+NOaU1tHVYkZSQs
        /2BQ/rBA==;
Content-Disposition: inline
In-Reply-To: <Ycbhh5n8TBODWHR+-UAkeum2rnor1owfsx/q8xBTA2CDgPq3U3JN/6IHv09UQhXZLsr/E6M+yXz+rYK7V@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Sat, Dec 25, 2021 at 09:16:55AM +0000, Hyeonggon Yoo wrote:
> # mm: Convert struct page to struct slab in functions used by other subsystems
> I'm not familiar with kasan, but to ask:
> Does ____kasan_slab_free detect invalid free if someone frees
> an object that is not allocated from slab?
> 
> @@ -341,7 +341,7 @@ static inline bool ____kasan_slab_free(struct kmem_cache *cache, void *object,
> -       if (unlikely(nearest_obj(cache, virt_to_head_page(object), object) !=
> +       if (unlikely(nearest_obj(cache, virt_to_slab(object), object) !=
>             object)) {
>                 kasan_report_invalid_free(tagged_object, ip);
>                 return true;
> 
> I'm asking this because virt_to_slab() will return NULL if folio_test_slab()
> returns false. That will cause NULL pointer dereference in nearest_obj.
> I don't think this change is intended.

You need to track down how this could happen.  As far as I can tell,
it's always called when we know the object is part of a slab.  That's
where the cachep pointer is deduced from.

