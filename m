From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/7] memcg: remove pre_destroy()
Date: Tue, 17 Apr 2012 10:47:13 -0700
Message-ID: <CALWz4iwBSuFJaARiNdKWWoF6Xc5S3CHG4CgBXDqc6CyK3Pzc7Q@mail.gmail.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
	<4F86BCCE.5050802@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=R0f20NRGDLfHiVL+HBFnHJz35to2veDSumafn7UjGPU=;
        b=kkC0d+j4nKE+cGWSTgB8YJQJFT+aoTxVti6rzW0q7mmjaV3feR9zHtCI8DI94Irypu
         zMmcoh9g6bAdArSlUrS62T4lGEzHiu3cxHnD3gupUYxvdOF3SHm4CRuWhxaVhOj166em
         r8vvcgDpCByMaLRMj8Q7C9YnsXMbkOxB1aZ0wca5d7LbVWKFfyFNHXYLMmwQoeKtqpwS
         R0OwFbz/bicn7lRN5awcZ+cuPJEMiAgEwMgOIzoEH5t/5XeESrdmQHXHnMY1XBMLERXX
         XNTgru0MRsFpA/yJQtEqY2EUaBGr6ITEHRQiybBsGpjG2FUCd6jLEoNWfIEoN57baJ2u
         A5fA==
In-Reply-To: <4F86BCCE.5050802-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Apr 12, 2012 at 4:30 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> Tejun Heo, cgroup maintainer, tries to remove ->pre_destroy() to
> prevent rmdir() from failure of EBUSY or some.
>
> This patch removes pre_destroy() in memcg. All remaining charges
> will be moved to other cgroup, without any failure, =A0->destroy()
> just schedule a work and it will destroy the memcg.
> Then, rmdir will never fail. The kernel will take care of remaining
> resources in the cgroup to be accounted correctly.
>
> After this patch, memcg will be destroyed by workqueue in asynchrnous=
 way.

Is it necessary to change the destroy asynchronously?

=46rankly, i don't that that much. It will leave the system in a
deterministic state on admin perspective. The current synchronous
destroy works fine, and admin can rely on that w/ charging change
after the destroy returns.

--Ying

