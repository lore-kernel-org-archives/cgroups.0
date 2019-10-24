From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH v4 1/2] sched/topology: Don't try to build empty sched
 domains
Date: Thu, 24 Oct 2019 17:45:14 +0100
Message-ID: <7e20f309-3ca0-b916-b703-052ab8284012@arm.com>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
 <20191023153745.19515-2-valentin.schneider@arm.com>
 <27d8a51d-a899-67f4-8b74-224281f25cef@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <27d8a51d-a899-67f4-8b74-224281f25cef@arm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dietmar Eggemann <dietmar.eggemann@arm.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

On 24/10/2019 17:19, Dietmar Eggemann wrote:
> Sorry for being picky but IMHO you should also mention that it fixes
> 
> f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting
> information")
> 

I can append the following to the changelog, although I'd like some
feedback from the cgroup folks before doing a respin:

"""
Note that commit

  f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")

introduced a similar issue. Since doms_new is assigned to doms_cur without
any filtering, we can end up with an empty cpumask in the doms_cur array.

The next time we go through a rebuild, this will break on:

  rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;

If there wasn't enough already, this is yet another argument for *not*
handing over empty cpumasks to the sched domain rebuild.
"""

I tagged the commit that introduces the static key with Fixes: because it
was introduced earlier - I don't think it would make sense to have two
"Fixes:" lines? In any case, it'll now be listed in the changelog.

