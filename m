From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Fri, 17 Nov 2017 09:35:01 -0800
Message-ID: <CALvZod77t3FWgO+rNLHDGU9TZUH-_3qBpzt86BC6R8JJK2ZZ=g@mail.gmail.com>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
 <20171117155509.GA920@castle> <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
 <20171117164531.GA23745@castle> <CALOAHbABr5gVL0f5LX5M2NstZ=FqzaFxrohu8B97uhrSo6Jp2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=j4C2c7kD41MFEvsbNccZzoLwxKLreLW4KP/0LHNefEk=;
        b=FRHn4uZlKz/ermVUcee/Lnm0MkIBlmnqD8J9f4iDOoTEaqyyBryP3ve/JbaEejWzJh
         64RrKAcfvNUrCGem+3yB5orfls5ZyfR1MBvqNOyC06WH60b0EjLGFFAs7aBfFB9QGxBg
         jsxPBqm2edF1WTuBZTB/SVenpUU6MoP+17IfbfVmwXOOr+cMSLM06cnOx1hDYvQE2N4s
         fj3TSuf78jEY6VKrTh8LxTI5LAdJdzbXEnmI8KcwO3Z/33H8Buxli5sj7F6K/51r7ty7
         RQdVckeapImhHEFnrKaajPchV/ghNNVRnRmTqOal+i4uxrJGdtssOq9oh7n7Bud/u1ZL
         nlAA==
In-Reply-To: <CALOAHbABr5gVL0f5LX5M2NstZ=FqzaFxrohu8B97uhrSo6Jp2Q@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, khlebnikov@yandex-team.ru, mka@chromium.org, Hugh Dickins <hughd@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Nov 17, 2017 at 9:09 AM, Yafang Shao <laoar.shao@gmail.com> wrote:
> 2017-11-18 0:45 GMT+08:00 Roman Gushchin <guro@fb.com>:
>> On Sat, Nov 18, 2017 at 12:20:40AM +0800, Yafang Shao wrote:
>>> 2017-11-17 23:55 GMT+08:00 Roman Gushchin <guro@fb.com>:
>>> > On Thu, Nov 16, 2017 at 08:43:17PM -0800, Shakeel Butt wrote:
>>> >> On Thu, Nov 16, 2017 at 7:09 PM, Yafang Shao <laoar.shao@gmail.com> wrote:
>>> >> > Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
>>> >> > without "-o size=XXX".
>>> >> > When we mount tmpfs in a container(i.e. docker), it is also
>>> >> > totalram_pages / 2 regardless of the memory limit on this container.
>>> >> > That may easily cause OOM if tmpfs occupied too much memory when swap is
>>> >> > off.
>>> >> > So when we mount tmpfs in a memcg, the default size should be limited by
>>> >> > the memcg memory.limit.
>>> >> >
>>> >>
>>> >> The pages of the tmpfs files are charged to the memcg of allocators
>>> >> which can be in memcg different from the memcg in which the mount
>>> >> operation happened. So, tying the size of a tmpfs mount where it was
>>> >> mounted does not make much sense.
>>> >
>>> > Also, memory limit is adjustable,
>>>
>>> Yes. But that's irrelevant.
>>>
>>> > and using a particular limit value
>>> > at a moment of tmpfs mounting doesn't provide any warranties further.
>>> >
>>>
>>> I can not agree.
>>> The default size of tmpfs is totalram / 2, the reason we do this is to
>>> provide any warranties further IMHO.
>>>
>>> > Is there a reason why the userspace app which is mounting tmpfs can't
>>> > set the size based on memory.limit?
>>>
>>> That's because of misuse.
>>> The application should set size with "-o size=" when mount tmpfs, but
>>> not all applications do this.
>>> As we can't guarantee that all applications will do this, we should
>>> give them a proper default value.
>>
>> The value you're suggesting is proper only if an app which is mounting
>> tmpfs resides in the same memcg
>
> Yes.
> But maybe that's mostly used today?
>
>> and the memory limit will not be adjusted
>> significantly later.
>
> There's a similar issue for physical memory adjusted by memory hotplug.
> So what will happen if the physical memory adjusted significantly later ?
>
>> Otherwise you can end up with a default value, which
>> is worse than totalram/2, for instance, if tmpfs is mounted by some helper,
>> which is located in a separate and very limited memcg.
>
> That may happen.
> Maybe we could improve the solution to handle this issue ?
>
>

Let's backtrack, what is the actual concern? If a user/process inside
a memcg is allocating pages for a file on a tmpfs mounted without size
parameter, you want the OS to return ENOSPC (if allocation is done by
write syscall) earlier to not cause the user/process's memcg to OOM.
Is that right?

First, there is no guarantee to not cause OOM by restricting tmpfs to
half the size of memcg limit due to the presence of other memory
charged to that memcg. The memcg can OOM even before the tmpfs hits
its size.

Second, the users who really care to avoid such scenario should just
set the size parameter of tmpfs.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
