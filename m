From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Wed, 6 Mar 2013 15:15:59 +0800
Message-ID: <5136ED2F.8080400@huawei.com>
References: <5136B7C1.6030403@huawei.com> <20130306062224.GJ1227@htj.dyndns.org> <5136E9A4.7000201@huawei.com> <CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/6 15:02, Tejun Heo wrote:
> On Tue, Mar 5, 2013 at 11:00 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>> Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
>>> irq context?
>>
>> becase cgroup_event_wake() is a callback to a wait queue, and it's wake_up()
>> that acquires wqh->lock with irq disabled.
> 
> So, acquiring a lock with irq disabled doesn't make it a irq lock.
> Being grabbed *from* irq handler makes it a irq lock. Would the
> wake_up() happen from irq handler?
> 

wqh->lock is used through out fs/eventfd.c. I don't know if currently there's
any kernel user using eventfd APIs in an irq handler, but at least that should
be allowed.

wake_up() is also allowed to be called from irq handler?

"allowed" should be enough reason we forbid:

	spin_lock_irqsave(...)
	spin_lock(...)
