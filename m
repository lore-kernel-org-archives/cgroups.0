From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 2/3] sched, cgroup: replace signal_struct->group_rwsem
 with a global percpu_rwsem
Date: Wed, 20 May 2015 18:05:37 +0800
Message-ID: <555C5C71.80200@huawei.com>
References: <1431549318-16756-1-git-send-email-tj@kernel.org> <1431549318-16756-3-git-send-email-tj@kernel.org> <20150519151659.GF3644@twins.programming.kicks-ass.net> <20150519155133.GM24861@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519155133.GM24861@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org

On 2015/5/19 23:51, Tejun Heo wrote:
> Hello, Peter.
> 
> On Tue, May 19, 2015 at 05:16:59PM +0200, Peter Zijlstra wrote:
>> .gitconfig:
>>
>> [diff "default"]
>>         xfuncname = "^[[:alpha:]$_].*[^:]$"
>>
>> Will avoid keying on labels like that and show us this is
>> __cgroup_procs_write().
> 
> Ah, nice trick.
> 
>> So my only worry with this patch-set is that these operations will be
>> hugely expensive.
>>
>> Now it looks like the cgroup_update_dfl_csses() thing is very rare, its
>> when you change which controllers are active in a given subtree under
>> the uber-l337-super-comount design.
>>
>> The other one, __cgorup_procs_write() is every /procs, /tasks write to a
>> cgroup, and that does worry me, this could be a somewhat common thing.
>>
>> The Changelog states task migration is a cold path, but is tens of
>> miliseconds per task really no problem?
> 
> The latency is bound by synchronize_sched_expedited().  Given the way
> cgroups are used in majority of setups (process migration happening
> only during service / session setups), I think this should be okay.
> 

Actually process migration can happen quite frequently, for example in
Android phones, and that's why Google had an out-of-tree patch to remove
the synchronize_rcu() in that path, which turned out to be buggy.

> I agree that something which is closer to lglock in characteristics
> would fit the workload better tho.  If this actually becomes a
> problem, we can come up with a different percpu locking scheme which
> puts a bit more overhead on the reader side to reduce the latency /
> overhead on the writer side which shouldn't be that difficult but
> let's see whether we need to get there at all.
> 
> Thanks.
> 
