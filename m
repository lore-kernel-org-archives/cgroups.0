From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/5] mm: Split release_pages work into 3 passes
Date: Thu, 20 Aug 2020 07:13:30 -0700
Message-ID: <CAKgT0UdmKpn3x_=F4E-u+mCf75hu4Bu0O0dyds4mHq93G6wJVA@mail.gmail.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042730.23414.41309.stgit@localhost.localdomain> <15edf807-ce03-83f7-407d-5929341b2b4e@linux.alibaba.com>
 <CAKgT0UepdfjXn=j8e4xEBFmsNJdzJyN57em8dscr-Er4OBZCOg@mail.gmail.com> <a88eef1b-242d-78c6-fecb-35ea00cd739b@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7KUqD0NVyRg3Zo03GZrFVQegwrcexF2aJREuag4UjIs=;
        b=TCJZNgYlFkolAtKYDIaSQN1FZqYOp0XkIPkHM5WH42LWR6/yUHnPUjst8eHDeJmbVI
         j5LsQXv6294iLVbd3J87FiCydVMOuBJ0fa9oex0OUM92w/tFyJmNbRU8b1a1MM1c5uyN
         785YJ3lAM9LVM2OjK3bnrI51rakDkVrQRnhg68McF4HsFIfOb7naUtnS8WgGlVCen2uL
         DQ6HuaO1AY/+oE+9Y09w9SJnDdZjAfNT0twocg+yXtnzrQxMVmNyS9CdKBKqTpezXNHM
         gAvy5RnVll4PadjCJ/Vi3pdvgimSd0fUCj+odJhmONiUJCgifJsi+1UkihKXhBJ/4T/1
         IKaA==
In-Reply-To: <a88eef1b-242d-78c6-fecb-35ea00cd739b-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Thu, Aug 20, 2020 at 2:51 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/8/19 =E4=B8=8B=E5=8D=8810:57, Alexander Duyck =E5=86=99=E9=
=81=93:
> >>>       lruvec =3D relock_page_lruvec_irqsave(page, lruvec, &flags);
> >> the lock bounce is better with the patch, would you like to do further
> >> like using add_lruvecs to reduce bounce more?
> >>
> >> Thanks
> >> Alex
> > I'm not sure how much doing something like that would add. In my case
> > I had a very specific issue that this is addressing which is the fact
> > that every compound page was taking the LRU lock and zone lock
> > separately. With this patch that is reduced to one LRU lock per 15
> > pages and then the zone lock per page. By adding or sorting pages by
> > lruvec I am not sure there will be much benefit as I am not certain
> > how often we will end up with pages being interleaved between multiple
> > lruvecs. In addition as I am limiting the quantity to a pagevec which
> > limits the pages to 15 I am not sure there will be much benefit to be
> > seen for sorting the pages beforehand.
> >
>
> the relock will unlock and get another lock again, the cost in that, the =
2nd
> lock need to wait for fairness for concurrency lruvec locking.
> If we can do sort before, we should remove the fairness waiting here. Of =
course,
> perf result depends on scenarios.

Agreed. The question is in how many scenarios are you going to have
pages interleaved between more than one lruvec? I suspect in most
cases you should only have one lruvec for all the pages being
processed in a single pagevec.
