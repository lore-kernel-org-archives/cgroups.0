From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 11/12] cpuset: allow writing offlined masks to
 cpuset.cpus/mems
Date: Tue, 15 Oct 2013 11:36:01 -0400
Message-ID: <20131015153601.GM3141@htj.dyndns.org>
References: <5257C9A1.1030404@huawei.com>
 <5257CA3A.2040705@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M78WKbF/N2iIP9oKRqf3iINGswcQv7m9F25H2+ffTFo=;
        b=rT/QDDGKVhh5YMMVdIU6fxSLZWVNv26K+APibWUOgEuZhJeu1jgAhuGOv2OBzHjMuS
         Qit778fLeHwUQzi3Z0Mw/4mXfH37gLy9VB+w57N0Xv5BMqbVijtfyjnsf3pdgzmSQ1+3
         rkqyYPsoU98XQ2sadcslkm8uyKsS6QX7xt0IG/WR1Cknq47cMuOo/juAHl4cRXUYcFpL
         yVB28C4uXswgnRo4nLWRSLAPqQW/GAaBgfXSX4kIU5YMz2G9/YGS1xqKWaj4bX2Ire6E
         fuwXnZTscsc4CxCv7i/qTUKIY8Q1ZfkrLWIslq7tI5IHz1S/5Gt7bVaduvBrxsu0jvyS
         iDAA==
Content-Disposition: inline
In-Reply-To: <5257CA3A.2040705@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

On Fri, Oct 11, 2013 at 05:51:54PM +0800, Li Zefan wrote:
> As the configured masks won't be limited by its parent, and the top
> cpuset's masks won't change when hotplug happens, it's natural to
> allow writing offlined masks to the configured masks.
> 
> Signed-off-by; Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index e71c04f..a98723d 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -960,7 +960,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  		if (retval < 0)
>  			return retval;
>  
> -		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
> +		if (!cpumask_subset(trialcs->cpus_allowed,
> +				    top_cpuset.cpus_allowed))

Shouldn't this gated by sane_behavior?

>  
> @@ -1238,8 +1239,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
>  			goto done;
>  
>  		if (!nodes_subset(trialcs->mems_allowed,
> -				node_states[N_MEMORY])) {
> -			retval =  -EINVAL;
> +				  top_cpuset.mems_allowed)) {
> +			retval = -EINVAL;

Ditto.

Thanks.

-- 
tejun
