From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 25 Feb 2016 16:30:45 +0200
Message-ID: <56CF1015.4040408@mellanox.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
 <56CDAC7A.6030206@mellanox.com>
 <CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
 <56CEED81.7010507@mellanox.com>
 <CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nixPuXP0sEDeaOCbQRX9ekI+DZU4eDcypUklODpR7w4=;
 b=t0q+StZvVCqVmhM+Dtgigbj0Vr32aamYBQjUXtvkleJmzg7kZjlpqxuM7KZOtrXL2QMbjsE8rF/RZzpFEU29HyC6yTBiyDZYhcJQUIrY/HGSYewDjBPUBAFrGtzIUlk9Y9I8X4b9Ec2MupXtEn3X3dQpaFAAefHGZVRGeiRVpkA=
In-Reply-To: <CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 25/02/2016 15:34, Parav Pandit wrote:
> On Thu, Feb 25, 2016 at 5:33 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> +retry:
>>>>> +     spin_lock(&cg->rpool_list_lock);
>>>>> +     rpool = find_cg_rpool_locked(cg, device);
>>>>> +     if (!rpool) {
>>>>> +             spin_unlock(&cg->rpool_list_lock);
>>>>> +             ret = alloc_cg_rpool(cg, device);
>>>>> +             if (ret)
>>>>> +                     goto err;
>>>>> +             else
>>>>> +                     goto retry;
>>>> Instead of retrying after allocation of a new rpool, why not just return the
>>>> newly allocated rpool (or the existing one) from alloc_cg_rpool?
>>>
>>> It can be done, but locking semantics just becomes difficult to
>>> review/maintain with that where alloc_cg_rpool will unlock and lock
>>> conditionally later on.
>> Maybe I'm missing something, but couldn't you simply lock rpool_list_lock
>> inside alloc_cg_rpool()? It already does that around its call to
>> find_cg_rpool_locked() and the insertion to cg_list.
> 
> No. ref_count and usage counters are updated at level where lock is
> taken in charge_cg_resource().
> If I move locking rpool_list_lock inside alloc_cg_rpool, unlocking
> will continue outside, alloc_cg_rpool() when its found or allocated.
> As you acknowledged in below comment that this makes confusing to
> lock/unlock from different context, I think current implementation
> achieves both.
> (a) take lock from single context
> (b) keep functionality of find and alloc in two separate individual functions

Okay, fair enough.

>> I thought that was about functions that only locked the lock, called the
>> find function, and released the lock. What I'm suggesting is to have one
>> function that does "lock + find + allocate if needed + unlock",
> 
> I had similar function in past which does,
> "lock + find + allocate if needed + + inc_ref_cnt + unlock", (get_cg_rpool)
> update usage_counter atomically, because other thread/process might update too.
> check atomic_dec_cnt - on reaching zero, "lock + del_entry + unlock + free".
> 
> Tejun asked to simplify this to,
> 
> "lock + find + allocate if needed + inc_ref_cnt_without_atomic" + unlock".
> which I did in this patch v6.

Okay.

>> and another
>> function that does (under caller's lock) "check ref count + check max count +
>> release rpool".
> This can be done. Have one dumb basic question for thiat.
> Can we call kfree() with spin_lock held? All these years I tend to
> avoid doing so.
> 

I think so. This is an old link but I think it still applies: 
https://lkml.org/lkml/2004/11/21/130
