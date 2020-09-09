From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 31/32] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 9 Sep 2020 11:24:14 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009091100280.9020@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-32-git-send-email-alex.shi@linux.alibaba.com> <20200909010118.GB6583@casper.infradead.org> <CAKgT0UcjNx=00OgAQNWezc7UjLmF2NcDH0p7kzZ5D23PaFrFXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Ruhhup1GiVMzdtnhUGJBHZmdP0+i41QleFToFouJcG0=;
        b=XDE4XX5WI/xPzfW/NMmUCQ3gVCnjbXrHt8OZ8zTa8NBevb7IHbrl/CNJzNEBbJAWSt
         mb2pkZ6iQFCSt/q5DVeqGb+Nus0hYvK68luUixqriqlyeKJdl+oqygph3LDTrnWc6T9h
         fWv/uvdnEzXrsILGx8SzqA65K21CKUQDVaAl0JFq2hcncH1UebzvxYpWJbFh7zVFBpBu
         gingaYs6WXb1VQj6dXz40KyyJXkaaFLrzQ4rRC1CX61vyJvkxHuszDndK7jT5Lrbkojv
         DJeqyHfkPPnmTJGrQIIwUhTtQ+MRbeYsaCG00Wkar1qmHCnOEQgsdMgsei9v2ccL99kT
         XkOQ==
In-Reply-To: <CAKgT0UcjNx=00OgAQNWezc7UjLmF2NcDH0p7kzZ5D23PaFrFXA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Alex Shi <alex.shi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, 

On Wed, 9 Sep 2020, Alexander Duyck wrote:
> On Tue, Sep 8, 2020 at 6:01 PM Matthew Wilcox <willy@infradead.org> wrote:
> > On Mon, Aug 24, 2020 at 08:55:04PM +0800, Alex Shi wrote:
> > > +++ b/mm/vmscan.c
> > > @@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
> > >
> > >                       if (!TestClearPageLRU(page)) {
> > >                               /*
> > > -                              * This page may in other isolation path,
> > > -                              * but we still hold lru_lock.
> > > +                              * This page is being isolated in another
> > > +                              * thread, but we still hold lru_lock. The
> > > +                              * other thread must be holding a reference
> > > +                              * to the page so this should never hit a
> > > +                              * reference count of 0.
> > >                                */
> > > -                             put_page(page);
> > > +                             WARN_ON(put_page_testzero(page));
> > >                               goto busy;
> >
> > I read Hugh's review and that led me to take a look at this.  We don't
> > do it like this.  Use the same pattern as elsewhere in mm:
> >
> >         page_ref_sub(page, nr);
> >         VM_BUG_ON_PAGE(page_count(page) <= 0, page);
> >
> >
> 
> Actually for this case page_ref_dec(page) would make more sense
> wouldn't it? Otherwise I agree that would be a better change if that
> is the way it has been handled before. I just wasn't familiar with
> those other spots.

After overnight reflection, my own preference would be simply to
drop this patch.  I think we are making altogether too much of a
fuss here over what was simply correct as plain put_page()
(and further from correct if we change it to leak the page in an
unforeseen circumstance).

And if Alex's comment was not quite grammatically correct, never mind,
it said as much as was worth saying.  I got more worried by his
placement of the "busy:" label, but that does appear to work correctly.

There's probably a thousand places where put_page() is used, where
it would be troublesome if it were the final put_page(): this one
bothered you because you'd been looking at isolate_migratepages_block(),
and its necessary avoidance of lru_lock recursion on put_page();
but let's just just leave this put_page() as is.

Hugh
