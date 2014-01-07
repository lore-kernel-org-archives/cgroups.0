From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Subject: Re: RFC: cgroups aware proc
Date: Tue, 07 Jan 2014 19:42:24 +0200
Message-ID: <52CC3C80.8030603@yuhu.biz>
References: <52C78E09.60904@yuhu.biz> <52C8A36B.6030201@yuhu.biz> <52CBE22F.1010106@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yuhu.biz; s=default;
	t=1389116539; bh=y0gRr5sl3tocZ4DpCxbfimI1TcrTDcLnGf0VDu1LI5Y=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=tYFmn8bzL2tc7zgfT9QqF8WNzqYCSGG2P17LQ3NaYyqZ6DUf7mGLQtLyh8RYP54ZJ
	 k1enbQaHoH+JSspies6diF/9VihHVU6BTaGuAyDHzeRCfYru8+/X3Wrv+xerEXa0EB
	 bCp82+2IRBDJuAc9MFyoMhp8F2n9uXqrWsMMhNCc=
In-Reply-To: <52CBE22F.1010106-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On 01/07/2014 01:17 PM, Li Zefan wrote:
> On 2014/1/5 8:12, Marian Marinov wrote:
>> Happy new year guys.
>>
>> I need to have /proc cgroups aware, as I want to have LXC containers that see only the resources that are given to them.
>>
>> In order to do that I had to patch the kernel. I decided to start with cpuinfo, stat and interrupts and then continue
>> with meminfo and loadavg.
>>
>> I managed to patch the Kernel (linux 3.12.0) and make /proc/cpuinfo, /proc/stat and /proc/interrupts be cgroups aware.
>>
>> Attached are the patches that make the necessary changes.
>>
>> The change for /proc/cpuinfo and /proc/interrupts is currently done only for x86 arch, but I will patch the rest of the
>> architectures if the style of the patches is acceptable.
>>
>> Tomorrow I will check if the patches apply and build with the latest kernel.
>>
>
> People tried to do this before, but got rejected by upstream maintainers,
> and then the opinion was to do this in userspace throught FUSE.
>
> Seems libvirt-lxc already supports containerized /proc/meminfo in this way.
> See:
> 	http://libvirt.org/drvlxc.html

I'm well aware of the FUSE approach and the fact that the kernel maintainers do not accept the this kind of changing the 
kernel but the simple truth is that FUSE is too have for this thing.

I'm setting up a repo on GitHub which will hold all the patches for this and will keep updating it even if it is not 
accepted by the upstream maintainers. I'll give you the link within a few days.

I have already finished with CPU and Memory... the only thing that is left is the /proc/loadavg, which will take more 
time, but will be done.

I hope some of the scheduler maintainers at least to give me some comments on the patches that I have done.

Marian

>
>
>
