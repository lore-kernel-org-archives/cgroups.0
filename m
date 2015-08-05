From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Wed, 5 Aug 2015 09:47:58 +0200
Message-ID: <20150805074758.GA11182@dhcp22.suse.cz>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804193101.GI17598@mtj.duckdns.org>
 <55C15B4C.9080202@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55C15B4C.9080202@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, mingo@redhat.com, peterz@infradead.org, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed 05-08-15 09:39:40, KAMEZAWA Hiroyuki wrote:
[...]
> so, for memory controller, we'll have

We currently have only current, low, high, max and events currently.
All other knobs are either deprecated or waiting for a usecase to emerge
before they get added.

> (in alphabet order)
> memory.failcnt
> memory.force_empty  (<= should this be removed ?)
> memory.kmem.failcnt
> memory.kmem.max
> memory.kmem.max_usage
> memory.kmem.slabinfo
> memory.kmem.tcp.failcnt
> memory.kmem.tcp.max
> memory.kmem.tcp.max_usage
> memory.kmem.tcp.usage
> memory.kmem.usage
> memory.max
> memory.max_usage
> memory.move_charge_at_immigrate
> memory.numa_stat
> memory.oom_control
> memory.pressure_level
> memory.high
> memory.swapiness
> memory.usage
> memory.use_hierarchy (<= removed)

-- 
Michal Hocko
SUSE Labs
