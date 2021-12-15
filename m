From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 1/7] cgroup/cpuset: Don't let child cpusets restrict
 parent in default hierarchy
Date: Wed, 15 Dec 2021 12:59:19 -0500
Message-ID: <8d73dc26-74e1-d763-d897-6e03cdac3c8c@redhat.com>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-2-longman@redhat.com>
 <Ybev80+h4JArgMDz@slm.duckdns.org> <20211215122336.GB25459@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639591184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7T9baihxbZOtsdtJTZ7JWcmVJu0+eN6bqcVUWyieaoA=;
        b=dOTUmmac0K6To55+DjDP8R+fSkNFCxkVZOGg2BqGNWmeSTGeFYYBLS+6HjcCWjGF6UZhl7
        VgLN8niVzH/QHwqrPzT6LTt2X1QXa/HnZFsvT1ck/PFSYugwpSL/wPvWzRt8+nKeEGGJXx
        OyC/z+wbzV0sldcRSEodQMRX8hB0ugg=
Content-Language: en-US
In-Reply-To: <20211215122336.GB25459-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 12/15/21 07:23, Michal Koutný wrote:
> On Mon, Dec 13, 2021 at 10:41:23AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> To address this issue, the check is now removed for the default hierarchy
>>> to free parent cpusets from being restricted by child cpusets. The
>>> check will still apply for legacy hierarchy.
> I'm trying to find whether something in update_cpumasks_hier() ensures
> the constraint is checkd on the legacy hierarchy but it seems to me this
> baby was thrown out with the bathwater. How is the legacy check still
> applied?
Yes, you are right. I did remove the check for legacy hierarchy too.
>> Applied to cgroup/for-5.17.
> It comes out a bit more complex if I want to achieve both variants in
> the below followup:
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0dd7d853ed17..8b6e06f504f6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -590,6 +590,35 @@ static inline void free_cpuset(struct cpuset *cs)
>   	kfree(cs);
>   }
>   
> +/*
> + * validate_change_legacy() - Validate conditions specific to legacy (v1)
> + *                            behavior.
> + */
> +static int validate_change_legacy(struct cpuset *cur, struct cpuset *trial)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cpuset *c, *par;
> +	int ret;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +	/* Each of our child cpusets must be a subset of us */
> +	ret = -EBUSY;
> +	cpuset_for_each_child(c, css, cur)
> +		if (!is_cpuset_subset(c, trial))
> +			goto out;
> +
> +	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
> +	ret = -EACCES;
> +	par = parent_cs(cur);
> +	if (par && !is_cpuset_subset(trial, par))
> +		goto out;
> +
> +	ret = 0;
> +out:
> +	return ret;
> +}
> +
>   /*
>    * validate_change() - Used to validate that any proposed cpuset change
>    *		       follows the structural rules for cpusets.
> @@ -614,20 +643,21 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>   {
>   	struct cgroup_subsys_state *css;
>   	struct cpuset *c, *par;
> -	int ret;
> -
> -	/* The checks don't apply to root cpuset */
> -	if (cur == &top_cpuset)
> -		return 0;
> +	int ret = 0;
>   
>   	rcu_read_lock();
> -	par = parent_cs(cur);
>   
> -	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
> -	ret = -EACCES;
> -	if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))

I think you still need to guard it with "!is_in_v2_mode()".

         if (!is_in_v2_mode()) {
                 ret = validate_change_legacy(cur, trial);
                 if (ret)
                         goto out;
         }

> +	ret = validate_change_legacy(cur, trial);
> +	if (ret)
> +		goto out;
> +
> +	/* Remaining checks don't apply to root cpuset */
> +	ret = 0;
> +	if (cur == &top_cpuset)
>   		goto out;
>   
> +	par = parent_cs(cur);
> +
>   	/*
>   	 * If either I or some sibling (!= me) is exclusive, we can't
>   	 * overlap
Cheers,
Longman

