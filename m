From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 3/5] cpuset: Add a root-only cpus.isolated v2 control
 file
Date: Wed, 2 May 2018 16:08:35 +0200
Message-ID: <20180502140835.GK12180@hirez.programming.kicks-ass.net>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-4-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=C1H3Ob2QKGUSolnCS2yNEqJK5IQKKBmRUzbgjMwvlNw=; b=a/f2hcrpeagigO9lON0xl/Pi4
        wDm8Vxl2wOFDb+3NXq1EwIx1NfPmHxKkwKHf+Tr5EQ9qB0+0H8j3i1BTqB6qSsyrs0eYFgyqHi7Dq
        oy1QtNuhtkk1/lMmwtodf8xPXtF+rpWCdcybYv6rv4ZWJEFuDIJVKzfoReOr/BGeRp1rvhSKGzIQX
        0OQELoMUewIWtkilLd7vQdipjbm6vl+rcDhek1eg5Pf3BGOXJGlQmHsdnznyREDCoRgqMNuhU57Gq
        WD24Ihg3pFwg2vASg9iGvbBAXnBMzRH5b77AtNuOrScUoWugfhJS0dw3JZQOqu3iBWSB0c5BviuP5
    
Content-Disposition: inline
In-Reply-To: <1524145624-23655-4-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Thu, Apr 19, 2018 at 09:47:02AM -0400, Waiman Long wrote:
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index c970bd7..8d89dc2 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1484,6 +1484,31 @@ Cpuset Interface Files
>  	a subset of "cpuset.cpus".  Its value will be affected by CPU
>  	hotplug events.
>  
> +  cpuset.cpus.isolated
> +	A read-write multiple values file which exists on root cgroup
> +	only.
> +
> +	It lists the CPUs that have been withdrawn from the root cgroup
> +	for load balancing.  These CPUs can still be allocated to child
> +	cpusets with load balancing enabled, if necessary.
> +
> +	If a child cpuset contains only an exclusive set of CPUs that are
> +	a subset of the isolated CPUs and with load balancing enabled,
> +	these CPUs will be load balanced on a separate root domain from
> +	the one in the root cgroup.
> +
> +	Just putting the CPUs into "cpuset.cpus.isolated" will be
> +	enough to disable load balancing on those CPUs as long as they
> +	do not appear in a child cpuset with load balancing enabled.
> +	Fine-grained control of cpu isolation can also be done by
> +	putting these isolated CPUs into child cpusets with load
> +	balancing disabled.
> +
> +	The "cpuset.cpus.isolated" should be set up before child
> +	cpusets are created.  Once child cpusets are present, changes
> +	to "cpuset.cpus.isolated" will not be allowed if the CPUs that
> +	change their states are in any of the child cpusets.
> +

So I see why you did this, but it is _really_ ugly and breaks the
container invariant.

Ideally we'd make the root group less special, not more special.
