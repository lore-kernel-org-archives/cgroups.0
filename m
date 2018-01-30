From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Tue, 30 Jan 2018 11:21:56 +0100
Message-ID: <20180130102156.GS2249@hirez.programming.kicks-ass.net>
References: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3bEz86ldnwtpMt+r70ucYH9GZggk+psJoW2A7pc3G6c=; b=P8aYwBaPssturaUwlkqU580Y0
        IRa501OkK9auRWSkvcG6wWuqXkOUyEmZSZH0ClhplTA2+QjoEoCn3acW9y9UJvLtdDgvyXbS7qWti
        56SEEdvdAYjhHmJQ0t6Ir7ulSSYIz9JDOVcbt9tTHAyHFK4APA55ZJoIJXzRZxolfoU86IUGRODwE
        192sBrW4VbgzyFlaSEnk2FhEeNG1vOqG1uAxEuRBfpRZAga604yOXZQGfIzuhGoxvXakEv74jEDfX
        pkd6o4Rncd21M7/oIivC192ZbE3hd0VBJvNbngGZy52Tizq4UpsPO+jv0N1/lpT23lssguNqchFkt
    
Content-Disposition: inline
In-Reply-To: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

On Mon, Jan 22, 2018 at 11:26:18AM -0800, Tejun Heo wrote:
> While adding cgroup2 interface for the cpu controller, 0d5936344f30
> ("sched: Implement interface for cgroup unified hierarchy") forgot to
> update input validation and left it to reject cpu.max config if any
> descendant has set a higher value.
> 
> cgroup2 officially supports delegation and a descendant must not be
> able to restrict what its ancestors can configure.  For absolute
> limits such as cpu.max and memory.max, this means that the config at
> each level should only act as the upper limit at that level and
> shouldn't interfere with what other cgroups can configure.

*blink* what?

afaiu the existing code does exactly the opposite, it forces the
descendants to configure less than the parent allows.

You're taking out an error condition and silently allowing descentant
misconfiguration. How does that make sense?

