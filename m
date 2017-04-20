From: "Gonglei (Arei)" <arei.gonglei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: about CPU QoS in KVM
Date: Thu, 20 Apr 2017 13:32:31 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA237684@DGGEMA505-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linqiangmin <linqiangmin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Huangweidong (C)" <weidong.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi all,

Currently, KVM do the CPU resource reservation by the cgroup mechanism
which can't do entire accurate separation because the capacity of the Linux
scheduler. Take the public cloud as an example, some customers rent one vm
with 8 CPUs paid by enough money, they want to get enough response
speed on CPU scheduling. So we (the cloud platform providers ) reserve 1GHz
CPU resources by cgroup for those VM's vcpu/pcpu. 

But the actual effects can't meet those requirements because the cgroup is
limiting share usage of other processes in order to attach the reservation proportion,
but the scheduler can't assure that. This mechanism is different with Xen,
We can directly change the CPU weight on Xen hypervisor so that we can
get entire accurate control on CPU resources based on accurate capacity (upper limit),
share (weight) and reservation.

So my question is do we have a good method to do CPU reservation in KVM?

Thanks,
-Gonglei

