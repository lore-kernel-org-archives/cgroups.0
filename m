From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: protect modifications to
 cgroup_idr with cgroup_mutex
Date: Wed, 12 Feb 2014 10:32:11 +0800
Message-ID: <52FADD2B.3080401@huawei.com>
References: <52F9D9DA.7040108@huawei.com> <20140211154105.GC24490@htj.dyndns.org> <20140211162625.GP11946@dhcp22.suse.cz> <52FAD958.6020505@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52FAD958.6020505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/12 10:15, Li Zefan wrote:
> On 2014/2/12 0:26, Michal Hocko wrote:
>> On Tue 11-02-14 10:41:05, Tejun Heo wrote:
>> [...]
>>> @@ -4254,12 +4256,12 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>>>  
>>>  	return 0;
>>>  
>>> -err_unlock:
>>> -	mutex_unlock(&cgroup_mutex);
>>> -	/* Release the reference count that we took on the superblock */
>>> -	deactivate_super(sb);
>>>  err_free_id:
>>>  	idr_remove(&root->cgroup_idr, cgrp->id);
>>> +	/* Release the reference count that we took on the superblock */
>>> +	deactivate_super(sb);
>>> +err_unlock:
>>> +	mutex_unlock(&cgroup_mutex);
>>>  err_free_name:
>>>  	kfree(rcu_dereference_raw(cgrp->name));
>>>  err_free_cgrp:
>>
>> Do I have to change deactivate_super vs. mutex_unlock ordering in my
>> backport for 3.12 as well?
>>
> 
> Your change is wrong that you shouldn't drop sb refcnt in err_unlock path.
> 
> But you made me think if it's OK to hold cgroup_mutex while calling deactivate_super(),
> and the answer is NO! deactive_super() may call cgroup_kill_sb() which will
> acquire cgroup_mutex.
> 
> I'll update the patch.
> 
> Thank Tejun we won't be entangled with vfs internal anymore after coverting
> to kernfs.
> 

On second thought, it should be safe to call deactivate_super() before
releasing cgroup_mutex, as cgroup_create() is called through vfs, so vfs
should guanrantee the superblock won't disapear, so this deactivate_super()
won't drop sb refcnt to 0.

Still this is just my guess without diving into vfs code, and we'd better
not depend on it even my guess is correct.
