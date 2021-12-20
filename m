From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 00/33] Separate struct slab from struct page
Date: Mon, 20 Dec 2021 01:42:13 +0000
Message-ID: <Yb/fdYbLunsVYRqQ@casper.infradead.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05@suse.cz>
 <Ybk+0LKrsAJatILE@carbon.dhcp.thefacebook.com>
 <Ybp8a5JNndgCLy2w@carbon.dhcp.thefacebook.com>
 <86617be0-8aa8-67d2-08bd-1e06c3d12785@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k7fHWgKrjS6NSIvn5a4Jtgxmp/WhT9Wz1heA+PvFHEU=; b=fbUn3fvK/C4lIcfXkF1dhfDZp+
        0ZelBeFgnQYcFnt0EOTirvxdbva/ddh2SL+FntgltRD3RE987l95C52xyYhhRfbE2xb17KwOfKlFs
        5hOrS2+3DKFsP3AzTTFXGdtnAfDlAGiCbxuyVX733jeZZ+d0DD58EAaIyKmbheLpfRjDtShOeT6am
        hg7mxrzy3tJ/5EM0XQThsZ+qE0Zv7Dl2ydMZ44Ueicge/g2XjDjlE+5Q0yijLnkgOFaSa51eA1ivu
        3KHkjCK1aKheaU9DVEJ4MCzqGgtQ+Ndgh2oKwtYQK2wpphRgppBrz+kxZNRgm1Zd6KP6yXdmRMLqn
        IlqHXmWA==;
Content-Disposition: inline
In-Reply-To: <86617be0-8aa8-67d2-08bd-1e06c3d12785-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, J

On Mon, Dec 20, 2021 at 01:47:54AM +0100, Vlastimil Babka wrote:
> > * mm/slub: Convert print_page_info() to print_slab_info()
> > Do we really need to explicitly convert slab_folio()'s result to (struct folio *)?
> 
> Unfortunately yes, as long as folio_flags() don't take const struct folio *,
> which will need some yak shaving.

In case anyone's interested ...

folio_flags calls VM_BUG_ON_PGFLAGS() which would need its second
argument to be const.

That means dump_page() needs to take a const struct page, which
means __dump_page() needs its argument to be const.

That calls ...

is_migrate_cma_page()
page_mapping()
page_mapcount()
page_ref_count()
page_to_pgoff()
page_to_pfn()
hpage_pincount_available()
head_compound_mapcount()
head_compound_pincount()
compound_order()
PageKsm()
PageAnon()
PageCompound()

... and at that point, I ran out of motivation to track down some parts
of this tarbaby that could be fixed.  I did do:

    mm: constify page_count and page_ref_count
    mm: constify get_pfnblock_flags_mask and get_pfnblock_migratetype
    mm: make compound_head const-preserving
    mm/page_owner: constify dump_page_owner

so some of those are already done.  But a lot of them just need to be
done at the same time.  For example, page_mapping() calls
folio_mapping() which calls folio_test_slab() which calls folio_flags(),
so dump_page() and page_mapping() need to be done at the same time.

One bit that could be broken off easily (I think ...) is PageTransTail()
PageTail(), PageCompound(), PageHuge(), page_to_pgoff() and
page_to_index().  One wrinkle is needed a temporary
TESTPAGEFLAGS_FALSE_CONST.  But I haven't tried it yet.

