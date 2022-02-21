From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/5] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Mon, 21 Feb 2022 15:27:19 +0100
Message-ID: <YhOhRzAqC4PxsSx6@dhcp22.suse.cz>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645453640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7qlynhI6VNEu44qmvL7ARJ1jvjijtZcw+Rs2WqC7BU=;
        b=cQs2PZLCJnE2+44odjuVX/QVbqM5A9SJqHn/bj8zvDOHajtiXL1KUsXpytN/TTFMh1UVSW
        QAzf9biM8mwylRViQrjJqU6EIstjeY2LSDu6uFMLtTt6/F9lhgR2Q7ARQgISSsCc4EUvlt
        Ms4d/g60ij+I1u4EPbKqUX2FwA2z7y8=
Content-Disposition: inline
In-Reply-To: <20220217094802.3644569-3-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu 17-02-22 10:47:59, Sebastian Andrzej Siewior wrote:
> During the integration of PREEMPT_RT support, the code flow around
> memcg_check_events() resulted in `twisted code'. Moving the code around
> and avoiding then would then lead to an additional local-irq-save
> section within memcg_check_events(). While looking better, it adds a
> local-irq-save section to code flow which is usually within an
> local-irq-off block on non-PREEMPT_RT configurations.
>=20
> The threshold event handler is a deprecated memcg v1 feature. Instead of
> trying to get it to work under PREEMPT_RT just disable it. There should
> be no users on PREEMPT_RT. From that perspective it makes even less
> sense to get it to work under PREEMPT_RT while having zero users.
>=20
> Make memory.soft_limit_in_bytes and cgroup.event_control return
> -EOPNOTSUPP on PREEMPT_RT. Make an empty memcg_check_events() and
> memcg_write_event_control() which return only -EOPNOTSUPP on PREEMPT_RT.
> Document that the two knobs are disabled on PREEMPT_RT.
>=20
> Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.or=
g>
> Suggested-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@=
public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Thanks!

> ---
>  Documentation/admin-guide/cgroup-v1/memory.rst |  2 ++
>  mm/memcontrol.c                                | 14 ++++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentati=
on/admin-guide/cgroup-v1/memory.rst
> index faac50149a222..2cc502a75ef64 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -64,6 +64,7 @@ Brief summary of control files.
>  				     threads
>   cgroup.procs			     show list of processes
>   cgroup.event_control		     an interface for event_fd()
> +				     This knob is not available on CONFIG_PREEMPT_RT systems.
>   memory.usage_in_bytes		     show current usage for memory
>  				     (See 5.5 for details)
>   memory.memsw.usage_in_bytes	     show current usage for memory+Swap
> @@ -75,6 +76,7 @@ Brief summary of control files.
>   memory.max_usage_in_bytes	     show max memory usage recorded
>   memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
>   memory.soft_limit_in_bytes	     set/show soft limit of memory usage
> +				     This knob is not available on CONFIG_PREEMPT_RT systems.
>   memory.stat			     show various statistics
>   memory.use_hierarchy		     set/show hierarchical account enabled
>                                       This knob is deprecated and shouldn=
't be
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8ab2dc75e70ec..0b5117ed2ae08 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -859,6 +859,9 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgr=
oup *memcg,
>   */
>  static void memcg_check_events(struct mem_cgroup *memcg, int nid)
>  {
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		return;
> +
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> @@ -3731,8 +3734,12 @@ static ssize_t mem_cgroup_write(struct kernfs_open=
_file *of,
>  		}
>  		break;
>  	case RES_SOFT_LIMIT:
> -		memcg->soft_limit =3D nr_pages;
> -		ret =3D 0;
> +		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
> +			ret =3D -EOPNOTSUPP;
> +		} else {
> +			memcg->soft_limit =3D nr_pages;
> +			ret =3D 0;
> +		}
>  		break;
>  	}
>  	return ret ?: nbytes;
> @@ -4708,6 +4715,9 @@ static ssize_t memcg_write_event_control(struct ker=
nfs_open_file *of,
>  	char *endp;
>  	int ret;
> =20
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		return -EOPNOTSUPP;
> +
>  	buf =3D strstrip(buf);
> =20
>  	efd =3D simple_strtoul(buf, &endp, 10);
> --=20
> 2.34.1

--=20
Michal Hocko
SUSE Labs
