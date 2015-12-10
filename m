From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: memcontrol: account "kmem" consumers in cgroup2
 memory controller
Date: Thu, 10 Dec 2015 17:25:48 +0100
Message-ID: <20151210162548.GC11778@dhcp22.suse.cz>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-8-git-send-email-hannes@cmpxchg.org>
 <20151209113037.GS11488@esperanza>
 <20151210132833.GM19496@dhcp22.suse.cz>
 <20151210151627.GB1431@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151210151627.GB1431-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 10-12-15 10:16:27, Johannes Weiner wrote:
> On Thu, Dec 10, 2015 at 02:28:33PM +0100, Michal Hocko wrote:
> > On Wed 09-12-15 14:30:38, Vladimir Davydov wrote:
> > > From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > > Subject: [PATCH] mm: memcontrol: allow to disable kmem accounting for cgroup2
> > > 
> > > Kmem accounting might incur overhead that some users can't put up with.
> > > Besides, the implementation is still considered unstable. So let's
> > > provide a way to disable it for those users who aren't happy with it.
> > 
> > Yes there will be users who do not want to pay an additional overhead
> > and still accoplish what they need.
> > I haven't measured the overhead lately - especially after the opt-out ->
> > opt-in change so it might be much lower than my previous ~5% for kbuild
> > load.
> 
> I think switching from accounting *all* slab allocations to accounting
> a list of, what, less than 20 select slabs, counts as a change
> significant enough to entirely invalidate those measurements and never
> bring up that number again in the context of kmem cost, don't you think?

Yes, as I've said the numbers are expected to be much lower. That is
one of the reasons I have acknowledged kmem enabled as a reasonable
default.  There will always be _special_ loads where numbers might look
differently, though, and having a disabling knob is a reasonable thing
to offer with a minimum maintenance overhead. And this is the argument
for the inclusion of the patch from Vladimir.

-- 
Michal Hocko
SUSE Labs
