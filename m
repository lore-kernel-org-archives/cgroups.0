From: Qais Yousef <qais.yousef@arm.com>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Thu, 26 Mar 2020 10:15:32 +0000
Message-ID: <20200326101529.xh763j5frq2r7mqv@e107158-lin>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
 <20200325191922.GM162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200325191922.GM162390@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Qian Cai <cai@lca.pw>, Prateek Sood <prsood@codeaurora.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>

On 03/25/20 15:19, Tejun Heo wrote:
> On Wed, Mar 25, 2020 at 03:16:56PM -0400, Qian Cai wrote:
> > The linux-next commit a49e4629b5ed (“cpuset: Make cpuset hotplug synchronous”)
> > introduced real deadlocks with CPU hotplug as showed in the lockdep splat, since it is
> > now making a relation from cpu_hotplug_lock —> cgroup_mutex.
> 
> Prateek, can you please take a look? Given that the merge window is just around
> the corner, we might have to revert and retry later if it can't be resolved
> quickly.

I've ran cpuset_hotplug and cpuhotplug LTP tests using next-20200325 but
couldn't reproduce it.

Hopefully that can be fixed, but if you had to revert it, do you mind picking
this instead to fix the LTP issue I encountered before?

	https://lore.kernel.org/lkml/20200211141554.24181-1-qais.yousef@arm.com/

Thanks!

--
Qais Yousef
