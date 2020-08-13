From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: Drop locked from isolate_migratepages_block
Date: Thu, 13 Aug 2020 07:26:42 -0700
Message-ID: <CAKgT0UfO0j9yQCiQD+QDpNPCGncfH-+yP+qmEYGA_Fz=jmqAUQ@mail.gmail.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040224.13054.96724.stgit@localhost.localdomain> <4403f572-03c3-3061-6fc4-f56e3b6d7b67@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GxNk6clU3GutwGWPMQKKGMAHcko+Fcxjva5mT8vHA9w=;
        b=EnrKUUmlZEVpPRj/draNaTL+xj7fm12tnG8YBCxdMfhuuvKGGYpBM58nXaMgwUYS0H
         ++sLe6PMR37iRjVJ9YGOAQJhCBN6fLW9aPvhTTug1Fih0dDBe26GPD0QdmwaT6BtFe4a
         IR2hoWGPr1QfdsTD25jx+hdDhzKDyoGGwBKR6MnET80E6XiqZvOlhSw8Qt3OsCNYdNXw
         UocKsYWZgRJNkRil0H4DBNH8LJosbla/DxOWE8WHdpNNYpHBnAPOlsr4ynWDRMp70cgj
         qeHsS3xjFfClcd77lQGvsREAVwdnK1hgfIQ69ar2Qj0466wbosmB6wWo8Q50unI+H5XT
         rt/w==
In-Reply-To: <4403f572-03c3-3061-6fc4-f56e3b6d7b67@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>, kbuild test robot <lkp@intel.com>, Rong Chen <rong.a.chen@intel.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, "Kirill A. Shutemov" <kirill@shutemov.name>, Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Wei Yang <richard.weiyang@gmail.com>, Mel Gorman <mgorman@techsingularity.net>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Thu, Aug 13, 2020 at 12:45 AM Alex Shi <alex.shi@linux.alibaba.com> wrot=
e:
>
>
>
> =E5=9C=A8 2020/8/13 =E4=B8=8B=E5=8D=8812:02, Alexander Duyck =E5=86=99=E9=
=81=93:
> > -             rcu_read_lock();
> > -             lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> > -
> >               /* If we already hold the lock, we can skip some rechecki=
ng */
> > -             if (lruvec !=3D locked) {
> > -                     if (locked)
> > -                             unlock_page_lruvec_irqrestore(locked, fla=
gs);
> > +             if (!lruvec || !lruvec_holds_page_lru_lock(page, lruvec))=
 {
>
> Ops, lruvec_holds_page_lru_lock need rcu_read_lock.

How so? The reason I wrote lruvec_holds_page_lru_lock the way I did is
that it is simply comparing the pointers held by the page and the
lruvec. It is never actually accessing any of the values, just the
pointers. As such we should be able to compare the two since the
lruvec is still locked and the the memcg and pgdat held by the lruvec
should not be changed. Likewise with the page pointers assuming the
values match.

> > +                     if (lruvec)
> > +                             unlock_page_lruvec_irqrestore(lruvec, fla=
gs);
> >
> > +                     lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> >                       compact_lock_irqsave(&lruvec->lru_lock, &flags, c=
c);
> > -                     locked =3D lruvec;
> >                       rcu_read_unlock();
> >
>
> and some bugs:
> [  534.564741] CPU: 23 PID: 545 Comm: kcompactd1 Kdump: loaded Tainted: G=
 S      W         5.8.0-next-20200803-00028-g9a7ff2cd6e5c #85
> [  534.577320] Hardware name: Alibaba Alibaba Cloud ECS/Alibaba Cloud ECS=
, BIOS 1.0.PL.IP.P.027.02 05/29/2020
> [  534.587693] Call Trace:
> [  534.590522]  dump_stack+0x96/0xd0
> [  534.594231]  ___might_sleep.cold.90+0xff/0x115
> [  534.599102]  kcompactd+0x24b/0x370
> [  534.602904]  ? finish_wait+0x80/0x80
> [  534.606897]  ? kcompactd_do_work+0x3d0/0x3d0
> [  534.611566]  kthread+0x14e/0x170
> [  534.615182]  ? kthread_park+0x80/0x80
> [  534.619252]  ret_from_fork+0x1f/0x30
> [  535.629483] BUG: sleeping function called from invalid context at incl=
ude/linux/freezer.h:57
> [  535.638691] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 545=
, name: kcompactd1
> [  535.647601] INFO: lockdep is turned off.

Ah, I see the bug now. It isn't the lruvec_holds_page_lru_lock that
needs the LRU lock. This is an issue as a part of a merge conflict.
There should have been an rcu_read_lock added before
mem_cgroup_page_lruvec.
