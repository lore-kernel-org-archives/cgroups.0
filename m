Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946647;
	b=TLYWE5ehwjamB9TS0x2vtlTiDcPxneB3H1gZ8390PxpKc/bmdhyS6sawDihXemDEm/Ys
	 S03AA3UWK7NXRILpaJSqipqABgziBYGrn3gSFeW9DNVg3DJ9658xFP8hR1ZKq1SYqPKJu
	 hZIuOvW9FoAZotDfOySQjDTpCOgbOy4nMYjtO+rgT4WL7ffMaoSKo1L54UufjTT6Vnp+Y
	 Q5gh16LszTSrJb1Nm83Er32blmf62DaslA2kaAQSB3Uam8NbR1pcA+LgDd27hzqe8prG2
	 Bu8E2VTdFw8kAzZEhfDpmZCbK26suUDwEdgQuGP4ob/eB1O5fIPyMVlmy4IK7it3kfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946647;
	h=DMARC-Filter:DKIM-Signature:References:Mime-Version:User-Agent:
	 Subject:Date:Message-Id:Content-Type:In-Reply-To:
	 Content-Transfer-Encoding:To:Cc:X-Original-From:From:
	 X-Lms-Return-Path;
	bh=mX+GdBvA4yT9OKqPBs6xrJW5OhdpJfdnYKs9cQ6hIug=;
	b=tbopwKOEMjyDMSbZb1ON1e5B+pFlKk50MOKaLX6KyKplAiBsvzU8+EyRZ0dBV41QjPq3
	 o/H1pe2WSDA/bU0jM8kl38nTl2pCEk5YlMGcrm10/nWDVXcPTEhidRLG9z+Qi9nE0ISIY
	 dCo4DF+MxVZsZuAYILhTHokD2LioGtLj0Qg/oAigd4lKVMEzaY7z19gAi1RujyelBsdcn
	 uOVu3zku5rU7I/9QcTNJe2RMKvp0VvKWLROqQa2OfKUPLTFhrmEVuamo31dP0gtO0bQrY
	 tJFVmkAW4ZgIBFO7YqWdHGUTvriNwGRTFxdDjUT7Eh2H9wg2ReMmk+5fmR30FLlWaSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=p4sn5M9G;
	arc=none smtp.remote-ip=209.127.231.115
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E3606A331
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 06:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 258E3606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=p4sn5M9G
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793946641; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=mX+GdBvA4yT9OKqPBs6xrJW5OhdpJfdnYKs9cQ6hIug=;
 b=p4sn5M9GuxhrN8PCzUt033kH7bQaoLzYR9vIZD8nfrGq+NdhxIAl9vXxigrYX9OaCKiU2K
 P2JmxymFPibPEM1J9jUR3hkqH/r5srmO9NDO52RLPHMD7OouLdX03dzFye3yKVgUDj94w9
 7L7WF8b5S/KuOyqCENe7tDYEiOLd+2rjq3c+YOCZaAoBzR/a4PUbidGIHljCQVDcNBHxN+
 jYNE0PfkbKUlLb5M+HDHnrrziNoS10N6sqOD9/XVuuMY6FkaeajZlmh5kGSD4pvEWunGqI
 BP3shM9w/2yubWH48m4xuu/fxNVL+kEwaRNKWEwvOGw2WAEgdXQyDHiigCk5ug==
References: <20261103122816.48037-1-lizhe.67@bytedance.com> <0efbf4db1decd8e6bb6a5fcdcf897314@kernel.org> <03bceb67-d362-47a6-b555-ed5aa1f9bd3e@bytedance.com> <aurTz8SiB-nQ22lJ@gourry-fedora-PF4VCD3F>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
Date: Fri, 6 Nov 2026 14:30:17 +0800
Message-Id: <67fcd8db-269d-43f1-aea2-8c41165747d0@bytedance.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <aurTz8SiB-nQ22lJ@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 7bit
To: "Gregory Price" <gourry@gourry.net>
Cc: "Tejun Heo" <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<ljs@kernel.org>, <liam@infradead.org>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<bpf@vger.kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26aed740f+481b53+vger.kernel.org+lizhe.67@bytedance.com>

