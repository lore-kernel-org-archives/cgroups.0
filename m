From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 28 Jul 2020 18:27:16 -0700
Message-ID: <CAKgT0UfCv9u3UaJnzh7CYu_nCggV8yesZNu4oxMGn4+mJYiFUw@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com>
 <ccd01046-451c-463d-7c5d-9c32794f4b1e@linux.alibaba.com> <CAKgT0UdrQpa9OSusi=TZoj4RgC63-BNiF1GmeTG=rS47r7rGvQ@mail.gmail.com>
 <09aeced7-cc36-0c9a-d40b-451db9dc54cc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2AUZodZwJRXZg+Nk/lyRu0Z8bQTh1DNt0my27QVLRIE=;
        b=XHRjbV6gcKKyZ7t3CuLSBJocHqKHPIjZvwsV5DIOeWQ3ngzNTNUwZds7roo63C+ktS
         PYjB9YztN1uSR96wxcGWPo1IILBKAU5yRYVFlNQDGdHc2tGGryZ1aw2A2CqY3ImZRZ8b
         fFXnrmGZXe4j3aKu72ikXjiSJP3h8qOTow4eoPJSjHRCIoEeSK34SNbyP9xoHzYblJ4D
         /ddlrdx2vPMg61m6jpgsBVm+VSFyH268r0bOLg01yfs79F5AMif/9ZbBKB1LuINmz0Ww
         hSnm5Wi1q6pzSQQViTsBhrcvlPW2F4cLnRLSJ8w9NOxr2BX8ltTmT4V6IWqg5l3JYSKi
         TlOA==
In-Reply-To: <09aeced7-cc36-0c9a-d40b-451db9dc54cc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Jul 28, 2020 at 6:00 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/7/28 =E4=B8=8B=E5=8D=8810:54, Alexander Duyck =E5=86=99=E9=
=81=93:
> > On Tue, Jul 28, 2020 at 4:20 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> w=
rote:
> >>
> >>
> >>
> >> =E5=9C=A8 2020/7/28 =E4=B8=8A=E5=8D=887:34, Alexander Duyck =E5=86=99=
=E9=81=93:
> >>>> @@ -1876,6 +1876,12 @@ static unsigned noinline_for_stack move_pages=
_to_lru(struct lruvec *lruvec,
> >>>>                  *                                        list_add(&=
page->lru,)
> >>>>                  *     list_add(&page->lru,) //corrupt
> >>>>                  */
> >>>> +               new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgd=
at(page));
> >>>> +               if (new_lruvec !=3D lruvec) {
> >>>> +                       if (lruvec)
> >>>> +                               spin_unlock_irq(&lruvec->lru_lock);
> >>>> +                       lruvec =3D lock_page_lruvec_irq(page);
> >>>> +               }
> >>>>                 SetPageLRU(page);
> >>>>
> >>>>                 if (unlikely(put_page_testzero(page))) {
> >>> I was going through the code of the entire patch set and I noticed
> >>> these changes in move_pages_to_lru. What is the reason for adding the
> >>> new_lruvec logic? My understanding is that we are moving the pages to
> >>> the lruvec provided are we not?If so why do we need to add code to ge=
t
> >>> a new lruvec? The code itself seems to stand out from the rest of the
> >>> patch as it is introducing new code instead of replacing existing
> >>> locking code, and it doesn't match up with the description of what
> >>> this function is supposed to do since it changes the lruvec.
> >>
> >> this new_lruvec is the replacement of removed line, as following code:
> >>>> -               lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> >> This recheck is for the page move the root memcg, otherwise it cause t=
he bug:
> >
> > Okay, now I see where the issue is. You moved this code so now it has
> > a different effect than it did before. You are relocking things before
> > you needed to. Don't forget that when you came into this function you
> > already had the lock. In addition the patch is broken as it currently
> > stands as you aren't using similar logic in the code just above this
> > addition if you encounter an evictable page. As a result this is
> > really difficult to review as there are subtle bugs here.
>
> Why you think its a bug? the relock only happens if locked lruvec is diff=
erent.
> and unlock the old one.

The section I am talking about with the bug is this section here:
       while (!list_empty(list)) {
+               struct lruvec *new_lruvec =3D NULL;
+
                page =3D lru_to_page(list);
                VM_BUG_ON_PAGE(PageLRU(page), page);
                list_del(&page->lru);
                if (unlikely(!page_evictable(page))) {
-                       spin_unlock_irq(&pgdat->lru_lock);
+                       spin_unlock_irq(&lruvec->lru_lock);
                        putback_lru_page(page);
-                       spin_lock_irq(&pgdat->lru_lock);
+                       spin_lock_irq(&lruvec->lru_lock);
                        continue;
                }

Basically it probably is not advisable to be retaking the
lruvec->lru_lock directly as the lruvec may have changed so it
wouldn't be correct for the next page. It would make more sense to be
using your API and calling unlock_page_lruvec_irq and
lock_page_lruvec_irq instead of using the lock directly.

> >
> > I suppose the correct fix is to get rid of this line, but  it should
> > be placed everywhere the original function was calling
> > spin_lock_irq().
> >
> > In addition I would consider changing the arguments/documentation for
> > move_pages_to_lru. You aren't moving the pages to lruvec, so there is
> > probably no need to pass that as an argument. Instead I would pass
> > pgdat since that isn't going to be moving and is the only thing you
> > actually derive based on the original lruvec.
>
> yes, The comments should be changed with the line was introduced from lon=
g ago. :)
> Anyway, I am wondering if it worth a v18 version resend?

So I have been looking over the function itself and I wonder if it
isn't worth looking at rewriting this to optimize the locking behavior
to minimize the number of times we have to take the LRU lock. I have
some code I am working on that I plan to submit as an RFC in the next
day or so after I can get it smoke tested. The basic idea would be to
defer returning the evictiable pages or freeing the compound pages
until after we have processed the pages that can be moved while still
holding the lock. I would think it should reduce the lock contention
significantly while improving the throughput.
