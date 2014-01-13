From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: cgroups aware proc
Date: Mon, 13 Jan 2014 11:26:08 +0800
Message-ID: <52D35CD0.9070602@huawei.com>
References: <52C78E09.60904@yuhu.biz> <52C8A36B.6030201@yuhu.biz> <52CBE22F.1010106@huawei.com> <52CC3C80.8030603@yuhu.biz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52CC3C80.8030603-NV7Lj0SOnH0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Cc: lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

>> People tried to do this before, but got rejected by upstream maintainers,
>> and then the opinion was to do this in userspace throught FUSE.
>>
>> Seems libvirt-lxc already supports containerized /proc/meminfo in this way.
>> See:
>>     http://libvirt.org/drvlxc.html
> 
> I'm well aware of the FUSE approach and the fact that the kernel maintainers do not accept the this kind of changing the kernel but the simple truth is that FUSE is too have for this thing.
> 
> I'm setting up a repo on GitHub which will hold all the patches for this and will keep updating it even if it is not accepted by the upstream maintainers. I'll give you the link within a few days.
> 
> I have already finished with CPU and Memory... the only thing that is left is the /proc/loadavg, which will take more time, but will be done.
> 
> I hope some of the scheduler maintainers at least to give me some comments on the patches that I have done.
> 

Then you should add Peter, Ingo and LKML to your Cc list. :)
