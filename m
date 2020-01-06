From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC] memcg: Add swappiness to cgroup2
Date: Mon, 6 Jan 2020 14:10:20 +0100
Message-ID: <20200106131020.GC9198@dhcp22.suse.cz>
References: <1577252208-32419-1-git-send-email-teawater@gmail.com>
 <20191225140546.GA311630@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191225140546.GA311630@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Hui Zhu <teawater@gmail.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Hui Zhu <teawaterz@linux.alibaba.com>

On Wed 25-12-19 14:05:46, Chris Down wrote:
> Hi Hui,
> 
> Hui Zhu writes:
> > Even if cgroup2 has swap.max, swappiness is still a very useful config.
> > This commit add swappiness to cgroup2.
> 
> When submitting patches like this, it's important to explain *why* you want
> it and what evidence there is. For example, how should one use this to
> compose a reasonable system? Why aren't existing protection controls
> sufficient for your use case? Where's the data?

Agreed!

> Also, why would swappiness be something cgroup-specific instead of
> hardware-specific, when desired swappiness is really largely about the
> hardware you have in your system?

I am not really sure I agree here though. Swappiness has been
traditionally more about workload because it has been believed that it
is a preference of the workload whether the anonymous or disk based
memory is more important. Whether this is a good interface is debatable
of course but time has shown that it is extremely hard to tune.

Not to mention that swappiness has been ignored for years for vast
majority workloads because of the highly biased file LRU reclaim.

At the time when cgroup v2 was introduced it'd been claimed that we
do not want to copy the v1 swappiness logic because of the semantic
shortcomings and that a better tuning should developed in future
replacing even the global knob. AFAIR Johannes wanted to have a refault
vs. cost based file/anon balancing.

The lack of a sensible hierarchical behavior has been even a stronger
argument.
-- 
Michal Hocko
SUSE Labs
