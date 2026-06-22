Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67B0306B0A
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782094878; cv=none; b=r3OsV66TntI/dhQRQZbmmXw6paXbkqO0JWON7F3ATX6tcmHHo7rcCAbSlDoPMdYpE3bvKQKJzw9wVLsRDoeLHQ8xObJurEl6AFCpUvZnxOlmiw9Ri+YUYSpc0EomhIrSLNfAcZ3nWg9dUFZYheU8LbQRkyo9OxJJhSy8ltx7QHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782094878; c=relaxed/simple;
	bh=A3/0Sw1Z52ZTRtQvkjFqCtkIN7M6+nywIl2K9AMEEEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XB0GgDlbsxckme+XPlX69gnUgsFoccVHhJYTLywdCZLRHBfXXh7EjO4wScoMGrYPKK1mbTvepCvr1rM4XoEFZ0HaHsNNYsJLFeLM6kEErr6VXyD9DzS+y84bzc9xLxutLwcfiUQ7toe+GYztwIX7VHTpa5k+BqbtbbE7qvRWEDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A4AdqB2Y; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A4AdqB2Y"
Message-ID: <44da924b-f3a1-4ef8-9113-37d6d11b8c1b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782094874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3mS/YGPKiqUD0hDFr7pjFg45nz2xPIIGigEjGmeXJI0=;
	b=A4AdqB2YhjoN1N1qrLOjqDqtB//BOxCexo3CT5534F1zwmq1MsQbwttRYq0aLz8HtJhvE+
	Zs9oHQXUXLLCeahbQO+f/SGx/Lha9BTMqXYN23kOR8Il0VDeDxxe2Yw2rW3/1cdNX7hRod
	5E4XyxT7Nt2s7IkPJOF+xdveONw0Zmw=
Date: Mon, 22 Jun 2026 10:21:03 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 3/9] cgroup/cpuset: Prevent race between task attach
 and cpuset state change
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Li Zefan <lizefan@huawei.com>,
 Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Aaron Tomlin <atomlin@atomlin.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Gregory Price <gourry@gourry.net>, David Hildenbrand <david@kernel.org>
References: <20260621032816.1806773-1-longman@redhat.com>
 <20260621032816.1806773-4-longman@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260621032816.1806773-4-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 6/21/2026 11:28 AM, Waiman Long wrote:
> Commit e44193d39e8d ("cpuset: let hotplug propagation work wait for
> task attaching") was introduced to let hotplug operation to wait
> until the completion of task attaching operation. However, it is
> still possible that the states of the source or destination cpuset
> can be changed between the cpuset_can_attach() call and the subsequent
> cpuset_attach()/cpuset_cacnel_attach() call.
> 
> As a result, data gathered during cpuset_can_attach() cannot be reliably
> used in the subsequent cpuset_attach()/cpuset_cacnel_attach()
> call at all. Make the task attach operation more robust
> and allow the sharing of data between cpuset_can_attach() and
> cpuset_attach()/cpuset_cacnel_attach() by making cpuset_write_resmask()
> and cpuset_partition_write() wait for the completion of task attach
> and set the attach_in_progress flag in the source cpuset as well.
> 
> The comments about validate_change() are no longer valid as it won't
> be called at all if an attach operation is in progress. So the comments
> can be removed.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 28 ++++++++++++++++++++--------
>   1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index a1c8890d3519..65d095dcada1 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3080,11 +3080,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   	cs->dl_bw_cpu = cpu;
>   
>   out_success:
> -	/*
> -	 * Mark attach is in progress.  This makes validate_change() fail
> -	 * changes which zero cpus/mems_allowed.
> -	 */
>   	cs->attach_in_progress++;
> +	oldcs->attach_in_progress++;
>   

I only see oldcs->attach_in_progress being incremented here — the 
matching decrement seems to land in a later patch. That makes this one 
unbalanced on its own (the count would leak, and a later write to the 
source cpuset would block on the new wait_event()), so it's not bisect-safe.

Let's either keep the patch self-contained or fold it into the patch 
that adds the decrement.

>   out_unlock:
>   	if (ret)
> @@ -3235,10 +3232,19 @@ ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>   		return -EACCES;
>   
>   	buf = strstrip(buf);
> +retry:
> +	wait_event(cpuset_attach_wq, cs->attach_in_progress == 0);
> +
>   	cpuset_full_lock();
>   	if (!is_cpuset_online(cs))
>   		goto out_unlock;
>   
> +	/* Don't race with task attach */
> +	if (cs->attach_in_progress) {
> +		cpuset_full_unlock();
> +		goto retry;
> +	}
> +
>   	trialcs = dup_or_alloc_cpuset(cs);
>   	if (!trialcs) {
>   		retval = -ENOMEM;
> @@ -3366,7 +3372,17 @@ static ssize_t cpuset_partition_write(struct kernfs_open_file *of, char *buf,
>   	else
>   		return -EINVAL;
>   
> +retry:
> +	wait_event(cpuset_attach_wq, cs->attach_in_progress == 0);
> +
>   	cpuset_full_lock();
> +
> +	/* Don't race with task attach */
> +	if (cs->attach_in_progress) {
> +		cpuset_full_unlock();
> +		goto retry;
> +	}
> +
>   	if (is_cpuset_online(cs))
>   		retval = update_prstate(cs, val);
>   	cpuset_update_sd_hk_unlock();
> @@ -3605,10 +3621,6 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
>   	if (ret)
>   		goto out_unlock;
>   
> -	/*
> -	 * Mark attach is in progress.  This makes validate_change() fail
> -	 * changes which zero cpus/mems_allowed.
> -	 */
>   	cs->attach_in_progress++;
>   out_unlock:
>   	mutex_unlock(&cpuset_mutex);

-- 
Best regards
Ridong

