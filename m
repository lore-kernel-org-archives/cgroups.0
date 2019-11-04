From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched/topology, cpuset: Account for housekeeping CPUs to
 avoid empty cpumasks
Date: Mon, 4 Nov 2019 00:37:15 +0000
Message-ID: <845e4aba-eee2-efd0-2902-1d956057059d@arm.com>
References: <20191102001406.10208-1-valentin.schneider@arm.com>
 <20191103190957.GA39453@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191103190957.GA39453@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 03/11/2019 19:09, Ingo Molnar wrote:
> This patch doesn't apply cleanly to Linus's latest tree - which tree is 
> this against?
> 

This was against Linus' tree at the time (31408fbe33d1), but my local .patch
doesn't apply either. I regenerated a fresh one and there's an off-by-one in
original chunk size - I suspect my editor trying to be smart when I edited
the changelog.

I'll look into preventing this from happening again, in the meantime I'll
send an apply-able version. Apologies for that mess.

> Thanks,
> 
> 	Ingo
> 
