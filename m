From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 18/21] mm/lru: introduce the relock_page_lruvec function
Date: Fri, 31 Jul 2020 07:20:46 -0700
Message-ID: <CAKgT0UdtVnQKOvC4FTfk2c0s6syT9b=X9ak3wVRMJugwUGaBKQ@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-19-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdFDcz=CQ+6mzcjh-apwy3UyPqAuOozvYr+2PSCNQrENA@mail.gmail.com> <3345bfbf-ebe9-b5e0-a731-77dd7d76b0c9@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0aAVEzNKHnDRLwQliJhWr60G4nOTwfN1Nr0S9gmiAaI=;
        b=hFnFQkQexoCzKcXPojwdl0Qll7CYMMAdP35xco70i8/rURwuLltCrLeBTHQ8SOvfPT
         1BXsP+cRN+slrTj3L3U8MttdBfSu3eGLxNHbrZ2unl0XZdtvSfS9VV2CifQ3TgMoFd76
         NLJmwgGC3TOSiCD38xjzKAYQvHnS2LvxnOkfD2hpNUpA7+1iMpslVw3X868DGW420leT
         Z3zzcV/x9wQK5q3KF2CwdvXgq79B19byg7ZwkoQq8THbqxeX5sQ+jFr9ParWN8tQOSpi
         VIwfQEhzBk1kux/D5J4Wv0+3Ja00tsK+nXEgkWl08cDuebnLKCfHVT7hEpSxeDedyKff
         vHSw==
In-Reply-To: <3345bfbf-ebe9-b5e0-a731-77dd7d76b0c9-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

On Wed, Jul 29, 2020 at 11:08 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrot=
e:
>
>
>
> =E5=9C=A8 2020/7/30 =E4=B8=8A=E5=8D=881:52, Alexander Duyck =E5=86=99=E9=
=81=93:
> >> +       rcu_read_lock();
> >> +       locked =3D mem_cgroup_page_lruvec(page, pgdat) =3D=3D locked_l=
ruvec;
> >> +       rcu_read_unlock();
> >> +
> >> +       if (locked)
> >> +               return locked_lruvec;
> >> +
> >> +       if (locked_lruvec)
> >> +               unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
> >> +
> >> +       return lock_page_lruvec_irqsave(page, flags);
> >> +}
> >> +
> > So looking these over they seem to be pretty inefficient for what they
> > do. Basically in worst case (locked_lruvec =3D=3D NULL) you end up call=
ing
> > mem_cgoup_page_lruvec and all the rcu_read_lock/unlock a couple times
> > for a single page. It might make more sense to structure this like:
> > if (locked_lruvec) {
>
> Uh, we still need to check this page's lruvec, that needs a rcu_read_lock=
.
> to save a mem_cgroup_page_lruvec call, we have to open lock_page_lruvec
> as your mentained before.
>
> >     if (lruvec_holds_page_lru_lock(page, locked_lruvec))
> >         return locked_lruvec;
> >
> >     unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
> > }
> > return lock_page_lruvec_irqsave(page, flags);
> >
> > The other piece that has me scratching my head is that I wonder if we
> > couldn't do this without needing the rcu_read_lock. For example, what
> > if we were to compare the page mem_cgroup pointer to the memcg back
> > pointer stored in the mem_cgroup_per_node? It seems like ordering
> > things this way would significantly reduce the overhead due to the
> > pointer chasing to see if the page is in the locked lruvec or not.
> >
>
> If page->mem_cgroup always be charged. the following could be better.
>
> +/* Don't lock again iff page's lruvec locked */
> +static inline struct lruvec *relock_page_lruvec_irqsave(struct page *pag=
e,
> +               struct lruvec *locked_lruvec, unsigned long *flags)
> +{
> +       struct lruvec *lruvec;
> +
> +       if (mem_cgroup_disabled())
> +               return locked_lruvec;
> +
> +       /* user page always be charged */
> +       VM_BUG_ON_PAGE(!page->mem_cgroup, page);
> +
> +       rcu_read_lock();
> +       if (likely(lruvec_memcg(locked_lruvec) =3D=3D page->mem_cgroup)) =
{
> +               rcu_read_unlock();
> +               return locked_lruvec;
> +       }
> +
> +       if (locked_lruvec)
> +               unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
> +
> +       lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
> +       spin_lock_irqsave(&lruvec->lru_lock, *flags);
> +       rcu_read_unlock();
> +       lruvec_memcg_debug(lruvec, page);
> +
> +       return lruvec;
> +}
> +

