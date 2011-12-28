From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Wed, 28 Dec 2011 14:12:35 +0800
Message-ID: <4EFAB353.9050705@cn.fujitsu.com>
References: <4EF9291D.7030208@cn.fujitsu.com> <20111227163535.GA17712@google.com> <4EFAB2E2.4040008@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFAB2E2.4040008-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Li Zefan wrote:
> Tejun Heo wrote:
>> Hello, Li.
>>
>> On Tue, Dec 27, 2011 at 10:10:37AM +0800, Li Zefan wrote:
>>> If we mount a hierarchy with a name specified, the name is unique,
>>> and we can use it to mount the hierarchy without specifying its
>>> set of subsystem names. This feature is documented is
>>> Documentation/cgroups/cgroups.txt section 2.3
>>>
>>> Here's an example:
>>>
>>> 	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
>>> 	# mount -t cgroup -o name=myhier xxx /cgroup2
>>>
>>> But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
>>> (cgroup: make the mount options parsing more accurate)
>>>
>>> This fixes the regression.
>>
>> Hmmm... so that has been broken over a year and nobody complained?  Is
>> there any valid use case where specifying mount path as all other
>> filesystems wouldn't work?  Is this 'name' thing necessary at all?
>> Maybe we should rip it out instead of fixing it?  We can just leave it
>> as non-functional name which does nothing but being visible in mount
>> listing.
>>
> 
> The "name" option was introduced along with the "none" option, so we
> can distinguish between different cgroup hierarchies which have no
> bound subsystems, like this:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
> 
> As the name is unique, we have this "mount by hierarchy name" feature.
> It looks reasonable, but I guess few people know this feature. We can
> live with it, as it only saves us some typing when mounting an existing

s/with/without

> hierarchy. On the other hand, removing this small feature can hardly
> result in code reduction.
