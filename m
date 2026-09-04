Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218CD417BCA;
	Fri,  4 Sep 2026 06:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503854; cv=none; b=aCuC+JjAyxdkSXHa6HJDmMDFq4KcAJh9N2ZQGTVbF49+J8ScaN/bykl0VRQ2uV1ORfvvtOqnFlBYvdQJhKt40O4GT91Rv4rEk8qJVFRVQXOLnVb/ivfc/4WcRfKx6Upki3Q5tzujq2icGjJ6yi7f5FIWuSeE9OG6i3odDFW14Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503854; c=relaxed/simple;
	bh=Lyt4zTkns9ZnJm6rJ92Xc3dxZ6ixSlqnxUSLVKnW5rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jks7wH5pDGAOW1lBYWvRYZ0VeuZHoRRIQZQM53LP8NwwW0unYxZW0qYgojq3d4iprMGnOPd3HuwW4kEI1BrBxllVUhTn5nqX1bG7VW+wkJTdsguMazuVFSaLXgTNq1pLb7hAqTpRyy0jl305PeuoQpJ3YhhEDY0/boCZ8kuRrh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVD8kQi9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVD8kQi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E421F00A3D;
	Fri,  4 Sep 2026 06:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503852;
	bh=YAopYbtE/Hwbe+f9dG8ogCM4RF9pPvDArMRzyY6VlZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EVD8kQi9541B9gB8iwLMxbNn0hTIyrYC7WZYV9fELRIEBDpbP3R16kT7MgaLIyLFB
	 /6QtjpaSLE1ivp2QwGCCLxiqGW3En9gWZ3ibRvqXxFv1yOM6oytc42F1A0aqKxmOY9
	 yndVDpJGN2lYOCudePgn+o/po73UzNn3HD2DRtwTqiIJ0EAVjA9MXi25iFPxDAK8wW
	 ePK/iBziEyzIr8DbguFiUZbzy007KxJZeX6dEX5q4HMKaxbTmY72igvoiw9buc4Ekx
	 pjeShEy2FWSlqBhP1wimBaxi/jf4qdAi/7he+r50Wpl6Ea9VgQAMxknEDoMMZ2LKZA
	 M6CAB3UPp0r5Q==
Date: Thu, 3 Sep 2026 20:37:31 -1000
From: Tejun Heo <tj@kernel.org>
To: Hui Su <sh_def@163.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	John Stultz <jstultz@google.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: Account cgroup CPU time to the execution
 context
Message-ID: <appnKwylGK3QUIJ3@slm.duckdns.org>
References: <20260904034707.268416-1-sh_def@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904034707.268416-1-sh_def@163.com>

On Fri, Sep 04, 2026 at 11:47:07AM +0800, Hui Su wrote:
> Proxy execution separates the scheduling context from the execution
> context. Commit aa4f74dfd42b ("sched: Fix runtime accounting w/ split
> exec & sched contexts") made per-task and thread-group runtime
> accounting follow the task that actually executes, while cgroup CPU
> usage is charged to the donor.
> 
> When the donor and execution task belong to different cgroups, this
> makes a task's execution time count against a different cgroup from the
> one the task belongs to.
> 
> Cgroup CPU usage should follow the execution context, matching the
> per-task, thread-group, and cgroup user/system accounting. Keep
> scheduling state associated with the donor, but charge cgroup CPU
> usage to rq->curr.
> 
> A reproducer with the donor and execution task in separate cgroups
> showed the execution task accumulating runtime while cgroup CPU usage
> was charged to the donor's cgroup. With this change, the execution
> task's cgroup accumulates the CPU usage instead. The same behavior was
> verified with an RT donor and with legacy cpuacct accounting.
> 
> Fixes: aa4f74dfd42b ("sched: Fix runtime accounting w/ split exec & sched contexts")
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hui Su <sh_def@163.com>

Provided John is okay with going this way:

Acked-by: Tejun Heo <tj@kernel.org>

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8dff37059faf..6fcf67d741e8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1404,7 +1404,6 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
>  
>  	se->exec_start = now;
>  	if (entity_is_task(se)) {
> -		struct task_struct *donor = task_of(se);
>  		struct task_struct *running = rq->curr;
>  		/*
>  		 * If se is a task, we account the time against the running
> @@ -1417,8 +1416,7 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
>  		account_group_exec_runtime(running, delta_exec);
>  		account_mm_sched(rq, running, delta_exec);
>  
> -		/* cgroup time is always accounted against the donor */
> -		cgroup_account_cputime(donor, delta_exec);
> +		cgroup_account_cputime(running, delta_exec);

The diff looks so much better.

Thanks.

-- 
tejun
