From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sysfs: fix namespace refcnt leak
Date: Wed, 19 Feb 2014 09:39:28 +0800
Message-ID: <53040B50.4060600@huawei.com>
References: <53018813.7030409@huawei.com> <20140218231242.GJ31892@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140218231242.GJ31892-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/19 7:12, Tejun Heo wrote:
> Hey,
> 
> On Mon, Feb 17, 2014 at 11:54:59AM +0800, Li Zefan wrote:
>> I think we have to fix kernfs in order to fix refcnt leak in sysfs
>> and cgroupfs. This fix is for 3.14, but it creates conflicts for
>> cgroup-next.
>>
>> ====================
>>
>> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
>> ns refcnt unconditionally in sysfs_mount(), and instead we should
>> get the refcnt only when kernfs_mount() allocated a new superblock.
> 
> Ugh... nasty :(
> 
>> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>>   * @flags: mount flags specified for the mount
>>   * @root: kernfs_root of the hierarchy being mounted
>>   * @ns: optional namespace tag of the mount
>> + * @new: tell the caller if we allocated a new superblock
> 
> Maybe something like @new_sb_created is better?
> 
>>  	struct super_block *sb;
>>  	struct kernfs_super_info *info;
>>  	int error;
>>  
>> +	*new_sb = false;
> 
> Can we make it optional so that users who don't care about it can
> ignore it?
> 

cgroupfs also needs this to fix refcnt leak.

Because success in finding an existing cgroup_root doesn't mean no new
superblock is needed. For example:

  # mount -t cgroup -o cpuacct xxx /cgroup
  # mkdir /cgroup/tmp
  # umount /cgroup    <--- sb will be freed but cgroup_root won't

  // this will allocate new sb, but we find the cgroup_root is there.
  # mount -t cgroup -o cpuacct xxx /cgroup

But debugfs won't need this if it's converted to kernfs.

How about I keep kernfs_mount() API intact, and when this fix gets
merged into mainline, you merge the fix into cgroup-next, and then
I make a fix for cgroup by changing kernfs_mount()?

>> @@ -430,9 +431,9 @@ static inline int kernfs_rename(struct kernfs_node *kn,
>>  
>>  static inline struct dentry *
>>  kernfs_mount(struct file_system_type *fs_type, int flags,
>> -	     struct kernfs_root *root)
>> +	     struct kernfs_root *root, bool *new_sb)
>>  {
>> -	return kernfs_mount_ns(fs_type, flags, root, NULL);
>> +	return kernfs_mount_ns(fs_type, flags, root, NULL, new_sb);
> 
> And let kernfs_mount() just use NULL for the parameter?
> 

