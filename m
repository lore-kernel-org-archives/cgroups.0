From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH 6/6] mm/vmscan: Don't mess with pgdat->flags in memcg
 reclaim.
Date: Wed, 21 Mar 2018 14:14:35 +0300
Message-ID: <c3405049-222d-a045-4ce5-8e51817d89b6@virtuozzo.com>
References: <20180315164553.17856-1-aryabinin@virtuozzo.com>
 <20180315164553.17856-6-aryabinin@virtuozzo.com>
 <20180320152903.GA23100@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=z76Oe+SIQUwSgw0Vcye2Cm42gmHu8HcPX9XAqvCn5Ag=;
 b=LzvO/8TAwWmev9pSj6NRa9EK9EyehSaxHNIPPzHc+8zdEUdM+bGcrW2qqOZY1H0RVEMZizCPAufhmQ6YmqimzdxZMLKttrPV7h4uLIWh0j7fkeHjOjQjzgLR1rBKBjTpbCqx3MklwFziF5seejAp+9s7bjJjOMQyIKmQHo3ZTd0=
In-Reply-To: <20180320152903.GA23100@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org



On 03/20/2018 06:29 PM, Michal Hocko wrote:

>> Leave all pgdat->flags manipulations to kswapd. kswapd scans the whole
>> pgdat, so it's reasonable to leave all decisions about node stat
>> to kswapd. Also add per-cgroup congestion state to avoid needlessly
>> burning CPU in cgroup reclaim if heavy congestion is observed.
>>
>> Currently there is no need in per-cgroup PGDAT_WRITEBACK and PGDAT_DIRTY
>> bits since they alter only kswapd behavior.
>>
>> The problem could be easily demonstrated by creating heavy congestion
>> in one cgroup:
>>
>>     echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control
>>     mkdir -p /sys/fs/cgroup/congester
>>     echo 512M > /sys/fs/cgroup/congester/memory.max
>>     echo $$ > /sys/fs/cgroup/congester/cgroup.procs
>>     /* generate a lot of diry data on slow HDD */
>>     while true; do dd if=/dev/zero of=/mnt/sdb/zeroes bs=1M count=1024; done &
>>     ....
>>     while true; do dd if=/dev/zero of=/mnt/sdb/zeroes bs=1M count=1024; done &
>>
>> and some job in another cgroup:
>>
>>     mkdir /sys/fs/cgroup/victim
>>     echo 128M > /sys/fs/cgroup/victim/memory.max
>>
>>     # time cat /dev/sda > /dev/null
>>     real    10m15.054s
>>     user    0m0.487s
>>     sys     1m8.505s
>>
>> According to the tracepoint in wait_iff_congested(), the 'cat' spent 50%
>> of the time sleeping there.
>>
>> With the patch, cat don't waste time anymore:
>>
>>     # time cat /dev/sda > /dev/null
>>     real    5m32.911s
>>     user    0m0.411s
>>     sys     0m56.664s
>>
>> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
>> ---
>>  include/linux/backing-dev.h |  2 +-
>>  include/linux/memcontrol.h  |  2 ++
>>  mm/backing-dev.c            | 19 ++++------
>>  mm/vmscan.c                 | 84 ++++++++++++++++++++++++++++++++-------------
>>  4 files changed, 70 insertions(+), 37 deletions(-)
> 
> This patch seems overly complicated. Why don't you simply reduce the whole
> pgdat_flags handling to global_reclaim()?
> 

In that case cgroup2 reclaim wouldn't have any way of throttling if cgroup is full of congested dirty pages.
