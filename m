From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] patch
Date: Thu, 05 Apr 2012 07:38:21 +0400
Message-ID: <4F7D13AD.3030309@samsung.com>
References: <4F7928BE.8000502@samsung.com> <4F792976.4090503@samsung.com>
 <20120402102931.GA5885@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120402102931.GA5885-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi guys, I investigate

http://lwn.net/Articles/453642/

seems that this really fit my proposal and I can make move this 
functionality from core to this css. But, unfortunately, Frederic git is 
not available on kernel.org and current Linux kernel doesn't have this 
patches. Could you be so kind to provide link to the kernel with this 
patches.

On 04/02/2012 02:29 PM, Kirill A. Shutemov wrote:
> On Mon, Apr 02, 2012 at 08:22:14AM +0400, Alexander Nikiforov wrote:
>
> I think it should be part of task counter css, not core.
> CC list updated.
>
>> @@ -4558,6 +4594,22 @@ void cgroup_fork(struct task_struct *child)
>>   	child->cgroups = current->cgroups;
>>   	get_css_set(child->cgroups);
>>   	INIT_LIST_HEAD(&child->cg_list);
>> +
>> +	struct cgroupfs_root *root;
>> +
>> +	/* send event to the userspace */
>> +	mutex_lock(&cgroup_mutex);
>> +	for_each_active_root(root) {
>> +		struct cgroup *cgrp;
>> +		struct fe_eventfd_list *ev;
>> +
>> +		cgrp = task_cgroup_from_root(child, root);
>> +
>> +		list_for_each_entry(ev,&cgrp->fe_notify, list) {
>> +			eventfd_signal(ev->eventfd, 1);
>> +		}
>> +	}
>> +	mutex_unlock(&cgroup_mutex);
>>   }
> How does it affect performance?
>
>>
>>   /**
>> @@ -4653,6 +4705,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>>   {
>>   	struct css_set *cg;
>>   	int i;
>> +	struct cgroupfs_root *root;
>>
>>   	/*
>>   	 * Unlink from the css_set task list if necessary.
>> @@ -4666,6 +4719,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>>   		write_unlock(&css_set_lock);
>>   	}
>>
>> +	/* send event to the userspace */
>> +	mutex_lock(&cgroup_mutex);
>> +	for_each_active_root(root) {
>> +		struct cgroup *cgrp;
>> +		struct fe_eventfd_list *ev;
>> +
>> +		cgrp = task_cgroup_from_root(tsk, root);
>> +
>> +		list_for_each_entry(ev,&cgrp->fe_notify, list) {
>> +			eventfd_signal(ev->eventfd, 1);
>> +		}
>> +	}
>> +	mutex_unlock(&cgroup_mutex);
>> +
> I think it's racy. You need to notify userspace after reassigning the
> task, not before.
>
>>   	/* Reassign the task to the init_css_set. */
>>   	task_lock(tsk);
>>   	cg = tsk->cgroups;
>


-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
