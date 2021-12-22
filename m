From: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Wed, 22 Dec 2021 07:36:33 +0000
Message-ID: <YcLVgdpyhZjtAatZ@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <YbtUmi5kkhmlXEB1@ip-172-31-30-232.ap-northeast-1.compute.internal>
 <38976607-b9f9-1bce-9db9-60c23da65d2e@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WrvvWhSLi37P9Hu9a/lN3dt16MiGegPkcEW+eWXvnco=;
        b=RKpi5mEKObOsMfFa2Hh3uM3GzsMIBcjoLEKD7cwnOeZVwpA/d0V88BawrYNtOMnFn7
         l9nLVd1NKaLq5pB3voPPj4Z2icjvncDwuZ1uCcPIm6/WMKIxRRSgNH/mDo7gCP9SqWkU
         gYLMtOZHpZ2bc7XcFtJFnIgGuT/WDzmxB2cJqJdB0KPkqVUD86hast7AId9I1sCheseV
         FXPC48nv7polwBlytcx80Ge2CfcadbncgdXZ3ZbZeK1wttQ3MYdrMcX33gMLD2b77cBe
         1XVNoWD64mGKqnHA2cr7yfFsOmBI796jO3rcUEeDFIAJ9d2aBQsqNJ50N2r74mkiVcl+
         IdoQ==
Content-Disposition: inline
In-Reply-To: <38976607-b9f9-1bce-9db9-60c23da65d2e-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes@cmpxchg>

On Tue, Dec 21, 2021 at 12:58:14AM +0100, Vlastimil Babka wrote:
> On 12/16/21 16:00, Hyeonggon Yoo wrote:
> > On Tue, Dec 14, 2021 at 01:57:22PM +0100, Vlastimil Babka wrote:
> >> On 12/1/21 19:14, Vlastimil Babka wrote:
> >> > Folks from non-slab subsystems are Cc'd only to patches affecting them, and
> >> > this cover letter.
> >> > 
> >> > Series also available in git, based on 5.16-rc3:
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2
> >> 
> >> Pushed a new branch slab-struct-slab-v3r3 with accumulated fixes and small tweaks
> >> and a new patch from Hyeonggon Yoo on top. To avoid too much spam, here's a range diff:
> > 
> > Reviewing the whole patch series takes longer than I thought.
> > I'll try to review and test rest of patches when I have time.
> > 
> > I added Tested-by if kernel builds okay and kselftests
> > does not break the kernel on my machine.
> > (with CONFIG_SLAB/SLUB/SLOB depending on the patch),
> 
> Thanks!
>

:)

> > Let me know me if you know better way to test a patch.
> 
> Testing on your machine is just fine.
>

Good!

> > # mm/slub: Define struct slab fields for CONFIG_SLUB_CPU_PARTIAL only when enabled
> > 
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > Comment:
> > Works on both SLUB_CPU_PARTIAL and !SLUB_CPU_PARTIAL.
> > btw, do we need slabs_cpu_partial attribute when we don't use
> > cpu partials? (!SLUB_CPU_PARTIAL)
> 
> The sysfs attribute? Yeah we should be consistent to userspace expecting to
> read it (even with zeroes), regardless of config.
> 

I thought entirely disabling the attribute is simpler,
But okay If it should be exposed even if it's always zero.

> > # mm/slub: Simplify struct slab slabs field definition
> > Comment:
> > 
> > This is how struct page looks on the top of v3r3 branch:
> > struct page {
> > [...]
> >                 struct {        /* slab, slob and slub */
> >                         union {
> >                                 struct list_head slab_list;
> >                                 struct {        /* Partial pages */
> >                                         struct page *next;
> > #ifdef CONFIG_64BIT
> >                                         int pages;      /* Nr of pages left */
> > #else
> >                                         short int pages;
> > #endif
> >                                 };
> >                         };
> > [...]
> > 
> > It's not consistent with struct slab.
> 
> Hm right. But as we don't actually use the struct page version anymore, and
> it's not one of the fields checked by SLAB_MATCH(), we can ignore this.
>

Yeah this is not a big problem. just mentioned this because 
it looked weird and I didn't know when the patch "mm: Remove slab from struct page"
will come back.

> > I think this is because "mm: Remove slab from struct page" was dropped.
>
> That was just postponed until iommu changes are in. Matthew mentioned those
> might be merged too, so that final cleanup will happen too and take care of
> the discrepancy above, so no need for extra churn to address it speficially.
> 

Okay it seems no extra work needed until the iommu changes are in!

BTW, in the patch (that I sent) ("mm/slob: Remove unnecessary page_mapcount_reset()
function call"), it refers commit 4525180926f9  ("mm/sl*b: Differentiate struct slab fields by
sl*b implementations"). But the commit hash 4525180926f9 changed after the
tree has been changed.

It will be nice to write a script to handle situations like this.

> > Would you update some of patches?
> > 
> > # mm/sl*b: Differentiate struct slab fields by sl*b implementations
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Works SL[AUO]B on my machine and makes code much better.
> > 
> > # mm/slob: Convert SLOB to use struct slab and struct folio
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > It still works fine on SLOB.
> > 
> > # mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > # mm/slub: Convert __free_slab() to use struct slab
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Tested-by: Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > Thanks,
> > Hyeonggon.
> 
> Thanks again,
> Vlastimil

Have a nice day, thanks!
Hyeonggon.
