From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Tue, 30 Jan 2018 06:56:39 -0800
Message-ID: <20180130145639.GD1121507@devbig577.frc2.facebook.com>
References: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
 <20180130102156.GS2249@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jE4un1YQvFyyNrXjA4HtlOUYbWBNhzPJull+C6KKWIU=;
        b=uCEOmcfNjCP8jgx5q2mffxTkut16lW9bO3rmigEv/jzH+J+1U8EGZpypGsyNZcFp8I
         ixA0iBAU+/KLLxWONpaXyTmOeMClVXbabYIUJS+FLJcSVneU2FmCPd0XUP2WSIrsgk0J
         j6s3W1FKxni4A/l8bj4acmLtZoMyaPfjSb3Vcd+LBz1YKNrpiHv5I3UZoBOoQv/9LMeX
         2bI9R6Ond7ZOUh7kplN6dCIeZmGAanlC7psJgIHKLPHgqPN40RV7oNKIgu5O5Fjo5jKI
         Q65weW57Xiof3xxBnEiasNyheHrTRKetL2hpSETv4B66ggAnJkIPTuIsOBG9l2Dvgmd1
         +4pA==
Content-Disposition: inline
In-Reply-To: <20180130102156.GS2249@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello,

On Tue, Jan 30, 2018 at 11:21:56AM +0100, Peter Zijlstra wrote:
> afaiu the existing code does exactly the opposite, it forces the
> descendants to configure less than the parent allows.
> 
> You're taking out an error condition and silently allowing descentant
> misconfiguration. How does that make sense?

Well, they're upper limits, not strict allocations.  The current
behavior implemented by cpu isn't either a strict allocation or upper
limits.  It disallows a child from having a value higher than the
parent (allocation-ish) but the sum of the children is allowed to
exceed the parent's (limit-ish).

The combination is rather arbitrary and makes it impossible to
delegate safely (a delegatee can block the delegator from reducing the
amount resource allocated to the delegatee) while not really
protecting against overcommit from descendants either.

We had this sort of input validations in different controllers all in
their own ways.  In most cases, these aren't well thought out and we
can't support things like delegation without aligning controller
behaviors.

Thanks.

-- 
tejun
