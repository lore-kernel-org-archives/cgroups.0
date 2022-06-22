From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] sched: RT bandwidth interface for cgroup unified
 hierarchy
Date: Wed, 22 Jun 2022 19:39:29 +0200
Message-ID: <20220622173929.GA669@blackbody.suse.cz>
References: <20220622015557.7497-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655919571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qjLsn3chRmVR7wBslFm7Nmwci+bvj1b1+qTpUK32rXQ=;
        b=iGD8LGlhBV+ijnTy+c24IKvp3gS6t3Xd7fZf0W5mhS4jcdaQdBdVobDGrLTSUQYAXoEATz
        JokCZyEMcnVxZEGqwjaMlMEyZdB0kDdegEDn9d5unKiSxSMx7nn9t4BUaYxsUPslHkd98r
        aF5iZpfXyd/FBxVY1CTQo6j408qFIqM=
Content-Disposition: inline
In-Reply-To: <20220622015557.7497-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: rdunlap@infradead.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Chengming.

On Wed, Jun 22, 2022 at 09:55:57AM +0800, Chengming Zhou <zhouchengming@bytedance.com> wrote:
> We need to run RT threads in cgroup unified hierarchy, but we can't
> since the default rt_bandwidth.rt_runtime of non-root task_group is 0
> and we haven't interface to update it.

Do you really want to make use of group RT schedulling
(CONFIG_RT_GROUP_SCHED) or just be able to run RT threads in the unified
hieararchy with cpu controller enabled?

Those are two different use cases, the former is more complex and it's a
reason why v2 doesn't expose the RT attributes (yet).
The latter is typically achieved by unsetting CONFIG_RT_GROUP_SCHED (and
relying on the global rt_runtime limit).

Thanks,
Michal
