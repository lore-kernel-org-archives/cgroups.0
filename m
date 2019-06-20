From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] slub: Don't panic for memcg kmem cache creation failure
Date: Thu, 20 Jun 2019 17:35:16 +0200
Message-ID: <20190620153516.GG12083@dhcp22.suse.cz>
References: <20190619232514.58994-1-shakeelb@google.com>
 <20190620055028.GA12083@dhcp22.suse.cz>
 <CALvZod4Fd5X91CzDLaVAvspQL-zoD7+9OGTiOro-hiMda=DqBA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALvZod4Fd5X91CzDLaVAvspQL-zoD7+9OGTiOro-hiMda=DqBA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>

On Thu 20-06-19 07:44:27, Shakeel Butt wrote:
> On Wed, Jun 19, 2019 at 10:50 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Wed 19-06-19 16:25:14, Shakeel Butt wrote:
> > > Currently for CONFIG_SLUB, if a memcg kmem cache creation is failed and
> > > the corresponding root kmem cache has SLAB_PANIC flag, the kernel will
> > > be crashed. This is unnecessary as the kernel can handle the creation
> > > failures of memcg kmem caches.
> >
> > AFAICS it will handle those by simply not accounting those objects
> > right?
> >
> 
> The memcg kmem cache creation is async. The allocation has already
> been decided not to be accounted on creation trigger. If memcg kmem
> cache creation is failed, it will fail silently and the next
> allocation will trigger the creation process again.

Ohh, right I forgot that it will get retried. This would be useful to
mention in the changelog as it is not straightforward from reading just
the particular function.

> > > Additionally CONFIG_SLAB does not
> > > implement this behavior. So, to keep the behavior consistent between
> > > SLAB and SLUB, removing the panic for memcg kmem cache creation
> > > failures. The root kmem cache creation failure for SLAB_PANIC correctly
> > > panics for both SLAB and SLUB.
> >
> > I do agree that panicing is really dubious especially because it opens
> > doors to shut the system down from a restricted environment. So the
> > patch makes sesne to me.
> >
> > I am wondering whether SLAB_PANIC makes sense in general though. Why is
> > it any different from any other essential early allocations? We tend to
> > not care about allocation failures for those on bases that the system
> > must be in a broken state to fail that early already. Do you think it is
> > time to remove SLAB_PANIC altogether?
> >
> 
> That would need some investigation into the history of SLAB_PANIC. I
> will look into it.

Well, I strongly suspect this is a relict from the past. I have hard
time to believe that the system would get to a usable state if many of
those caches would fail to allocate. And as Dave said in his reply it is
quite silly to give this weapon to a random driver hands. Everybody just
thinks his toy is the most important one...

-- 
Michal Hocko
SUSE Labs
