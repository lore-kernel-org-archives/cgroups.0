From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: force charge kmem counter too
Date: Thu, 31 May 2018 08:56:42 +0200
Message-ID: <20180531065642.GI15278@dhcp22.suse.cz>
References: <20180525185501.82098-1-shakeelb@google.com>
 <20180526185144.xvh7ejlyelzvqwdb@esperanza>
 <CALvZod5yTxcuB_Aao-a0ChNEnwyBJk9UPvEQ80s9tZFBQ0cxpw@mail.gmail.com>
 <20180528091110.GG1517@dhcp22.suse.cz>
 <CALvZod6x5iRmcJ6pYKS+jwJd855jnwmVcPK9tnKbuJ9Hfppa-A@mail.gmail.com>
 <20180529083153.GR27180@dhcp22.suse.cz>
 <CALvZod67qzq+hQLms4Wut5LNVBjBcEQPpMp9zxF6NE5k+7CLOw@mail.gmail.com>
 <20180531060133.GA31477@rodete-desktop-imager.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531060133.GA31477@rodete-desktop-imager.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu 31-05-18 15:01:33, Minchan Kim wrote:
> On Wed, May 30, 2018 at 11:14:33AM -0700, Shakeel Butt wrote:
> > On Tue, May 29, 2018 at 1:31 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > > On Mon 28-05-18 10:23:07, Shakeel Butt wrote:
> > >> On Mon, May 28, 2018 at 2:11 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > >> Though is there a precedence where the broken feature is not fixed
> > >> because an alternative is available?
> > >
> > > Well, I can see how breaking GFP_NOFAIL semantic is problematic, on the
> > > other hand we keep saying that kmem accounting in v1 is hard usable and
> > > strongly discourage people from using it. Sure we can add the code which
> > > handles _this_ particular case but that wouldn't make the whole thing
> > > more usable I strongly suspect. Maybe I am wrong and you can provide
> > > some specific examples. Is GFP_NOFAIL that common to matter?
> > >
> > > In any case we should balance between the code maintainability here.
> > > Adding more cruft into the allocator path is not free.
> > >
> > 
> > We do not use kmem limits internally and this is something I found
> > through code inspection. If this patch is increasing the cost of code
> > maintainability I am fine with dropping it but at least there should a
> > comment saying that kmem limits are broken and no need fix.
>  
> I agree.
> 
> Even, I didn't know kmem is strongly discouraged until now. Then,
> why is it enabled by default on cgroup v1?

You have to set a non-zero limit to make it active IIRC. The code is
compiled in because v2 enables it by default.

> Let's turn if off with comment "It's broken so do not use/fix. Instead,
> please move to cgroup v2".

-- 
Michal Hocko
SUSE Labs
