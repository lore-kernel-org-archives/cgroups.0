From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup: fix cgroup_path() vs rename() race, take
 2
Date: Tue, 19 Feb 2013 09:44:17 +0800
Message-ID: <5122D8F1.8000101@huawei.com>
References: <51218100.5020007@huawei.com> <20130218173023.GG17414@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130218173023.GG17414-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/2/19 1:30, Tejun Heo wrote:
> Hello, Li.
> 
> On Mon, Feb 18, 2013 at 09:16:48AM +0800, Li Zefan wrote:
>> @@ -171,6 +171,7 @@ struct cgroup {
>>  
>>  	struct cgroup *parent;		/* my parent */
>>  	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
>> +	char __rcu *name;		/* a copy of dentry->d_name */
> 
> A brief explanation of why this is necessary and how rcu is used would
> be nice.
> 

The comments in cgroup_path() explains why we can't use dentry->d_name,
which suggests why cgrp->name is needed. I'll revise the comments there,
and add comments on the rcu thing.

>> +static char *cgroup_alloc_name(struct dentry *dentry)
>> +{
>> +	char *name;
>> +
>> +	name = kmalloc(dentry->d_name.len + 1, GFP_KERNEL);
>> +	if (!name)
>> +		return NULL;
>> +	memcpy(name, dentry->d_name.name, dentry->d_name.len);
>> +	name[dentry->d_name.len] = '\0';
>> +	return name;
>> +}
> 
> While d_name has length field, it's always properly NULL terminated,
> so kstrdup() should suffice here.  Right, Al?
> 

Oh you're right. We pass dentry->d_name.name to printk %s in other places.

>> @@ -1613,13 +1626,19 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
> ...
>> -		inode = sb->s_root->d_inode;
>> +		dentry = sb->s_root;
>> +		inode = dentry->d_inode;
>> +
>> +		root_cgrp->name = cgroup_alloc_name(dentry);
>> +		if (!root_cgrp->name)
>> +			goto drop_new_super;
> 
> Don't we need an RCU assignment?  Is it safe because it isn't online
> yet?  But wouldn't this still trigger sparse warning?
> 

Yeah, it's safe.

To be frank, I haven't used sparse for years. Will check.

>> @@ -1751,6 +1770,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
>>  	mutex_unlock(&cgroup_root_mutex);
>>  	mutex_unlock(&cgroup_mutex);
>>  
>> +	synchronize_rcu();
> 
> An explanation on what we're synchronizing would be nice.  Barriers
> without explanation sucks because there's nothing directly linking the
> barriers to the things which are being protected.
> 
>> @@ -2539,13 +2558,41 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
>>  static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
>>  			    struct inode *new_dir, struct dentry *new_dentry)
>>  {
> ...
>> +	old_name = cgrp->name;
>> +	rcu_assign_pointer(cgrp->name, name);
>> +
>> +	synchronize_rcu();
> 
> Please don't call synchronize_rcu() from interface which is directly
> visible to userland.  It leads to sporadic difficult-to-reproduce
> latencies which hurt enough in corner cases and this is kmalloc
> memory.  It's not like kfree_rcu() is difficult to use or anything.
> 

ok

>> +	kfree(old_name);
>> +	return 0;
>>  }
>>  
>>  static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
>> @@ -4144,9 +4191,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>>  	if (!cgrp)
>>  		return -ENOMEM;
>>  
>> +	cgrp->name = cgroup_alloc_name(dentry);
>> +	if (!cgrp->name)
>> +		goto err_free_cgrp;
> 
> Ditto with assignment.
> 
> Thanks.
> 
