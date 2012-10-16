From: Ni zhan Chen <nizhan.chen@gmail.com>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Tue, 16 Oct 2012 18:20:19 +0800
Message-ID: <507D34E3.3040705@gmail.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=FHn2sbvM+ffOajFzz8SqHWEBVKNsvl1WhsfmYCeowiM=;
        b=fTgN6+TUL1ymi6UgS6IX849xOAJsU2/fS3Qv3W1fBY6XScDBARwU2rlo4mqOGbg4Ss
         yUPwrg+7I7BzIRKFAjjUQaVJxheGJ2BfYRoBz1dcEk7Sx48DbshYEwyfeFObQT7iSNno
         84viS2Ofaq7b24Y6GsssIWMlC6X1w7zUWKW/SQiDK6CZfa+IgNVQZRh6d2yMxt9bNQOO
         Opqt7knCVynK8xh2jmQbNl3rrqE6LzQQATRvi0zkBdvWPO7Sz84SdyhAj6TmkY8wAF16
         J3vyzDwI0qVF37O3X0Jbtq8yS2AkuGCh9G36ZN+xqbQtyZd6eT9v/NcTFLInNhaixzgt
         aDrg==
In-Reply-To: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On 10/16/2012 06:12 PM, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
>
> Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
> task in out-of-memory situations, but it only works on overall system-wide oom.
> But it's also a useful indication in memcg so we take it into consideration
> while oom happening in memcg. Other sysctl such as panic_on_oom has already
> been memcg-ware.

Is it the resend one or new version, could you add changelog if it is 
the last case?

>
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> ---
>   mm/memcontrol.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e4e9b18..c329940 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1486,6 +1486,15 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   
>   	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>   	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> +	if (sysctl_oom_kill_allocating_task && current->mm &&
> +	    !oom_unkillable_task(current, memcg, NULL) &&
> +	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
> +		get_task_struct(current);
> +		oom_kill_process(current, gfp_mask, order, 0, totalpages, memcg, NULL,
> +				 "Memory cgroup out of memory (oom_kill_allocating_task)");
> +		return;
> +	}
> +
>   	for_each_mem_cgroup_tree(iter, memcg) {
>   		struct cgroup *cgroup = iter->css.cgroup;
>   		struct cgroup_iter it;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
