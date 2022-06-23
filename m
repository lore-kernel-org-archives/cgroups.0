From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [External] Re: [PATCH v2] sched: RT bandwidth interface for
 cgroup unified hierarchy
Date: Thu, 23 Jun 2022 09:51:02 +0200
Message-ID: <20220623075102.GJ27251@blackbody.suse.cz>
References: <20220622015557.7497-1-zhouchengming@bytedance.com>
 <20220622173929.GA669@blackbody.suse.cz>
 <888b6885-5380-e21f-260f-eb1bb89679c3@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655970664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N/aCRSdhEB1a/0vv+am/2J2O6zh8qGqpd9QHXNhE6fQ=;
        b=uX9mixs8DaMWvUWkJIlE5hYrzddV835XJc/pbvqs6zdl2ElMIt6vkjYE976CR/AFb8xzm5
        AE+zJC+LE7CWeChJY9ZsZnarpVzWsKP9XyHYR6oZu4lbuY0C1Jif8xInDH2xQajcTkU+LH
        f+KGfRmCvrPYV5PW7x6Nq7DwZvzsuvw=
Content-Disposition: inline
In-Reply-To: <888b6885-5380-e21f-260f-eb1bb89679c3@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: rdunlap@infradead.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 23, 2022 at 10:23:26AM +0800, Chengming Zhou <zhouchengming@bytedance.com> wrote:
> I don't know why v2 differ from v1 in the RT bandwidth control.. Is there
> some links of explanation? (CFS bandwidth control can work on v2 now.)

You can see some ideas in [1] (the v1 API allows configurations that are
not implemented).
And I'd also say more generally, that applying throttling to an RT task
is already a lost game (either it's a runaway meaning there's a bug
elsewhere or the RT task won't have sufficient runtime which defeats its
RTness).

> If the problem can't be solved, we have to unset CONFIG_RT_GROUP_SCHED.

AFAICT, this was enough so far (but RT group scheduling can still be
(re)worked).

HTH,
Michal

[1] https://www.kernel.org/doc/html/latest/scheduler/sched-rt-group.html
