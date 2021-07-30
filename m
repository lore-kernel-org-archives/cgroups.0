From: Hu Haowen <src.res@email.cn>
Subject: Re: [PATCH] cgroup: Fix typo in comments and documents
Date: Fri, 30 Jul 2021 21:43:39 +0800
Message-ID: <6de09d3e-6e54-60b9-fa23-9ff0e1f68a28@email.cn>
References: <20210730051605.2626-1-caihuoqing@baidu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cn;
        s=dkim; h=To:From:Date; bh=U6j4xCRQTNphDoWVkEQmuY0zFpuU+auTGrnhA
        Ph8wKQ=; b=mgeRrYjSL4QxpqYe+xgUThO/P2GIlC7Axzqi5zbif3I6MN/A4yIKS
        SSM557/l7kM+6ttYO2U+wbXogaLZ/ALmnR0RCu7QwhZz6fi2PtQPbBeRXu7i/PbX
        x4LnrlybMIN+0+8qVHXfOqgyodOl9TYgwqPsGN3Sxf7dx4Kgkao2Os=
In-Reply-To: <20210730051605.2626-1-caihuoqing@baidu.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Cai Huoqing <caihuoqing@baidu.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org


=D4=DA 2021/7/30 =CF=C2=CE=E71:16, Cai Huoqing =D0=B4=B5=C0:
> Fix typo: iff  =3D=3D> if
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>


Reviewed-by: Hu Haowen <src.res@email.cn>


> ---
>  Documentation/admin-guide/cgroup-v1/cgroups.rst           | 2 +-
>  Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst | 4 ++--
>  kernel/cgroup/cgroup-v1.c                                 | 4 ++--
>  kernel/cgroup/cgroup.c                                    | 6 +++---
>  kernel/cgroup/cpuset.c                                    | 4 ++--
>  5 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/cgroups.rst b/Documentat=
ion/admin-guide/cgroup-v1/cgroups.rst
> index b0688011ed06..fa747466e304 100644
> --- a/Documentation/admin-guide/cgroup-v1/cgroups.rst
> +++ b/Documentation/admin-guide/cgroup-v1/cgroups.rst
> @@ -573,7 +573,7 @@ cgroup_for_each_descendant_pre() for details.
>  ``void css_offline(struct cgroup *cgrp);``
>  (cgroup_mutex held by caller)
> =20
> -This is the counterpart of css_online() and called iff css_online()
> +This is the counterpart of css_online() and called if css_online()
>  has succeeded on @cgrp. This signifies the beginning of the end of
>  @cgrp. @cgrp is being removed and the subsystem should start dropping
>  all references it's holding on @cgrp. When all references are dropped,
> diff --git a/Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst b/=
Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst
> index 582d3427de3f..a908c5226bde 100644
> --- a/Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst
> +++ b/Documentation/admin-guide/cgroup-v1/freezer-subsystem.rst
> @@ -56,7 +56,7 @@ expected.
>  The cgroup freezer is hierarchical. Freezing a cgroup freezes all
>  tasks belonging to the cgroup and all its descendant cgroups. Each
>  cgroup has its own state (self-state) and the state inherited from the
> -parent (parent-state). Iff both states are THAWED, the cgroup is
> +parent (parent-state). If both states are THAWED, the cgroup is
>  THAWED.
> =20
>  The following cgroupfs files are created by cgroup freezer.
> @@ -87,7 +87,7 @@ The following cgroupfs files are created by cgroup free=
zer.
>  * freezer.self_freezing: Read only.
> =20
>    Shows the self-state. 0 if the self-state is THAWED; otherwise, 1.
> -  This value is 1 iff the last write to freezer.state was "FROZEN".
> +  This value is 1 if the last write to freezer.state was "FROZEN".
> =20
>  * freezer.parent_freezing: Read only.
> =20
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index de2c432dee20..71d2b46d1968 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -120,7 +120,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct c=
group *from)
>  		goto out_err;
> =20
>  	/*
> -	 * Migrate tasks one-by-one until @from is empty.  This fails iff
> +	 * Migrate tasks one-by-one until @from is empty.  This fails if
>  	 * ->can_attach() fails.
>  	 */
>  	do {
> @@ -215,7 +215,7 @@ static void cgroup_pidlist_destroy_work_fn(struct wor=
k_struct *work)
>  	mutex_lock(&l->owner->pidlist_mutex);
> =20
>  	/*
> -	 * Destroy iff we didn't get queued again.  The state won't change
> +	 * Destroy if we didn't get queued again.  The state won't change
>  	 * as destroy_dwork can only be queued while locked.
>  	 */
>  	if (!delayed_work_pending(dwork)) {
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 3a0161c21b6b..b831554372a2 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -793,7 +793,7 @@ static bool css_set_populated(struct css_set *cset)
>   * One of the css_sets associated with @cgrp is either getting its first
>   * task or losing the last.  Update @cgrp->nr_populated_* accordingly.  =
The
>   * count is propagated towards root so that a given cgroup's
> - * nr_populated_children is zero iff none of its descendants contain any
> + * nr_populated_children is zero if none of its descendants contain any
>   * tasks.
>   *
>   * @cgrp's interface file "cgroup.populated" is zero if both
> @@ -2410,7 +2410,7 @@ struct task_struct *cgroup_taskset_next(struct cgro=
up_taskset *tset,
>   * @mgctx: migration context
>   *
>   * Migrate tasks in @mgctx as setup by migration preparation functions.
> - * This function fails iff one of the ->can_attach callbacks fails and
> + * This function fails if one of the ->can_attach callbacks fails and
>   * guarantees that either all or none of the tasks in @mgctx are migrate=
d.
>   * @mgctx is consumed regardless of success.
>   */
> @@ -4264,7 +4264,7 @@ struct cgroup_subsys_state *css_next_child(struct c=
group_subsys_state *pos,
>  	 * increasing unique serial number and always appended to the
>  	 * sibling list, the next one can be found by walking the parent's
>  	 * children until the first css with higher serial number than
> -	 * @pos's.  While this path can be slower, it happens iff iteration
> +	 * @pos's.  While this path can be slower, it happens if iteration
>  	 * races against release and the race window is very small.
>  	 */
>  	if (!pos) {
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index adb5190c4429..f09fc0347550 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -782,7 +782,7 @@ static int generate_sched_domains(cpumask_var_t **dom=
ains,
>  		if (cp =3D=3D &top_cpuset)
>  			continue;
>  		/*
> -		 * Continue traversing beyond @cp iff @cp has some CPUs and
> +		 * Continue traversing beyond @cp if @cp has some CPUs and
>  		 * isn't load balancing.  The former is obvious.  The
>  		 * latter: All child cpusets contain a subset of the
>  		 * parent's cpus, so just skip them, and then we call
> @@ -1801,7 +1801,7 @@ static int update_nodemask(struct cpuset *cs, struc=
t cpuset *trialcs,
>  	}
> =20
>  	/*
> -	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
> +	 * An empty mems_allowed is ok if there are no tasks in the cpuset.
>  	 * Since nodelist_parse() fails on an empty mask, we special case
>  	 * that parsing.  The validate_change() call ensures that cpusets
>  	 * with tasks have memory.

