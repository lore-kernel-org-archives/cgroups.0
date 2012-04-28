From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFD/RFC v2] event about group change
Date: Sat, 28 Apr 2012 09:40:49 +0400
Message-ID: <4F9B82E1.3070602@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120427223455.GU26595-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Hi,

Tejun thx for your reply. I need to have agreement with 
cgroup_add_file() and I'll post v3. Comments on your comments below

On 04/28/2012 02:34 AM, Tejun Heo wrote:
> Hello,
>
> I like it generally (well I suggested it so...) but can you please
> post a proper patch with SOB against cgroup/for-3.5 branch?
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5
About for-3.5 - sure. I'll do it. Sorry, but what is SOB? :)
> Also, can you please cc fsnotify people so that they can go over the
> new usage?
Done. But unfortunately mail from my box not reach Li Zefan. Routing loop.

>> @@ -179,6 +179,8 @@ struct cgroup {
>>   	struct cgroup *parent;		/* my parent */
>>   	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
>>
>> +	struct dentry *tasks_dentry;	/* "tasks" dentry */
> Urgh... not the prettiest but I suppose it's necessary.  It will
> probably be better to point to cfent instead.
Are you talking about struct cftype. If yes, I think for now put 
tasks_dentry into cgroup better. But if we can take dentry directly from 
cftype (look on this, for now I have no idea how can I do it)
it will be of course better. If we can't take, we will have pointer to 
every file inside cgroup. Since for memcg we have different event 
approach, I don't think this proper way.
>> +static inline void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)
> No need to make it inline.
Ok
>> +{
>> +	struct cgroupfs_root *root;
>> +	struct inode	*d_inode;
>> +	struct cgroup	*cgrp;
> What are the locking rules?
fsnotify_cgroup() called inside cgroup_lock(), is it not sufficient??
>> +	for_each_active_root(root) {
>> +		cgrp = task_cgroup_from_root(tsk, root);
>> +		d_inode = cgrp->tasks_dentry->d_inode;
>> +
>> +		fsnotify_parent(NULL, cgrp->tasks_dentry, mask);
>> +		fsnotify(d_inode, mask, d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> The interface is rather weird.  It's called fsnotify_cgroup() and it
> always generates the requested event on its tasks file?
>
yes
>>   int cgroup_add_file(struct cgroup *cgrp,
>>   		       struct cgroup_subsys *subsys,
>> -		       const struct cftype *cft)
>> +		       const struct cftype *cft,
>> +		       int tasks)
> Ugh... this is ugly.
yes. I wrote about this. But run_callback in do_exit()->cgroup_exit() 
works on this way.
>>   {
>>   	struct dentry *dir = cgrp->dentry;
>>   	struct dentry *dentry;
>> @@ -2629,6 +2649,12 @@ int cgroup_add_file(struct cgroup *cgrp,
>>   		dput(dentry);
>>   	} else
>>   		error = PTR_ERR(dentry);
>> +
>> +	if(tasks) {
>            ^ missing space
>
>> +		pr_warn("%s(): cft name: %s\n", __func__, name);
> Why pr_warn?
sorry, I sent this patch RFC, forgot to clean up.
>
>> +		cgrp->tasks_dentry = dentry;
>> +	}
>> +
>>   	return error;
>>   }
>>   EXPORT_SYMBOL_GPL(cgroup_add_file);
>> @@ -2640,7 +2666,7 @@ int cgroup_add_files(struct cgroup *cgrp,
>>   {
>>   	int i, err;
>>   	for (i = 0; i<  count; i++) {
>> -		err = cgroup_add_file(cgrp, subsys,&cft[i]);
>> +		err = cgroup_add_file(cgrp, subsys,&cft[i], 0);
>>   		if (err)
>>   			return err;
>>   	}
>> @@ -3642,12 +3668,16 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
>>   	/* First clear out any existing files */
>>   	cgroup_clear_directory(cgrp->dentry);
>>
>> -	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
>> +	err = cgroup_add_file(cgrp, NULL, files, 1);
>> +	if (err)
>> +		return err;
>> +
>> +	err = cgroup_add_files(cgrp, NULL, files + 1, ARRAY_SIZE(files) - 1);
>>   	if (err<  0)
>>   		return err;
>>
>>   	if (cgrp == cgrp->top_cgroup) {
>> -		if ((err = cgroup_add_file(cgrp, NULL,&cft_release_agent))<  0)
>> +		if ((err = cgroup_add_file(cgrp, NULL,&cft_release_agent, 0))<  0)
>>   			return err;
>>   	}
> Wouldn't it be better to make cgroup_add_file() return the created cft
> and let the caller handle the tasks special case?  Also, why use 1/0
> for boolean values instead of true/false?
How can I understand that this cft from tasks, only with strcmp with 
name. Don't think this is the best way, but my way ugly too.
About 1/0 try to write on current way, just made it like run_callbacks
>> @@ -4480,6 +4510,7 @@ static const struct file_operations proc_cgroupstats_operations = {
>>    */
>>   void cgroup_fork(struct task_struct *child)
>>   {
>> +
> Why the new line?
Forgot to cleanup
>
> Thanks.
>

Thanks.

-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
