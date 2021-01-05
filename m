From: Qian Cai <qcai-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v21 00/19] per memcg lru lock
Date: Tue, 05 Jan 2021 15:11:06 -0500
Message-ID: <49be27f2652d4658f80c95bea171142c35513761.camel@redhat.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
         <aebcdd933df3abad378aeafc1a07dfe9bbb25548.camel@redhat.com>
         <CALvZod448Ebw7YE-HVCNXNSbtvTcTvQx+_EqcyxTVd_SZ4ATBA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609877477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9lHUJ5BbT3/c3BacIKOhpQG6gVZEznCUigJp41xFTx4=;
        b=DsyJ8EIQt1uNC+OSLfA7GzykRp7sdK/tMW+8Cgd+XT0dI+oQ+Y9HR5+ipx5yvfxHNnrNvA
        W6FUn7Urts89RciD1VN/wMfV09tTQao2G8cfP+sxD7sYTJQFmSCw09WA8wyV7QYPo7S/8a
        9pIoBYruSHhq3eBO6cRi3dlgB3LGtkc=
In-Reply-To: <CALvZod448Ebw7YE-HVCNXNSbtvTcTvQx+_EqcyxTVd_SZ4ATBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel test robot <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev@gmail>

On Tue, 2021-01-05 at 11:42 -0800, Shakeel Butt wrote:
> On Tue, Jan 5, 2021 at 11:30 AM Qian Cai <qcai-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, 2020-11-05 at 16:55 +0800, Alex Shi wrote:
> > > This version rebase on next/master 20201104, with much of Johannes's
> > > Acks and some changes according to Johannes comments. And add a new patch
> > > v21-0006-mm-rmap-stop-store-reordering-issue-on-page-mapp.patch to support
> > > v21-0007.
> > > 
> > > This patchset followed 2 memcg VM_WARN_ON_ONCE_PAGE patches which were
> > > added to -mm tree yesterday.
> > > 
> > > Many thanks for line by line review by Hugh Dickins, Alexander Duyck and
> > > Johannes Weiner.
> > 
> > Given the troublesome history of this patchset, and had been put into linux-
> > next
> > recently, as well as it touched both THP and mlock. Is it a good idea to
> > suspect
> > this patchset introducing some races and a spontaneous crash with some mlock
> > memory presume?
> 
> This has already been merged into the linus tree. Were you able to get
> a similar crash on the latest upstream kernel as well?

No, I seldom test the mainline those days. Before the vacations, I have tested
linux-next up to something like 12/10 which did not include this patchset IIRC
and never saw any crash like this. I am still trying to figure out how to
reproduce it fast, so I can try a revert to confirm.

