From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cpuset filesystems - a (short) doubt
Date: Wed, 3 Apr 2013 11:52:45 +0800
Message-ID: <515BA78D.6020405@huawei.com>
References: <CAJJAcocYoD2ZoUBXNa7jHMnhcwHBKNUKt5AKUUBkXH=-SRr5ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJJAcocYoD2ZoUBXNa7jHMnhcwHBKNUKt5AKUUBkXH=-SRr5ZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Shwatrz <dshwatrz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/4/2 22:17, David Shwatrz wrote:
> Hi,
> I have a question about cpuset filesystem - is it needed ?
> 
> In the cpuset example given in:
> http://lxr.free-electrons.com/source/Documentation/cgroups/cgroups.txt
> we do not use the cpuset filesystsm but the cgroup filesystsm.
> (mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset)
> 
> On my distro, which uses systemd + cgroups:
> mount | grep "type cpuset"
> gives nothing.
> 
> On the other hands, mount | grep "type cgroup" | wc -l
> gives: 9
> 
> I looked in the code of other subsystems (like blk cgroup and  memcg -
> memory control groups) and there is no filesystsm in the code; see
> block/blk-cgroup.c
> mm/memcontrol.c
> 
> so is the cpuset filesystsm really needed ?
> 

The cpuset filesystem is for backward compatibility.
