From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Wed, 15 Nov 2017 13:34:12 +0100
Message-ID: <20171115123412.erspvvuqkeuioftt@dhcp22.suse.cz>
References: <20171114172429.8916-1-guro@fb.com>
 <20171115083504.nwczf5xq6posy3bw@dhcp22.suse.cz>
 <20171115111803.GA28352@castle>
 <20171115114223.ykyfrnxvvzhiglfd@dhcp22.suse.cz>
 <20171115122306.GA16468@castle>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171115122306.GA16468@castle>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 15-11-17 12:23:14, Roman Gushchin wrote:
> On Wed, Nov 15, 2017 at 12:42:23PM +0100, Michal Hocko wrote:
> > On Wed 15-11-17 11:18:13, Roman Gushchin wrote:
> > > On Wed, Nov 15, 2017 at 09:35:04AM +0100, Michal Hocko wrote:
> > [...]
> > > > So my primary question is, why don't you simply allow hugetlb controller
> > > > rather than tweak stats for memcg? Is there any fundamental reason why
> > > > hugetlb controller is not v2 compatible?
> > > 
> > > I really don't know if the hugetlb controller has enough users to deserve
> > > full support in v2 interface: adding knobs like memory.hugetlb.current,
> > > memory.hugetlb.min, memory.hugetlb.high, memory.hugetlb.max, etc.
> > > 
> > > I'd be rather conservative here and avoid adding a lot to the interface
> > > without clear demand. Also, hugetlb pages are really special, and it's
> > > at least not obvious how, say, memory.high should work for it.
> > 
> > But you clearly want the hugetlb accoutning and that is what hugetlb
> > controller is for. You might not be interested in the limit enforcement
> > but that is not strictly required. So my question remains. Why don't we
> > reuse an existing infrastructure and add a new which might confuse users
> > in an extreme case?
> 
> Hm, but to use a small part of hugetlb controller infrastructure I would
> have to add a whole set of cgroup v2 controls.

And? I mean how does that differ from somebody using memcg only for stat
purposes?

> And control knobs (like memory.hugetlb.current) are much more obligatory
> than an entry in memory.stat, where we have some internal stats as well.
> 
> So, I don't really know why confusion should come from in this case?

Because you stat data that is not controlled by the controller. Just
imagine if somebody wanted to sum counters to get the resulting
accounted and enforced memory.

You are simply trying to push a square through circle without a good
reason. Unless there is a fundamental reason to not enable hugetlb
controller to v2 I would rather go that way rather than to have another
hugetlb weirdness. Enabling the controller should be a matter of
exporting knobs. Trivial thing AFAICS.
-- 
Michal Hocko
SUSE Labs
