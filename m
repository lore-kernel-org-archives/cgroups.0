From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] memcg: calling reclaim_high(GFP_KERNEL) in GFP_NOFS
 context deadlocks
Date: Sat, 1 Oct 2022 08:08:34 +1000
Message-ID: <20220930220834.GK3600936@dread.disaster.area>
References: <20220929215440.1967887-1-david@fromorbit.com>
 <20220929222006.GI3600936@dread.disaster.area>
 <YzbesGeUkX3qwqj8@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YzbesGeUkX3qwqj8@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 30, 2022 at 02:18:56PM +0200, Michal Koutn=FD wrote:
> On Fri, Sep 30, 2022 at 08:20:06AM +1000, Dave Chinner <david-FqsqvQoI3Lj=
by3iVrkZq2A@public.gmane.org> wrote:
> > Fixes: b3ff92916af3 ("mm, memcg: reclaim more aggressively before high =
allocator throttling")
>=20
> Perhaps you meant this instead?
>=20
> Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large =
overcharges")

You might be right in that c9afe31ec443 exposed the issue, but it's
not the root cause. I think c9afe31ec443 just a case of a
new caller of mem_cgroup_handle_over_high() stepping on the landmine
left by b3ff92916af3 adding an unconditional GFP_KERNEL direct
reclaim deep in the guts of the memcg code.

IOWs, if b3ff92916af3 did things the right way to begin with, then
c9afe31ec443 would not have caused any problems. So what's the real
root cause of the issue - the commit that stepped on the landmine,
or the commit that placed the landmine?

Either way, if anyone backports b3ff92916af3 or has a kernel with
b3ff92916af3 and not c9afe31ec443, they still need to know
about the landmine in b3ff92916af3....

-Dave.
--=20
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
