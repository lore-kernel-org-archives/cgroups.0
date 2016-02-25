From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 25 Feb 2016 19:04:56 +0530
Message-ID: <CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<56CDAC7A.6030206@mellanox.com>
	<CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
	<56CEED81.7010507@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=o6ebUx3CC32KLJdYVHtI4q21iG373ix2QhDmTTq6oEA=;
        b=j7F7cy1xpWdLn35csC3F05DieSkIHoEyaXyVCSUdqxHVM5ZSjImWa+nOmfu84vgQZK
         Q7v8J/7JMYLxJUS1z1q0U0v585NamLSMYXf8od86WmcWzMbt4NinCIYf7ZFNV0lzVTnW
         XPNZ0rK93nj+AZvuS7Y3YJSmFElPyxWtmPCJGNBlT6unPEHV6RNZYPY8BaQx614YT0Lp
         pjPQGFk59mrZfp5RVf8Hej5aQLQaP5KdeRJs8UrjNeYY3LaG83PwBz8JeAG6U7W/vNI8
         spCCQ8VHOpmS9WksV3k/9NYGeBDWbfYJiMaCvFme5XSKAEX5RzkfRUb1Hkj6LfUP/FC8
         QJSw==
In-Reply-To: <56CEED81.7010507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 25, 2016 at 5:33 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>> +retry:
>>>> +     spin_lock(&cg->rpool_list_lock);
>>>> +     rpool = find_cg_rpool_locked(cg, device);
>>>> +     if (!rpool) {
>>>> +             spin_unlock(&cg->rpool_list_lock);
>>>> +             ret = alloc_cg_rpool(cg, device);
>>>> +             if (ret)
>>>> +                     goto err;
>>>> +             else
>>>> +                     goto retry;
>>> Instead of retrying after allocation of a new rpool, why not just return the
>>> newly allocated rpool (or the existing one) from alloc_cg_rpool?
>>
>> It can be done, but locking semantics just becomes difficult to
>> review/maintain with that where alloc_cg_rpool will unlock and lock
>> conditionally later on.
> Maybe I'm missing something, but couldn't you simply lock rpool_list_lock
> inside alloc_cg_rpool()? It already does that around its call to
> find_cg_rpool_locked() and the insertion to cg_list.

No. ref_count and usage counters are updated at level where lock is
taken in charge_cg_resource().
If I move locking rpool_list_lock inside alloc_cg_rpool, unlocking
will continue outside, alloc_cg_rpool() when its found or allocated.
As you acknowledged in below comment that this makes confusing to
lock/unlock from different context, I think current implementation
achieves both.
(a) take lock from single context
(b) keep functionality of find and alloc in two separate individual functions

>
>> This path will be hit anyway on first allocation typically. Once
>> application is warm up, it will be unlikely to enter here.
>> I should change if(!rpool) to if (unlikely(!rpool)).
> Theoretically the new allocated rpool can be released again by the time you
> get to the second call to find_cg_rpool_locked().
>
Thats ok, because if that occurs find_cg_rpool_locked() won't find the
entry and will try to allocate again.
Things work fine in that case.

> I thought that was about functions that only locked the lock, called the
> find function, and released the lock. What I'm suggesting is to have one
> function that does "lock + find + allocate if needed + unlock",

I had similar function in past which does,
"lock + find + allocate if needed + + inc_ref_cnt + unlock", (get_cg_rpool)
update usage_counter atomically, because other thread/process might update too.
check atomic_dec_cnt - on reaching zero, "lock + del_entry + unlock + free".

Tejun asked to simplify this to,

"lock + find + allocate if needed + inc_ref_cnt_without_atomic" + unlock".
which I did in this patch v6.

> and another
> function that does (under caller's lock) "check ref count + check max count +
> release rpool".
This can be done. Have one dumb basic question for thiat.
Can we call kfree() with spin_lock held? All these years I tend to
avoid doing so.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
