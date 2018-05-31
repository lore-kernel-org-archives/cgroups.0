From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 12:54:16 +0200
Message-ID: <20180531105416.GI12180@hirez.programming.kicks-ass.net>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wK3gd8V16jU2PtUbyVoCdyUhgml9RJnpgQY+XVdFtWM=; b=VpQjVAYxsuWXgZhRWPlbQHNcL
        0yP5jZQwsIbD8KUhXKXT6GyiXpEGorCaa7LhJ5YBgCWbkgiDeG8lTEZy7fp9/DBYL8pKB4mlTDMQt
        pPn7tktKg3zAGgN76RL+g95GlHqeOlFdW4KtiT7w9er10M9sIm4p5Og8AOqMrUtPk2IPVVt42SntG
        /jxE5UFN83ASlV2/FrPfiMrlZBh4521lItKDkRTygnKp4aaXaaDZ54sbtH6h9LWgsEibgTEdTX2FD
        XXxhnoB7M2GqqbfMoUrcFfZbEhhzUODw4RyTu8EuAGEt+9qsVgV7XP7Vi0ghDJ+K20jNShst5/lcX
    
Content-Disposition: inline
In-Reply-To: <1527601294-3444-4-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Tue, May 29, 2018 at 09:41:30AM -0400, Waiman Long wrote:

> +  cpuset.sched.load_balance
> +	A read-write single value file which exists on non-root
> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
> +	either "0" (off) or "1" (on).  This flag is set by the parent
> +	and is not delegatable.  It is on by default in the root cgroup.
> +
> +	When it is on, tasks within this cpuset will be load-balanced
> +	by the kernel scheduler.  Tasks will be moved from CPUs with
> +	high load to other CPUs within the same cpuset with less load
> +	periodically.
> +
> +	When it is off, there will be no load balancing among CPUs on
> +	this cgroup.  Tasks will stay in the CPUs they are running on
> +	and will not be moved to other CPUs.

That is not entirely accurate I'm afraid (unless the patch makes it so,
I've yet to check). When you disable load-balancing on a cgroup you'll
get whatever balancing is left for the partition you happen to end up
in.

Take for instance workqueue thingies, they use kthread_bind_mask()
(IIRC) and thus end up with PF_NO_SETAFFINITY so cpusets (or any other
cgroups really) do not have effect on them (long standing complaint).

So take for instance the unbound numa enabled workqueue threads, those
will land in whatever partition and get balanced there.
