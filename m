From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Wed, 6 Mar 2013 15:00:52 +0800
Message-ID: <5136E9A4.7000201@huawei.com>
References: <5136B7C1.6030403@huawei.com> <20130306062224.GJ1227@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130306062224.GJ1227-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/6 14:22, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Mar 06, 2013 at 11:28:01AM +0800, Li Zefan wrote:
>> cgroup_event_wake() is called with hardirq-safe wqh->lock held, so
>> the nested cgrp->event_list_lock should also be hardirq-safe.
>>
>> Fortunately I don't think the deadlock can happen in real life.
>>
>> Lockdep never complained, maybe because it never found wqh->lock was
>> held in irq context?
> 
> Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
> irq context?

becase cgroup_event_wake() is a callback to a wait queue, and it's wake_up()
that acquires wqh->lock with irq disabled.

> Locks which are grabbed with irq disabled aren't
> necessarily irq context locks as that doesn't lead to deadlocks.  They
> need to be actually grabbed from irq context.
> 
> Thanks.
> 
