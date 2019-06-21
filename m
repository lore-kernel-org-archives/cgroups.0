From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH 0/5] BT scheduling class
Date: Fri, 21 Jun 2019 14:26:11 +0100
Message-ID: <6a81a564-9d89-f01d-15b8-e07f092cc5f1@arm.com>
References: <1561103157-11246-1-git-send-email-xiaoggchen@tencent.com>
 <20190621130316.GK3436@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621130316.GK3436@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, xiaoggchen@tencent.com
Cc: jasperwang@tencent.com, heddchen@tencent.com, mingo@redhat.com, linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, viresh.kumar@linaro.org

On 21/06/2019 14:03, Peter Zijlstra wrote:
> On Fri, Jun 21, 2019 at 03:45:52PM +0800, xiaoggchen@tencent.com wrote:
> 
>> First only server application exists in the system and the success
>> rate is 99.998% and the average cpu use is only 25%.
> 
> Have you guys looked at this series:
> 
>   https://lkml.kernel.org/r/cover.1556182964.git.viresh.kumar@linaro.org
> 
> 

Sort of a shot in the dark here, but I wonder if task stealing [1] could
help as well? IIRC Steve had some pretty good CPU utilization improvements
with his series.

FWIW I have a somewhat recent rebase of CFS stealing laying around at [2].

[1]: https://lore.kernel.org/lkml/1544131696-2888-1-git-send-email-steven.sistare@oracle.com/
[2]: http://www.linux-arm.org/git?p=linux-vs.git;a=shortlog;h=refs/heads/mainline/cfs-stealing/v4-rebase
