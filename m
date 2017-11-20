From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Mon, 20 Nov 2017 20:16:15 +0800
Message-ID: <CALOAHbCRdPSQ8RNZxYY292fsgBTGf92PWPjvnXpbbVVv5LeL6A@mail.gmail.com>
References: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod7AY=J3i0NL-VuWWOxjdVmWh7VnpcQhdx7+Jt-Hnqrk+g@mail.gmail.com>
 <20171117155509.GA920@castle> <CALOAHbAWvYKve4eB9+zissgi24cNKeFih1=avfSi_dH5upQVOg@mail.gmail.com>
 <20171117164531.GA23745@castle> <CALOAHbABr5gVL0f5LX5M2NstZ=FqzaFxrohu8B97uhrSo6Jp2Q@mail.gmail.com>
 <CALvZod77t3FWgO+rNLHDGU9TZUH-_3qBpzt86BC6R8JJK2ZZ=g@mail.gmail.com>
 <CALOAHbB6+uGNm_RdMiLNCzu+NwZLYcqYJmAZ0FcE8HZts8=JdA@mail.gmail.com>
 <CALvZod6=-dxhaeQMEBwJ5o6iyVhvQ_jdNck-yWncFVRvkb1YXQ@mail.gmail.com> <20171120120422.a6r4govoyxjbgp7w@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=wXPCglxoGEpp8Lx2n7x1lbY6HE5SoMmCZkQ2Wew3RZI=;
        b=Wz3OCuqKBYgGKSuTgf1SILLCWZds+bhdQWKOcYPzpFgbTr7fyoqQE6kX7sqav1tPUm
         mTMD2EyCiAcCkKMd+P+Dzfx/KdopXWT2yAz61sa1VAtPQUIeecllz4/j6CWHwlsz14OC
         XvG+1udtK0AmQq78sjqrpZ7hDAeolDQ9frl9Wx2Q9o1fp7YmLqRzrvNzrLwZP8sz7rw7
         hZHIu49QXGVJNxa3JG4Q/BahXBMOqeh7Ya4aiYwZA1iagtyE26eb7q7LJrsrfOqvk0m6
         +BPi6+ZRW47Rj0aaUmexHAkVQdoBkPwVFTSJbGqfGJOy4jiBNm/4eKM2hVgRYXKIrhip
         ktUg==
In-Reply-To: <20171120120422.a6r4govoyxjbgp7w@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, khlebnikov@yandex-team.ru, mka@chromium.org, Hugh Dickins <hughd@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

2017-11-20 20:04 GMT+08:00 Michal Hocko <mhocko@kernel.org>:
> On Fri 17-11-17 09:49:54, Shakeel Butt wrote:
>> On Fri, Nov 17, 2017 at 9:41 AM, Yafang Shao <laoar.shao@gmail.com> wrote:
> [...]
>> > Of couse that is the best way.
>> > But we can not ensue all applications will do it.
>> > That's why I introduce a proper defalut value for them.
>> >
>>
>> I think we disagree on the how to get proper default value. Unless you
>> can restrict that all the memory allocated for a tmpfs mount will be
>> charged to a specific memcg, you should not just pick limit of the
>> memcg of the process mounting the tmpfs to set the default of tmpfs
>> mount. If you can restrict tmpfs charging to a specific memcg then the
>> limit of that memcg should be used to set the default of the tmpfs
>> mount. However this feature is not present in the upstream kernel at
>> the moment (We have this feature in our local kernel and I am planning
>> to upstream that).
>
> I think the whole problem is that containers pretend to be independent
> while they share a non-reclaimable resource. Fix this and you will not
> have a problem. I am afraid that the only real fix is to make tmpfs
> private per container instance and that is something you can easily
> achieve in the userspace.
>

Agree with you.

Introduce tmpfs stat in memory cgroup, something like
memory.tmpfs.limit
memory.tmpfs.usage

IMHO this is the best solution.

Thanks
Yafang
