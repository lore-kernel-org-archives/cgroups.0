From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] Makefiles: Disable unused-variable warning (was: Re:
 [PATCH 1/6] memcg: fix unused variable warning)
Date: Thu, 29 Dec 2011 11:42:30 +0100
Message-ID: <20111229104230.GA20854@tiehlicka.suse.cz>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <20111227135752.GK5344@tiehlicka.suse.cz>
 <20111227182613.GA21840@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111227182613.GA21840-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 27-12-11 20:26:13, Kirill A. Shutemov wrote:
> On Tue, Dec 27, 2011 at 02:57:52PM +0100, Michal Hocko wrote:
> > On Sat 24-12-11 05:00:14, Kirill A. Shutemov wrote:
> > > From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > >=20
> > > mm/memcontrol.c: In function =E2=80=98memcg_check_events=E2=80=99=
:
> > > mm/memcontrol.c:784:22: warning: unused variable =E2=80=98do_numa=
info=E2=80=99 [-Wunused-variable]
> > >=20
> > > Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > > ---
> > >  mm/memcontrol.c |    7 ++++---
> > >  1 files changed, 4 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index d643bd6..a5e92bd 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_c=
group *memcg, struct page *page)
> > >  	/* threshold event is triggered in finer grain than soft limit =
*/
> > >  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> > >  						MEM_CGROUP_TARGET_THRESH))) {
> > > -		bool do_softlimit, do_numainfo;
> > > +		bool do_softlimit;
> > > =20
> > > -		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
> > > -						MEM_CGROUP_TARGET_SOFTLIMIT);
> > >  #if MAX_NUMNODES > 1
> > > +		bool do_numainfo;
> > >  		do_numainfo =3D mem_cgroup_event_ratelimit(memcg,
> > >  						MEM_CGROUP_TARGET_NUMAINFO);
> > >  #endif
> > > +		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
> > > +						MEM_CGROUP_TARGET_SOFTLIMIT);
> >=20
> > I don't like this very much. Maybe we should get rid of both do_* a=
nd
> > do it with flags? But maybe it is not worth the additional code at
> > all...
>=20
> Something like this (untested):
> =3D=3D=3D=3D
> From f57e1a2e1aaaa167c75b963d5bf12fcbdd3331b8 Mon Sep 17 00:00:00 200=
1
> From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Date: Tue, 27 Dec 2011 20:17:13 +0200
> Subject: [PATCH] memcg: cleanup memcg_check_events()
>=20
> Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

The patch looks correct but I am still not sure this is worth fixing in
the code rather than disabling Wunused-variable.

> ---
>  mm/memcontrol.c |   42 ++++++++++++++++++++++++------------------
>  1 files changed, 24 insertions(+), 18 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d643bd6..40c2236 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -108,11 +108,12 @@ enum mem_cgroup_events_index {
>   * than using jiffies etc. to handle periodic memcg event.
>   */
>  enum mem_cgroup_events_target {
> -	MEM_CGROUP_TARGET_THRESH,
> -	MEM_CGROUP_TARGET_SOFTLIMIT,
> -	MEM_CGROUP_TARGET_NUMAINFO,
> -	MEM_CGROUP_NTARGETS,
> +	MEM_CGROUP_TARGET_THRESH	=3D BIT(1),
> +	MEM_CGROUP_TARGET_SOFTLIMIT	=3D BIT(2),
> +	MEM_CGROUP_TARGET_NUMAINFO	=3D BIT(3),
>  };
> +#define MEM_CGROUP_NTARGETS 3
> +
>  #define THRESHOLDS_EVENTS_TARGET (128)
>  #define SOFTLIMIT_EVENTS_TARGET (1024)
>  #define NUMAINFO_EVENTS_TARGET	(1024)
> @@ -743,7 +744,7 @@ static unsigned long mem_cgroup_nr_lru_pages(stru=
ct mem_cgroup *memcg,
>  	return total;
>  }
> =20
> -static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> +static int mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
>  				       enum mem_cgroup_events_target target)
>  {
>  	unsigned long val, next;
> @@ -766,9 +767,9 @@ static bool mem_cgroup_event_ratelimit(struct mem=
_cgroup *memcg,
>  			break;
>  		}
>  		__this_cpu_write(memcg->stat->targets[target], next);
> -		return true;
> +		return target;
>  	}
> -	return false;
> +	return 0;
>  }
> =20
>  /*
> @@ -777,29 +778,34 @@ static bool mem_cgroup_event_ratelimit(struct m=
em_cgroup *memcg,
>   */
>  static void memcg_check_events(struct mem_cgroup *memcg, struct page=
 *page)
>  {
> +	int flags;
> +
>  	preempt_disable();
> -	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +	flags =3D mem_cgroup_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRES=
H);
> =20
> -		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
> +	/*
> +	 * Threshold event is triggered in finer grain than soft limit
> +	 * and numainfo
> +	 */
> +	if (unlikely(flags)) {
> +		flags |=3D mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_SOFTLIMIT);
>  #if MAX_NUMNODES > 1
> -		do_numainfo =3D mem_cgroup_event_ratelimit(memcg,
> +		flags |=3D mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> -		preempt_enable();
> +	}
> +	preempt_enable();
> =20
> +	if (unlikely(flags)) {
>  		mem_cgroup_threshold(memcg);
> -		if (unlikely(do_softlimit))
> +		if (unlikely(flags & MEM_CGROUP_TARGET_SOFTLIMIT))
>  			mem_cgroup_update_tree(memcg, page);
>  #if MAX_NUMNODES > 1
> -		if (unlikely(do_numainfo))
> +		if (unlikely(flags & MEM_CGROUP_TARGET_NUMAINFO))
>  			atomic_inc(&memcg->numainfo_events);
>  #endif
> -	} else
> -		preempt_enable();
> +	}
>  }
> =20
>  struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
> --=20
> 1.7.7.3

--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
