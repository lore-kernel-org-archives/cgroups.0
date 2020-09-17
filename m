From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Thu, 17 Sep 2020 12:48:12 -0400
Message-ID: <20200917164812.y6bstuo6zvxklcjc@ca-dmjordan1.us.oracle.com>
References: <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
 <alpine.LSU.2.11.2009091524260.10087@eggly.anvils>
 <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com>
 <alpine.LSU.2.11.2009111634020.22739@eggly.anvils>
 <5cfc6142-752d-26e6-0108-38d13009268b@linux.alibaba.com>
 <alpine.LSU.2.11.2009150112130.1550@eggly.anvils>
 <20200915165807.kpp7uhiw7l3loofu@ca-dmjordan1.us.oracle.com>
 <c3362c0a-3707-3a3d-9955-960d95f3ad8c@linux.alibaba.com>
 <20200917143519.lhdfnoc47qrmbhaz@ca-dmjordan1.us.oracle.com>
 <CAKgT0Ud8sYidvxtyrN3AFLs+-DiW7cuPGrKknaRicQsC8PLRtg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=IbwTUuS7WDD96m5NCI9svM+4U/lOcHyrB4uP9uxzxr8=;
 b=GGE9vmsGoRqBb0l8dT/2oKizlmK1s/LXNokj3OyhnXeKCCgUxCSt/DKaTmIL+b60WOHJ
 TFl6JP4IqBWWyHkHzkNk33pJkoBO8o/lWuYxk8Vk7sV2iGmCj+0dKqKfthcLGLzSgv/C
 CDLU4rXyDplrzeoZwGkLtV6crE5BpX55fepx6NDcq/SBc/UKxYlu6SoTrI02I2HvOsCG
 UwQucFJ4w/7hO4NUg7bWKj2pcoUE+7RHwKetgC2NV4U9YqFx7HlQwg5SGIz7+NYi9S1Z
 wvPLxyBZ6gr/Vqa0nn921uvtENU8uZZ8vxtLxh4sa/n7XKir6DIoDN4YPqx7nVeN9cuf mQ== 
Content-Disposition: inline
In-Reply-To: <CAKgT0Ud8sYidvxtyrN3AFLs+-DiW7cuPGrKknaRicQsC8PLRtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sh

On Thu, Sep 17, 2020 at 08:39:34AM -0700, Alexander Duyck wrote:
> On Thu, Sep 17, 2020 at 7:26 AM Daniel Jordan
> <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, Sep 17, 2020 at 10:37:45AM +0800, Alex Shi wrote:
> > > 在 2020/9/16 上午12:58, Daniel Jordan 写道:
> > > > On Tue, Sep 15, 2020 at 01:21:56AM -0700, Hugh Dickins wrote:
> > > >> On Sun, 13 Sep 2020, Alex Shi wrote:
> > > >>> Uh, I updated the testing with some new results here:
> > > >>> https://lkml.org/lkml/2020/8/26/212
> > > >> Right, I missed that, that's better, thanks.  Any other test results?
> > > > Alex, you were doing some will-it-scale runs earlier.  Are you planning to do
> > > > more of those?  Otherwise I can add them in.
> > >
> > > Hi Daniel,
> > >
> > > Does compaction perf scalable, like thpscale, I except they could get some benefit.
> >
> > Yep, I plan to stress compaction.  Reclaim as well.
> >
> > I should have said which Alex I meant.  I was asking Alex Duyck since he'd done
> > some will-it-scale runs.
> 
> I probably won't be able to do any will-it-scale runs any time soon.
> If I recall I ran them for this latest v18 patch set and didn't see
> any regressions like I did with the previous set. However the system I
> was using is tied up for other purposes and it may be awhile before I
> can free it up to look into this again.

Ok, sure.  I hadn't seen the regressions were taken case of, that's good to
hear.  Might still add them to my testing for v19 and beyond, we'll see.
