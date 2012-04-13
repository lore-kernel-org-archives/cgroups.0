From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/7] res_counter: add a function res_counter_move_parent().
Date: Fri, 13 Apr 2012 09:57:03 +0900
Message-ID: <4F8779DF.3080307@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BA66.2010503@jp.fujitsu.com> <4F86D733.50809@parallels.com> <CAFTL4hyKOkoTv=717MkYx4QB0j3B6xA0ZPp1jg6HkrtTkAu7nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFTL4hyKOkoTv=717MkYx4QB0j3B6xA0ZPp1jg6HkrtTkAu7nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(2012/04/12 23:30), Frederic Weisbecker wrote:

> 2012/4/12 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>:
>> On 04/12/2012 08:20 AM, KAMEZAWA Hiroyuki wrote:
>>>
>>> This function is used for moving accounting information to its
>>> parent in the hierarchy of res_counter.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>
>> Frederic has a patch in his fork cgroup series, that allows you to
>> uncharge a counter until you reach a specific ancestor.
>> You pass the parent as a parameter, and then only you gets uncharged.
> 
> I'm missing the referring patchset from Kamezawa. Ok I'm going to
> subscribe to the
> cgroup mailing list. Meanwhile perhaps would it be nice to keep Cc
> LKML for cgroup patches?
> 

Ah, sorry. I will do next time.

> Some comments below:
> 
>>
>> I think that is a much better interface than this you are proposing.
>> We should probably merge that patch and use it.
>>
>>> ---
>>>   include/linux/res_counter.h |    3 +++
>>>   kernel/res_counter.c        |   13 +++++++++++++
>>>   2 files changed, 16 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
>>> index da81af0..8919d3c 100644
>>> --- a/include/linux/res_counter.h
>>> +++ b/include/linux/res_counter.h
>>> @@ -135,6 +135,9 @@ int __must_check res_counter_charge_nofail(struct res_counter *counter,
>>>   void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
>>>   void res_counter_uncharge(struct res_counter *counter, unsigned long val);
>>>
>>> +/* move resource to parent counter...i.e. just forget accounting in a child */
>>> +void res_counter_move_parent(struct res_counter *counter, unsigned long val);
>>> +
>>>   /**
>>>    * res_counter_margin - calculate chargeable space of a counter
>>>    * @cnt: the counter
>>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>>> index d508363..fafebf0 100644
>>> --- a/kernel/res_counter.c
>>> +++ b/kernel/res_counter.c
>>> @@ -113,6 +113,19 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
>>>       local_irq_restore(flags);
>>>   }
>>>
>>> +/*
>>> + * In hierarchical accounting, child's usage is accounted into ancestors.
>>> + * To move local usage to its parent, just forget current level usage.
> 
> The way I understand this comment and the changelog matches the opposite
> of what the below function is doing.
> 
> The function charges a child and ignore all its parents. The comments says it
> charges the parents but not the child.
> 


Sure, I'll fix...and look into your code first.
"uncharge a counter until you reach a specific ancestor"...
Is it in linux-next ?

Thanks,
-Kame


>>> + */
>>> +void res_counter_move_parent(struct res_counter *counter, unsigned long val)
>>> +{
>>> +     unsigned long flags;
>>> +
>>> +     BUG_ON(!counter->parent);
>>> +     spin_lock_irqsave(&counter->lock, flags);
>>> +     res_counter_uncharge_locked(counter, val);
>>> +     spin_unlock_irqrestore(&counter->lock, flags);
>>> +}
>>>
>>>   static inline unsigned long long *
>>>   res_counter_member(struct res_counter *counter, int member)
>>
> 
> 


