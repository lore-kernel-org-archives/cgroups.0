From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Thu, 6 Aug 2015 11:30:08 +0900
Message-ID: <55C2C6B0.3080203@jp.fujitsu.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804193101.GI17598@mtj.duckdns.org> <55C15B4C.9080202@jp.fujitsu.com>
 <20150805074758.GA11182@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150805074758.GA11182@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@redhat.com, peterz@infradead.org, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 2015/08/05 16:47, Michal Hocko wrote:
> On Wed 05-08-15 09:39:40, KAMEZAWA Hiroyuki wrote:
> [...]
>> so, for memory controller, we'll have
>
> We currently have only current, low, high, max and events currently.
> All other knobs are either deprecated or waiting for a usecase to emerge
> before they get added.
>

Sure. I think following has users.
  - *.stat             - for chekcing health of cgroup ,or for debug
  - *.pressure_level   - for notifying memory pressure
  - *.swappiness       - for adjusting LRU activity per application type.
  - *.oom_control      - for surviving/notifiyng out of memory
                         memcg's oom can be recovered if limit goes up rather than kill.
                         But I know people says this knob is not useful. This will require
                         discussion.

Hm. If we don't want to increase files, NETLINK or systemcall is an another choice of
subsystem specific interface ?

-Kame

>> (in alphabet order)
>> memory.failcnt
>> memory.force_empty  (<= should this be removed ?)
>> memory.kmem.failcnt
>> memory.kmem.max
>> memory.kmem.max_usage
>> memory.kmem.slabinfo
>> memory.kmem.tcp.failcnt
>> memory.kmem.tcp.max
>> memory.kmem.tcp.max_usage
>> memory.kmem.tcp.usage
>> memory.kmem.usage
>> memory.max
>> memory.max_usage
>> memory.move_charge_at_immigrate
>> memory.numa_stat
>> memory.oom_control
>> memory.pressure_level
>> memory.high
>> memory.swapiness
>> memory.usage
>> memory.use_hierarchy (<= removed)
>

