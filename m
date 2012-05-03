From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFD/RFC v2] event about group change
Date: Thu, 03 May 2012 13:17:39 +0400
Message-ID: <4FA24D33.7080202@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120428214131.GB4586-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On 04/29/2012 01:41 AM, Tejun Heo wrote:
> Hello,
>
> On Sat, Apr 28, 2012 at 09:40:49AM +0400, Alexander Nikiforov wrote:
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5
>> About for-3.5 - sure. I'll do it. Sorry, but what is SOB? :)
> Signed-off-by tag.  Sorry about the abbreviation.

done

>
>>> Also, can you please cc fsnotify people so that they can go over the
>>> new usage?
>> Done. But unfortunately mail from my box not reach Li Zefan. Routing loop.
> His new mail address is lizefan-hv44wF8Li92Xj1p+fO2waQ@public.gmane.org

done

>
>>>> @@ -179,6 +179,8 @@ struct cgroup {
>>>>   	struct cgroup *parent;		/* my parent */
>>>>   	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
>>>>
>>>> +	struct dentry *tasks_dentry;	/* "tasks" dentry */
>>> Urgh... not the prettiest but I suppose it's necessary.  It will
>>> probably be better to point to cfent instead.
>> Are you talking about struct cftype. If yes, I think for now put
>> tasks_dentry into cgroup better. But if we can take dentry directly
>> from cftype (look on this, for now I have no idea how can I do it)
>> it will be of course better. If we can't take, we will have pointer
>> to every file inside cgroup. Since for memcg we have different event
>> approach, I don't think this proper way.
> If you look at cgroup/for-3.5 branch, there's new entry named struct
> cfent representing each instance of the file which has a pointer to
> the matching dentry.

done

>
>>>> +{
>>>> +	struct cgroupfs_root *root;
>>>> +	struct inode	*d_inode;
>>>> +	struct cgroup	*cgrp;
>>> What are the locking rules?
>> fsnotify_cgroup() called inside cgroup_lock(), is it not sufficient??
> I was hoping for lockdep_assert_held() annotation. :)

done

>
>>> Wouldn't it be better to make cgroup_add_file() return the created cft
>>> and let the caller handle the tasks special case?  Also, why use 1/0
>>> for boolean values instead of true/false?
>> How can I understand that this cft from tasks, only with strcmp with
>> name. Don't think this is the best way, but my way ugly too.
>> About 1/0 try to write on current way, just made it like run_callbacks
> I meant separating out "task" cftype entry and creating it separately
> using a function returning the created cfent and storing it.  Instead
> of putting the special logic inside file creation function.

done

>
> Thanks.
>

Please review new version

Thanks

-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
