From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
Date: Fri, 27 Jun 2014 14:32:33 +0800
Message-ID: <53AD1001.4090405@huawei.com>
References: <53994943.60703@huawei.com> <539949A1.90301@huawei.com> <20140620193521.GB28324@mtj.dyndns.org> <53A8D2B8.4080107@huawei.com> <20140624210119.GC14909@htj.dyndns.org> <53AA2C4F.30808@huawei.com> <20140625150053.GE26883@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140625150053.GE26883-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/6/25 23:00, Tejun Heo wrote:
> Hey,
> 
> On Wed, Jun 25, 2014 at 09:56:31AM +0800, Li Zefan wrote:
>>> Hmmm?  Why does that matter?  The only region in cgroup_mount() which
>>> needs to be put inside such mutex would be root lookup, no?
>>
>> unfortunately that won't help. I think what you suggest is:
>>
>> cgroup_mount()
>> {
>> 	mutex_lock();
>> 	lookup_cgroup_root();
>> 	mutex_unlock();
>> 	kernfs_mount();
>> }
>>
>> cgroup_kill_sb()
>> {
>> 	mutex_lock();
>> 	percpu_ref_kill();
>> 	mutex_Unlock();
>> 	kernfs_kill_sb();
>> }
>>
>> See, we may still be destroying the superblock after we've succeeded
>> in getting the refcnt of cgroup root.
> 
> Sure, but now the decision to kill is synchronized so the other side
> can interlock with it.  e.g.
> 
> cgroup_mount()
> {
> 	mutex_lock();
> 	lookup_cgroup_root();
> 	if (root isn't killed yet)
> 		root->this_better_stay_alive++;
> 	mutex_unlock();
> 	kernfs_mount();
> }
> 
> cgroup_kill_sb()
> {
> 	mutex_lock();
> 	if (check whether root can be killed)
> 		percpu_ref_kill();
> 	mutex_unlock();
> 	if (the above condition was true)
> 		kernfs_kill_sb();
> }
> 

This looks nasty, and I don't think it's correct. If we skip the call
to kernfs_kill_sb(), kernfs_super_info won't be freed but super_block
will, so we will end up either leaking memory or accessing invalid
memory. There are other problems like returning with sb->s_umount still
held.
