From: Juri Lelli <juri.lelli@arm.com>
Subject: Re: about CPU QoS in KVM
Date: Tue, 25 Apr 2017 11:13:03 +0100
Message-ID: <20170425101303.GA17999@e106622-lin>
References: <33183CC9F5247A488A2544077AF19020DA237684@DGGEMA505-MBS.china.huawei.com>
 <8a5470cd-0cb2-5019-c7d3-7c407e6a6005@redhat.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8a5470cd-0cb2-5019-c7d3-7c407e6a6005@redhat.com>
Sender: kvm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>, "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>, "Huangweidong (C)" <weidong.huang@huawei.com>, linqiangmin@huawei.com, Rik van Riel <riel@redhat.com>, Luca Abeni <luca.abeni@santannapisa.it>, Tommaso Cucinotta <tommaso.cucinotta@santannapisa.it>, carlo.vitucci@ericsson.com

Hi,

just noticed this and thought I might just jump in. :)

On 20/04/17 16:00, Paolo Bonzini wrote:
> Adding Rik.
> 
> Paolo
> 
> On 20/04/2017 15:32, Gonglei (Arei) wrote:
> > Hi all,
> > 
> > Currently, KVM do the CPU resource reservation by the cgroup mechanism
> > which can't do entire accurate separation because the capacity of the Linux
> > scheduler. Take the public cloud as an example, some customers rent one vm
> > with 8 CPUs paid by enough money, they want to get enough response
> > speed on CPU scheduling. So we (the cloud platform providers ) reserve 1GHz
> > CPU resources by cgroup for those VM's vcpu/pcpu. 
> > 
> > But the actual effects can't meet those requirements because the cgroup is
> > limiting share usage of other processes in order to attach the reservation proportion,
> > but the scheduler can't assure that. This mechanism is different with Xen,
> > We can directly change the CPU weight on Xen hypervisor so that we can
> > get entire accurate control on CPU resources based on accurate capacity (upper limit),
> > share (weight) and reservation.
> > 
> > So my question is do we have a good method to do CPU reservation in KVM?
> > 
> > Thanks,
> > -Gonglei

Not entirely sure what your particular requirements are Gonglei, but you
might be interested to know that there has been research work [1,2,3,
just to name a few] that used a mainline real-time scheduling policy
(SCHED_DEADLINE) to provide Qos support to virtual machines (KVM).

I won't enter in too much detail, but the basic idea is to use
reservation based scheduling mechanisms to enforce temporal isolation and
guaranteed CPU bandwidth to VM's vcpu(s).

I'm Cc-ing Tommaso, Luca and Carlo, whom can provide more information as
needed.

Best,

- Juri

[1] - http://retis.sssup.it/~nino/publication/rtlws14sdnnfs.pdf
[2] - http://retis.sssup.it/~tommaso/publications/VHPC-2010.pdf
[3] - http://retis.sssup.it/~tommaso/publications/RTSOAA-2009-RTV.pdf

Skimming through Tommaso and Luca publications might be interesting as
well. I'm pretty sure I missed the most importants papers. :)
http://retis.sssup.it/~tommaso/eng/publications.html
https://scholar.google.co.uk/citations?user=C3a6glEAAAAJ&hl=en
