From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] sched, cgroup: replace signal_struct->group_rwsem
 with a global percpu_rwsem
Date: Sun, 24 May 2015 10:35:48 +0800
Message-ID: <55613904.7060502@huawei.com>
References: <1431549318-16756-1-git-send-email-tj@kernel.org> <1431549318-16756-3-git-send-email-tj@kernel.org> <20150519151659.GF3644@twins.programming.kicks-ass.net> <20150519155133.GM24861@htj.duckdns.org> <555C5C71.80200@huawei.com> <20150521203943.GS24861@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150521203943.GS24861-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/5/22 4:39, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, May 20, 2015 at 06:05:37PM +0800, Zefan Li wrote:
>>> The latency is bound by synchronize_sched_expedited().  Given the way
>>> cgroups are used in majority of setups (process migration happening
>>> only during service / session setups), I think this should be okay.
>>
>> Actually process migration can happen quite frequently, for example in
>> Android phones, and that's why Google had an out-of-tree patch to remove
>> the synchronize_rcu() in that path, which turned out to be buggy.
> 
> It's still not a very frequent operation tho.  We're talking about
> users switching fore/background jobs here and the expedited
> synchronization w/ preemption enabled doesn't take much time.  In
> addition, as it currently stands, android is doing memory charge
> immigration on each fore/background switches.  I'm pretty doubtful
> this would make any difference.
> 

I did some testing with my laptop.

Moving a task between 2 cgroups for 10W times with one or two threads:

                  1T        2T
orig              3.36s     3.65s
orig+tj           3.55s     6.31s
orig+sync_rcu     16.69s    28.47s    (only 1000 times)

The overhead looks acceptable.
