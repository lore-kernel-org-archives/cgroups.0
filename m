From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 4/7] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Wed, 12 Jan 2022 16:21:00 +0100
Message-ID: <Yd7x3P+wGCVfYtza@hirez.programming.kicks-ass.net>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PeT2LoZXZw99I6PIg4z9VVN/0YLATJTsoI1YHe2dcKg=; b=Y2RbGA40kz18bOBofpUu+nLNyz
        71OBT4yUrBNu1aldnyDPbWRDXY2pOatTuDqzuY4Zb3CKxogY/whi+VDJZGw27whuQhrLoJUGPPR/A
        SMl8hhueSWk2N2dLb//FURhbOz+HrZ1jtiqoqdU4KsKaa8pXqdMSX+obvMHs0mbOBvJlwXUo/YbUP
        eFcGHx85qsqO0uFFJMjTcv1kcrKqe2JRut633rMY8gsx7Mlz9eOUtLpk9gIOxV1OF1tGaMqhUOOoc
        AgZvDsOnRLmSZyStd9mX7FYfN0P2CTCkhhC7ye0x6TlZUJHgS3+g1VMF7mVdj7PKrbWGsCBnrw3k0
        ccKB8yXg==;
Content-Disposition: inline
In-Reply-To: <20211205183220.818872-5-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Sun, Dec 05, 2021 at 01:32:17PM -0500, Waiman Long wrote:
> Cpuset v1 uses the sched_load_balance control file to determine if load
> balancing should be enabled.  Cpuset v2 gets rid of sched_load_balance
> as its use may require disabling load balancing at cgroup root.
> 
> For workloads that require very low latency like DPDK, the latency
> jitters caused by periodic load balancing may exceed the desired
> latency limit.
> 
> When cpuset v2 is in use, the only way to avoid this latency cost is to
> use the "isolcpus=" kernel boot option to isolate a set of CPUs. After
> the kernel boot, however, there is no way to add or remove CPUs from
> this isolated set. For workloads that are more dynamic in nature, that
> means users have to provision enough CPUs for the worst case situation
> resulting in excess idle CPUs.
> 
> To address this issue for cpuset v2, a new cpuset.cpus.partition type
> "isolated" is added which allows the creation of a cpuset partition
> without load balancing. This will allow system administrators to
> dynamically adjust the size of isolated partition to the current need
> of the workload without rebooting the system.

you can, ofcourse, create lots of 1 cpu partitions, which is effectively
what you're doing, except there was a problem with that which you also
forgot to mention.


