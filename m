From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
Date: Wed, 25 Jun 2014 09:56:31 +0800
Message-ID: <53AA2C4F.30808@huawei.com>
References: <53994943.60703@huawei.com> <539949A1.90301@huawei.com> <20140620193521.GB28324@mtj.dyndns.org> <53A8D2B8.4080107@huawei.com> <20140624210119.GC14909@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140624210119.GC14909-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/6/25 5:01, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jun 24, 2014 at 09:22:00AM +0800, Li Zefan wrote:
>>> Ah, right.  Gees, I'm really hating the fact that we have ->mount but
>>> not ->umount.  However, can't we make it a bit simpler by just
>>> introducing a mutex protecting looking up and refing up an existing
>>> root and a sb going away?  The only problem is that the refcnt being
>>> killed isn't atomic w.r.t. new live ref coming up, right?  Why not
>>> just add a mutex around them so that they can't race?
>>
>> Well, kill_sb() is called with sb->s_umount held, while kernfs_mount()
>> returned with sb->s_umount held, so adding a mutex will lead to ABBA
>> deadlock.
> 
> Hmmm?  Why does that matter?  The only region in cgroup_mount() which
> needs to be put inside such mutex would be root lookup, no?
> 

unfortunately that won't help. I think what you suggest is:

cgroup_mount()
{
	mutex_lock();
	lookup_cgroup_root();
	mutex_unlock();
	kernfs_mount();
}

cgroup_kill_sb()
{
	mutex_lock();
	percpu_ref_kill();
	mutex_Unlock();
	kernfs_kill_sb();
}

See, we may still be destroying the superblock after we've succeeded
in getting the refcnt of cgroup root.
