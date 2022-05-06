From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Fri, 6 May 2022 09:40:15 -0700
Message-ID: <20220506164015.fsdsuv226nhllos5@dev0025.ash9.facebook.com>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
 <20220427140928.GD9823@blackbody.suse.cz>
 <20220429010333.5rt2jwpiumnbuapf@dev0025.ash9.facebook.com>
 <20220429092620.GA23621@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220429092620.GA23621-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>

Sorry for the delayed reply, Michal. I've been at LSFMM this week.

On Fri, Apr 29, 2022 at 11:26:20AM +0200, Michal Koutn=FD wrote:
> I still think that the behavior when there's no protection left for the
> memory.low =3D=3D 0 child, there should be no memory.low events (not just
> uncounted but not happening) and test should not accept this (even
> though it's the current behavior).

That's fair. I think part of the problem here is that in general, the
memcontroller itself is quite heuristic, so it's tough to write tests that
provide useful coverage while also being sufficiently flexible to avoid
flakiness and over-prescribing expected behavior. In this case I think it's
probably correct that the memory.low =3D=3D 0 child shouldn't inherit
protection from its parent under any circumstances due to its siblings
overcommitting the parent's protection, but I also wonder if it's really
necessary to enforce that. If you look at how much memory A/B/E gets at the
end of the reclaim, it's still far less than 1MB (though should it be 0?).
I'd be curious to hear what Johannes thinks.

> What might improve the test space would be to have two configs like
>=20
> Original one (simplified here)
> 	parent		memory.low=3D50M	memory.current=3D100M
> 	` child1	memory.low=3D50M	memory.current=3D50M
> 	` child2	memory.low=3D0M	memory.current=3D50M
>=20
> New one (checks events due to recursive protection)
> 	parent		memory.low=3D50M	memory.current=3D100M
> 	` child1	memory.low=3D40M	memory.current=3D50M
> 	` child2	memory.low=3D0M	memory.current=3D50M
>=20
> The second config assigns recursive protection to child2 and should
> therefore cause memory.low events in child2 (with memory_recursiveprot
> enabled of course).

Something like this would work, though I think it's useful to specifically
validate the behavior of the memcontroller when the children overcommit the
parent's memory.low protection, which the current test does. So I'm
inclined to keep this testcase, and add your next suggestion:

> Or alternative new one (checks events due to recursive protection)
> 	parent		memory.low=3D50M	memory.current=3D100M
> 	` child1	memory.low=3D0M	memory.current=3D50M
> 	` child2	memory.low=3D0M	memory.current=3D50M

This definitely sounds to me like a useful testcase to add, and I'm happy
to do so in a follow-on patch. If we added this, do you think we need to
keep the check for memory.low events for the memory.low =3D=3D 0 child in t=
he
overcommit testcase? It arguably helped to catch the SWAP_CLUSTER_MAX
rounding issue you pointed out. Again, curious to hear what Johannes thinks
as well.

Thanks,
David
