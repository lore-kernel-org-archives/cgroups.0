From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v2] sched/fair: add burst to cgroup cpu bandwidth
 controller
Date: Thu, 20 Feb 2020 11:52:43 +0300
Message-ID: <98998672-4fab-2bb2-5f2d-fd6d83025036@yandex-team.ru>
References: <157476581065.5793.4518979877345136813.stgit@buzz>
 <CAC=E7cU8TeNHDRnrHiFxmiHUKviVU9KaDvMq-U16VRgcohg6-w@mail.gmail.com>
 <xm268sl5uhgo.fsf@bsegall-linux.svl.corp.google.com>
 <CAC=E7cUgALi4g19GsDZQemHafQfaSpjY1XUo3Swrv_g1PaWejQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1582188764; bh=aG3Ei0HHrgrm5hahSqfhzECWrrr1Sfgr3ScUKH/KTBA=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=DMtrzoek+TmVbTa6j2DbONx0J+k79QrdkWNyMyV/0sJKcJppkPl2lCC3ecUFzsZYV
         b4hrr8Sf5vN3p2xJyA1xY+YxSViH21C5E+HOXnvmpfVyNQtC51bo1wl0sUpksXW4ga
         jrAUTseUglLkNENA9nvhf8/k8QqFaHdfP09YPiuI=
In-Reply-To: <CAC=E7cUgALi4g19GsDZQemHafQfaSpjY1XUo3Swrv_g1PaWejQ@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Chiluk <chiluk+linux@indeed.com>, Ben Segall <bsegall@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>, Cong Wang <xiyou.wangcong@gmail.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>

On 17/02/2020 22.56, Dave Chiluk wrote:
> On Fri, Feb 14, 2020 at 12:55 PM <bsegall@google.com> wrote:
>> I'm not sure that starting with full burst runtime is best, though it
>> definitely seems likely to be one of those things where sometimes it's
>> what you want and sometimes it's not.
> 
> We (Indeed) definitely want to start with a full burst bank in most
> cases, as this would help with slow/throttled start-up times for our
> Jitted and interpreter-based language applications.  I agree that it
> would be nice to have it be configurable.
> 
> Dave.
> fyi.  Unfortunately, this e-mail may be temporarily turned off for the
> next few weeks, I apologize in advance for any bounced messages to me.
> 

How much burst time you are planning to use?

On our side common setup should be like this:

cpu.cfs_period_us = 100ms
cpu.cfs_quota_us = 100ms * X
cpu.cfs_burst_us = clamp(400ms * X, 100ms, 100ms * NR_CPUS)

Where is X is a cpu power in cpus.