> Then, we can modify 'moving' logic to work asynchrnously, i.e,
> we don't force users to wait for the end of rmdir(), now. We don't
> need to use heavy synchronous calls. This patch modifies logics as
>
> =A0- Use mem_cgroup_drain_stock_async rather tan drain_stock_sync.
> =A0- lru_add_drain_all() will be called only when necessary, in a laz=
y way.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
> =A0mm/memcontrol.c | =A0 52 ++++++++++++++++++++++-------------------=
-----------
> =A01 files changed, 22 insertions(+), 30 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22c8faa..e466809 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -315,6 +315,8 @@ struct mem_cgroup {
> =A0#ifdef CONFIG_INET
> =A0 =A0 =A0 =A0struct tcp_memcontrol tcp_mem;
> =A0#endif
> +
> + =A0 =A0 =A0 struct work_struct work_destroy;
> =A0};
>
> =A0/* Stuffs for move charges at task migration. */
> @@ -2105,7 +2107,6 @@ static void drain_all_stock_async(struct mem_cg=
roup *root_memcg)
> =A0 =A0 =A0 =A0mutex_unlock(&percpu_charge_mutex);
> =A0}
>
> -/* This is a synchronous drain interface. */
> =A0static void drain_all_stock_sync(struct mem_cgroup *root_memcg)
> =A0{
> =A0 =A0 =A0 =A0/* called when force_empty is called */
> @@ -3661,10 +3662,9 @@ static int mem_cgroup_recharge_lru(struct mem_=
cgroup *memcg,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pc =3D lookup_page_cgroup(page);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D mem_cgroup_move_parent(page, p=
c, memcg, GFP_KERNEL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D -EINTR)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D -EBUSY || ret =3D=3D -EI=
NVAL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 VM_BUG_ON(ret !=3D 0 && ret !=3D -EBUSY=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* found lock contenti=
on or "pc" is obsolete. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0busy =3D page;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cond_resched();
> @@ -3677,22 +3677,19 @@ static int mem_cgroup_recharge_lru(struct mem=
_cgroup *memcg,
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> -
> -static int mem_cgroup_recharge(struct mem_cgroup *memcg)
> +/*
> + * This function is called after ->destroy(). So, we cannot access c=
group
> + * of this memcg.
> + */
> +static void mem_cgroup_recharge(struct work_struct *work)
> =A0{
> + =A0 =A0 =A0 struct mem_cgroup *memcg;
> =A0 =A0 =A0 =A0int ret, node, zid;
> - =A0 =A0 =A0 struct cgroup *cgrp =3D memcg->css.cgroup;
>
> + =A0 =A0 =A0 memcg =3D container_of(work, struct mem_cgroup, work_de=
stroy);
> + =A0 =A0 =A0 /* No task points this memcg. call this only once */
> + =A0 =A0 =A0 drain_all_stock_async(memcg);
> =A0 =A0 =A0 =A0do {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EBUSY;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cgroup_task_count(cgrp) || !list_em=
pty(&cgrp->children))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINTR;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (signal_pending(current))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is for making all *used* pages =
to be on LRU. */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_add_drain_all();
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 drain_all_stock_sync(memcg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mem_cgroup_start_move(memcg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for_each_node_state(node, N_HIGH_MEMOR=
Y) {
> @@ -3710,13 +3707,14 @@ static int mem_cgroup_recharge(struct mem_cgr=
oup *memcg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mem_cgroup_end_move(memcg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cond_resched();
> - =A0 =A0 =A0 /* "ret" should also be checked to ensure all lists are=
 empty. */
> - =A0 =A0 =A0 } while (memcg->res.usage > 0 || ret);
> -out:
> - =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* drain LRU only when we canoot find p=
ages on LRU */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (res_counter_read_u64(&memcg->res, R=
ES_USAGE) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !mem_cgroup_nr_lru_pages(memcg,=
 LRU_ALL))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_add_drain_all();
> + =A0 =A0 =A0 } while (res_counter_read_u64(&memcg->res, RES_USAGE) |=
| ret);
> + =A0 =A0 =A0 mem_cgroup_put(memcg);
> =A0}
>
> -
> =A0/*
> =A0* make mem_cgroup's charge to be 0 if there is no task. This is on=
ly called
> =A0* by memory.force_empty file, an user request.
> @@ -4803,6 +4801,7 @@ static void vfree_work(struct work_struct *work=
)
> =A0 =A0 =A0 =A0memcg =3D container_of(work, struct mem_cgroup, work_f=
reeing);
> =A0 =A0 =A0 =A0vfree(memcg);
> =A0}
> +
> =A0static void vfree_rcu(struct rcu_head *rcu_head)
> =A0{
> =A0 =A0 =A0 =A0struct mem_cgroup *memcg;
> @@ -4982,20 +4981,14 @@ free_out:
> =A0 =A0 =A0 =A0return ERR_PTR(error);
> =A0}
>
> -static int mem_cgroup_pre_destroy(struct cgroup *cont)
> -{
> - =A0 =A0 =A0 struct mem_cgroup *memcg =3D mem_cgroup_from_cont(cont)=
;
> -
> - =A0 =A0 =A0 return mem_cgroup_recharge(memcg);
> -}
> -
> =A0static void mem_cgroup_destroy(struct cgroup *cont)
> =A0{
> =A0 =A0 =A0 =A0struct mem_cgroup *memcg =3D mem_cgroup_from_cont(cont=
);
>
> =A0 =A0 =A0 =A0kmem_cgroup_destroy(cont);
>
> - =A0 =A0 =A0 mem_cgroup_put(memcg);
> + =A0 =A0 =A0 INIT_WORK(&memcg->work_destroy, mem_cgroup_recharge);
> + =A0 =A0 =A0 schedule_work(&memcg->work_destroy);
> =A0}
>
> =A0static int mem_cgroup_populate(struct cgroup_subsys *ss,
> @@ -5589,7 +5582,6 @@ struct cgroup_subsys mem_cgroup_subsys =3D {
> =A0 =A0 =A0 =A0.name =3D "memory",
> =A0 =A0 =A0 =A0.subsys_id =3D mem_cgroup_subsys_id,
> =A0 =A0 =A0 =A0.create =3D mem_cgroup_create,
> - =A0 =A0 =A0 .pre_destroy =3D mem_cgroup_pre_destroy,
> =A0 =A0 =A0 =A0.destroy =3D mem_cgroup_destroy,
> =A0 =A0 =A0 =A0.populate =3D mem_cgroup_populate,
> =A0 =A0 =A0 =A0.can_attach =3D mem_cgroup_can_attach,
> --
> 1.7.4.1
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org =A0For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthem=
eter.ca/
> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
