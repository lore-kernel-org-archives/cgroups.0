From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH v4 3/7] mm: memcontrol: convert
 NR_FILE_THPS account to pages
Date: Fri, 11 Dec 2020 22:14:22 +0800
Message-ID: <CAMZfGtVYkkoQc+VsMPj-_FWAZmQOhme4QD0vJ9cDZNMsTg2jPw@mail.gmail.com>
References: <20201211041954.79543-1-songmuchun@bytedance.com>
 <20201211041954.79543-4-songmuchun@bytedance.com> <20201211135737.GA2443@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5f1oHmcol2mHx6bC5gFH8ezh95GR9pifCliLgoZXiHI=;
        b=Bzgx3oPWqgw2n1k0AK1q+w30PZWgSi1dqKV5jw4NTUlxXSt/Em/bVVrqnzOIlv2DBr
         fjVuO3tsgvvmQZXK8pbVfZGMi5nU1uZGf1M1er6k2a0orAK6Q5bUSNTN7OkFM7LX8abp
         qcAPpTeDQaBnKIIg7RisfNNKMSBGR05hlFYUQeX4Lrrzo7olSSxraRJiRhPjAlTwwle6
         GkPMDER0cf/tv5691W+YJs5CjQVWbTBgYzNJTYFqgH0KFlQro1pPQAw1eB47CptCcgsn
         5zvRtWb/qbSs9IZWA4zUdMkPOK9ReXwzcO6X9zb51a0t10AV6YQYrW+R5nCR/WVstc2O
         ixuw==
In-Reply-To: <20201211135737.GA2443@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Sami Tolvanen <samitolvanen@google.com>, Feng Tang <feng.tang@intel.com>, Neil Brown <neilb@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Dec 11, 2020 at 9:57 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Dec 11, 2020 at 12:19:50PM +0800, Muchun Song wrote:
> > +++ b/mm/filemap.c
> > @@ -207,7 +207,7 @@ static void unaccount_page_cache_page(struct address_space *mapping,
> >               if (PageTransHuge(page))
> >                       __dec_lruvec_page_state(page, NR_SHMEM_THPS);
> >       } else if (PageTransHuge(page)) {
> > -             __dec_lruvec_page_state(page, NR_FILE_THPS);
> > +             __mod_lruvec_page_state(page, NR_FILE_THPS, -HPAGE_PMD_NR);
>
> +               __mod_lruvec_page_state(page, NR_FILE_THPS, -nr);

Thank you.

>
> > +++ b/mm/huge_memory.c
> > @@ -2748,7 +2748,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
> >                       if (PageSwapBacked(head))
> >                               __dec_lruvec_page_state(head, NR_SHMEM_THPS);
> >                       else
> > -                             __dec_lruvec_page_state(head, NR_FILE_THPS);
> > +                             __mod_lruvec_page_state(head, NR_FILE_THPS,
> > +                                                     -HPAGE_PMD_NR);
>
> +                               __mod_lruvec_page_state(head, NR_FILE_THPS,
> +                                               -thp_nr_pages(head));
>

Thanks.

-- 
Yours,
Muchun
