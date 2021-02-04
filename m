From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: replace the loop with a list_for_each_entry()
Date: Thu, 4 Feb 2021 23:55:45 +0800
Message-ID: <CAMZfGtX6VKKyBNhUJk+a2NTub8nfHbET=N_1ERHAqjUDEVJnZg@mail.gmail.com>
References: <20210204105320.46072-1-songmuchun@bytedance.com> <YBwPQUwLQ6hAbdSV@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCCaUVi9BPMivSd/JjnmDZicqO5VGVuxEY7PUQjIT88=;
        b=rlZgV+XQhv7Yhfg2tHnSnXCKKbzm84eznk312M6PxgAwzfTh4Ik7suX8rLMrd8rXzW
         ELbY53/nujaDFMiP14r3bJRXJe2SLOoDDm7sffhsqmt4GKW+wmpKq6Gdtfj2QdFO17T+
         WrG64+XjOEDDvget+WoHZdNRbg5IRNW8ARaNBPxIRGcCFwjnSRzV0hu2+Sg9n5s1otFy
         dIe6RG99T8b1bYWd9JqmT4Sgzp+tBEy+/04B4IeuCr5ItLShwKeV6hjbqyEvOKR40jJe
         PdJGOuMShSOj8Gf4D32HY3XPIV4w8c5fUSBIfYPjxjpKYoZdYKnWF1oTvlasKNpW/y0T
         fP8w==
In-Reply-To: <YBwPQUwLQ6hAbdSV-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 4, 2021 at 11:14 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Thu, Feb 04, 2021 at 06:53:20PM +0800, Muchun Song wrote:
> > The rule of list walk has gone since:
> >
> >  commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")
> >
> > So remove the strange comment and replace the loop with a
> > list_for_each_entry().
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 17 ++---------------
> >  1 file changed, 2 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6c7f1ea3955e..43341bd7ea1c 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6891,24 +6891,11 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
> >  static void uncharge_list(struct list_head *page_list)
> >  {
> >       struct uncharge_gather ug;
> > -     struct list_head *next;
> > +     struct page *page;
> >
> >       uncharge_gather_clear(&ug);
> > -
> > -     /*
> > -      * Note that the list can be a single page->lru; hence the
> > -      * do-while loop instead of a simple list_for_each_entry().
> > -      */
> > -     next = page_list->next;
> > -     do {
> > -             struct page *page;
> > -
> > -             page = list_entry(next, struct page, lru);
> > -             next = page->lru.next;
> > -
> > +     list_for_each_entry(page, page_list, lru)
> >               uncharge_page(page, &ug);
> > -     } while (next != page_list);
> > -
> >       uncharge_batch(&ug);
>
> Good catch, this makes things much simpler.
>
> Looking at the surrounding code, there also seems to be no reason
> anymore to have uncharge_list() as a separate function: there is only
> one caller after the mentioned commit, and it's trivial after your
> change. Would you mind folding it into mem_cgroup_uncharge_list()?

Will do. Thanks.

>
> The list_empty() check in that one is also unnecessary now: the
> do-while loop required at least one page to be on the list or it would
> crash, but list_for_each() will be just fine on an empty list.

Right. It makes things more simple.

>
> Thanks
