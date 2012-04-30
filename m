From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 2/7 v2] memcg: fix error code in hugetlb_force_memcg_empty()
Date: Mon, 30 Apr 2012 14:19:46 +0530
Message-ID: <87y5pd8uz9.fsf@skywalker.in.ibm.com>
References: <4F9A327A.6050409@jp.fujitsu.com> <4F9A33CB.8040304@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F9A33CB.8040304@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, Han Ying <yinghan@google.com>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> EBUSY should be returned.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/hugetlb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 17ae2e4..4dd6b39 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1922,8 +1922,11 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
>  	int ret = 0, idx = 0;
>
>  	do {
> -		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> +		if (cgroup_task_count(cgroup)
> +			|| !list_empty(&cgroup->children)) {
> +			ret = -EBUSY;
>  			goto out;
> +		}
>  		/*
>  		 * If the task doing the cgroup_rmdir got a signal
>  		 * we don't really need to loop till the hugetlb resource

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
