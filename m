From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/12] cpuset: update cs->effective_{cpus,mems} when
 config changes
Date: Tue, 15 Oct 2013 11:18:51 -0400
Message-ID: <20131015151851.GK3141@htj.dyndns.org>
References: <5257C9A1.1030404@huawei.com>
 <5257C9CC.3080806@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1K2qION9OimDvsmJ0IYICqU3iHPVKlYLAzjMHWyuyHE=;
        b=M40hmbRy6AVaCa8tgVi6/n3Zo7MbqFtLAOqg2mDr57yd+khLZJFp20ezStyJgty0EU
         qBDFJDH5m8zMETbB321KoO//hONhd1qF6Ab6ZTjm0o/vYMDATsxopgWnrWOjI3epGJQj
         VoBumj1cvxGlJNLviz1LfXKQ63xo/G0eEJgr22YlgAYMTEEC2/O8ASqV/KijvFOn8zjm
         TsfhbUsK0B8JCViVJ7JzujTsR80HJ7Ps2KP4A74On8H6baVm/GjnFfMf3p2t2l8onLal
         cJqK+XzacO7ZHIIwjU5dIzCxIvHvYaHmaU0Pc8dRS6eXoYanfDogU6FyHdXM77+v7z+O
         wFOQ==
Content-Disposition: inline
In-Reply-To: <5257C9CC.3080806-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Oct 11, 2013 at 05:50:04PM +0800, Li Zefan wrote:
> +	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +		struct cpuset *parent = parent_cs(cp);
> +		struct cpumask *new_cpus = trialcs->effective_cpus;
> +
> +		cpumask_and(new_cpus, cp->cpus_allowed,
> +			    parent->effective_cpus);

So, @trial_cs is only passed in to use its ->effective_cpus as
temporary buffer?  If allocating from inside the function isn't an
option, wouldn't it be better to pass in cpumask * instead of the
whole trial_cs and explicitly note that the argument is used as a temp
var?

...
> +	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +		struct cpuset *parent = parent_cs(cp);
> +		nodemask_t *new_mems = &trialcs->effective_mems;
> +
> +		nodes_and(*new_mems, cp->mems_allowed,
> +			  parent->effective_mems);

Ditto.

Thanks.

-- 
tejun
