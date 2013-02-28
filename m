From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: implement low limits
Date: Thu, 28 Feb 2013 15:30:52 +0100
Message-ID: <20130228143052.GE6573@dhcp22.suse.cz>
References: <8121361952156@webcorp1g.yandex-team.ru>
 <20130227094054.GC16719@dhcp22.suse.cz>
 <38951361977052@webcorp2g.yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <38951361977052-uV6RMHoE7x/0t1ZyImeKKJZIWCK8hONu@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Johannes Weiner-Arquette <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org" <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed 27-02-13 18:57:32, Roman Gushchin wrote:
[...]
> >> =A0+ *
> >> =A0+ */
> >> =A0+unsigned int mem_cgroup_low_limit_scale(struct lruvec *lruvec)
> >> =A0+{
> >> =A0+ struct mem_cgroup_per_zone *mz;
> >> =A0+ struct mem_cgroup *memcg;
> >> =A0+ unsigned long long low_limit;
> >> =A0+ unsigned long long usage;
> >> =A0+ unsigned int i;
> >> =A0+
> >> =A0+ mz =3D container_of(lruvec, struct mem_cgroup_per_zone, lruve=
c);
> >> =A0+ memcg =3D mz->memcg;
> >> =A0+ if (!memcg)
> >> =A0+ return 0;
> >> =A0+
> >> =A0+ low_limit =3D res_counter_read_u64(&memcg->res, RES_LOW_LIMIT=
);
> >> =A0+ if (!low_limit)
> >> =A0+ return 0;
> >> =A0+
> >> =A0+ usage =3D res_counter_read_u64(&memcg->res, RES_USAGE);
> >> =A0+
> >> =A0+ if (usage < low_limit)
> >> =A0+ return DEF_PRIORITY - 2;
> >> =A0+
> >> =A0+ for (i =3D 0; i < DEF_PRIORITY - 2; i++)
> >> =A0+ if (usage - low_limit > (usage >> (i + 3)))
> >> =A0+ break;
> >
> > why this doesn't depend in the current reclaim priority?
>=20
> How do you want to use reclaim priority here?

But then you can get up to 2*DEF_PRIORITY-2 priority (in
get_scan_count) in the end and we are back to my original and more
fundamental objection that the low_limit depends on the group size
because small groups basically do not get scanned when under/close_to
limit while big groups do get scanned and reclaimed.

> I don't like an idea to start ignoring low limit on some priorities.

Well, but you are doing that already. If you are reclaiming for prio 0 =
then
you add up just DEF_PRIORITY-2 which means you reclaim for all groups w=
ith
more than 1024 pages on the LRUs.
[...]
--=20
Michal Hocko
SUSE Labs
