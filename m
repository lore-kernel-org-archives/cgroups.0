From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 2/5] cpuset: Add cpuset.sched_load_balance to v2
Date: Wed, 2 May 2018 12:24:16 +0200
Message-ID: <20180502102416.GJ12180@hirez.programming.kicks-ass.net>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+eTGSS7Cv6Co7u5U111G0eVVRGuuFovTlO69IISNExI=; b=fV+VB4mISPeyh5XMUgs6SUkFZ
        /ESM9V03e0fJk9OtCcd7fArRr2lym7RFlnKORTJj/ouJ1h+vcdozNd1KTFa3s6p4reOAtL/Xb7FZR
        iAQnnd2JfHjzOG0bYx9Sisej4m5vTXtesVZCr3yxPVh9NnFHFg1iEANWJgoVubi7nEDQddZuiBu5r
        ss1XxaN0d5DPLfENy9dCbyReIDxo8QDnr3OCjJ3Hq/RvBpV2oaB2yho5nMGkTh2hPyZZ8GzD7LP+p
        85rhGh0zrk1qUd8L97nghbWlAV/kdPJQ2FY6/Af/pEu7iNjilDSYJ9mVdpirFocgNoa8VSsJQAVIT
    
Content-Disposition: inline
In-Reply-To: <1524145624-23655-3-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Thu, Apr 19, 2018 at 09:47:01AM -0400, Waiman Long wrote:
> +  cpuset.sched_load_balance
> +	A read-write single value file which exists on non-root cgroups.

Uhhm.. it should very much exist in the root group too. Otherwise you
cannot disable it there, which is required to allow smaller groups to
load-balance between themselves.

> +	The default is "1" (on), and the other possible value is "0"
> +	(off).
> +
> +	When it is on, tasks within this cpuset will be load-balanced
> +	by the kernel scheduler.  Tasks will be moved from CPUs with
> +	high load to other CPUs within the same cpuset with less load
> +	periodically.
> +
> +	When it is off, there will be no load balancing among CPUs on
> +	this cgroup.  Tasks will stay in the CPUs they are running on
> +	and will not be moved to other CPUs.
> +
> +	This flag is hierarchical and is inherited by child cpusets. It
> +	can be turned off only when the CPUs in this cpuset aren't
> +	listed in the cpuset.cpus of other sibling cgroups, and all
> +	the child cpusets, if present, have this flag turned off.
> +
> +	Once it is off, it cannot be turned back on as long as the
> +	parent cgroup still has this flag in the off state.

That too is wrong and broken. You explicitly want to turn it on for
children.

So the idea is that you can have:

		R
	      /   \
            A       B

With:

	R cpus=0-3, load_balance=0
	A cpus=0-1, load_balance=1
	B cpus=2-3, load_balance=1

Which will allow all tasks in A,B (and its children) to load-balance
across 0-1 or 2-3 resp.

If you don't allow the root group to disable load_balance, it will
always be the largest group and load-balancing will always happen system
wide.
