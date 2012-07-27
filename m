From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Don't drop the cgroup_mutex in cgroup_rmdir
Date: Fri, 27 Jul 2012 14:15:12 +0800
Message-ID: <501231F0.8050505@huawei.com>
References: <87ipdjc15j.fsf@skywalker.in.ibm.com> <1342706972-10912-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120719165046.GO24336@google.com> <1342799140.2583.6.camel@twins> <20120720200542.GD21218@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120720200542.GD21218-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org

On 2012/7/21 4:05, Tejun Heo wrote:

> Hey, Peter.
> 
> On Fri, Jul 20, 2012 at 05:45:40PM +0200, Peter Zijlstra wrote:
>>> So, Peter, why does cpuset mangle with cgroup_mutex?  What guarantees
>>> does it need?  Why can't it work on "changed" notification while
>>> caching the current css like blkcg does?
>>
>> I've no clue sorry.. /me goes stare at this stuff.. Looks like something
>> Paul Menage did when he created cgroups. I'll have to have a hard look
>> at all that to untangle this. Not something obvious to me.
> 
> Yeah, it would be great if this can be untangled.  I really don't see
> any other reasonable way out of this circular locking mess.  If cpuset
> needs stable css association across certain period, the RTTD is
> caching the css by holding its ref and synchronize modifications to
> that cache, rather than synchronizing cgroup operations themselves.
> 


The cgroup core was extracted from cpuset, so they are deeply tangled.

There are several issues to resolve with regard to removing cgroup lock from cpuset.

- there are places that the cgroup hierarchy is travelled. This should be
easy, as cpuset can be made to maintain its hierarchy.

- cpuset disallows clearing cpuset.mems/cpuset.cpus if the cgroup is not empty,
which can be guaranteed only by cgroup lock.

- cpuset disallows a task be attached to a cgroup with empty cpuset.mems/cpuset.cpus,
which again can be guarantted only by cgroup lock.

- cpuset may move tasks from a cgroup to another cgroup (Glauber mentioned this).

- maybe other cases I overlooked..
