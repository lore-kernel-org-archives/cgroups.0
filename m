From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: cgroups aware proc
Date: Tue, 7 Jan 2014 19:16:50 +0800
Message-ID: <52CBE222.9030404@huawei.com>
References: <52C78E09.60904@yuhu.biz> <52C8A36B.6030201@yuhu.biz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52C8A36B.6030201-NV7Lj0SOnH0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Cc: lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On 2014/1/5 8:12, Marian Marinov wrote:
> Happy new year guys.
> 
> I need to have /proc cgroups aware, as I want to have LXC containers that see only the resources that are given to them.
> 
> In order to do that I had to patch the kernel. I decided to start with cpuinfo, stat and interrupts and then continue
> with meminfo and loadavg.
> 
> I managed to patch the Kernel (linux 3.12.0) and make /proc/cpuinfo, /proc/stat and /proc/interrupts be cgroups aware.
> 
> Attached are the patches that make the necessary changes.
> 
> The change for /proc/cpuinfo and /proc/interrupts is currently done only for x86 arch, but I will patch the rest of the
> architectures if the style of the patches is acceptable.
> 
> Tomorrow I will check if the patches apply and build with the latest kernel.
> 

People tried to do this before, but got rejected by upstream maintainers,
and then the opinion was to do this in userspace throught FUSE.

Seems libvirt already supports containerized /proc/meminfo in this way.
See:
	http://libvirt.org/drvlxc.html
