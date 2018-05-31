From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 17:20:50 +0200
Message-ID: <20180531152050.GK12180@hirez.programming.kicks-ass.net>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
 <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jXCVriBrw+jgBebtJ3nvyzGSmm5H9oe+RRwRKNOGFCM=; b=quzLe2oaV41JQ4YrGn9qNZKSA
        8bwthqtWAUYuvlmF7OolCvxzntqF9qhnFO8Xhw2vkW/JIzga+WoUwN9j6XdVJzZmVmUfCqkDnq02P
        xkMf93IDbC5cn/LboGYrZAtMJYSfaGzMDUHtb8cqQV/QS29nbwzAFuvIpVyD9ZD9aqeJmzPYxoS1n
        ScNSEvW6PXulwtLR8XoJROmn94wmNjzpQDwAWpBBOFL7U0ujOTzfospeGxn/bzx3s0cYkFtM5WoNg
        Yvdkxw4e1kjJSFg5IWseS9mDAUFHPhoA7EWX6fPmk6hDaogI9h7avyPbiUKOaRuOa6iXqZgdi+jrB
      
Content-Disposition: inline
In-Reply-To: <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Thomas Gleixner <tglx@linutronix.de>

On Thu, May 31, 2018 at 09:54:27AM -0400, Waiman Long wrote:
> On 05/31/2018 08:26 AM, Peter Zijlstra wrote:

> > I still find all that a bit weird.
> >
> > So load_balance=0 basically changes a partition into a
> > 'fully-partitioned partition' with the seemingly random side-effect that
> > now sub-partitions are allowed to consume all CPUs.
> 
> Are you suggesting that we should allow sub-partition to consume all the
> CPUs no matter the load balance state? I can live with that if you think
> it is more logical.

I'm on the fence myself; the only thing I'm fairly sure of is that tying
this particular behaviour to the load-balance knob seems off.

> > The rationale, only given in the Changelog above, seems to be to allow
> > 'easy' emulation of isolcpus.
> >
> > I'm still not convinced this is a useful knob to have. You can do
> > fully-partitioned by simply creating a lot of 1 cpu parititions.
> 
> That is certainly true. However, I think there are some additional
> overhead in the scheduler side in maintaining those 1-cpu partitions. Right?

cpuset-controller as such doesn't have much overhead scheduler wise,
cpu-controller OTOH does, and there depth is the predominant factor, so
many sibling groups should not matter there either.

> > So this one knob does two separate things, both of which seem, to me,
> > redundant.
> >
> > Can we please get better rationale for this?
> 
> I am fine getting rid of the load_balance flag if this is the consensus.
> However, we do need to come up with a good migration story for those
> users that need the isolcpus capability. I think Mike was the one asking
> for supporting isolcpus. So Mike, what is your take on that.

So I don't strictly mind having a knob that does the 'fully-partitioned
partition' thing -- however odd that sounds -- but I feel we should have
a solid use-case for it.

I also think we should not mix the 'consume all' thing with the
'fully-partitioned' thing, as they are otherwise unrelated.
