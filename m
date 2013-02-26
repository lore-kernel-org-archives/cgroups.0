From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Tue, 26 Feb 2013 18:25:08 +0800
Message-ID: <512C8D84.7090707@huawei.com>
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130226022703.GA13837-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/2/26 10:27, Tejun Heo wrote:
> On Mon, Feb 25, 2013 at 02:17:49PM +0800, Li Zefan wrote:
>> cgroup_name() returns the name of a cgroup and it must be called with
>> rcu_read_lock() held.
>>
>> This will be used by cpuset.
>>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ...
>>  /**
>> + * cgroup_name - get the name of a cgroup
>> + * @cgrp: the cgroup in question
>> + *
>> + * Must be called with rcu_read_lock() held.
>> + */
>> +char *cgroup_name(const struct cgroup *cgrp)
>> +{
>> +	if (!cgrp->parent)
>> +		return "/";
>> +	else
>> +		return rcu_dereference(cgrp->name)->name;
>> +}
> 
> Can't we initialize ->name of root cgroup to "/" and lose the
> conditional? 

Sure we can. We'll have to allocate cgrp->name in cgroup_remount() and
cgroup_init(), and free cgrp->name in cgroup_kill_sb(). It looks to me
the current version is a bit simpler.

That said, I don't have strong preference. I'll revise the patchset if
you still prefer to init root_cgrp->name.

> We can lose the wrapper altogether but if you're worried
> that sparse check isn't enough, we can have trivial inline wrapper,
> but in that case it probably would help to rename cgrp->name to, say,
> cgrp->__name and put a comment directing people to the accessing
> wrapper which should probably return const char *.
> 

I do expect people always use cgroup_name(). Should anyone access
cgrp->name directly and doesn't notice cgrp->name can be NULL, he'll
get NULL ptr crash and turn to cgroup_name(), and a comment to guide
people to cgroup_name() is helpful too.
