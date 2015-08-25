From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 25 Aug 2015 11:36:25 +0900
Message-ID: <55DBD4A9.7080603@jp.fujitsu.com>
References: <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com> <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
 <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
 <20150824224936.GO28944@mtj.duckdns.org>
 <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2015/08/25 8:15, Paul Turner wrote:
> On Mon, Aug 24, 2015 at 3:49 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Hello,
>>
>> On Mon, Aug 24, 2015 at 03:03:05PM -0700, Paul Turner wrote:
>>>> Hmm... I was hoping for an actual configurations and usage scenarios.
>>>> Preferably something people can set up and play with.
>>>
>>> This is much easier to set up and play with synthetically.  Just
>>> create the 10 threads and 100 threads above then experiment with
>>> configurations designed at guaranteeing the set of 100 threads
>>> relatively uniform throughput regardless of how many are active.   I
>>> don't think trying to run a VM stack adds anything except complexity
>>> of reproduction here.
>>
>> Well, but that loses most of details and why such use cases matter to
>> begin with.  We can imagine up stuff to induce arbitrary set of
>> requirements.
>
> All that's being proved or disproved here is that it's difficult to
> coordinate the consumption of asymmetric thread pools using nice.  The
> constraints here were drawn from a real-world example.
>
>>
>>>> I take that the
>>>> CPU intensive helper threads are usually IO workers?  Is the scenario
>>>> where the VM is set up with a lot of IO devices and different ones may
>>>> consume large amount of CPU cycles at any given point?
>>>
>>> Yes, generally speaking there are a few major classes of IO (flash,
>>> disk, network) that a guest may invoke.  Each of these backends is
>>> separate and chooses its own threading.
>>
>> Hmmm... if that's the case, would limiting iops on those IO devices
>> (or classes of them) work?  qemu already implements IO limit mechanism
>> after all.
>
> No.
>
> 1) They should proceed at the maximum rate that they can that's still
> within their provisioning budget.
> 2) The cost/IO is both inconsistent and changes over time.  Attempting
> to micro-optimize every backend for this is infeasible, this is
> exactly the type of problem that the scheduler can usefully help
> arbitrate.
> 3) Even pretending (2) is fixable, dynamically dividing these
> right-to-work tokens between different I/O device backends is
> extremely complex.
>

I think I should explain my customer's use case of qemu + cpuset/cpu (via libvirt)

(1) Isolating hypervisor thread.
    As already discussed, hypervisor threads are isolated by cpuset. But their purpose
    is to avoid _latency_ spike caused by hypervisor behavior. So, "nice" cannot be solution
    as already discussed.

(2) Fixed rate vcpu service.
    With using cpu controller's quota/period feature, my customer creates  vcpu models like
    Low(1GHz), Mid(2GHz), High(3GHz) for IaaS system.

    To do this, each vcpus should be quota-limited independently, with per-thread cpu control.

Especially, the method (1) is used in several enterprise customers for stabilizing their system.

Sub-process control should be provided by some way.

Thanks,
-Kame



>>
>> Anyways, a point here is that threads of the same process competing
>> isn't a new problem.  There are many ways to make those threads play
>> nice as the application itself often has to be involved anyway,
>> especially for something like qemu which is heavily involved in
>> provisioning resources.
>
> It's certainly not a new problem, but it's a real one, and it's
> _hard_.  You're proposing removing the best known solution.
>
>>
>> cgroups can be a nice brute-force add-on which lets sysadmins do wild
>> things but it's inherently hacky and incomplete for coordinating
>> threads.  For example, what is it gonna do if qemu cloned vcpus and IO
>> helpers dynamically off of the same parent thread?
>
> We're talking about sub-process usage here.  This is the application
> coordinating itself, NOT the sysadmin.  Processes are becoming larger
> and larger, we need many of the same controls within them that we have
> between them.
>
>>   It requires
>> application's cooperation anyway but at the same time is painful to
>> actually interact from those applications.
>
> As discussed elsewhere on thread this is really not a problem if you
> define consistent rules with respect to which parts are managed by
> who.  The argument of potential interference is no different to
> messing with an application's on-disk configuration behind its back.
> Alternate strawmen which greatly improve this from where we are today
> have also been proposed.
>
>>
>> Thanks.
>>
>> --
>> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

