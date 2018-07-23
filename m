From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcg: fix use after free in mem_cgroup_iter()
Date: Mon, 23 Jul 2018 09:17:28 -0700
Message-ID: <CALvZod5UwJp8cM3OcjCDadkjKgAnGHj8XVcgjFk5Thcst02MAQ@mail.gmail.com>
References: <1531994807-25639-1-git-send-email-jing.xia@unisoc.com>
 <20180719104345.GV7193@dhcp22.suse.cz> <CALvZod55Ku7U3soLtuYY_HL2_mMp5+OT-hngdZkPRGN9xm1a9Q@mail.gmail.com>
 <20180723064441.GA17905@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cRCRWxPa5qhRdztjFVMXQMWVdzdRusjpODKHDjNtIpQ=;
        b=oJK9oqyGMmqDX4tysDZpRJLCSEyrPZ1Bz6Wq4maicB36VaC1gB79X4ikJk2NLyLL7Q
         41Trmh+y9QMHe3B77u/zO0Gg4YGOIhiJga1JwVjHBAoYheB4g+3CBaQHz0zDwJK6vlmY
         SmDf6PSTjO/nZlXfkDqS2pngqDy+D9V6k4H/YW72NJEWrcSjy7/P29Q0S/Fgme5PKeBO
         Z1LHPlKrxz9E1BzSLqIZHUJx2MhnvsXdlGo5DvbQnUyYQSiXtuL3ctUn/m2eSXmyWtmF
         j5YKYhl8HUumFxqr7Sv5LetznIqf22hsuBMoTGABKnqR2/ofIZta6P6FIJQ/BuOIUG/O
         DcKw==
In-Reply-To: <20180723064441.GA17905@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: jing.xia.mail@gmail.com, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, chunyan.zhang@unisoc.com, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Jul 22, 2018 at 11:44 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 19-07-18 09:23:10, Shakeel Butt wrote:
> > On Thu, Jul 19, 2018 at 3:43 AM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > [CC Andrew]
> > >
> > > On Thu 19-07-18 18:06:47, Jing Xia wrote:
> > > > It was reported that a kernel crash happened in mem_cgroup_iter(),
> > > > which can be triggered if the legacy cgroup-v1 non-hierarchical
> > > > mode is used.
> > > >
> > > > Unable to handle kernel paging request at virtual address 6b6b6b6b6b6b8f
> > > > ......
> > > > Call trace:
> > > >   mem_cgroup_iter+0x2e0/0x6d4
> > > >   shrink_zone+0x8c/0x324
> > > >   balance_pgdat+0x450/0x640
> > > >   kswapd+0x130/0x4b8
> > > >   kthread+0xe8/0xfc
> > > >   ret_from_fork+0x10/0x20
> > > >
> > > >   mem_cgroup_iter():
> > > >       ......
> > > >       if (css_tryget(css))    <-- crash here
> > > >           break;
> > > >       ......
> > > >
> > > > The crashing reason is that mem_cgroup_iter() uses the memcg object
> > > > whose pointer is stored in iter->position, which has been freed before
> > > > and filled with POISON_FREE(0x6b).
> > > >
> > > > And the root cause of the use-after-free issue is that
> > > > invalidate_reclaim_iterators() fails to reset the value of
> > > > iter->position to NULL when the css of the memcg is released in non-
> > > > hierarchical mode.
> > >
> > > Well, spotted!
> > >
> > > I suspect
> > > Fixes: 6df38689e0e9 ("mm: memcontrol: fix possible memcg leak due to interrupted reclaim")
> > >
> > > but maybe it goes further into past. I also suggest
> > > Cc: stable
> > >
> > > even though the non-hierarchical mode is strongly discouraged.
> >
> > Why not set root_mem_cgroup's use_hierarchy to true by default on
> > init? If someone wants non-hierarchical mode, they can explicitly set
> > it to false.
>
> We do not change defaults under users feet usually.

Then how non-hierarchical mode is being discouraged currently? I don't
see any comments in the docs.

Shakeel
