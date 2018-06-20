From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Wed, 20 Jun 2018 16:46:13 +0200
Message-ID: <20180620144613.GP2476@hirez.programming.kicks-ass.net>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
 <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
 <20180531152050.GK12180@hirez.programming.kicks-ass.net>
 <ebe7f0c1-b2dc-57ad-e5cb-7edf0fee4626@redhat.com>
 <20180531160857.GM12180@hirez.programming.kicks-ass.net>
 <54c607c3-e742-4da9-c89a-4ed54146e3bd@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZKf96prADD2Hvs7n4fXf2KFm7vCLkqBMyh1u+rx+U8I=; b=OAHa/VOJ8rCQdHOeWUY+u/fPV
        TCmV0pmkhNh0Vbc/ftKRHmPuRRAfvnD0bt09Ehk01gz77jYjbtplIj4LF/vakZ9dxj2jbUTpjGe8d
        Q8wXvCU/KoDWCrjkPxEUnrr7MR5FPDrPkqNkQXE6TqQ9oAmW0UAWK2S3d6Lu5UW/yRR3MNGcBempy
        cmJuhd1lRcTbleYxXMzekk1VWVr8E6zlIaB3lEyB/97MXUVju8MCQQCHeXbRptjR9FfPv2JnGIdIX
        yB496lON0JcYlD/m3DS5+Ie+N8rs/zhG1ka+WYRslUv9LKfE2IhX2W+JwNWW2QkVGUC7xiG8VWGFN
    
Content-Disposition: inline
In-Reply-To: <54c607c3-e742-4da9-c89a-4ed54146e3bd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>

On Thu, May 31, 2018 at 12:42:20PM -0400, Waiman Long wrote:
> Thinking about isolcpus emulation, I now realize that it is more than
> just disabling load balancing. it also disables some kernel threads like
> kworker from running so that an userspace application can monopolize as
> much of a cpu as possible. Disabling kernel threads from running isn't
> that hard if it is only done once at boot time. it is trickier if we
> have to do it at run time.

Don't think it is all that difficult, we just need a notifier for when
that housekeeping thing changes and ensure that everybody who uses it
re-evaluates crap.

> Without good isolcpus emulation, disabling load balance kind of loses
> its usefulness. So I am going to take out the load_balance flag for now
> unless I hear objection otherwise.

I'm not seeing the direct link between the load_balance flag and
isolcpus emulation in the proposed stuff.

We can tie the housekeeping mask to whatever CPUs remain in the root
cgroup, couple that to that notifier and it should all just work I
think.
