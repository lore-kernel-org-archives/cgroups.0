From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v16 18/22] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Sun, 19 Jul 2020 08:14:50 -0700
Message-ID: <CAKgT0UestD7cU+3aqg3a9JT4bTXVYQpjGbwoC2-bOBHPY5xn6A@mail.gmail.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-19-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0Ud+Dj-Q8Sxv8eDQhjM3fFHwnU_ZFEVG54debBennUmxAg@mail.gmail.com>
 <62dfd262-a7ac-d18e-216a-2988c690b256@linux.alibaba.com> <c339f46e-ae04-4e65-2713-a5c8be56051a@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KD0HIaFZq56OVyDZqxH1qgBh9ALce1H+dJs/b8P0iG0=;
        b=D6e1D4mOo+HLSCzvFU92E3OgGKo/Y61GaP1Wsc1D9JDCraHobxyAqr7b2k5RHTNtA8
         SuHImDHowt8DtGQZWdkWX8rZ/2f7WbVDBw7XOomMwhDYKNGBJSankHuY2+RSUJcO0rbe
         F5c7K0OS5FY/DCtJYYKNlzoTY6b3Ud+RIgyArS/8CSzNbN47Sg+JLniSPFJHt8RkFBAC
         Js8uZkZBezaWHjXQ9GPf+Fv/77op2/GgPox6RZBCykSZrYEYPf2mdPcOr0WIuE5euVBT
         BhNObptsociXZSrF6MVSnoMUNWMSBw22lnBh+77SWx7h+dC0ckBsrH3jwnYm8sFf9sGu
         dSpw==
In-Reply-To: <c339f46e-ae04-4e65-2713-a5c8be56051a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sun, Jul 19, 2020 at 2:12 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/7/18 =E4=B8=8B=E5=8D=8810:15, Alex Shi =E5=86=99=E9=81=93:
> >>>
> >>>  struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
> >>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>> index 14c668b7e793..36c1680efd90 100644
> >>> --- a/include/linux/mmzone.h
> >>> +++ b/include/linux/mmzone.h
> >>> @@ -261,6 +261,8 @@ struct lruvec {
> >>>         atomic_long_t                   nonresident_age;
> >>>         /* Refaults at the time of last reclaim cycle */
> >>>         unsigned long                   refaults;
> >>> +       /* per lruvec lru_lock for memcg */
> >>> +       spinlock_t                      lru_lock;
> >>>         /* Various lruvec state flags (enum lruvec_flags) */
> >>>         unsigned long                   flags;
> >> Any reason for placing this here instead of at the end of the
> >> structure? From what I can tell it looks like lruvec is already 128B
> >> long so placing the lock on the end would put it into the next
> >> cacheline which may provide some performance benefit since it is
> >> likely to be bounced quite a bit.
> > Rong Chen(Cced) once reported a performance regression when the lock at
> > the end of struct, and move here could remove it.
> > Although I can't not reproduce. But I trust his report.
> >
> Oops, Rong's report is on another member which is different with current
> struct.
>
> Compare to move to tail, how about to move it to head of struct, which is
> close to lru list? Did you have some data of the place change?

I don't have specific data, just anecdotal evidence from the past that
usually you want to keep locks away from read-mostly items since they
cause obvious cache thrash. My concern was more with the other fields
in the structure such as pgdat since it should be a static value and
having it evicted would likely be more expensive than just leaving the
cacheline as it is.

> > ...
> >
> >>>  putback:
> >>> -               spin_unlock_irq(&zone->zone_pgdat->lru_lock);
> >>>                 pagevec_add(&pvec_putback, pvec->pages[i]);
> >>>                 pvec->pages[i] =3D NULL;
> >>>         }
> >>> -       /* tempary disable irq, will remove later */
> >>> -       local_irq_disable();
> >>>         __mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
> >>> -       local_irq_enable();
> >>> +       if (lruvec)
> >>> +               unlock_page_lruvec_irq(lruvec);
> >> So I am not a fan of this change. You went to all the trouble of
> >> reducing the lock scope just to bring it back out here again. In
> >> addition it implies there is a path where you might try to update the
> >> page state without disabling interrupts.
> > Right. but any idea to avoid this except a extra local_irq_disable?
> >
>
> The following changes would resolve the problem. Is this ok?
> @@ -324,7 +322,8 @@ static void __munlock_pagevec(struct pagevec *pvec, s=
truct zone *zone)
>                 pagevec_add(&pvec_putback, pvec->pages[i]);
>                 pvec->pages[i] =3D NULL;
>         }
> -       __mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
> +       if (delta_munlocked)
> +               __mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
>         if (lruvec)
>                 unlock_page_lruvec_irq(lruvec);

Why not just wrap the entire thing in a check for "lruvec"? Yes you
could theoretically be modding with a value of 0, but it avoids a
secondary unnecessary check and branching.
