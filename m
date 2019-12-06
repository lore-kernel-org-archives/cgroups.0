From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: fix hanging shrinker management on long
 do_shrink_slab
Date: Fri, 6 Dec 2019 11:09:00 +0100
Message-ID: <20191206100900.GM28317@dhcp22.suse.cz>
References: <20191129214541.3110-1-ptikhomirov@virtuozzo.com>
 <4e2d959a-0b0e-30aa-59b4-8e37728e9793@virtuozzo.com>
 <20191206020953.GS2695@dread.disaster.area>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191206020953.GS2695@dread.disaster.area>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, "J. Bruce Fields" <bfields@field>

On Fri 06-12-19 13:09:53, Dave Chinner wrote:
> [please cc me on future shrinker infrastructure modifications]
> 
> On Mon, Dec 02, 2019 at 07:36:03PM +0300, Andrey Ryabinin wrote:
> > 
> > On 11/30/19 12:45 AM, Pavel Tikhomirov wrote:
> > > We have a problem that shrinker_rwsem can be held for a long time for
> > > read in shrink_slab, at the same time any process which is trying to
> > > manage shrinkers hangs.
> > > 
> > > The shrinker_rwsem is taken in shrink_slab while traversing shrinker_list.
> > > It tries to shrink something on nfs (hard) but nfs server is dead at
> > > these moment already and rpc will never succeed. Generally any shrinker
> > > can take significant time to do_shrink_slab, so it's a bad idea to hold
> > > the list lock here.
> 
> registering/unregistering a shrinker is not a performance critical
> task.

We have had a bug report from production system which stumbled over a
long [u]nmount which was stuck on a shrinker {un}register path waiting for
the lock. This wouldn't be a big deal most of the time but [u]mount were
part of the login session in this case. This was on an older
distribution kernel and e496612c5130 ("mm: do not stall register_shrinker()")
helped a bit but not really for shrinkers that take a lot of time.

> If a shrinker is blocking for a long time, then we need to
> work to fix the shrinker implementation because blocking is a much
> bigger problem than just register/unregister.

Absolutely agreed here.
-- 
Michal Hocko
SUSE Labs
