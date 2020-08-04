From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 21/21] mm/lru: revise the comments of lru_lock
Date: Tue, 4 Aug 2020 07:29:58 -0700
Message-ID: <CAKgT0UckqbmYJDE3L2Bg1Nr=Y=GT0OBx1GEhaZ14EbRTzd8tiw@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-22-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UfpHjBTHvtZz7=WMhZZAunVYuNMpuYBQCiorERb5seFUQ@mail.gmail.com> <f34e790f-50e6-112c-622f-d7ab804c6d22@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DSILtMaPZVkkWKSXWo0XxONGdj0mqua+F4iUMIFu5jo=;
        b=dbt3cGyXK0zGkFNIC+R9pXNutUkFJp04mRi+AlD6bPj6TtJ2sBFrNr9I+9rfQpo6hX
         yHwRsJIC9S0+7cLucGvZPblimft6ur5BNrp0vaHJfrkMUAn00H7skzug6KA7LYH+4fKE
         JJBI5zZkXe8hA7I3uvZ338dmSi4v2qZNctvJM93IjxLHCi8GroNaCxQ2VkZGa9DpOSZM
         WeR6/T8+HnIDg5YEvSDD1xKeLfigme727LtghevcFLf/u+mt1kIC3gkOpQj+EDtyWPOn
         KsukeoiHTZkxannG30Cf8DMv4sKlp2kx6wQlG25ckRZG/PD0ywxC7bPb0TfoiW/k0OU7
         AyIQ==
In-Reply-To: <f34e790f-50e6-112c-622f-d7ab804c6d22-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Aug 4, 2020 at 3:04 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
>
>
> =E5=9C=A8 2020/8/4 =E4=B8=8A=E5=8D=886:37, Alexander Duyck =E5=86=99=E9=
=81=93:
> >>
> >>  shrink_inactive_list() also diverts any unevictable pages that it fin=
ds on the
> >> -inactive lists to the appropriate zone's unevictable list.
> >> +inactive lists to the appropriate node's unevictable list.
> >>
> >>  shrink_inactive_list() should only see SHM_LOCK'd pages that became S=
HM_LOCK'd
> >>  after shrink_active_list() had moved them to the inactive list, or pa=
ges mapped
> > Same here.
>
> lruvec is used per memcg per node actually, and it fallback to node if me=
mcg disabled.
> So the comments are still right.
>
> And most of changes just fix from zone->lru_lock to pgdat->lru_lock chang=
e.

Actually in my mind one thing that might work better would be to
explain what the lruvec is and where it resides. Then replace zone
with lruvec since that is really where the unevictable list resides.
Then it would be correct for both the memcg and pgdat case.

> >
> >> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> >> index 64ede5f150dc..44738cdb5a55 100644
> >> --- a/include/linux/mm_types.h
> >> +++ b/include/linux/mm_types.h
> >> @@ -78,7 +78,7 @@ struct page {
> >>                 struct {        /* Page cache and anonymous pages */
> >>                         /**
> >>                          * @lru: Pageout list, eg. active_list protect=
ed by
> >> -                        * pgdat->lru_lock.  Sometimes used as a gener=
ic list
> >> +                        * lruvec->lru_lock.  Sometimes used as a gene=
ric list
> >>                          * by the page owner.
> >>                          */
> >>                         struct list_head lru;
> >> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >> index 8af956aa13cf..c92289a4e14d 100644
> >> --- a/include/linux/mmzone.h
> >> +++ b/include/linux/mmzone.h
> >> @@ -115,7 +115,7 @@ static inline bool free_area_empty(struct free_are=
a *area, int migratetype)
> >>  struct pglist_data;
> >>
> >>  /*
> >> - * zone->lock and the zone lru_lock are two of the hottest locks in t=
he kernel.
> >> + * zone->lock and the lru_lock are two of the hottest locks in the ke=
rnel.
> >>   * So add a wild amount of padding here to ensure that they fall into=
 separate
> >>   * cachelines.  There are very few zone structures in the machine, so=
 space
> >>   * consumption is not a concern here.
> > So I don't believe you are using ZONE_PADDING in any way to try and
> > protect the LRU lock currently. At least you aren't using it in the
> > lruvec. As such it might make sense to just drop the reference to the
> > lru_lock here. That reminds me that we still need to review the
> > placement of the lru_lock and determine if there might be a better
> > placement and/or padding that might improve performance when under
> > heavy stress.
> >
>
> Right, is it the following looks better?
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ccc76590f823..0ed520954843 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -113,8 +113,7 @@ static inline bool free_area_empty(struct free_area *=
area, int migratetype)
>  struct pglist_data;
>
>  /*
> - * zone->lock and the lru_lock are two of the hottest locks in the kerne=
l.
> - * So add a wild amount of padding here to ensure that they fall into se=
parate
> + * Add a wild amount of padding here to ensure datas fall into separate
>   * cachelines.  There are very few zone structures in the machine, so sp=
ace
>   * consumption is not a concern here.
>   */
>
> Thanks!
> Alex

I would maybe tweak it to make sure it is clear that we are using this
to pad out items that are likely to cause cache thrash such as various
hot spinocks and such.
