From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Wed, 15 Dec 2021 15:38:19 -0800
Message-ID: <Ybp8a5JNndgCLy2w@carbon.dhcp.thefacebook.com>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <Ybk+0LKrsAJatILE@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FISMclEalm7kRVdN9oOm4Xk4Dtn0W9Br+NPCqWkjADQ=;
 b=Wy7dJd/hHD0a3/3lPONEkmkNHCBtUIfn4N2q07ittQlvv6HrAbw1hiWMK3O76FNXzNqj
 EUF+hFHeii4mpY3yLUffGd3MAptl6j21ahCdjkSOhb75Cr8IbKkDVq45XtdM8yoHIvpA
 HS0JIKaCb3rOrXxK/2VTlrvo5fV8jKWnqlU= 
Content-Disposition: inline
In-Reply-To: <Ybk+0LKrsAJatILE-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes>

On Tue, Dec 14, 2021 at 05:03:12PM -0800, Roman Gushchin wrote:
> On Tue, Dec 14, 2021 at 01:57:22PM +0100, Vlastimil Babka wrote:
> > On 12/1/21 19:14, Vlastimil Babka wrote:
> > > Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> > > this cover letter.
> > > 
> > > Series also available in git, based on 5.16-rc3:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> > 
> > Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> > and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> 
> Hi Vlastimil!
> 
> I've started to review this patchset (btw, a really nice work, I like
> the resulting code way more). Because I'm looking at v3 and I don't have
> the whole v2 in my mailbox, here is what I've now:
> 
> * mm: add virt_to_folio() and folio_address()
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slab: Dissolve slab_map_pages() in its caller
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm/slub: Make object_err() static
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Split slab into its own type
> 1) Shouldn't SLAB_MATCH() macro use struct folio instead of struct page for the
> comparison?
> 2) page_slab() is used only in kasan and only in one place, so maybe it's better
> to not introduce it as a generic helper?
> Other than that
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Add account_slab() and unaccount_slab()
> 1) maybe change the title to convert/replace instead of add?
> 2) maybe move later changes to memcg_alloc_page_obj_cgroups() to this patch?
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Convert virt_to_cache() to use struct slab
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Convert __ksize() to struct slab
> It looks like certain parts of __ksize() can be merged between slab, slub and slob?
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> * mm: Use struct slab in kmem_obj_info()
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Part 2:

* mm: Convert check_heap_object() to use struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert detached_freelist to use a struct slab
How about to convert free_nonslab_page() to free_nonslab_folio()?
And maybe rename it to something like free_large_kmalloc()?
If I'm not missing something, large kmallocs is the only way how we can end up
there with a !slab folio/page.

* mm/slub: Convert kfree() to use a struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert __slab_lock() and __slab_unlock() to struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert print_page_info() to print_slab_info()
Do we really need to explicitly convert slab_folio()'s result to (struct folio *)?
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert alloc_slab_page() to return a struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert __free_slab() to use struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert pfmemalloc_match() to take a struct slab
Cool! Removing pfmemalloc_unsafe() is really nice.
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Convert most struct page to struct slab by spatch
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Finish struct page to struct slab conversion
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slab: Convert most struct page to struct slab by spatch

Another patch with the same title? Rebase error?

* mm/slab: Finish struct page to struct slab conversion

And this one too?


Thanks!

Roman
