From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/5] mm: Identify compound pages sooner in isolate_migratepages_block
Date: Wed, 19 Aug 2020 07:48:11 -0700
Message-ID: <CAKgT0UfVdaMfg=TiiqOK1axUdmViEeaU+R8sisf5WpOKqa-65w@mail.gmail.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042705.23414.84098.stgit@localhost.localdomain> <20200819114309.GB17456@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ApYOFSEYaJPt7kKwt38Kbe/M+l0V8+5a0AJxr5VRnc=;
        b=YYBHKawxqJQGH1DRcGNuNEl8HkABjzipt0mrQB7bCYB3X3HNFEjzrPeNzEydAioj/M
         DwVxkFmLmp6FYn7jLmVK819EibJcsnNXjaOcxdInSWq5tAKv62k7M0o5y4ysoqaF9BbV
         qphZCSByCz4tOwQ4m2IseIey1XrnftJYJn2p69QJBLHQc90jrKFj64a/XXMvuhpfRyGN
         XnKEk/0OPRCvmjVHuYH4zNer7uEKRmiXBGN9njK4kUWx3qyz6boBD4UioL22mwzjEwjt
         Oc5zDVyYkwMsJcnXux9zkSu9cM4OZg8KGChwRNkRqzHHlIxPITRBvJwd6qI/aGIExjjG
         jqSA==
In-Reply-To: <20200819114309.GB17456-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Wed, Aug 19, 2020 at 4:43 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Tue, Aug 18, 2020 at 09:27:05PM -0700, Alexander Duyck wrote:
> > +             /*
> > +              * Page is compound. We know the order before we know if it is
> > +              * on the LRU so we cannot assume it is THP. However since the
> > +              * page will have the LRU validated shortly we can use the value
> > +              * to skip over this page for now or validate the LRU is set and
> > +              * then isolate the entire compound page if we are isolating to
> > +              * generate a CMA page.
> > +              */
> > +             if (PageCompound(page)) {
> > +                     const unsigned int order = compound_order(page);
> > +
> > +                     if (likely(order < MAX_ORDER))
> > +                             low_pfn += (1UL << order) - 1;
>
> Hmm.  You're checking for PageCompound but then skipping 1UL << order.
> That only works if PageHead.  If instead this is PageCompound because
> it's PageTail, you need to do something like:
>
>                                 low_pfn |= (1UL << order) - 1;
>
> which will move you to the end of the page you're in the middle of.

Can you successfully call get_page_unless_zero in a tail page? I
thought their reference count was 0? There is a get_page_unless_zero
call before the PageCompound check, so I don't think we can get a tail
page.

> If PageTail can't actually happen here, then it's better to check for
> PageHead explicitly and WARN_ON if you get a PageTail (eg a page was
> combined into a compound page after you processed the earlier head page).
>
> Is it possible the page you've found is hugetlbfs?  Those can have orders
> larger than MAX_ORDER.

So in theory we only need to jump pageblock_order. However there are
some architectures where that is not a fixed constant and so it would
have some additional overhead if I am not mistaken. In addition we
should have been only provided a pageblock if i am not mistaken so the
check further down that prevents low_pfn from passing end_pfn should
reset to the correct value.
