From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cgroup: distinguish the default and legacy hierarchies
 when handling cftypes
Date: Mon, 14 Jul 2014 10:13:27 +0800
Message-ID: <53C33CC7.3020707@huawei.com>
References: <1404345055-8196-1-git-send-email-tj@kernel.org> <1404345055-8196-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404345055-8196-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> @@ -3085,8 +3091,37 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
>  	return ret;
>  }
>  
> +/**
> + * cgroup_add_dfl_cftypes - add an array of cftypes for default hierarchy
> + * @ss: target cgroup subsystem
> + * @cfts: zero-length name terminated array of cftypes
> + *
> + * Similar to cgroup_add_cftypes() but the added files are only used for
> + * the default hierarchy.
> + */
> +int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
> +{
> +	struct cftype *cft;
> +
> +	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
> +		cft->flags |= CFTYPE_ONLY_ON_DFL;

I think we should remove this flag in cgroup_rm_cftypes_locked(). Otherwise
if we call cgroup_add_dlf_cftypes() and then cgroup_rm_cftypes() and then
cgroup_add_legacy_cftypes() for the same @cfts, both CFTYPE_ONLY_ON_DFL and
CFTYPE_INSANE are set.

> +	return cgroup_add_cftypes(ss, cfts);
> +}
> +
> +/**
> + * cgroup_add_legacy_cftypes - add an array of cftypes for legacy hierarchies
> + * @ss: target cgroup subsystem
> + * @cfts: zero-length name terminated array of cftypes
> + *
> + * Similar to cgroup_add_cftypes() but the added files are only used for
> + * the legacy hierarchies.
> + */
>  int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
>  {
> +	struct cftype *cft;
> +
> +	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
> +		cft->flags |= CFTYPE_INSANE;
>  	return cgroup_add_cftypes(ss, cfts);
>  }
