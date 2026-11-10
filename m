Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794309855;
	b=UMtyakxAUjtAG2vOfm4th0du80s5LbSNxaWTKqCIqWzIvSVaZiclseZGOA6qB7hxLu+Z
	 QyKrGBX2/NKy5y/tR7ik9WfrxIH0Iyf4w4MDjP4e57M3ykl4w2Iul5pqT2mI0Z8K0dI9O
	 6TtQQkt+regpl0V+ElVgQjVcvcNh7ywcnV/QfJ/GU8fNKUJXftqg41zOIf6MQZuW2SMdI
	 YM8aG9RZV8WT+GDGiNzSFcYMmw/+f8OvkMWOkxKs4RobX8ivb20FP6mhK+tHLtoX2dgfd
	 kzHVmazcDQMov9Jfj1a+uyfgGn+7Q470YieUGGj+twEpLNnJ9hTlEdZvSZMbiLYj8+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794309855;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6gYqU8yoGIqJYTt36NdvX8rGK65lFYTGTFaoagI1k10=;
	b=v1fEv/3ORay5OzfirBcgNQ5wihZ+Y0OHatwwDbtuqQ9MpBYBfqC82Y1vDL1ti+NtShBH
	 YqxvpwCBWNG63om+uZf490sk2zyIWLgTa7IIExX6BIBeYf5mRXq//F23yHMkvRw8DoI/U
	 0Ye0ERa/THS9OEN+IuZZpQEKCl1MrlULh/LNq3kHwAhPJrUfNaKiUS660L0qS0fyJnLW1
	 mKDCFFPUvjgP8xetQIRDgtggmKMlwIbmjsrl3S5U/Bs3AJ3tn5zyXZhW8Ya1iffRKRrY+
	 bqRTkPBQBmAM+M6I2YwIrQ7VOpzlvi4YGstQ9cVLZp8wfy9p9ilfMues8fZwnYoP01Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gAPuD05e;
	arc=none smtp.remote-ip=91.218.175.153
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD3860A2605
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 11:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFD3860A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gAPuD05e
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QEorwODxY7FmS/wK8h8zlNj7pdzBxWuIPtBjJgyQ7ac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309853; v=1; x=1794914653;
 b=gAPuD05e+VTSDf3VxnXFYkby1F6wX639XFDmsmzBgqqyzsQ5OaOQkIrQPp/zV4RtNGi9VYbA
 uaximODf7+LCWEL60zvcgrd3MzLFfwg12l+3Xom20eJWt6zHaQDDqiMP1tqbb3URU58XgzOK6Gf
 dpFeaGLz2WueVRwzfDEttcbs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b38db6903488a640;
	Tue, 10 Nov 2026 11:24:13 +0000
X-Mizu-Trace-ID: b38db6903488a640
X-Migadu-Flow: FLOW_OUT
Message-ID: <cfa85d13-1da7-45ad-9dd8-208e1267000e@linux.dev>
Date: Tue, 10 Nov 2026 19:24:07 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 4/5] cgroup/cpuset: Protect current->mems_allowed
 read in cpuset_fork()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Guopeng Zhang <guopeng.zhang@linux.dev>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261109190955.1398611-1-longman@redhat.com>
 <20261109190955.1398611-5-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261109190955.1398611-5-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2026 3:09 AM, Waiman Long wrote:
> Reading mems_allowed of the current task outside of cpuset_mutex critical
> section should be protected by using mems_allowed_seq seqlock as the
> nodemask can be updated concurrently leading to a torn read. Such
> protection is currently not implemented in cpuset_fork() for the
> !CLONE_INTO_CGROUP case. As a result, the child task may inherit an empty
> or corrupted mems_allowed nodemask. This violates NUMA memory policy
> constraints and causes subsequent page allocations to unconditionally
> fail, potentially leading to crashes or spurious OOM killer invocations
> for the child task.
> 
> Fix that by using a read_mems_allowed_begin/read_mems_allowed_retry()
> loop to protect the mems_allowed read.
> 
> Fixes: 06f4e9489891 ("cpuset: make sure new tasks conform to the current config of the cpuset")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-601100b4-fa77-45fd-99f9-bfbd4385201f
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index e9b84671af21..7aa614c6ac4d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3868,11 +3868,20 @@ static void cpuset_fork(struct task_struct *task)
>   	rcu_read_unlock();
>   
>   	if (cs == oldcs) {
> +		unsigned int seq;
> +
>   		if (cs == &top_cpuset)
>   			return;
>   
>   		set_cpus_allowed_ptr(task, current->cpus_ptr);
> -		task->mems_allowed = current->mems_allowed;
> +		/*
> +		 * A cpuset.mems update can update current->mems_allowed
> +		 * concurrently, so retry it again if it really happens.
> +		 */
> +		do {
> +			seq = read_mems_allowed_begin();
> +			task->mems_allowed = current->mems_allowed;
> +		} while (read_mems_allowed_retry(seq));
>   		return;
>   	}
>   

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong

