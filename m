From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Fri, 13 Jan 2012 23:44:24 +0100
Message-ID: <20120113224424.GC1653@cmpxchg.org>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
 <1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
 <CALWz4izwNBN_qcSsqg-qYw-Esc9vBL3=4cv3Wsg1jf6001_fWQ@mail.gmail.com>
 <20120112085904.GG24386@cmpxchg.org>
 <CALWz4iz3sQX+pCr19rE3_SwV+pRFhDJ7Lq-uJuYBq6u3mRU3AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALWz4iz3sQX+pCr19rE3_SwV+pRFhDJ7Lq-uJuYBq6u3mRU3AQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 13, 2012 at 01:31:16PM -0800, Ying Han wrote:
> On Thu, Jan 12, 2012 at 12:59 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org=
> wrote:
> > On Wed, Jan 11, 2012 at 01:42:31PM -0800, Ying Han wrote:
> >> On Tue, Jan 10, 2012 at 7:02 AM, Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >> > @@ -1318,6 +1123,36 @@ static unsigned long mem_cgroup_margin(st=
ruct mem_cgroup *memcg)
> >> > =A0 =A0 =A0 =A0return margin >> PAGE_SHIFT;
> >> > =A0}
> >> >
> >> > +/**
> >> > + * mem_cgroup_over_softlimit
> >> > + * @root: hierarchy root
> >> > + * @memcg: child of @root to test
> >> > + *
> >> > + * Returns %true if @memcg exceeds its own soft limit or contri=
butes
> >> > + * to the soft limit excess of one of its parents up to and inc=
luding
> >> > + * @root.
> >> > + */
> >> > +bool mem_cgroup_over_softlimit(struct mem_cgroup *root,
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0str=
uct mem_cgroup *memcg)
> >> > +{
> >> > + =A0 =A0 =A0 if (mem_cgroup_disabled())
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> >> > +
> >> > + =A0 =A0 =A0 if (!root)
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D root_mem_cgroup;
> >> > +
> >> > + =A0 =A0 =A0 for (; memcg; memcg =3D parent_mem_cgroup(memcg)) =
{
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* root_mem_cgroup does not have a=
 soft limit */
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memcg =3D=3D root_mem_cgroup)
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (res_counter_soft_limit_excess(=
&memcg->res))
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memcg =3D=3D root)
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> > + =A0 =A0 =A0 }
> >>
> >> Here it adds pressure on a cgroup if one of its parents exceeds so=
ft
> >> limit, although the cgroup itself is under soft limit. It does cha=
nge
> >> my understanding of soft limit, and might introduce regression of =
our
> >> existing use cases.
> >>
> >> Here is an example:
> >>
> >> Machine capacity 32G and we over-commit by 8G.
> >>
> >> root
> >> =A0 -> A (hard limit 20G, soft limit 15G, usage 16G)
> >> =A0 =A0 =A0 =A0-> A1 (soft limit 5G, usage 4G)
> >> =A0 =A0 =A0 =A0-> A2 (soft limit 10G, usage 12G)
> >> =A0 -> B (hard limit 20G, soft limit 10G, usage 16G)
> >>
> >> under global reclaim, we don't want to add pressure on A1 although=
 its
> >> parent A exceeds its soft limit. Assume that if we set the soft li=
mit
> >> corresponding to each cgroup's working set size (hot memory), and =
it
> >> will introduce regression to A1 in that case.
> >>
> >> In my existing implementation, i am checking the cgroup's soft lim=
it
> >> standalone w/o looking its ancestors.
> >
> > Why do you set the soft limit of A in the first place if you don't
> > want it to be enforced?
>=20
> The soft limit should be enforced under certain condition, not always=
=2E
> The soft limit of A is set to be enforced when the parent of A and B
> is under memory pressure. For example:
>=20
> Machine capacity 32G and we over-commit by 8G
>=20
> root
> -> A (hard limit 20G, soft limit 12G, usage 20G)
> =A0 =A0 =A0 =A0-> A1 (soft limit 2G, usage 1G)
> =A0 =A0 =A0 =A0-> A2 (soft limit 10G, usage 19G)
> -> B (hard limit 20G, soft limit 10G, usage 0G)
>=20
> Now, A is under memory pressure since the total usage is hitting its
> hard limit. Then we start hierarchical reclaim under A, and each
> cgroup under A also takes consideration of soft limit. In this case,
> we should only set priority =3D 0 to A2 since it contributes to A's
> charge as well as exceeding its own soft limit. Why punishing A1 (set
> priority =3D 0) also which has usage under its soft limit ? I can
> imagine it will introduce regression to existing environment which th=
e
> soft limit is set based on the working set size of the cgroup.
>
> To answer the question why we set soft limit to A, it is used to
> over-commit the host while sharing the resource with its sibling (B i=
n
> this case). If the machine is under memory contention, we would like
> to push down memory to A or B depends on their usage and soft limit.

D'oh, I think the problem is just that we walk up the hierarchy one
too many when checking whether a group exceeds a soft limit.  The soft
limit is a signal to distribute pressure that comes from above, it's
meaningless and should indeed be ignored on the level the pressure
originates from.

Say mem_cgroup_over_soft_limit(root, memcg) would check everyone up to
but not including root, wouldn't that do exactly what we both want?

Example:

1. If global memory is short, we reclaim with root=3Droot_mem_cgroup.
   A1 and A2 get soft limit reclaimed because of A's soft limit
   excess, just like the current kernel would do.

2. If A hits its hard limit, we reclaim with root=3DA, so we only mind
   the soft limits of A1 and A2.  A1 is below its soft limit, all
   good.  A2 is above its soft limit, gets treated accordingly.  This
   is new behaviour, the current kernel would just reclaim them
   equally.

Code:

bool mem_cgroup_over_soft_limit(struct mem_cgroup *root,
			        struct mem_cgroup *memcg)
{
	if (mem_cgroup_disabled())
		return false;

	if (!root)
		root =3D root_mem_cgroup;

	for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
		if (memcg =3D=3D root)
			break;
		if (res_counter_soft_limit_excess(&memcg->res))
			return true;
	}
	return false;
}
