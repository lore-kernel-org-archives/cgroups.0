From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 1/2] cgroup: make sure a parent css isn't offlined before
 its children
Date: Fri, 22 Jan 2016 09:18:35 +0100
Message-ID: <56A1E5DB.1010201@de.ibm.com>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org> <5698A023.9070703@de.ibm.com>
 <20160121203111.GF5157@mtj.duckdns.org>
 <20160121212416.GL6357@twins.programming.kicks-ass.net>
 <20160121212812.GJ5157@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160121212812.GJ5157@mtj.duckdns.org>
Sender: kvm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-s390 <linux-s390@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, kernel-team@fb.com

On 01/21/2016 10:28 PM, Tejun Heo wrote:
> On Thu, Jan 21, 2016 at 10:24:16PM +0100, Peter Zijlstra wrote:
>> On Thu, Jan 21, 2016 at 03:31:11PM -0500, Tejun Heo wrote:
>>> There are three subsystem callbacks in css shutdown path -
>>> css_offline(), css_released() and css_free().  Except for
>>> css_released(), cgroup core didn't use to guarantee the order of
>>> invocation.  css_offline() or css_free() could be called on a parent
>>> css before its children.  This behavior is unexpected and led to
>>> use-after-free in cpu controller.
>>>
>>> This patch updates offline path so that a parent css is never offlined
>>> before its children.  Each css keeps online_cnt which reaches zero iff
>>> itself and all its children are offline and offline_css() is invoked
>>> only after online_cnt reaches zero.
>>>
>>> This fixes the reported cpu controller malfunction.  The next patch
>>> will update css_free() handling.
>>
>> No, I need to fix the cpu controller too, because the offending code
>> sits off of css_free() (the next patch), but also does a call_rcu() in
>> between, which also doesn't guarantee order.
> 
> Ah, I see.  Christian, can you please apply all three patches and see
> whether the problem gets fixed?  Once verified, I'll update the patch
> description and repost.

With these 3 patches I always run into the dio/scsi problem, but never in
the css issue. So I cannot test a full day or so, but it looks like
the problem is gone. At least it worked multiple times for 30minutes or
so until my system was killed by the io issue.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>

