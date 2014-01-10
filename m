From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Subject: Re: RFC: cgroups aware proc
Date: Fri, 10 Jan 2014 18:29:56 +0200
Message-ID: <52D02004.2060501@yuhu.biz>
References: <52C78E09.60904@yuhu.biz> <52C8A36B.6030201@yuhu.biz> <52CBE22F.1010106@huawei.com> <52CC3C80.8030603@yuhu.biz> <20140108152747.GC4765@sergelap>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yuhu.biz; s=default;
	t=1389371391; bh=PitY/uJb2415qQMYZL7ss3AZas5+n7dK7zQjJTdXRPc=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=DLPZFQ1JqcoPdtNE+HLvtF3lq5AgWxe7hVLthm2cQZ8y2FC10em9P0flps9Tt7JNi
	 PdgWX/igqH2804Lvu/4wOkFXveBzb+oThXV5D+NwLZl/Wl/O3xUKmcaOOa8h6EUU6J
	 Mq+bHfoeyd481RWKt5dXjrgqoJckgMgCMhkMInUk=
In-Reply-To: <20140108152747.GC4765@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 01/08/2014 05:27 PM, Serge Hallyn wrote:
> Quoting Marian Marinov (mm-NV7Lj0SOnH0@public.gmane.org):
>> On 01/07/2014 01:17 PM, Li Zefan wrote:
>>> On 2014/1/5 8:12, Marian Marinov wrote:
>>>> Happy new year guys.
>>>>
>>>> I need to have /proc cgroups aware, as I want to have LXC containers that see only the resources that are given to them.
>>>>
>>>> In order to do that I had to patch the kernel. I decided to start with cpuinfo, stat and interrupts and then continue
>>>> with meminfo and loadavg.
>>>>
>>>> I managed to patch the Kernel (linux 3.12.0) and make /proc/cpuinfo, /proc/stat and /proc/interrupts be cgroups aware.
>>>>
>>>> Attached are the patches that make the necessary changes.
>>>>
>>>> The change for /proc/cpuinfo and /proc/interrupts is currently done only for x86 arch, but I will patch the rest of the
>>>> architectures if the style of the patches is acceptable.
>>>>
>>>> Tomorrow I will check if the patches apply and build with the latest kernel.
>>>>
>>>
>>> People tried to do this before, but got rejected by upstream maintainers,
>>> and then the opinion was to do this in userspace throught FUSE.
>>>
>>> Seems libvirt-lxc already supports containerized /proc/meminfo in this way.
>>> See:
>>> 	http://libvirt.org/drvlxc.html
>>
>> I'm well aware of the FUSE approach and the fact that the kernel
>> maintainers do not accept the this kind of changing the kernel but
>> the simple truth is that FUSE is too have for this thing.
>>
>> I'm setting up a repo on GitHub which will hold all the patches for
>
> Thanks, that'll be easier to look at than the in-line patches.
>
>>From my very quick look, I would recommend
>
> 1. coming up with some helpers to reduce the degree to which you are
> negatively affecting the flow of the existing code.  Currently it
> looks like you're obfuscating it a lot, and I think you can make it
> so only a few clean lines are added per function.
>
> For instance, in arch_show_interrupts(), instead of plopping
>
> +#ifdef CONFIG_CPUSETS
> +               if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
> +#endif
>
> in several places,
>
> write
> static inline bool task_has_cpu(tsk, cpu) {
> #ifdef CONFIG_CPUSETS
>          return (tsk != NULL && cpumask_test_cpu(cpu, &tsk->cpus_allowed));
> #else
> 	return true;
> #endif
> }
>
> and then just use 'if task_has_cpu(tsk, j)' several times.
>
>
> 2. showing performance degredation in the not-using-it case (that is,
> with cgroups enabled but in the root cpuset for instance), which
> hopefully will be near-nil.
>
> If you can avoid confounding the readability of the code and not impact
> the performance, that'll help your chances a lot.

Thanks for the suggestions. I have merged all of my changes into this branch:
   https://github.com/1HLtd/linux/tree/cgroup-aware-proc

I'm still working on the loadavg issue I hope to have it finished next week.
If anyone has any suggestions for it I would be more then happy.

Marian

>
>> this and will keep updating it even if it is not accepted by the
>> upstream maintainers. I'll give you the link within a few days.
>>
>> I have already finished with CPU and Memory... the only thing that
>> is left is the /proc/loadavg, which will take more time, but will be
>> done.
>>
>> I hope some of the scheduler maintainers at least to give me some comments on the patches that I have done.
>>
>> Marian
>>
>>>
>>>
>>>
>>
>
>
