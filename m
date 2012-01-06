From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Fri, 06 Jan 2012 10:24:47 +0800
Message-ID: <4F065B6F.6060506@cn.fujitsu.com>
References: <4EF9291D.7030208@cn.fujitsu.com> <20111227163535.GA17712@google.com> <4EFAB2E2.4040008@cn.fujitsu.com> <20111228163631.GN17712@google.com> <4EFBD55E.5030106@cn.fujitsu.com> <20111229162313.GD3516@google.com> <4EFD531C.50300@cn.fujitsu.com> <20120105174507.GC18486@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120105174507.GC18486-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Tejun Heo wrote:
> Hello,
> 
> On Fri, Dec 30, 2011 at 01:58:52PM +0800, Li Zefan wrote:
>> Normal filesystems can have multi mount points, and an fs instance
>> is identified by device name, but cgroupfs ignores device name like
>> other pseudo filesystems. Instead a set of subsystems is used, so
>> to mount the same cgroupfs instance in different mount points, we
>> can do this:
>>
>> 	# mount -t cgroup -o cpuset xxx /cgroup1
>> 	# mount -t cgroup -o cpuset xxx /cgroup2
>>
>> Now we have the "none" option, so a cgroupfs can have no subsystems
>> bound to it, and we allow multi instances of such cgroupfs, so we
>> have to assign names to each instance:
>>
>> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
>> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
>>
>> Then we want to also mount "hier1" in another mount point, we can't
>> do this:
>>
>> 	# mount -t cgroup -o none xxx /mnt
>>
>> because we have two different instances with "none" subsystem. So
>> we specify its name:
>>
>> 	# mount -t cgroup -o none,name=hier1 xxx /mnt
>>
>> Hope I have made things clear to you?
> 
> mount --bind?  It's not exactly the same thing but I don't think the
> differences would matter for cgroup.

There's a corner case where "mount --bind" can't be used:

	# mount -t cgroup -o none,name=hier1 xxx /mnt
	# mkdir /mnt/tmp
	# umount /mnt

Since there's a sub-cgroup in it, umount won't destroy the hierarchy,
but "hide" it, so the name=xxx is necessary to re-mount it.

> Also, what's the use case for
> mounting the same cgroup directory multiple times?  Why is that
> necessary?  Is it useful for some namespace-savvy setup?
> 

I don't have a use case in real life. It was made so at the very
beginning of cgroup, and we should't break it without strong reasons.
We can mount other pseudo filesystems like procfs, sysfs and debugfs
multiple times, right?
