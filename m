From: Roman Gushchin via iommu <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Tue, 14 Dec 2021 17:03:12 -0800
Message-ID: <Ybk+0LKrsAJatILE@carbon.dhcp.thefacebook.com>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
Reply-To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com;
 h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=5iCF1rNv7/raNBX5b6Ddekpu+7nTy/ld4v6tScCL3hs=;
 b=Ebg9R/ddwTVeI+REYFYgspO+z5I6WPMMkerajj4xbb44Kkf2PCZxQWcmBsGlTF53wy25
 NvgDyG7Cmy/zNtairE4T8qAF64RdK6BCkqbOF4kHEhVO9m04X4RRisQ3hsp6yZM235E8
 TzoEJT8EROxvPN1RdtI7lAbsxZP26/ZtHI0= 
Content-Disposition: inline
In-Reply-To: <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05-AlSwsSmVLrQ@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Joonsoo Kim <ia>

On Tue, Dec 14, 2021 at 01:57:22PM +0100, Vlastimil Babka wrote:
> On 12/1/21 19:14, Vlastimil Babka wrote:
> > Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> > this cover letter.
> > 
> > Series also available in git, based on 5.16-rc3:
> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> 
> Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:

Hi Vlastimil!

I've started to review this patchset (btw, a really nice work, I like
the resulting code way more). Because I'm looking at v3 and I don't have
the whole v2 in my mailbox, here is what I've now:

* mm: add virt_to_folio() and folio_address()
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slab: Dissolve slab_map_pages() in its caller
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm/slub: Make object_err() static
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm: Split slab into its own type
1) Shouldn't SLAB_MATCH() macro use struct folio instead of struct page for the
comparison?
2) page_slab() is used only in kasan and only in one place, so maybe it's better
to not introduce it as a generic helper?
Other than that
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm: Add account_slab() and unaccount_slab()
1) maybe change the title to convert/replace instead of add?
2) maybe move later changes to memcg_alloc_page_obj_cgroups() to this patch?
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm: Convert virt_to_cache() to use struct slab
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm: Convert __ksize() to struct slab
It looks like certain parts of __ksize() can be merged between slab, slub and slob?
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

* mm: Use struct slab in kmem_obj_info()
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>


I'll try to finish reviewing the patchset until the  end of the week.

Thanks!

Roman
