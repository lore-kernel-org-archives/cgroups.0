From: Luca Abeni <luca.abeni@santannapisa.it>
Subject: Re: about CPU QoS in KVM
Date: Wed, 26 Apr 2017 09:48:28 +0200
Message-ID: <20170426094828.560fcf10@luca>
References: <33183CC9F5247A488A2544077AF19020DA237684@DGGEMA505-MBS.china.huawei.com>
        <8a5470cd-0cb2-5019-c7d3-7c407e6a6005@redhat.com>
        <20170425101303.GA17999@e106622-lin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170425101303.GA17999@e106622-lin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>, "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>, "Huangweidong (C)" <weidong.huang@huawei.com>, linqiangmin@huawei.com, Rik van Riel <riel@redhat.com>, Tommaso Cucinotta <tommaso.cucinotta@santannapisa.it>, carlo.vitucci@ericsson.com

Hi all,

On Tue, 25 Apr 2017 11:13:03 +0100
Juri Lelli <juri.lelli@arm.com> wrote:
[...]
> > > Currently, KVM do the CPU resource reservation by the cgroup
> > > mechanism which can't do entire accurate separation because the
> > > capacity of the Linux scheduler. Take the public cloud as an
> > > example, some customers rent one vm with 8 CPUs paid by enough
> > > money, they want to get enough response speed on CPU scheduling.
> > > So we (the cloud platform providers ) reserve 1GHz CPU resources
> > > by cgroup for those VM's vcpu/pcpu. 
> > > 
> > > But the actual effects can't meet those requirements because the
> > > cgroup is limiting share usage of other processes in order to
> > > attach the reservation proportion, but the scheduler can't assure
> > > that. This mechanism is different with Xen, We can directly
> > > change the CPU weight on Xen hypervisor so that we can get entire
> > > accurate control on CPU resources based on accurate capacity
> > > (upper limit), share (weight) and reservation.
> > > 
> > > So my question is do we have a good method to do CPU reservation
> > > in KVM?
> > > 
> > > Thanks,
> > > -Gonglei  
> 
> Not entirely sure what your particular requirements are Gonglei, but
> you might be interested to know that there has been research work
> [1,2,3, just to name a few] that used a mainline real-time scheduling
> policy (SCHED_DEADLINE) to provide Qos support to virtual machines
> (KVM).
> 
> I won't enter in too much detail, but the basic idea is to use
> reservation based scheduling mechanisms to enforce temporal isolation
> and guaranteed CPU bandwidth to VM's vcpu(s).

Since I've been CC-ed, I add some details to what Juri wrote:
if the guest workload is mostly CPU intensive, just scheduling the vCPU
threads with SCHED_DEADLINE allows deterministic CPU allocation.

I recently showed some experiments about this to some students: if some
periodic real-time tasks are executed in the guest and KVM's vCPU
threads are scheduled with SCHED_DEADLINE, then the number of missed
deadlines measured in the guest matches with the number of missed
deadlines expected from theoretical analysis (using real-time
hierarchical scheduling analysis).
[I can provide more details if needed: here is a quick and incomplete
summary I wrote for the students:
http://retis.sssup.it/~luca/CBSD/h-sched_experiments.txt
up to item 4 it is just theoretical schedulability analysis; the
interesting parts start from item 5]

I think this shows that (for CPU-intensive workloads) it is possible to
deterministically control the QoS of a KVM-based VM by using
SCHED_DEADLINE.


If your guest workload includes more I/O, then you have to schedule
more threads with SCHED_DEADLINE (for example, I have some experiments
with a lot of network traffic in the guest; I used vhost-net and I've
been able to control the network throughput by scheduling the vhost-net
kernel thread with SCHED_DEADLINE and changing the runtime and period
associated to thread).



				Luca

> 
> I'm Cc-ing Tommaso, Luca and Carlo, whom can provide more information
> as needed.
> 
> Best,
> 
> - Juri
> 
> [1] - http://retis.sssup.it/~nino/publication/rtlws14sdnnfs.pdf
> [2] - http://retis.sssup.it/~tommaso/publications/VHPC-2010.pdf
> [3] - http://retis.sssup.it/~tommaso/publications/RTSOAA-2009-RTV.pdf
> 
> Skimming through Tommaso and Luca publications might be interesting as
> well. I'm pretty sure I missed the most importants papers. :)
> http://retis.sssup.it/~tommaso/eng/publications.html
> https://scholar.google.co.uk/citations?user=C3a6glEAAAAJ&hl=en

