From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: + hugetlb-cgroup-simplify-pre_destroy-callback.patch added to
 -mm tree
Date: Sat, 21 Jul 2012 11:14:21 +0900
Message-ID: <500A107D.9060404@jp.fujitsu.com>
References: <20120718212637.133475C0050@hpza9.eem.corp.google.com> <20120719113915.GC2864@tiehlicka.suse.cz> <87r4s8gcwe.fsf@skywalker.in.ibm.com> <20120719123820.GG2864@tiehlicka.suse.cz> <87ipdjc15j.fsf@skywalker.in.ibm.com> <20120720080639.GC12434@tiehlicka.suse.cz> <87d33qmeb9.fsf@skywalker.in.ibm.com> <20120720195643.GC21218@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120720195643.GC21218-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

(2012/07/21 4:56), Tejun Heo wrote:
> On Sat, Jul 21, 2012 at 12:48:34AM +0530, Aneesh Kumar K.V wrote:
>> Does cgroup_rmdir do a cgroup_task_count check ? I do see that it check
>> cgroup->childern and cgroup->count. But cgroup->count is not same as
>> task_count right ?
>>
>> May be we need to push the task_count check also to rmdir so that
>> pre_destory doesn't need to check this
>
> task_count implies cgroup refcnt which cgroup core does check.  No
> need to worry about that, ->children or whatever from memcg.  As soon
> as the deprecated behavior is gone, everything will be okay;
> otherwise, it's a bug in cgroup core.
>

I'm sorry I misunderstand. The problem is following.

         CPU A                       CPU B
     mutex_unlock()
                                 mutex_lock()
     ->pre_destroy()             attach task
       commit res->usage=0       mutex_unlock()
                                 increase res->usage
                                 detach task
     mutex_lock()
     check css's refcount=0
      ....continue destroy.

Now, I thinks memcg's check is not enough but putting the -EBUSY there
not to forget this race.


I think a patch to stop task-attach and create child cgroup if  CGRP_WAIT_ON_RMDIR
is set is required. And that's enough..
Thanks,
-Kame





