From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Wed, 4 Jul 2012 13:56:24 +0800
Message-ID: <4FF3DB08.5080606@huawei.com>
References: <4FEEA5CB.8070809@huawei.com> <20120703170317.GB555@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120703170317.GB555-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org

>> @@ -78,8 +79,8 @@ struct cgroup_subsys_state {

>>  	/* ID for this css, if possible */
>>  	struct css_id __rcu *id;
>>  
>> -	/* Used to put @cgroup->dentry on the last css_put() */
>> -	struct work_struct dput_work;
>> +	/* Used to put @cgroup->css_refs on the last css_put() */
>> +	struct work_struct put_work;
>>  };
>>  
>>  /* bits in struct cgroup_subsys_state flags field */
>> @@ -170,6 +171,9 @@ struct cgroup {
>>  	 */
>>  	atomic_t count;
>>  
>> +	/* We won't destroy the cgroup when there are css refs */
>> +	struct kref css_refs;
>> +
>>  	/*
>>  	 * We link our 'sibling' struct into our parent's 'children'.
>>  	 * Our children link their 'sibling' into our 'children'.
> 
> Hmm... adding another layer of refcnting.  Now we end up with three
> layers of refcnting - the active usage via cgroup->count, cgroup
> lifetime via cgroup->dentry->d_count and this extended lifecycle
> refcnt.  In addition, we now have to deal with partially destroyed
> cgroups - e.g. running cgroup_path() will oops on lingering cgroups.
> Hating this tangling of dentries and cgroups more and more.  :(
> 


yeah, the fix you sent looks better.
