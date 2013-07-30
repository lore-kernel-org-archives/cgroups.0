From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 1/8] cgroup: convert cgroup_ida to cgroup_idr
Date: Tue, 30 Jul 2013 09:10:19 +0800
Message-ID: <51F7127B.1070107@huawei.com>
References: <51F614B2.6010503@huawei.com> <51F614C4.7060602@huawei.com> <20130729182835.GD26076@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130729182835.GD26076@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On 2013/7/30 2:28, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jul 29, 2013 at 03:07:48PM +0800, Li Zefan wrote:
>> @@ -4590,6 +4599,9 @@ static void cgroup_offline_fn(struct work_struct *work)
>>  	/* delete this cgroup from parent->children */
>>  	list_del_rcu(&cgrp->sibling);
>>  
>> +	if (cgrp->id)
>> +		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
>> +
> 
> Yeap, if we're gonna allow lookups, removal should happen here but can
> we please add short comment explaining why that is?

sure

> Also, do we want to clear cgrp->id?
> 

Set cgrp->id to 0? No, 0 is a valid id. The if is here because at first
I called idr_alloc() very late in cgroup_create(), so cgroup_offline_fn()
can be called while cgrp->id hasn't been initialized. Now I can remove
this check.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
