From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Wed, 20 Nov 2013 21:47:42 -0700
Message-ID: <CAErSpo4bXfVbxcJ6-LcByDRX25DSa8Pa+9dLtcaW631YK88Gcw@mail.gmail.com>
References: <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org> <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com> <20131116045356.GA5618@mtj.dyndns.org>
 <20131118181440.GA2996@google.com> <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
 <20131118203925.GA26682@google.com> <528D8B6A.40008@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=OXOX4wcJchU74uN2p9hWXBr5nUV5Pq1IAnvxMIAjyJY=;
        b=maiy+U2+0Hutxl6SBvmmmV6c3zneIhgC3Pd9ivqJI/IsQjRdvWbVK7Kj9EU1Dc+8Jt
         CRO/M3tvdfUGPyBACyRNQky06vbrHCTROkSyPrfvkVne2lD+BgvfqxJ7wVnn5Xs1T5pa
         oeBczfSYE7BNiYAs0R0R7UyFHsZwdZxg2+snPI/6g2VgZU0y2tle8vq10qCMFJeng31w
         /rRW637CEAK16n6BIaxrBCdKu8N4x6eqiFwx73u4HhMUewyEXPr6aAGrbxkPL7VpVwBt
         Ly6FX2fnAvEP6nTmh2fWRnnBIClO9+JjCVR+LW3f4Cf/Hkq6grcqcEXDMB76Z7BUgms4
         eSGw==
In-Reply-To: <528D8B6A.40008-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>

[+cc Jiri]

