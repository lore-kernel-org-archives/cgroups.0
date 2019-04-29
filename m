From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg, oom: no oom-kill for __GFP_RETRY_MAYFAIL
Date: Mon, 29 Apr 2019 10:52:49 -0400
Message-ID: <20190429145249.GN21837@dhcp22.suse.cz>
References: <20190428235613.166330-1-shakeelb@google.com>
 <20190429122214.GK21837@dhcp22.suse.cz>
 <CALvZod6-EOAkcuiuBpoE6uR2DFNUkUY8syHxenFEAZTxhgNMhQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALvZod6-EOAkcuiuBpoE6uR2DFNUkUY8syHxenFEAZTxhgNMhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon 29-04-19 07:37:08, Shakeel Butt wrote:
> On Mon, Apr 29, 2019 at 5:22 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Sun 28-04-19 16:56:13, Shakeel Butt wrote:
> > > The documentation of __GFP_RETRY_MAYFAIL clearly mentioned that the
> > > OOM killer will not be triggered and indeed the page alloc does not
> > > invoke OOM killer for such allocations. However we do trigger memcg
> > > OOM killer for __GFP_RETRY_MAYFAIL. Fix that.
> >
> > An example of __GFP_RETRY_MAYFAIL memcg OOM report would be nice. I
> > thought we haven't been using that flag for memcg allocations yet.
> > But this is definitely good to have addressed.
> 
> Actually I am planning to use it for memcg allocations (specifically
> fsnotify allocations).

OK, then articulate it in the changelog please.

> > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> >
> > Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs
