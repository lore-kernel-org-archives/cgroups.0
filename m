From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce CGROUP_FREEZING_[SELF|PARENT]
Date: Thu, 08 Nov 2012 13:56:52 +0900
Message-ID: <509B3B94.1070407@jp.fujitsu.com>
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-8-git-send-email-tj@kernel.org> <509B382E.4030707@jp.fujitsu.com> <20121108044521.GH2660@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121108044521.GH2660@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org, fweisbec@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

(2012/11/08 13:45), Tejun Heo wrote:
> Hello,
>
> On Thu, Nov 08, 2012 at 01:42:22PM +0900, Kamezawa Hiroyuki wrote:
>> (2012/11/03 17:38), Tejun Heo wrote:
>>> Introduce FREEZING_SELF and FREEZING_PARENT and make FREEZING OR of
>>> the two flags.  This is to prepare for full hierarchy support.
>>>
>>> freezer_apply_date() is updated such that it can handle setting and
>>> clearing of both flags.  The two flags are also exposed to userland
>>> via read-only files self_freezing and parent_freezing.
>>>
>>> Other than the added cgroupfs files, this patch doesn't introduce any
>>> behavior change.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>
>> What is the purpose of FREEZING_SELG/PARENT, having 2 flags and
>> make it visible to users ?
>
> SELF is the configuration of the current cgroup, PARENT is freezing
> state inherited from an ancestor.  If either is set, the cgroup is
> freezing.  Without the two conditions visible to userland, it can get
> a bit confusing as echoing "THAWED" to state may not do anything to
> the cgroup.
>
Got it, thank you. I'm glad if you add some more explanation in comments
and considered use-case in changelog.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame





