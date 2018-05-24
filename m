From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 2/6] cpuset: Add new v2 cpuset.sched.domain flag
Date: Thu, 24 May 2018 17:41:56 +0200
Message-ID: <20180524154156.GI12198@hirez.programming.kicks-ass.net>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=y/8P9Qhg/+MQWekfFBN/IJQwlqOULEmCausPJgGbFKk=; b=oGDFl9Zv9NNT6hOm4/P8l9IP8
        vw0JuYSEqklJvNYQR+4bihtJBurwKuWKg07PNH7/auhtl/Tk2RTzKLYjHxPzvF9u+E0cUL8HBae96
        7E+pZu5N80Spu/Zxk1zrpXveikU1WKbLimtAeLoFPDtKAYcfgzp5hq/8KlIUBdrj4ARaIXk3J4Rbh
        EIU5RBVm3EAq8pbA27GYx+01lNCkd7Vl65GkT+6nKgQT1CjYhJKx0tTHrk3GNzyVrMmF15m/87PDy
        uaosJOUuXUFqhS4s1dWO3gFx7JKCmG3IU2UrKykDfk2RzLMar3UIu1CgSBe/lUqjho5rdfN59Tr6B
      
Content-Disposition: inline
In-Reply-To: <1526590545-3350-3-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Thu, May 17, 2018 at 04:55:41PM -0400, Waiman Long wrote:
> A new cpuset.sched.domain boolean flag is added to cpuset v2. This new
> flag indicates that the CPUs in the current cpuset should be treated
> as a separate scheduling domain.

The traditional name for this is a partition.

>                                  This new flag is owned by the parent
> and will cause the CPUs in the cpuset to be removed from the effective
> CPUs of its parent.

This is a significant departure from existing behaviour, but one I can
appreciate. I don't immediately see something terribly wrong with it.

> This is implemented internally by adding a new isolated_cpus mask that
> holds the CPUs belonging to child scheduling domain cpusets so that:
> 
> 	isolated_cpus | effective_cpus = cpus_allowed
> 	isolated_cpus & effective_cpus = 0
> 
> This new flag can only be turned on in a cpuset if its parent is either
> root or a scheduling domain itself with non-empty cpu list. The state
> of this flag cannot be changed if the cpuset has children.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/cgroup-v2.txt |  22 ++++
>  kernel/cgroup/cpuset.c      | 237 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 256 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index cf7bac6..54d9e22 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1514,6 +1514,28 @@ Cpuset Interface Files
>  	it is a subset of "cpuset.mems".  Its value will be affected
>  	by memory nodes hotplug events.
>  
> +  cpuset.sched.domain
> +	A read-write single value file which exists on non-root
> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
> +	either "0" (off) or a non-zero value (on).

I would be conservative and only allow 0/1.

>                                                  This flag is set
> +	by the parent and is not delegatable.
> +
> +	If set, it indicates that the CPUs in the current cgroup will
> +	be the root of a scheduling domain.  The root cgroup is always
> +	a scheduling domain.  There are constraints on where this flag
> +	can be set.  It can only be set in a cgroup if all the following
> +	conditions are true.
> +
> +	1) The parent cgroup is also a scheduling domain with a non-empty
> +	   cpu list.

Ah, so initially I was confused by the requirement for root to have it
always set, but you'll allow child domains to steal _all_ CPUs, such
that root ends up with an empty effective set?

What about the (kernel) threads that cannot be moved out of the root
group?

> +	2) The list of CPUs are exclusive, i.e. they are not shared by
> +	   any of its siblings.

Right.

> +	3) There is no child cgroups with cpuset enabled.
> +
> +	Setting this flag will take the CPUs away from the effective
> +	CPUs of the parent cgroup. Once it is set, this flag cannot be
> +	cleared if there are any child cgroups with cpuset enabled.

This I'm not clear on. Why?