I understand that you have to use the rcu_lock when you want to
acquire the lruvec via mem_cgroup_page_lruvec(). That is why I didn't
do away with the call to lock_page_lruvec_irqsave() at the end of the
function. However it doesn't make sense to do it when you are already
holding the locked_lruvec and simply getting the container of it in
order to compare pointer values.

One thing I was getting at with the lruvec_holds_page_lru_lock()
function I had introduced in my example is that the code baths for the
two relock functions are very similar. If we could move all the logic
for identifying if we can reuse the lock into a single function it
would dut down on the redundancy quite a bit as well. In addition by
testing for locked_lruvec !=3D NULL before we before we do the
comparison we can save ourselves some unnecessary testing in the case
where

The thought I had was try to avoid the rcu_lock entirely in the lock
reuse case. Basically you just need to compare the pgdat value and the
memcg between the page and the lruvec. As long as they both point the
same values then you should have the correct lruvec and no need to
relock. There is no need to take the rcu_lock as long as you aren't
dereferencing something and if you are just comparing the pointers it
should be good with that. The fallback if mem_cgroup_disabled() is to
make certain the page pgdat->__lruvec is the address belonging to the
lruvec.

> The user page is always be charged since readahead page is charged now.
> and looks we also can apply this patch. I will test it to see if there is
> other exception.

Yes that would simplify things a bit as the code I had was having to
use a ternary to test for root_mem_cgroup if page->mem_cgroup was
NULL. I should be able to finish up testing today and will submit a
few clean-up patches as RFC to get your thoughts/feedback.

> commit 826128346e50f6c60c513e166998466b593becad
> Author: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Date:   Thu Jul 30 13:58:38 2020 +0800
>
>     mm/memcg: remove useless check on page->mem_cgroup
>
>     Since readahead page will be charged on memcg too. We don't need to
>     check this exception now.
>
>     Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index af96217f2ec5..0c7f6bed199b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1336,12 +1336,6 @@ struct lruvec *mem_cgroup_page_lruvec(struct page =
*page, struct pglist_data *pgd
>
>         VM_BUG_ON_PAGE(PageTail(page), page);
>         memcg =3D READ_ONCE(page->mem_cgroup);
> -       /*
> -        * Swapcache readahead pages are added to the LRU - and
> -        * possibly migrated - before they are charged.
> -        */
> -       if (!memcg)
> -               memcg =3D root_mem_cgroup;
>
>         mz =3D mem_cgroup_page_nodeinfo(memcg, page);
>         lruvec =3D &mz->lruvec;
> @@ -6962,10 +6956,7 @@ void mem_cgroup_migrate(struct page *oldpage, stru=
ct page *newpage)
>         if (newpage->mem_cgroup)
>                 return;
>
> -       /* Swapcache readahead pages can get replaced before being charge=
d */
>         memcg =3D oldpage->mem_cgroup;
> -       if (!memcg)
> -               return;
>
>         /* Force-charge the new page. The old one will be freed soon */
>         nr_pages =3D thp_nr_pages(newpage);
> @@ -7160,10 +7151,6 @@ void mem_cgroup_swapout(struct page *page, swp_ent=
ry_t entry)
>
>         memcg =3D page->mem_cgroup;
>
> -       /* Readahead page, never charged */
> -       if (!memcg)
> -               return;
> -
>         /*
>          * In case the memcg owning these pages has been offlined and doe=
sn't
>          * have an ID allocated to it anymore, charge the closest online
>