On Wed, Nov 20, 2013 at 9:26 PM, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On 11/18/2013 03:39 PM, Bjorn Helgaas wrote:
>>
>> On Mon, Nov 18, 2013 at 11:29:32AM -0800, Yinghai Lu wrote:
>>>
>>> On Mon, Nov 18, 2013 at 10:14 AM, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> wrote:
>>>>>
>>>>> A bit of comment here would be nice but yeah I think this should work.
>>>>> Can you please also queue the revert of c2fda509667b ("workqueue:
>>>>> allow work_on_cpu() to be called recursively") after this patch?
>>>>> Please feel free to add my acked-by.
>>>>
>>>>
>>>> OK, below are the two patches (Alex's fix + the revert) I propose to
>>>> merge.  Unless there are objections, I'll ask Linus to pull these
>>>> before v3.13-rc1.
>>>>
>>>>
>>>>
>>>> commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
>>>> Author: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> Date:   Mon Nov 18 10:59:59 2013 -0700
>>>>
>>>>      PCI: Avoid unnecessary CPU switch when calling driver .probe()
>>>> method
>>>>
>>>>      If we are already on a CPU local to the device, call the driver
>>>> .probe()
>>>>      method directly without using work_on_cpu().
>>>>
>>>>      This is a workaround for a lockdep warning in the following
>>>> scenario:
>>>>
>>>>        pci_call_probe
>>>>          work_on_cpu(cpu, local_pci_probe, ...)
>>>>            driver .probe
>>>>              pci_enable_sriov
>>>>                ...
>>>>                  pci_bus_add_device
>>>>                    ...
>>>>                      pci_call_probe
>>>>                        work_on_cpu(cpu, local_pci_probe, ...)
>>>>
>>>>      It would be better to fix PCI so we don't call VF driver .probe()
>>>> methods
>>>>      from inside a PF driver .probe() method, but that's a bigger
>>>> project.
>>>>
>>>>      [bhelgaas: disable preemption, open bugzilla, rework comments &
>>>> changelog]
>>>>      Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
>>>>      Link:
>>>> http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
>>>>      Link:
>>>> http://lkml.kernel.org/r/20130624195942.40795.27292.stgit-+uVpp3jiz/Q1YPczIWDRvLvm/XP+8Wra@public.gmane.org
>>>>      Signed-off-by: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>      Signed-off-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>      Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>
>>>
>>> Tested-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Acked-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
>>
>> Thanks, I added these and pushed my for-linus branch for -next to
>> pick up before I ask Linus to pull them.
>
>
> Hi guys,
>
> This patch seems to be causing virtio (wouldn't it happen with any other
> driver too?) to give
> the following spew:

Yep, Jiri Slaby reported this earlier.  I dropped those patches for
now.  Yinghai and I both tested this without incident, but we must
have tested quite the same scenario you did.

I'll look at this more tomorrow.  My first thought is that it's
probably silly to worry about preemption when checking the node.  It's
unlikely that we'd be preempted (probably not even possible except at
hot add-time), and the worst that can happen is we run the .probe()
method on the wrong node, which means worse performance but correct
functionality.

Bjorn

> [   11.966381] virtio-pci 0000:00:00.0: enabling device (0000 -> 0003)
> [   11.968306] BUG: scheduling while atomic: swapper/0/1/0x00000002
> [   11.968616] 2 locks held by swapper/0/1:
> [   11.969144]  #0:  (&__lockdep_no_validate__){......}, at:
> [<ffffffff820162e8>] __driver_attach+0x48/0xa0
> [   11.969720]  #1:  (&__lockdep_no_validate__){......}, at:
> [<ffffffff820162f9>] __driver_attach+0x59/0xa0
> [   11.971519] Modules linked in:
> [   11.971519] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W
> 3.12.0-next-20131120-sasha-00002-gf582b19 #4023
> [   11.972293]  0000000000000003 ffff880fced736c8 ffffffff8429caa2
> 0000000000000003
> [   11.973145]  ffff880fce820000 ffff880fced736e8 ffffffff8115b67b
> 0000000000000003
> [   11.973952]  ffff880fe5dd7880 ffff880fced73768 ffffffff8429d463
> ffff880fced73708
> [   11.974881] Call Trace:
> [   11.975233]  [<ffffffff8429caa2>] dump_stack+0x52/0x7f
> [   11.975786]  [<ffffffff8115b67b>] __schedule_bug+0x6b/0x90
> [   11.976411]  [<ffffffff8429d463>] __schedule+0x93/0x760
> [   11.976971]  [<ffffffff810adfe4>] ? kvm_clock_read+0x24/0x50
> [   11.977646]  [<ffffffff8429dde5>] schedule+0x65/0x70
> [   11.978223]  [<ffffffff8429cb8d>] schedule_timeout+0x3d/0x260
> [   11.978821]  [<ffffffff8117c8ce>] ? put_lock_stats+0xe/0x30
> [   11.979595]  [<ffffffff8429eea7>] ? wait_for_completion+0xb7/0x120
> [   11.980324]  [<ffffffff8117fd2a>] ? __lock_release+0x1da/0x1f0
> [   11.981554]  [<ffffffff8429eea7>] ? wait_for_completion+0xb7/0x120
> [   11.981664]  [<ffffffff8429eeaf>] wait_for_completion+0xbf/0x120
> [   11.982266]  [<ffffffff81163880>] ? try_to_wake_up+0x2a0/0x2a0
> [   11.982891]  [<ffffffff811421a8>] call_usermodehelper_exec+0x198/0x240
> [   11.983552]  [<ffffffff811758e8>] ? complete+0x28/0x60
> [   11.984053]  [<ffffffff81142385>] call_usermodehelper+0x45/0x50
> [   11.984660]  [<ffffffff81a51d64>] kobject_uevent_env+0x594/0x600
> [   11.985254]  [<ffffffff81a51ddb>] kobject_uevent+0xb/0x10
> [   11.985855]  [<ffffffff82013635>] device_add+0x2b5/0x4a0
> [   11.986495]  [<ffffffff8201383e>] device_register+0x1e/0x30
> [   11.987051]  [<ffffffff81c59837>] register_virtio_device+0x87/0xb0
> [   11.987760]  [<ffffffff81ac36a3>] ? pci_set_master+0x23/0x30
> [   11.988410]  [<ffffffff81c5c3f2>] virtio_pci_probe+0x162/0x1c0
> [   11.989000]  [<ffffffff81ac725c>] local_pci_probe+0x4c/0xb0
> [   11.989683]  [<ffffffff81ac7361>] pci_call_probe+0xa1/0xd0
> [   11.990359]  [<ffffffff81ac7643>] pci_device_probe+0x63/0xa0
> [   11.991829]  [<ffffffff82015ce3>] ? driver_sysfs_add+0x73/0xb0
> [   11.991829]  [<ffffffff8201601f>] really_probe+0x11f/0x2f0
> [   11.992234]  [<ffffffff82016273>] driver_probe_device+0x83/0xb0
> [   11.992847]  [<ffffffff8201630e>] __driver_attach+0x6e/0xa0
> [   11.993407]  [<ffffffff820162a0>] ? driver_probe_device+0xb0/0xb0
> [   11.994020]  [<ffffffff820162a0>] ? driver_probe_device+0xb0/0xb0
> [   11.994719]  [<ffffffff82014066>] bus_for_each_dev+0x66/0xc0
> [   11.995272]  [<ffffffff82015c1e>] driver_attach+0x1e/0x20
> [   11.995829]  [<ffffffff8201552e>] bus_add_driver+0x11e/0x240
> [   11.996411]  [<ffffffff870d3600>] ? virtio_mmio_init+0x14/0x14
> [   11.996996]  [<ffffffff82016958>] driver_register+0xa8/0xf0
> [   11.997628]  [<ffffffff870d3600>] ? virtio_mmio_init+0x14/0x14
> [   11.998196]  [<ffffffff81ac7774>] __pci_register_driver+0x64/0x70
> [   11.998798]  [<ffffffff870d3619>] virtio_pci_driver_init+0x19/0x1b
> [   11.999421]  [<ffffffff810020ca>] do_one_initcall+0xca/0x1d0
> [   12.000109]  [<ffffffff8114cf0b>] ? parse_args+0x1cb/0x310
> [   12.000666]  [<ffffffff87065d76>] ? kernel_init_freeable+0x339/0x339
> [   12.001364]  [<ffffffff87065a1a>] do_basic_setup+0x9c/0xbf
> [   12.001903]  [<ffffffff87065d76>] ? kernel_init_freeable+0x339/0x339
> [   12.002542]  [<ffffffff8708e894>] ? sched_init_smp+0x13f/0x141
> [   12.003202]  [<ffffffff87065cf3>] kernel_init_freeable+0x2b6/0x339
> [   12.003815]  [<ffffffff84292d4e>] ? kernel_init+0xe/0x130
> [   12.004475]  [<ffffffff84292d40>] ? rest_init+0xd0/0xd0
> [   12.005011]  [<ffffffff84292d4e>] kernel_init+0xe/0x130
> [   12.005541]  [<ffffffff842ac9fc>] ret_from_fork+0x7c/0xb0
> [   12.006068]  [<ffffffff84292d40>] ? rest_init+0xd0/0xd0
>
>
> Thanks,
> Sasha
