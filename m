From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] memcg: refill_stock for kmem uncharging too
Date: Fri, 19 Apr 2019 20:07:37 +0000
Message-ID: <20190419200733.GB31878@tower.DHCP.thefacebook.com>
References: <20190418214224.61900-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0o7TgRhaW9KvbjPuiOAr7raGQS1pQ+IeI9U51JZC12I=;
 b=iIpvfYpK9uoABdqXowvTj/D0wOnhc0EcJ3DyUmWS98LMH9aIhIcIt4/5/kuDuZi9fVp2
 kUibv00Ti57ANvzqVmxIH1MYozD/N9czODlsHNxrElaEo2p1Its8bnZWpdi6XswFtzzz
 LRgfS5KqX/jTs0IWyirzVEUtkKQHzUGxqOk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0o7TgRhaW9KvbjPuiOAr7raGQS1pQ+IeI9U51JZC12I=;
 b=S+FCj6XiJVCX4l7FPV03wBXHGmcW9ckOipUBxwN1/xiCg8eKLesmGJ6CslQMHElSQk0yPdNlKVH1BL8fDF0T7JpQr9Tp0SuOISCy+c2/vU4t6YPI3sz/EyswpCFAKjSsiwltfrpe0FFDl8vnQofc8tGBWBE4mgJtsJ2Yr5NNWXI=
In-Reply-To: <20190418214224.61900-1-shakeelb@google.com>
Content-Language: en-US
Content-ID: <6E89A0B4BEB6BB42B99AC022945CB334@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Apr 18, 2019 at 02:42:24PM -0700, Shakeel Butt wrote:
> The commit 475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket
> memory uncharging") added refill_stock() for skmem uncharging path to
> optimize workloads having high network traffic. Do the same for the kmem
> uncharging as well. However bypass the refill for offlined memcgs to not
> cause zombie apocalypse.
>=20
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Hello, Shakeel!

> ---
>  mm/memcontrol.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2535e54e7989..7b8de091f572 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -178,6 +178,7 @@ struct mem_cgroup_event {
> =20
>  static void mem_cgroup_threshold(struct mem_cgroup *memcg);
>  static void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
> +static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_page=
s);
> =20
>  /* Stuffs for move charges at task migration. */
>  /*
> @@ -2097,10 +2098,7 @@ static void drain_stock(struct memcg_stock_pcp *st=
ock)
>  	struct mem_cgroup *old =3D stock->cached;
> =20
>  	if (stock->nr_pages) {
> -		page_counter_uncharge(&old->memory, stock->nr_pages);
> -		if (do_memsw_account())
> -			page_counter_uncharge(&old->memsw, stock->nr_pages);
> -		css_put_many(&old->css, stock->nr_pages);
> +		cancel_charge(old, stock->nr_pages);
>  		stock->nr_pages =3D 0;
>  	}
>  	stock->cached =3D NULL;
> @@ -2133,6 +2131,11 @@ static void refill_stock(struct mem_cgroup *memcg,=
 unsigned int nr_pages)
>  	struct memcg_stock_pcp *stock;
>  	unsigned long flags;
> =20
> +	if (unlikely(!mem_cgroup_online(memcg))) {
> +		cancel_charge(memcg, nr_pages);
> +		return;
> +	}

I'm slightly concerned about this part. Do we really need it?
The number of "zombies" which we can pin is limited by the number of CPUs,
and it will drop fast if there is any load on the machine.

If we skip offline memcgs, it can slow down charging/uncharging of skmem,
which might be a problem, if the socket is in active use by an other cgroup=
.
Honestly, I'd drop this part.

> +
>  	local_irq_save(flags);
> =20
>  	stock =3D this_cpu_ptr(&memcg_stock);
> @@ -2768,17 +2771,13 @@ void __memcg_kmem_uncharge(struct page *page, int=
 order)
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		page_counter_uncharge(&memcg->kmem, nr_pages);
> =20
> -	page_counter_uncharge(&memcg->memory, nr_pages);
> -	if (do_memsw_account())
> -		page_counter_uncharge(&memcg->memsw, nr_pages);
> -
>  	page->mem_cgroup =3D NULL;
> =20
>  	/* slab pages do not have PageKmemcg flag set */
>  	if (PageKmemcg(page))
>  		__ClearPageKmemcg(page);
> =20
> -	css_put_many(&memcg->css, nr_pages);
> +	refill_stock(memcg, nr_pages);
>  }
>  #endif /* CONFIG_MEMCG_KMEM */
> =20
> --=20
> 2.21.0.392.gf8f6787159e-goog
>=20

The rest looks good to me.

Thanks!
