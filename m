From: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] cgroup: Stop task iteration when rebinding subsystem
Date: Fri, 2 Jun 2023 16:15:39 +0800
Message-ID: <92671ed7-ca4f-48e4-f29d-a42860f93d89@huaweicloud.com>
References: <20230526114139.70274-1-xiujianfeng@huaweicloud.com>
 <ojymhf4m3p52py6sezwbc2zamxm46wmhxs577uucima6evj2sc@djoi3dhzbdf6>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <ojymhf4m3p52py6sezwbc2zamxm46wmhxs577uucima6evj2sc@djoi3dhzbdf6>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi Michal,

On 2023/6/2 1:33, Michal Koutn=C3=BD wrote:
> Hello Jianfeng.
>=20
> On Fri, May 26, 2023 at 07:41:39PM +0800, Xiu Jianfeng <xiujianfeng-XF6Jl=
duFytWkHkcT6e4Xnw@public.gmane.org> wrote:
>> The race that cause this bug can be shown as below:
>>
>> (hotplug cpu)                | (umount cpuset)
>> mutex_lock(&cpuset_mutex)    | mutex_lock(&cgroup_mutex)
>> cpuset_hotplug_workfn        |
>>  rebuild_root_domains        |  rebind_subsystems
>>   update_tasks_root_domain   |   spin_lock_irq(&css_set_lock)
>>    css_task_iter_start       |    list_move_tail(&cset->e_cset_node[ss->=
id]
>>    while(css_task_iter_next) |                  &dcgrp->e_csets[ss->id]);
>>    css_task_iter_end         |   spin_unlock_irq(&css_set_lock)
>> mutex_unlock(&cpuset_mutex)  | mutex_unlock(&cgroup_mutex)
>=20
> Good catch!
>=20
>>
>> Inside css_task_iter_start/next/end, css_set_lock is hold and then
>> released, so when iterating task(left side), the css_set may be moved to
>> another list(right side), then it->cset_head points to the old list head
>> and it->cset_pos->next points to the head node of new list, which can't
>> be used as struct css_set.
>=20
> I find your analysis sane -- the stale it->cset_head is problematic.
>=20
>> To fix this issue, introduce CSS_TASK_ITER_STOPPED flag for css_task_ite=
r.
>> when moving css_set to dcgrp->e_csets[ss->id] in rebind_subsystems(), st=
op
>> the task iteration.
>=20
> Does it mean that iteration would not yield all tasks that are
> associated with give cs->css? That sounds like broken correctness of the
> iterator.
>=20
> I may suggest a slightly different approach that should not affect
> running iterators.
> - I had to switch from all css_sets to only scgrp's css_sets since
>   css_set_table order of css_sets may be different than scgrp->e_csets
> - Not sure how portable is using array element as a `member` argument of
>   offsetof (in expansion of list_for_each_entry_safe).
>=20
> This is only to illustrate the idea, i.e. merely compile tested.
>=20
> WDYT?

Yes, I think this approach is better for it doesn't affect the running
iterators, and we have tested it, it can solve this issue, thank you.

So if maintainers agree, I would send a v2.

>=20
> Regards,
> Michal
>=20
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 625d7483951c..e67d2a0776c1 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1798,7 +1798,7 @@ int rebind_subsystems(struct cgroup_root *dst_root,=
 u16 ss_mask)
>  {
>  	struct cgroup *dcgrp =3D &dst_root->cgrp;
>  	struct cgroup_subsys *ss;
> -	int ssid, i, ret;
> +	int ssid, ret;
>  	u16 dfl_disable_ss_mask =3D 0;
> =20
>  	lockdep_assert_held(&cgroup_mutex);
> @@ -1842,7 +1842,8 @@ int rebind_subsystems(struct cgroup_root *dst_root,=
 u16 ss_mask)
>  		struct cgroup_root *src_root =3D ss->root;
>  		struct cgroup *scgrp =3D &src_root->cgrp;
>  		struct cgroup_subsys_state *css =3D cgroup_css(scgrp, ss);
> -		struct css_set *cset;
> +		struct css_set *cset, *cset_pos;
> +		struct css_task_iter *it;
> =20
>  		WARN_ON(!css || cgroup_css(dcgrp, ss));
> =20
> @@ -1860,9 +1861,18 @@ int rebind_subsystems(struct cgroup_root *dst_root=
, u16 ss_mask)
>  		css->cgroup =3D dcgrp;
> =20
>  		spin_lock_irq(&css_set_lock);
> -		hash_for_each(css_set_table, i, cset, hlist)
> +		WARN_ON(!list_empty(&dcgrp->e_csets[ss->id]));
> +		list_for_each_entry_safe(cset, cset_pos, &scgrp->e_csets[ss->id], e_cs=
et_node[ss->id]) {
>  			list_move_tail(&cset->e_cset_node[ss->id],
>  				       &dcgrp->e_csets[ss->id]);
> +			/* all css_sets of scgrp together in same order to dcgrp,
> +			 * patch in-flight iterators to preserve correct iteration,
> +			 * cset_head is under css_set_lock */
> +			list_for_each_entry(it, &cset->task_iters, iters_node) {
> +				if (it->cset_head =3D=3D &scgrp->e_csets[ss->id])
> +					it->cset_head =3D &dcgrp->e_csets[ss->id];
> +			}
> +		}
>  		spin_unlock_irq(&css_set_lock);
> =20
>  		if (ss->css_rstat_flush) {

