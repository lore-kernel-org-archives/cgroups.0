From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Mon, 20 Nov 2017 21:05:05 +0800
Message-ID: <CALOAHbBC6dGfGiz0hD5K8jX4ygHD1NOcoQ0X3tiBcY5eRXRX3Q@mail.gmail.com>
References: <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
 <20171117155509.GA920@castle> <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
 <20171117164531.GA23745@castle> <CALOAHbABr5gVL0f5LX5M2NstZ=FqzaFxrohu8B97uhrSo6Jp2Q@mail.gmail.com>
 <CALvZod77t3FWgO+rNLHDGU9TZUH-_3qBpzt86BC6R8JJK2ZZ=g@mail.gmail.com>
 <CALOAHbB6+uGNm_RdMiLNCzu+NwZLYcqYJmAZ0FcE8HZts8=JdA@mail.gmail.com>
 <CALvZod6=-dxhaeQMEBwJ5o6iyVhvQ_jdNck-yWncFVRvkb1YXQ@mail.gmail.com>
 <20171120120422.a6r4govoyxjbgp7w@dhcp22.suse.cz> <CALOAHbCRdPSQ8RNZxYY292fsgBTGf92PWPjvnXpbbVVv5LeL6A@mail.gmail.com>
 <20171120123933.fh5mnslggk4kys7d@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=tY6cWXvjGYt7Q5QgUjCN8Ro/hvwgbRyfFgQMOB9U8eY=;
        b=S/rMH/oNs/1jo+Lo+1WVZsqCkaRyBb8luxZXkI4kgqATOG+LExYIo5Sr/aZX7ZGRbm
         vZDVm6y0mbhh7dhGZOuNpMm56Yl9eXo84XJchmZShVm8F/h9WxmLDXqRzFWpVzldegat
         NuJwByw9yPEpNnkLEZpQ9RWzrQfOY4SCj+gXtjKYJaStmGQqnvJTMAX120ZT+yVOUMIz
         fVWnu7WznroGH3RemfDAng70OJLvFOIq739Nne0H9R0fOmsd/MKdl72q5JhVQmiHI8bI
         7klrZxtH3iVKjUEwccnI133D/78lwXcKG7AsJ3SJsa0JACV8v7J5vXij3Iv6EZaHVNjc
         A+Ug==
In-Reply-To: <20171120123933.fh5mnslggk4kys7d-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2017-11-20 20:39 GMT+08:00 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Mon 20-11-17 20:16:15, Yafang Shao wrote:
>> 2017-11-20 20:04 GMT+08:00 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>> > On Fri 17-11-17 09:49:54, Shakeel Butt wrote:
>> >> On Fri, Nov 17, 2017 at 9:41 AM, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > [...]
>> >> > Of couse that is the best way.
>> >> > But we can not ensue all applications will do it.
>> >> > That's why I introduce a proper defalut value for them.
>> >> >
>> >>
>> >> I think we disagree on the how to get proper default value. Unless you
>> >> can restrict that all the memory allocated for a tmpfs mount will be
>> >> charged to a specific memcg, you should not just pick limit of the
>> >> memcg of the process mounting the tmpfs to set the default of tmpfs
>> >> mount. If you can restrict tmpfs charging to a specific memcg then the
>> >> limit of that memcg should be used to set the default of the tmpfs
>> >> mount. However this feature is not present in the upstream kernel at
>> >> the moment (We have this feature in our local kernel and I am planning
>> >> to upstream that).
>> >
>> > I think the whole problem is that containers pretend to be independent
>> > while they share a non-reclaimable resource. Fix this and you will not
>> > have a problem. I am afraid that the only real fix is to make tmpfs
>> > private per container instance and that is something you can easily
>> > achieve in the userspace.
>> >
>>
>> Agree with you.
>
> I suspect you misunderstood...
>
>> Introduce tmpfs stat in memory cgroup, something like
>> memory.tmpfs.limit
>> memory.tmpfs.usage
>>
>> IMHO this is the best solution.
>
> No, you misunderstood. I do not think that we want to split tmpfs out of
> the regular limit. We used to have something like that for user vs.
> kernel memory accounting  in v1 and that turned to be not working well.
>

understood.
That really doesn't work well.

> What you really want to do is to make a private mount per container to
> ensure that the resource is really _yours_
> --

That is what I'm doing it currently.
Then setting the default size depends on the container memory limit works well.

Thanks
Yafang
