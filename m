From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v15 00/12] Enable cpuset controller in default hierarchy
Date: Thu, 8 Nov 2018 16:46:58 +0100
Message-ID: <20181108154658.GY9761@hirez.programming.kicks-ass.net>
References: <1541689726-20088-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/MZukFSpCuBEoizT4c3YKDQ8IZGjR9aSJBXouowbvFw=; b=K11mL6AJsm3afKC8+M6MIP5WZ
        ba5Qf1PXbPmZrNC5EpDox1ovrSTfkwD6lWLFdmLDJ1JCjIvHZ1Bxk0Vj4Vsl9FKG1YhVXLmiX7+t6
        YaCvEDwG6IMkghBmld8l/NdJWAAeZpee9yJrht+CE/HqBl9fbzsdiMJksB+ibIhS25P8LHeA14Fy5
        DfvS22Sdn6Qtazpt9/KP4VWjUDzFVa2jYlKqQTrtOfLYpPtYnjF0GgWyq5DzICJM3aTwfpechuHb+
        x6bUFy214XKuINqMhS+DKeQxZBPnOVTV+Gm/nBkoCqcI42fUAqK6Vk5xySegDekYCWFp7mIGTWVJg
    
Content-Disposition: inline
In-Reply-To: <1541689726-20088-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Thu, Nov 08, 2018 at 10:08:34AM -0500, Waiman Long wrote:
> Waiman Long (12):
>   cpuset: Enable cpuset controller in default hierarchy
>   cpuset: Define data structures to support scheduling partition
>   cpuset: Simply allocation and freeing of cpumasks
>   cpuset: Add new v2 cpuset.sched.partition flag
>   cpuset: Add an error state to cpuset.sched.partition
>   cpuset: Track cpusets that use parent's effective_cpus
>   cpuset: Make CPU hotplug work with partition
>   cpuset: Make generate_sched_domains() work with partition
>   cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
>   cpuset: Use descriptive text when reading/writing
>     cpuset.sched.partition
>   cpuset: Add documentation about the new "cpuset.sched.partition" flag
>   cpuset: Expose cpuset.cpus.subpartitions with cgroup_debug
> 
>  Documentation/admin-guide/cgroup-v2.rst | 182 +++++-
>  include/linux/cgroup-defs.h             |   1 +
>  kernel/cgroup/cgroup-internal.h         |   2 +
>  kernel/cgroup/cgroup.c                  |  14 +-
>  kernel/cgroup/cpuset.c                  | 942 +++++++++++++++++++++++++++++---
>  kernel/cgroup/debug.c                   |   4 +-
>  6 files changed, 1070 insertions(+), 75 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks Waiman!
