From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Fri, 04 May 2012 16:55:44 +0400
Message-ID: <4FA3D1D0.8000403@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org> <4FA24E07.1010206@samsung.com>
 <20120503155012.GB5528@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120503155012.GB5528-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On 05/03/2012 07:50 PM, Tejun Heo wrote:
>> Signed-off-by: Alex Nikiforov<a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Please read how other patches are being posted.  You need to explain
> what the patch does and why.
Sorry, I will.
>
>> +static void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)
>> +{
>> +	struct cgroupfs_root *root;
>> +	struct inode	*d_inode;
>> +	struct cgroup	*cgrp;
> Please read how other local variable definitions are indented.  Read
> the coding style and follow your surroundings.
>
>> +	lockdep_assert_held(&cgroup_mutex);
>> +
>> +	for_each_active_root(root) {
>> +		cgrp = task_cgroup_from_root(tsk, root);
>> +		d_inode = cgrp->tasks_cfe->dentry->d_inode;
> Why not define these variables inside loop?
sure
>
>> +		fsnotify_parent(NULL, cgrp->tasks_cfe->dentry, mask);
>> +		fsnotify(d_inode, mask, d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
>> +	}
>> +}
>> +
>>   /*
>>    * There is one global cgroup mutex. We also require taking
>>    * task_lock() when dereferencing a task's cgroup subsys pointers.
>> @@ -1978,6 +1996,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>>   		goto out;
>>   	}
>>
>> +	/* cgroup_attach_task() already guarded by cgroup_lock by caller */
> If you have lockdep annotation, I don't think this is necessary.
Ok
>
>> +	fsnotify_cgroup(tsk, FS_MODIFY);
>> +
>>   	cgroup_task_migrate(cgrp, oldcgrp, tsk, newcg);
>>
>>   	for_each_subsys(root, ss) {
>> @@ -2669,7 +2690,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>>   	return mode;
>>   }
>>
>> -static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>> +static struct cfent* cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>   			   const struct cftype *cft)
>>   {
>>   	struct dentry *dir = cgrp->dentry;
>> @@ -2696,12 +2717,13 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>
>>   	cfe = kzalloc(sizeof(*cfe), GFP_KERNEL);
>>   	if (!cfe)
>> -		return -ENOMEM;
>> +		return NULL;
>>
>>   	dentry = lookup_one_len(name, dir, strlen(name));
>>   	if (IS_ERR(dentry)) {
>>   		error = PTR_ERR(dentry);
>> -		goto out;
>> +		kfree(cfe);
>> +		return NULL;
>>   	}
>>
>>   	mode = cgroup_file_mode(cft);
>> @@ -2711,29 +2733,34 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>   		cfe->dentry = dentry;
>>   		dentry->d_fsdata = cfe;
>>   		list_add_tail(&cfe->node,&parent->files);
>> -		cfe = NULL;
>>   	}
>>   	dput(dentry);
>> -out:
>> -	kfree(cfe);
>> -	return error;
>> +
>> +	return cfe;
>>   }
> Are you sure you're not creating a memory leak here?

code make the same things, just without goto. move kfree inside if 
(IS_ERR(dentry), but before dput(dentry)  cfe set to NULL, so kfree(cfe) 
will do nothing. I think it's without any mem leaks.

>
>>   static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>   			      const struct cftype cfts[], bool is_add)
>>   {
>>   	const struct cftype *cft;
>> -	int err, ret = 0;
>> +	struct cfent *cfe;
>> +	int ret = 0;
>>
>>   	for (cft = cfts; cft->name[0] != '\0'; cft++) {
>> -		if (is_add)
>> -			err = cgroup_add_file(cgrp, subsys, cft);
>> -		else
>> -			err = cgroup_rm_file(cgrp, cft);
>> -		if (err) {
>> -			pr_warning("cgroup_addrm_files: failed to %s %s, err=%d\n",
>> -				   is_add ? "add" : "remove", cft->name, err);
>> -			ret = err;
>> +		if (is_add) {
>> +			cfe = cgroup_add_file(cgrp, subsys, cft);
>> +			if(!cfe) {
>> +				pr_warning("%s: failed to add %s\n",
>> +					   __func__, cft->name);
>> +				ret = -1;
>> +			} else if(strcmp(cft->name, "tasks") == 0)
>                                   ^
> 				space here.
>
> Please read Documents/CodingStyle.
Sorry, fixed.
>
>> +				cgrp->tasks_cfe = cfe;
>> +		} else {
>> +			if (cgroup_rm_file(cgrp, cft)) {
>> +				pr_warning("%s: failed to remove %s\n",
>> +					   __func__, cft->name);
>> +				ret = -1;
>> +			}
> Please don't bury this inside cgroup_addrm_files() with strcmp()
> trying to find out again which one is the task file - in general, if
> you're doing strcmp() inside kernel which isn't parsing userland
> input, something is wrong.  Just separate out the cftype of task file
> into a standalone entry and let cgroup_populate_dir() call
> cgroup_add_file() on it and then record the returned cfe.
done
>
> Thanks.
>

Thx, for your time.

-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
