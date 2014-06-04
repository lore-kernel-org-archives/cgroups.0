From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: don't destroy the default root
Date: Wed, 4 Jun 2014 16:40:28 +0800
Message-ID: <538EDB7C.2070405@huawei.com>
References: <538D4956.5050205@huawei.com> <20140603125728.GA26210@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140603125728.GA26210-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/6/3 20:57, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jun 03, 2014 at 12:04:38PM +0800, Li Zefan wrote:
>>  static void cgroup_get(struct cgroup *cgrp)
>>  {
>>  	WARN_ON_ONCE(cgroup_is_dead(cgrp));
>> -	css_get(&cgrp->self);
>> +	if (!(cgrp->self.flags & CSS_NO_REF))
>> +		css_get(&cgrp->self);
> 
> Hmmm?  The same condition is tested by css_get().  Why should it be
> tested again here?
> 

Oh, I completely ignored that.

>>  static void cgroup_put(struct cgroup *cgrp)
>>  {
>> -	css_put(&cgrp->self);
>> +	if (!(cgrp->self.flags & CSS_NO_REF))
>> +		css_put(&cgrp->self);
> 
> Ditto.
> 
>> @@ -1781,10 +1783,12 @@ static void cgroup_kill_sb(struct super_block *sb)
>>  	 * This prevents new mounts by disabling percpu_ref_tryget_live().
>>  	 * cgroup_mount() may wait for @root's release.
>>  	 */
>> -	if (css_has_online_children(&root->cgrp.self))
>> +	if (css_has_online_children(&root->cgrp.self)) {
>>  		cgroup_put(&root->cgrp);
>> -	else
>> -		percpu_ref_kill(&root->cgrp.self.refcnt);
>> +	} else {
>> +		if (root != &cgrp_dfl_root)
>> +			percpu_ref_kill(&root->cgrp.self.refcnt);
>> +	}
> 
> As conceptually percpu_ref_kill() just puts the base ref and the
> dfl_root's refcnt never reaches zero, it won't actually trigger.

Yes it will, just try mount && umount.

I think it's because cgroup_get() is a no-op for CSS_NO_REF, so it has
only the base ref, so percpu_ref_iill() will actually schedule the
call to css_release().

> Hmmm.... wouldn't the above leak a ref each time the default hierarchy
> is unmounted tho?  Shouldn't it be like the following?
> 

cgroup_get() is a no-op for root cgroup of the default root, so there's
no leak, but still better to call cgroup_put().

I'll send an updated patch.

> 	if (root == &cgrp_dfl_root || css_has_online_children(...))
> 		cgroup_put(&root->cgrp);
> 	else
> 		percpu_ref_kill(...);
> 
> Thanks.
> 
