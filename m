From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 25 Nov 2013 14:57:59 -0700
Message-ID: <CAErSpo5S4GqbOPfGUMOw2vsMFewrB4p4kXfW5D1MB9MC_WTWPQ@mail.gmail.com>
References: <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org> <20131113073806.GA23244@mtj.dyndns.org>
 <20131116002820.GA31073@google.com> <20131116045356.GA5618@mtj.dyndns.org>
 <20131118181440.GA2996@google.com> <CAE9FiQW07ZAU_0bjkrwK54TAn48ByyS=kXNFwQJ-G2FFkK_W3A@mail.gmail.com>
 <20131118203925.GA26682@google.com> <528D8B6A.40008@oracle.com> <CAErSpo4bXfVbxcJ6-LcByDRX25DSa8Pa+9dLtcaW631YK88Gcw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=SE3Gac6sSTB0TBkG3Cna+mvzRiAf0RGydWgx7Xn2wio=;
        b=OtIAqUXoRrlzYhLr8ZixmAKP/MbeoP5j4D1vWuU8q+UADWF4o4A3wIgYxvatbS5xXr
         umuDfXg6kB7VoRE/dqm4R4KsPkOiskTIzl8oXDObhjROB4IBXr61sp4e6DC/fA9OlLsi
         7igj7wrAYOanobDqWMuCdRk2P9PrjCFFs6pJsPXKmqD7O3NSf+JqWDnAMDLvtwVPrUYu
         mVGGiwFYobwKnuKdohrCgoKvNY4OUviddjXI8CXjeacu3M5vjovUnihPLD6qN+t7283j
         NbiAJwT7d8Cfhfv3QLK8ZTzC0CPPyd731LOpI2p3lc6lqyiTpIZtZkPzRHnL4bGk0lv5
         Tdpg==
In-Reply-To: <CAErSpo4bXfVbxcJ6-LcByDRX25DSa8Pa+9dLtcaW631YK88Gcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>

On Wed, Nov 20, 2013 at 9:47 PM, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> [+cc Jiri]
>
> On Wed, Nov 20, 2013 at 9:26 PM, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> On 11/18/2013 03:39 PM, Bjorn Helgaas wrote:
>>>
>>> On Mon, Nov 18, 2013 at 11:29:32AM -0800, Yinghai Lu wrote:
>>>>
>>>> On Mon, Nov 18, 2013 at 10:14 AM, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>> wrote:
>>>>>>
>>>>>> A bit of comment here would be nice but yeah I think this should work.
>>>>>> Can you please also queue the revert of c2fda509667b ("workqueue:
>>>>>> allow work_on_cpu() to be called recursively") after this patch?
>>>>>> Please feel free to add my acked-by.
>>>>>
>>>>>
>>>>> OK, below are the two patches (Alex's fix + the revert) I propose to
>>>>> merge.  Unless there are objections, I'll ask Linus to pull these
>>>>> before v3.13-rc1.
>>>>>
>>>>>
>>>>>
>>>>> commit 84f23f99b507c2c9247f47d3db0f71a3fd65e3a3
>>>>> Author: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>> Date:   Mon Nov 18 10:59:59 2013 -0700
>>>>>
>>>>>      PCI: Avoid unnecessary CPU switch when calling driver .probe()
>>>>> method
>>>>>
>>>>>      If we are already on a CPU local to the device, call the driver
>>>>> .probe()
>>>>>      method directly without using work_on_cpu().
>>>>>
>>>>>      This is a workaround for a lockdep warning in the following
>>>>> scenario:
>>>>>
>>>>>        pci_call_probe
>>>>>          work_on_cpu(cpu, local_pci_probe, ...)
>>>>>            driver .probe
>>>>>              pci_enable_sriov
>>>>>                ...
>>>>>                  pci_bus_add_device
>>>>>                    ...
>>>>>                      pci_call_probe
>>>>>                        work_on_cpu(cpu, local_pci_probe, ...)
>>>>>
>>>>>      It would be better to fix PCI so we don't call VF driver .probe()
>>>>> methods
>>>>>      from inside a PF driver .probe() method, but that's a bigger
>>>>> project.
>>>>>
>>>>>      [bhelgaas: disable preemption, open bugzilla, rework comments &
>>>>> changelog]
>>>>>      Link: https://bugzilla.kernel.org/show_bug.cgi?id=65071
>>>>>      Link:
>>>>> http://lkml.kernel.org/r/CAE9FiQXYQEAZ=0sG6+2OdffBqfLS9MpoN1xviRR9aDbxPxcKxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
>>>>>      Link:
>>>>> http://lkml.kernel.org/r/20130624195942.40795.27292.stgit-+uVpp3jiz/Q1YPczIWDRvLvm/XP+8Wra@public.gmane.org
>>>>>      Signed-off-by: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>      Signed-off-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>>      Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>>
>>>>
>>>> Tested-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>> Acked-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>
>>>
>>> Thanks, I added these and pushed my for-linus branch for -next to
>>> pick up before I ask Linus to pull them.
>>
>>
>> Hi guys,
>>
>> This patch seems to be causing virtio (wouldn't it happen with any other
>> driver too?) to give
>> the following spew:
>
> Yep, Jiri Slaby reported this earlier.  I dropped those patches for
> now.  Yinghai and I both tested this without incident, but we must
> have tested quite the same scenario you did.
>
> I'll look at this more tomorrow.  My first thought is that it's
> probably silly to worry about preemption when checking the node.  It's
> unlikely that we'd be preempted (probably not even possible except at
> hot add-time), and the worst that can happen is we run the .probe()
> method on the wrong node, which means worse performance but correct
> functionality.

I dropped the preempt_disable() and re-added this to my for-linus
branch.  Let me know if you see any more issues.

Bjorn
