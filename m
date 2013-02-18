From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] kvm: fix a race when closing irq eventfd
Date: Mon, 18 Feb 2013 12:31:54 +0800
Message-ID: <5121AEBA.2030205@huawei.com>
References: <51219C57.7080809@huawei.com> <1361160167.2801.12.camel@bling.home> <5121A971.7000604@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5121A971.7000604-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gregory Haskins <ghaskins-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

On 2013/2/18 12:09, Li Zefan wrote:
> On 2013/2/18 12:02, Alex Williamson wrote:
>> On Mon, 2013-02-18 at 11:13 +0800, Li Zefan wrote:
>>> While trying to fix a race when closing cgroup eventfd, I took a look
>>> at how kvm deals with this problem, and I found it doesn't.
>>>
>>> I may be wrong, as I don't know kvm code, so correct me if I'm.
>>>
>>> 	/*
>>> 	 * Race-free decouple logic (ordering is critical)
>>> 	 */
>>> 	static void
>>> 	irqfd_shutdown(struct work_struct *work)
>>>
>>> I don't think it's race-free!
>>>
>>> 	static int
>>> 	irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>> 	{
>>> 	...
>>> 			 * We cannot race against the irqfd going away since the
>>> 			 * other side is required to acquire wqh->lock, which we hold
>>> 			 */
>>> 			if (irqfd_is_active(irqfd))
>>> 				irqfd_deactivate(irqfd);
>>> 	}
>>>
>>> In kvm_irqfd_deassign() and kvm_irqfd_release() where irqfds are freed,
>>> wqh->lock is not acquired!
>>>
>>> So here is the race:
>>>
>>> CPU0                                    CPU1
>>> -----------------------------------     ---------------------------------
>>> kvm_irqfd_release()
>>>   spin_lock(kvm->irqfds.lock);
>>>   ...
>>>   irqfd_deactivate(irqfd);
>>>     list_del_init(&irqfd->list);
>>>   spin_unlock(kvm->irqfd.lock);
>>>   ...
>>> 					close(eventfd)
>>> 					  irqfd_wakeup();
>>
>> irqfd_wakeup is assumed to be called with wqh->lock held
>>
> 
> I'm aware of this.
> 
> As I said, kvm_irqfd_deassign() and kvm_irqfd_release() are not acquiring
> wqh->lock.
> 
>>>     irqfd_shutdown();
>>
>> eventfd_ctx_remove_wait_queue has to acquire wqh->lock to complete or
>> else irqfd_shutdown never makes it to the kfree.  So in your scenario
>> this cpu0 spins here until cpu1 completes.
>>

Oh you're right, this is not obvious. Thanks for the explanation.

Now I'll go to see how to fix cgroup.

>>>       remove_waitqueue(irqfd->wait);
>>>       kfree(irqfd);
>>> 					    spin_lock(kvm->irqfd.lock);
>>> 					      if (!list_empty(&irqfd->list))
>>
>> We don't take this branch because we already did list_del_init above,
>> which makes irqfd->list empty.
>>
> 
> It doesn't matter if the list is empty or not.
> 
> The point is, irqfd has been kfreed, so the if statement is simply not safe!
> 
>>> 						irqfd_deactivate(irqfd);
>>> 						  list_del_init(&irqfd->list);
>>> 					    spin_unlock(kvm->irqfd.lock);
>>>
>>> Look, we're accessing irqfd though it has already been freed!
>>
>> Unless the irqfd_wakeup path isn't acquiring wqh->lock, it looks
>> race-free to me.  Thanks,
>>
>> Alex
>>
>> .
>>
> 
