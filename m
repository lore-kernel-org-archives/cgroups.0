From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/10] memcg: Uncharge all kmem when deleting a cgroup.
Date: Wed, 29 Feb 2012 11:00:23 -0800
Message-ID: <CABCjUKAt0gvnSU9-jbK9QjOWBECgohZ699Tptd6W2ucb8-B8=w@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-3-git-send-email-ssouhlal@FreeBSD.org>
	<20120229152227.aa416668.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=DrdrRL9w1V0t+m9J3/Ggc37ccWJjVp6hMOQFiQKIifc=;
        b=ikcR9Pb0jN1vyfIjHG5RxBpn8TZRA+E0vUS1BCVC6Pi7RBPMXLJUujJ3Grk8aY/OeI
         DChBjWOzm0fp3AIoQcBnFcRLeI//PkjnZOCAwf6pVs9p8PnfiBu/1PHGg2hsI6JBCs9v
         SixXkdCJTSL96hqTRgSFfZodoZctFQzaEkoOXcGPH8crTMHc6EsGBQsN8qQ5Gir4zvck
         3YYHXzzDTpxbbIRuMDKmMBavcMymO3quKu7QDcQAuNQfeqyy7Su+wbH8jD4esNUKhXgs
         MPa1WiUIlTZ6TwR9H9BdXliHOtlMdI/dklPAqDqkaimKyUD9py1PUAdpBz0g9fHKhTcY
         HRlQ==
In-Reply-To: <20120229152227.aa416668.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Feb 28, 2012 at 10:22 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> On Mon, 27 Feb 2012 14:58:45 -0800
> Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org> wrote:
>
>> A later patch will also use this to move the accounting to the root
>> cgroup.
>>
>> Signed-off-by: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0mm/memcontrol.c | =A0 30 +++++++++++++++++++++++++++++-
>> =A01 files changed, 29 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 11e31d6..6f44fcb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -378,6 +378,7 @@ static void mem_cgroup_get(struct mem_cgroup *me=
mcg);
>> =A0static void mem_cgroup_put(struct mem_cgroup *memcg);
>> =A0static void memcg_kmem_init(struct mem_cgroup *memcg,
>> =A0 =A0 =A0struct mem_cgroup *parent);
>> +static void memcg_kmem_move(struct mem_cgroup *memcg);
>>
>> =A0/* Writing them here to avoid exposing memcg's inner layout */
>> =A0#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> @@ -3674,6 +3675,7 @@ static int mem_cgroup_force_empty(struct mem_c=
group *memcg, bool free_all)
>> =A0 =A0 =A0 int ret;
>> =A0 =A0 =A0 int node, zid, shrink;
>> =A0 =A0 =A0 int nr_retries =3D MEM_CGROUP_RECLAIM_RETRIES;
>> + =A0 =A0 unsigned long usage;
>> =A0 =A0 =A0 struct cgroup *cgrp =3D memcg->css.cgroup;
>>
>> =A0 =A0 =A0 css_get(&memcg->css);
>> @@ -3693,6 +3695,8 @@ move_account:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is for making all *used* pages t=
o be on LRU. */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_add_drain_all();
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 drain_all_stock_sync(memcg);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!free_all)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcg_kmem_move(memcg);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_start_move(memcg);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for_each_node_state(node, N_HIGH_MEMORY)=
 {
>> @@ -3714,8 +3718,13 @@ move_account:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D -ENOMEM)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto try_to_free;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cond_resched();
>> + =A0 =A0 =A0 =A0 =A0 =A0 usage =3D memcg->res.usage;
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (free_all && !memcg->independent_kmem_l=
imit)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 usage -=3D memcg->kmem_byt=
es.usage;
>> +#endif
>
> Why we need this even if memcg_kmem_move() does uncharge ?

We need it when manually calling force_empty.

-- Suleiman
