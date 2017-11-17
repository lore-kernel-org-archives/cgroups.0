From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Sat, 18 Nov 2017 01:41:31 +0800
Message-ID: <CALOAHbB6+uGNm_RdMiLNCzu+NwZLYcqYJmAZ0FcE8HZts8=JdA@mail.gmail.com>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
 <20171117155509.GA920@castle> <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
 <20171117164531.GA23745@castle> <CALOAHbABr5gVL0f5LX5M2NstZ=FqzaFxrohu8B97uhrSo6Jp2Q@mail.gmail.com>
 <CALvZod77t3FWgO+rNLHDGU9TZUH-_3qBpzt86BC6R8JJK2ZZ=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=agX1LT3B9veP+cDVBbntjcJ5bsveLW8uUgJelrf9UiA=;
        b=HP+k0dxMyRQ70e9QkrJfDCuxj9+8PviHWwmG7EeGsjEG6Pl4yrCMrYOjkOB6FNWL8/
         6Bm8EQnnvg79fPSbT3h05ov3B1MPhzsAqv23+XB3M5vxTCO4PN1Pv5OJU+D75RvTzkvO
         B0a8rKdcrANzl+HxU+rZxek8EsB64Jq/A9TxXVUcH+ne8bNIaC1MoFsy7Z8RJEMuyXTl
         u4B31edWGKwRPuEje5Gx57SLrV85z/5vylbtA2eIgWZV9IdimA6MADCUV+tEboZnBxK3
         o0KFFycaaUaJ0qgdxrfU9ZrRIc5sJ20XL/TDA+bldEHWfoOLPs69aKQAUabKvvoclDeB
         Z6Lg==
In-Reply-To: <CALvZod77t3FWgO+rNLHDGU9TZUH-_3qBpzt86BC6R8JJK2ZZ=g@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2017-11-18 1:35 GMT+08:00 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:
> On Fri, Nov 17, 2017 at 9:09 AM, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> 2017-11-18 0:45 GMT+08:00 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
>>> On Sat, Nov 18, 2017 at 12:20:40AM +0800, Yafang Shao wrote:
>>>> 2017-11-17 23:55 GMT+08:00 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
>>>> > On Thu, Nov 16, 2017 at 08:43:17PM -0800, Shakeel Butt wrote:
>>>> >> On Thu, Nov 16, 2017 at 7:09 PM, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> >> > Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
>>>> >> > without "-o size=XXX".
>>>> >> > When we mount tmpfs in a container(i.e. docker), it is also
>>>> >> > totalram_pages / 2 regardless of the memory limit on this container.
>>>> >> > That may easily cause OOM if tmpfs occupied too much memory when swap is
>>>> >> > off.
>>>> >> > So when we mount tmpfs in a memcg, the default size should be limited by
>>>> >> > the memcg memory.limit.
>>>> >> >
>>>> >>
>>>> >> The pages of the tmpfs files are charged to the memcg of allocators
>>>> >> which can be in memcg different from the memcg in which the mount
>>>> >> operation happened. So, tying the size of a tmpfs mount where it was
>>>> >> mounted does not make much sense.
>>>> >
>>>> > Also, memory limit is adjustable,
>>>>
>>>> Yes. But that's irrelevant.
>>>>
>>>> > and using a particular limit value
>>>> > at a moment of tmpfs mounting doesn't provide any warranties further.
>>>> >
>>>>
>>>> I can not agree.
>>>> The default size of tmpfs is totalram / 2, the reason we do this is to
>>>> provide any warranties further IMHO.
>>>>
>>>> > Is there a reason why the userspace app which is mounting tmpfs can't
>>>> > set the size based on memory.limit?
>>>>
>>>> That's because of misuse.
>>>> The application should set size with "-o size=" when mount tmpfs, but
>>>> not all applications do this.
>>>> As we can't guarantee that all applications will do this, we should
>>>> give them a proper default value.
>>>
>>> The value you're suggesting is proper only if an app which is mounting
>>> tmpfs resides in the same memcg
>>
>> Yes.
>> But maybe that's mostly used today?
>>
>>> and the memory limit will not be adjusted
>>> significantly later.
>>
>> There's a similar issue for physical memory adjusted by memory hotplug.
>> So what will happen if the physical memory adjusted significantly later ?
>>
>>> Otherwise you can end up with a default value, which
>>> is worse than totalram/2, for instance, if tmpfs is mounted by some helper,
>>> which is located in a separate and very limited memcg.
>>
>> That may happen.
>> Maybe we could improve the solution to handle this issue ?
>>
>>
>
> Let's backtrack, what is the actual concern? If a user/process inside
> a memcg is allocating pages for a file on a tmpfs mounted without size
> parameter, you want the OS to return ENOSPC (if allocation is done by
> write syscall) earlier to not cause the user/process's memcg to OOM.
> Is that right?
>

Right.

> First, there is no guarantee to not cause OOM by restricting tmpfs to
> half the size of memcg limit due to the presence of other memory
> charged to that memcg. The memcg can OOM even before the tmpfs hits
> its size.
>

Just guarantee that the OOM not caused by misuse of tmpfs.

> Second, the users who really care to avoid such scenario should just
> set the size parameter of tmpfs.

Of couse that is the best way.
But we can not ensue all applications will do it.
That's why I introduce a proper defalut value for them.


Thanks
Yafang
