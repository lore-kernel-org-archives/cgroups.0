From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 4/6] cgroup/cpuset: Iterate only if DEADLINE tasks are
 present
Date: Wed, 3 May 2023 13:56:34 -0400
Message-ID: <86854aad-d649-9369-c53d-75446ab8de7b@redhat.com>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230503072228.115707-5-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683136602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsL+UOJbF/TNc0P0DpLZQCkCHaeoLKCd8i3Rcq5uipg=;
        b=QpVwxy1QUX5DIvVIHs/QPD40lbGgR7KVyU5FUk1hCwwKagLgYtKUi+AdZmMb33s2dG7BBF
        +QRTQK5BvcRv2m4AUtJTETlYkvAxgOzQ+zsSCjSfcc5kDgHzmTeNfFz2AIDjo3BMy4eb6y
        zV24isyrmxmylGHlRCEXS1TUvywaXfY=
Content-Language: en-US
In-Reply-To: <20230503072228.115707-5-juri.lelli@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Sudeep Holla <sudeep.holla@arm.com>

On 5/3/23 03:22, Juri Lelli wrote:
> update_tasks_root_domain currently iterates over all tasks even if no
> DEADLINE task is present on the cpuset/root domain for which bandwidth
> accounting is being rebuilt. This has been reported to introduce 10+ ms
> delays on suspend-resume operations.
>
> Skip the costly iteration for cpusets that don't contain DEADLINE tasks.
>
> Reported-by: Qais Yousef <qyousef@layalina.io>
> Link: https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef@layalina.io/
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b9f4d5602517..6587df42cb61 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1090,6 +1090,9 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
>   	struct css_task_iter it;
>   	struct task_struct *task;
>   
> +	if (cs->nr_deadline_tasks == 0)
> +		return;
> +
>   	css_task_iter_start(&cs->css, 0, &it);
>   
>   	while ((task = css_task_iter_next(&it)))
Reviewed-by: Waiman Long <longman@redhat.com>

