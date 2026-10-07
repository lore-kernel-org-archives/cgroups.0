Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A0848A2BF;
	Wed,  7 Oct 2026 12:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374729; cv=none; b=DylZw/KyJvQH3+iBc8N9jwuvPP08tv1Emv90+LlOswQWMN9RMbiqGzjpxkQTyGaHPH495J12ilt3reC17eX7aXCod8tprChb6iQMW89WpJtUK4Ow0q9X5a9s0FWl8lBvGHFCLdnikfxJbyC4wkmsgzvMDntRfKsz0urZBzX/FKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374729; c=relaxed/simple;
	bh=+CqlKRuxWhCNd/6RlB/y7ZkipZeN9V9w02zVNtoOi4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1Mx/76PjNUs3umZwWNpEUOxPCbZl3/2JYXtoDduXjYVsb8m7FdfeFXfQeD4rRaCr/9vZtCUsp40RzaD9LQqXuvvB8YgCj1iyOg0t4QUCPrFgK6N4pixbdrbdEcqxRCXBY5n5hop4sncZwQkGRczWZkfdtIMBMw5d8HE01//D/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CarkZlSX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CarkZlSX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 299F01595;
	Wed,  7 Oct 2026 05:05:16 -0700 (PDT)
Received: from [10.163.146.249] (unknown [10.163.146.249])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A67DB3F763;
	Wed,  7 Oct 2026 05:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791374719; bh=+CqlKRuxWhCNd/6RlB/y7ZkipZeN9V9w02zVNtoOi4g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CarkZlSXkb6HrXh+4mCVYAk3uqLflEL8f25PTNZeVo7p3cdeKq7/VpP1RwHIiOUP3
	 ygdxKcZV2M766tXWr/KeeXozcz0Oc8RWaY7L7jAv5MZV+s5/y56D1mgOd+/O0vdPCL
	 DuuPejMfVgapSFJwfPgVvp6MbrR0bA9IEFdE/e2k=
Message-ID: <d9f31316-38fb-4841-9050-8a9f3a042847@arm.com>
Date: Wed, 7 Oct 2026 17:35:09 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
To: Mike Galbraith <efault@gmx.de>, Chen Yu <yu.c.chen@intel.com>,
 kprateek.nayak@amd.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
 longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, jstultz@google.com, qyousef@layalina.io,
 Ryan Roberts <ryan.roberts@arm.com>, chen.yu@linux.dev
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com> <arQCykkkCnADu5ek@chenyu-dev>
 <128e93ca1424630546e39f9e9c1377f8185f7644.camel@gmx.de>
 <arnbKNWNIIEcQ0a-@chenyu-dev>
 <4d4f5fdee4d1f462ba3490a6b3921006285e7fcc.camel@gmx.de>
Content-Language: en-US
From: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>
In-Reply-To: <4d4f5fdee4d1f462ba3490a6b3921006285e7fcc.camel@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

Thanks for the suggestions. I ran a couple of follow-up tests on the
same AWS Graviton3 (m7g.metal) setup with v7.3-rc4:

1. Disable WA_WEIGHT:
echo NO_WA_WEIGHT > /sys/kernel/debug/sched/features

2. Use the "smp" cgroup mode:
echo smp > /sys/kernel/debug/sched/cgroup_mode

Both tests were run with 20 repeats across 2 boot sessions. Below are
the request latency p99 results for schbench configurations discussed
earlier (usec, smaller is better):

message-thread:16, worker-thread:16
v7.2 = 662869
v7.3-rc4 = 969557
NO_WA_WEIGHT = 958541
smp = 723098

message-thread:64, worker-thread:4
v7.2 = 730453
v7.3-rc4 = 942251
NO_WA_WEIGHT = 740454
smp = 818483

message-thread:32, worker-thread:4
v7.2 = 74251
v7.3-rc4 = 56725
NO_WA_WEIGHT = 59008
smp = 82053

For the m:16 t:16 case that I originally bisected, disabling WA_WEIGHT
does not materially change the regression. Switching to cgroup_mode=smp,
however, recovers most of it.

The m:64 t:4 case behaves differently. Disabling WA_WEIGHT brings the
p99 latency almost back to the v7.2 value, while using smp mode gives
a partial recovery.

There is also an interesting result with m:32 t:4, which was one of the
configurations that improved with v7.3-rc4. That improvement is mostly
preserved with NO_WA_WEIGHT, but disappears with cgroup_mode=smp.

So this does not seem to point to WA_WEIGHT alone as the cause of the
original regression. The results seem consistent with the workload/load-
dependent behavior discussed in this thread, where weight calculation
and resulting placement decisions can help some schbench configurations
while hurting others.

For the original m:16 t:16 regression in particular, the larger recovery
with cgroup_mode=smp also seems consistent with Prateek's observation
that the older weight calculation performs closer to the hierarchical
pick.

Overall, the results suggest that the latency changes are sensitive to
the workload configuration and the weight calculation being used, rather
than being a uniform regression from the single-runqueue change.
It would be interesting to understand whether this variation across
load points is an expected consequence of the new weight calculation,
or whether there is still scope to avoid the larger p99 regressions.

Thanks,
Aishwarya

On 28/09/26 6:30 PM, Mike Galbraith wrote:
> On Mon, 2026-09-28 at 11:12 +0800, Chen Yu wrote:
>> According to my test last week, stacking the waker and wakee on the same CPU brings
>> a big improvement on my machine, iff the memory bandwidth is saturated. By comparison,
>> if the memory bandwidth is low, stacking the wakee on top of the waker causes harm.
> Ditto CPU wise.  The impact of even modest waker/wakee concurrency is
> considerable.  For much of netperf, the post-wakeup tail becomes a CPU
> service latency injection for the wakee when unnecessarily stacked.
> While cache misses sting, those hurt.
>
> As box approaches saturation, stacking of somewhat synchronous stuff
> becomes a better bet.  Aiming for having only waker's tail between
> wakee and CPU has decent chance of being a winner in a box full of
> wider obstacles.
>
> 	-Mike

