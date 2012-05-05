From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Sat, 05 May 2012 09:58:23 +0400
Message-ID: <4FA4C17F.7010700@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org> <4FA24E07.1010206@samsung.com>
 <20120503155012.GB5528@google.com> <4FA3D1D0.8000403@samsung.com>
 <20120504165433.GC24639@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120504165433.GC24639-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Hi

sorry for noise, but I have a question


     mode = cgroup_file_mode(cft);
     error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
     if (!error) {
         cfe->type = (void *)cft;
         cfe->dentry = dentry;
         dentry->d_fsdata = cfe;
         list_add_tail(&cfe->node, &parent->files);
         cfe = NULL;
     }
     dput(dentry);
out:
     kfree(cfe);
     return error;

this is from for-3.5 version. dput executes if cgroup_create_file fails 
and done correct. but in cgroup_create_file dget calls just before 
return, so if cgroup_create_file we call dput without dget. is this 
correct behavioural??


On 05/04/2012 08:54 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, May 04, 2012 at 04:55:44PM +0400, Alexander Nikiforov wrote:
>>>> -static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>>> +static struct cfent* cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>>>   			   const struct cftype *cft)
>>>>   {
>>>>   	struct dentry *dir = cgrp->dentry;
>>>> @@ -2696,12 +2717,13 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>>>
>>>>   	cfe = kzalloc(sizeof(*cfe), GFP_KERNEL);
>>>>   	if (!cfe)
>>>> -		return -ENOMEM;
>>>> +		return NULL;
>>>>
>>>>   	dentry = lookup_one_len(name, dir, strlen(name));
>>>>   	if (IS_ERR(dentry)) {
>>>>   		error = PTR_ERR(dentry);
>>>> -		goto out;
>>>> +		kfree(cfe);
>>>> +		return NULL;
>>>>   	}
>>>>
>>>>   	mode = cgroup_file_mode(cft);
>>>> @@ -2711,29 +2733,34 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>>>>   		cfe->dentry = dentry;
>>>>   		dentry->d_fsdata = cfe;
>>>>   		list_add_tail(&cfe->node,&parent->files);
>>>> -		cfe = NULL;
>>>>   	}
>>>>   	dput(dentry);
>>>> -out:
>>>> -	kfree(cfe);
>>>> -	return error;
>>>> +
>>>> +	return cfe;
>>>>   }
>>> Are you sure you're not creating a memory leak here?
>> code make the same things, just without goto. move kfree inside if
>> (IS_ERR(dentry), but before dput(dentry)  cfe set to NULL, so
>> kfree(cfe) will do nothing. I think it's without any mem leaks.
> I'm confused.  Who's freeing cfe after cgroup_create_file() failure?
> Also, why are you changing this at all?
>
> Thanks.
>


-- 
Best regards,
      Alex Nikiforov,
      Mobile SW, Advanced Software Group,
      Moscow R&D center, Samsung Electronics
