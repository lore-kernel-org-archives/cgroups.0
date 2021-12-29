From: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Wed, 29 Dec 2021 11:22:54 +0000
Message-ID: <YcxFDuPXlTwrPSPk@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B8D9h3oa8OpyqxIH3xe2rIOLYO1p/ntyh/ItEZc2ers=;
        b=WGgAxIa78MQr67iJtQ1TD1NaSUDzL8Sj14e4SvxYWhEN9di3WJIBnUF+L3ExcGr1oj
         QG61NAIFhjT/XTvY0CDIKSy0x2wdhjgp5o3CP/sn9tLZp0iIoIh8BXvPhaMFXpuLfzRl
         ssYONzQtGOvuMs4NA/1vndNqMZ2aeOxJ5COnpBFYJWM3L7v9L5GRfb6CzWNnmn7NDNB5
         Y3k9y/k0SaoD8ZsB9lFCcDRjDybncaD5TD9GRZZ/dYi8Nrw8/TG12zPX6PJi/KX88OD2
         OuID2/9IQHJyO+voFSIrf5Pg524R1rvzzNEz20N8dgdaI7Q3jfQjIb0uJgqdnoHZZxJI
         MBfA==
Content-Disposition: inline
In-Reply-To: <f3a83708-3f3c-a634-7bee-dcfcaaa7f36e-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes@cmpxchg>

On Wed, Dec 22, 2021 at 05:56:50PM +0100, Vlastimil Babka wrote:
> On 12/14/21 13:57, Vlastimil Babka wrote:
> > On 12/1/21 19:14, Vlastimil Babka wrote:
> >> Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> >> this cover letter.
> >>
> >> Series also available in git, based on 5.16-rc3:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> > 
> > Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> > and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> 
> Hi, I've pushed another update branch slab-struct_slab-v4r1, and also to
> -next. I've shortened git commit log lines to make checkpatch happier,
> so no range-diff as it would be too long. I believe it would be useless
> spam to post the whole series now, shortly before xmas, so I will do it
> at rc8 time, to hopefully collect remaining reviews. But if anyone wants
> a mailed version, I can do that.
>

Hello Matthew and Vlastimil.
it's part 3 of review.

# mm: Convert struct page to struct slab in functions used by other subsystems
Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


# mm/slub: Convert most struct page to struct slab by spatch
Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
with a question below.

-static int check_slab(struct kmem_cache *s, struct page *page)
+static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
        int maxobj;
 
-       if (!PageSlab(page)) {
-               slab_err(s, page, "Not a valid slab page");
+       if (!folio_test_slab(slab_folio(slab))) {
+               slab_err(s, slab, "Not a valid slab page");
                return 0;
        }

Can't we guarantee that struct slab * always points to a slab?

for struct page * it can be !PageSlab(page) because struct page *
can be other than slab. but struct slab * can only be slab
unlike struct page. code will be simpler if we guarantee that
struct slab * always points to a slab (or NULL).


# mm/slub: Convert pfmemalloc_match() to take a struct slab
It's confusing to me because the original pfmemalloc_match() is removed
and pfmemalloc_match_unsafe() was renamed to pfmemalloc_match() and
converted to use slab_test_pfmemalloc() helper.

But I agree with the resulting code. so:
Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


# mm/slub: Convert alloc_slab_page() to return a struct slab
Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


# mm/slub: Convert print_page_info() to print_slab_info()
Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I hope to review rest of patches in a week.

Thanks,
Hyeonggon

> Changes in v4:
> - rebase to 5.16-rc6 to avoid a conflict with mainline
> - collect acks/reviews/tested-by from Johannes, Roman, Hyeonggon Yoo -
> thanks!
> - in patch "mm/slub: Convert detached_freelist to use a struct slab"
> renamed free_nonslab_page() to free_large_kmalloc() and use folio there,
> as suggested by Roman
> - in "mm/memcg: Convert slab objcgs from struct page to struct slab"
> change one caller of slab_objcgs_check() to slab_objcgs() as suggested
> by Johannes, realize the other caller should be also changed, and remove
> slab_objcgs_check() completely.
