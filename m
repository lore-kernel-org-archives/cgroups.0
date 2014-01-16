From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch -mm] mm, oom: prefer thread group leaders for display
 purposes
Date: Thu, 16 Jan 2014 02:05:49 -0500
Message-ID: <20140116070549.GL6963@cmpxchg.org>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=WwfhWsabBBTF69lMgFnug58siJBNGBITvP+fcgR8RBw=;
	b=B0qHs0zVDXYMBIW447KD8p2jg5zou5KN2Lwgi+5hOeBl+fnskuQB6PJVL4D6evO6/nNeTN1A5qaHWnjwk0cslPhx4EMyc1PBu30bqclEcbw5XyHy5mtX2fOoRH5WEiVd5ya5prcTVVPpztxi8eoigvg2PtERBk7FHnT7Nz4TG+0=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:40:41PM -0800, David Rientjes wrote:
> When two threads have the same badness score, it's preferable to kill the 
> thread group leader so that the actual process name is printed to the 
> kernel log rather than the thread group name which may be shared amongst 
> several processes.
> 
> This was the behavior when select_bad_process() used to do 
> for_each_process(), but it now iterates threads instead and leads to 
> ambiguity.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/memcontrol.c | 18 +++++++++++-------
>  mm/oom_kill.c   | 12 ++++++++----
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a815686..b482f49 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1841,13 +1841,17 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				break;
>  			};
>  			points = oom_badness(task, memcg, NULL, totalpages);
> -			if (points > chosen_points) {
> -				if (chosen)
> -					put_task_struct(chosen);
> -				chosen = task;
> -				chosen_points = points;
> -				get_task_struct(chosen);

Where did that GET go?

> -			}
> +			if (points < chosen_points)
> +				continue;
> +			/* Prefer thread group leaders for display purposes */
> +			if (points == chosen_points &&
> +			    thread_group_leader(chosen))
> +				continue;
> +
> +			if (chosen)
> +				put_task_struct(chosen);

...boom.

> +			chosen = task;
> +			chosen_points = points;
>  		}
>  		css_task_iter_end(&it);
>  	}
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 054ff47..1dca3d8 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -327,10 +327,14 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  			break;
>  		};
>  		points = oom_badness(p, NULL, nodemask, totalpages);
> -		if (points > chosen_points) {
> -			chosen = p;
> -			chosen_points = points;
> -		}
> +		if (points < chosen_points)
> +			continue;
> +		/* Prefer thread group leaders for display purposes */
> +		if (points == chosen_points && thread_group_leader(chosen))
> +			continue;
> +
> +		chosen = p;
> +		chosen_points = points;
>  	}
>  	if (chosen)
>  		get_task_struct(chosen);
