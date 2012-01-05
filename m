From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Thu, 05 Jan 2012 10:20:36 +0800
Message-ID: <4F0508F4.2020705@cn.fujitsu.com>
References: <4EF9291D.7030208@cn.fujitsu.com> <20111227163535.GA17712@google.com> <4EFAB2E2.4040008@cn.fujitsu.com> <20111228163631.GN17712@google.com> <4EFBD55E.5030106@cn.fujitsu.com> <20111229162313.GD3516@google.com> <4EFD531C.50300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFD531C.50300-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Any comments on this?

Li Zefan wrote:
> Tejun Heo wrote:
>> Hello,
>>
>> On Thu, Dec 29, 2011 at 10:50:06AM +0800, Li Zefan wrote:
>>> Tejun Heo wrote:
>>>> Hello, Li.
>>>>
>>>> On Wed, Dec 28, 2011 at 02:10:42PM +0800, Li Zefan wrote:
>>>>> The "name" option was introduced along with the "none" option, so we
>>>>> can distinguish between different cgroup hierarchies which have no
>>>>> bound subsystems, like this:
>>>>>
>>>>> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
>>>>> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
>>>>>
>>>>> As the name is unique, we have this "mount by hierarchy name" feature.
>>>>
>>>> I could be missing something but does that add anything other than
>>>> naming convenience?
>>>
>>> The name option is necessary, otherwise how can we mount hierarchies
>>> as shown in the above example?
>>
>> I don't think mounting itself would be a problem.  We don't need name
>> option to create multiple tmpfs instances, right?  The problem is
> 
> Right, but you can't mount the same tmpfs instance in more than one mount
> point.
> 
>> referencing to them after they're created.  Filesystems generally
>> don't need such identifier because, once they're created, they can be
>> referenced by their mount points.  I'm still not very familiar with
>> different corners of cgroup, so it's entirely possible that I'm
>> missing something.  If I am, please point me to it.
>>
> 
> Normal filesystems can have multi mount points, and an fs instance
> is identified by device name, but cgroupfs ignores device name like
> other pseudo filesystems. Instead a set of subsystems is used, so
> to mount the same cgroupfs instance in different mount points, we
> can do this:
> 
> 	# mount -t cgroup -o cpuset xxx /cgroup1
> 	# mount -t cgroup -o cpuset xxx /cgroup2
> 
> Now we have the "none" option, so a cgroupfs can have no subsystems
> bound to it, and we allow multi instances of such cgroupfs, so we
> have to assign names to each instance:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
> 
> Then we want to also mount "hier1" in another mount point, we can't
> do this:
> 
> 	# mount -t cgroup -o none xxx /mnt
> 
> because we have two different instances with "none" subsystem. So
> we specify its name:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /mnt
> 
> Hope I have made things clear to you?
> 
>>>> If it's a redundant feature which has been broken over a year without
>>>> anyone complaining, it really doesn't need to exist.  It might not
>>>> save a lot of code but would save some WTH moments.
>>>>
>>>
>>> The redundant feature is mouting existing hierarchies by specifying name
>>> only, and the cleanup patch I sent has this feature removed in effect.
>>>
>>> kernel/cgroup.c |   15 +++++++--------
>>> 1 files changed, 7 insertions(+), 8 deletions(-)
>>>
>>> This is why I'm not so keen to remove the feature.
>>
>> Code reduction is definitely a plus and I don't want to remove a
>> useful feature either, but an unusual redundant feature without
>> necessity is confusing / misleading even if it doesn't necessasrily
>> add a lot of code complexity.
>>
>> Also, I at least want to understand why it's actually necessary before
>> applying the patches.  :)
>>
> 
> What I try to fix here is the behavior of "mount -t cgroup -o name=xxx ..."
> (no other options are specified), so what behavior do we want?
> 
> 1. find if any existing cgroupfs instance matches the name, which is
> the orginal behavior.
> 
> 2. the same as "mount -t cgroup -o all,name=xxx ...", which is the
> current behavior due to the commit that broke (1).
> 
> 3. make it invalid and fail to mount.
> 
> 4. any other idea?
