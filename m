From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 01 Apr 2022 14:09:25 +0530
Message-ID: <874k3d6vuq.fsf@vajain21.in.ibm.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=G5ux5PrsqjCTdlNQQ3/bauu6+cMr/v2RVE88yklbG+E=;
 b=Qnyfejn1aUQcBYsQhL85YqKJSbN56nBITnvu9+GgL94Qa/kNf4DYzoNNM3W1GMsS/qmi
 VejqjlbGKw+W3HaXb+j8d9eYn7Fj01jAjbnJEZjTirOTsUNbrn+29S4Fv9ftx6smO+Fr
 Ujsm0Tb9gaB6XhsyeKOSU+SOC9rJu1VvbyCENboE4ZUHuOpmQY+2dPcveCREuVb1szdC
 0fIHTSvR9y46SQ5K6Jvhl+FgUYG61lyYCLAgir8Xj3TXV7t3oZp2wGiVcro6TK0dhGEE
 uEhEZI6lcGqbfnFbSLynbzcmOMHECGyNOyHxM1RqsRSYoZWc3EKVBoR4orIWS3sr5rKA bA== 
In-Reply-To: <20220331084151.2600229-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Yosry Ahmed <yosryahmed@google.com>


Yosry Ahmed <yosryahmed@google.com> writes:
> From: Shakeel Butt <shakeelb@google.com>
>
> Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
<snip>

> +
> +	while (nr_reclaimed < nr_to_reclaim) {
> +		unsigned long reclaimed;
> +
> +		if (signal_pending(current))
> +			break;
> +
> +		reclaimed = try_to_free_mem_cgroup_pages(memcg,
> +						nr_to_reclaim - nr_reclaimed,
> +						GFP_KERNEL, true);
> +
> +		if (!reclaimed && !nr_retries--)
> +			break;
> +
> +		nr_reclaimed += reclaimed;

I think there should be a cond_resched() in this loop before
try_to_free_mem_cgroup_pages() to have better chances of reclaim
succeding early.

<snip>

-- 
Cheers
~ Vaibhav