On 11/4/26 2:42 PM, Gregory Price wrote:
> On Wed, Nov 04, 2026 at 10:44:46AM +0800, Li Zhe wrote:
>> Does that distinction make the cgroup-scoped override acceptable? If not,
>> could you suggest a better way to support this kind of administrative
>> weight override without adding new mempolicy syscalls?
>>
> I'm a little confused why cgroup-anything is needed here when you could
> just override the weight table / interleave functions.
>
> I don't particularly like the idea of bpf hooks for a single mempolicy
> mode as opposed to something more generally useful - and I question
> how useful task-mempolicies are in general for tiered memory systems
> (they also affect kernel allocation placement, which is not great).
>
> You have many patch proposals recently trying to adjust the mempolicy
> components and I think it might be helpful if we could chat a bit
> about what big problems you're actually trying to solve.
>
> I get that you want better control over task/task-groups, i think that
> can be useful - but I also know that demotion immediately mucks all
> this placement logic up (and we can't check vma / task policies at
> demotion time) so I question how realisitic the value of these
> extensions will be.


Thanks for the feedback.

Our target environment is a class of machines with both DRAM and CXL
memory. On these machines, different services run together in different
cgroups. For us, CXL memory has two main values: it increases the total
memory capacity of the machine, and it lowers the memory cost for
workloads that need a large resident memory footprint. DRAM is the
faster but also more expensive tier, so the practical question becomes:
how much DRAM does each workload really need, and how much of the rest
can be placed on CXL memory?

 From our earlier testing, different workloads have different suitable
DRAM/CXL ratios. By "suitable", I do not mean maintaining a fixed ratio
for its own sake. I mean that, after using some CXL memory, the
workload's important metrics, such as throughput, average latency, tail
latency, or other SLOs, are still within an acceptable range.

So the core problem I am trying to solve is: on a mixed DRAM/CXL memory
machine, each workload in each cgroup should be able to run with its own
suitable DRAM/CXL ratio, so that it can stay near its own
performance/cost balance point.

This is why a single system-wide weighted interleave table is not enough
for our use case. Two co-located services may have completely different
suitable DRAM/CXL ratios. The cgroup is also the more natural management
unit for us, because resource isolation, charging, SLO monitoring, and
userspace control logic are all organized by cgroup, not by individual
task.

I understand that Joshua's approach can solve part of this problem.
However, based on the current discussion, that direction still seems to
need more discussion before it can move forward upstream.

Of course, initial allocation is not the whole story. Demotion and
promotion will change the actual page placement over time, so I do not
expect weighted interleave alone to provide long-term placement control.
For long-term adjustment, using a userspace controller with
memory.reclaim is a more natural and convenient way to adjust placement
over time.

The value of weighted interleave here is in the initial allocation
phase. First, for bandwidth-sensitive workloads, it allows DRAM and CXL
bandwidth to be used together from startup, instead of concentrating
allocations on one tier first and relying on later reclaim or demotion to
reshape the distribution. Second, it gives the container scheduler a
more deterministic view of memory capacity, so the scheduler can place
workloads based on the total memory capacity provided by both DRAM and
CXL, rather than treating only DRAM as the schedulable capacity.

In the long term, we want to maintain the target ratio through a dynamic
control loop. Memory tiering promotes hot pages back to DRAM. A
userspace controller observes each cgroup's per-tier memory footprint
and workload metrics, decides whether the current ratio has deviated
from the target, and then uses memory.reclaim to apply reclaim pressure
to the source tier that should be relieved [1].

The target ratio is not meant to be a strict hard limit. The userspace
controller can adjust the policy based on workload metrics: when cost is
the priority, it can keep more cold memory on CXL; when performance or
SLO pressure becomes high, it can temporarily relax the ratio and allow
the workload to use more DRAM. In other words, I am not trying to make
demotion reinterpret task policy or VMA policy. I am trying to adjust
the actual resident distribution at cgroup granularity through a
userspace feedback loop.

This is also the background for my other patchsets. The memory.reclaim
source selector is intended to give the userspace controller a more
precise actuator [1]. In our testing, this is an important capability for
building the feedback loop.

The sched/numa memory tiering patchset came from issues we found while
testing this model [2]. Its goal is to make tiering promotion behavior
adapt better to different scenarios, and to avoid tiering-only feedback
being misused by the normal AutoNUMA task placement heuristic.

I am not attached to the exact API shape in this RFC. If the
per-cgroup weighted interleave BPF kfuncs are too narrow, or if you
think there is a more general control plane, or a better control
granularity, I am happy to adjust the direction.

[1] 
https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/
[2] 
https://lore.kernel.org/all/20261028041253.74839-1-lizhe.67@bytedance.com/

Thanks,
Zhe

>
> ~Gregory
