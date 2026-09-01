Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7611E28CF4A
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227623; cv=none; b=EQVuWtpXdYZxyWjs0zZyei3hIWqQIO9wi0QuSHbcLye17EuFauwM0CsnW1k1hE5pCom1J51ycf/Cth9y6QzkSgTaRvcDrf02PRZJZuQnQuiKA34kioSGkS+rXcDwhHOz6AKF2NvWXC2b/9fjlW2+8aR/cSRbekrJVyf5Bg5Fyvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227623; c=relaxed/simple;
	bh=Ay1gryBYGG6aqSGyYWuP+er0TtdYtW7WR2F5GMe8wBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=km2C85gzb9GVqr9gODy2UCznqbFMuDQQefabyywg/rMZ8QaduvScvo/S+75PV8CYiJQ7YvXejOqhV29nsm+XRVGzTk5+CScN+z6oSpdYWzaqUfBaNHMv2fjgkng+thR5QXipM8qlKHIogAIWm0Bku/T1rPdDNXaWyb4537llgp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XHfG0enZ; arc=none smtp.client-ip=91.218.175.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XHfG0enZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ay1gryBYGG6aqSGyYWuP+er0TtdYtW7WR2F5GMe8wBA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788227592; v=1; x=1788832392;
 b=XHfG0enZBs2Cx6R8OlvKrHLnEppxUENyCnRTKPAJ0UfKQiss1FcQmiUwANannm6kETm1jqBS
 KA5SbFmRwH/ShKdHLn1OhJfoymbft51weOW9DIxGWTI145fO7uUgHA7vH5Z/V7iuAmw02bKq+mz
 QDq7Xxk9u6hInk54W0v3Fd9E=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 24139c14f82578d9;
	Tue, 01 Sep 2026 01:53:12 +0000
X-Mizu-Trace-ID: 24139c14f82578d9
X-Migadu-Flow: FLOW_OUT
Message-ID: <6322b8b3-fcf2-4052-979d-439f458d31bb@linux.dev>
Date: Tue, 1 Sep 2026 09:53:07 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in
 cgroup1_pidlist_destroy_all
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Junnan Zhang <zhangjn_dev@163.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Junnan Zhang <zhangjn11@chinatelecom.cn>,
 Shouxin Sun <sunshx@chinatelecom.cn>
References: <20260814084016.123741-1-zhangjn_dev@163.com>
 <20260814102052.147408-1-zhangjn_dev@163.com>
 <apU1sXYP_QhsQFcB@localhost.localdomain>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <apU1sXYP_QhsQFcB@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/31/2026 4:16 PM, Michal Koutný wrote:
> Hi Junnan.
> 
> (Sorry for late response, I sketched some notes and then didn't get down
> to sent them. Now they're below.)
> 
> On Fri, Aug 14, 2026 at 06:20:52PM +0800, Junnan Zhang <zhangjn_dev@163.com> wrote:
>> From: Junnan Zhang <zhangjn11@chinatelecom.cn>
>>
>> cgroup1_pidlist_destroy_all() flushes the global
>> cgroup_pidlist_destroy_wq while destroying a cgroup. Because all cgroup
>> v1 pidlist destruction work items are queued on the same shared workqueue,
>> a single slow or stuck work item (e.g. waiting for pidlist_mutex held by a
>> user-space reader) blocks every concurrent cgroup destruction path.
>>
>> This can lead to kworker tasks stuck in flush_workqueue() for over
>> hung_task_timeout seconds, as observed on busy systems running Docker or
>> Kubernetes workloads.
> 
> Since the cgroup_pidlist_destroy_wq is already a dedicated workqueue (no
> other conteders), the pursuit of pidlist_mutex holder is a feasible
> theory. However, that would also mean:
> a) a single reader taking more than hung_task_timeout_secs (that'd be
>     a softlockup earlier),
> b) starvation of cgroup1_pidlist_destroy_all() by many (queued)
>     cgroup_pidlist_start() callers which goes against the second-long
>     caching of pidlists,
> c) there is large number of nr_cgroups * nr_pidnses which makes the
>     caching ineffective
> 
>>
>>    INFO: task kworker/0:1:1438499 blocked for more than 120 seconds.
>>    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>    kworker/0:1 D 0 1438499 2 0x80000080
>>    Workqueue: cgroup_destroy css_free_rwork_fn
>>    ? __schedule+0x296/0x900
>>    schedule+0x28/0x80
>>    schedule_timeout+0x1ee/0x3a0
>>    ? kvm_sched_clock_read+0xd/0x20
>>    wait_for_completion+0x12c/0x190
>>    ? wake_up_q+0x70/0x70
>>    flush_workqueue+0x132/0x430
>>    ? cgroup1_pidlist_destroy_all+0x7c/0xa0
>>    cgroup1_pidlist_destroy_all+0x7c/0xa0
>>    css_free_rwork_fn+0xb5/0x390
>>    process_one_work+0x195/0x3e0
>>    worker_thread+0x30/0x390
>>    ? process_one_work+0x3e0/0x3e0
>>    kthread+0x113/0x130
>>    ? kthread_create_worker_on_cpu+0x70/0x70
>>    ret_from_fork+0x1f/0x40
>>

I'm not sure we've found the real root cause yet, and the current analysis 
doesn't convince me.

Shouldn't we first figure out why flush_workqueue() waited 120s? Was it because 
there were too many pids, or because someone held pidlist_mutex for too long?

>> Fix it by moving the cgroup's pidlists to a local orphan list under
>> pidlist_mutex, clearing their ->owner pointer, and then cancelling each
>> pidlist's delayed work outside the lock. The destroy work function now
>> checks ->owner and skips freeing orphaned pidlists, so
>> cgroup1_pidlist_destroy_all() can free them safely without flushing the
>> whole shared workqueue.
> 
> What's the point of the workqueue after this change? (Mainly the
> expiration + having process context for the handler.)
> 
> The flushing isn't necessary if there's a way how to ensure pidlists
> head won't be used after cgrp removal, which the fix should achieve.
> 
> 
> So I'd say, the narrow-focused cancellation may work, no need to wait
> for other cgroups. OTOH, I'm surprised this v1-issue popped up only now
> and whether such a long contention can happen over pidlist_mutex as your
> commit message implies. What nr_cgroups, nr_pidnses could cause this in
> your theory?
> 
> Thanks,
> Michal

-- 
Best regards
Ridong

