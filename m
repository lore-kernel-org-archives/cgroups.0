From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory uncharging
Date: Thu, 7 Sep 2017 12:43:35 -0700
Message-ID: <CALvZod6jNNA=j0WzUzjLxe0vnZeCsJEZ=Q92CgfT65-g2tdCfg@mail.gmail.com>
References: <20170829100150.4580-1-guro@fb.com> <20170829192621.GA5447@cmpxchg.org>
 <20170830105524.GA2852@castle.dhcp.TheFacebook.com> <CALvZod5zP=LL=LhD0WX-zX4mPbn7F_obQmpCrrin9YuBQHJLow@mail.gmail.com>
 <20170907184745.GA20598@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=VsxCXit2z8TbbUeO6l1/feUB5F7vXA7Oo2Nldgc5/mA=;
        b=fNzi8KbTwkMBo6YW7XICyFqyn1tgJf8kn629ITw5BLCa5u4o6boMWAWw6QltNmtJYm
         4+sxBvSsN49BwJWTHhsaCP4tcnZuf/LnYZH872YpmwWKart3u4VVIrzWBUGp08NQilS9
         61Nw3DDPZ7ZuMuf6qmXes46Zii4H90USNg47zCk0720vxKMcRZfMm6GDhKm+NqlwmS11
         7OoUOKic+TYKcY7qmiu5OtjbHteVrUoNhNP97MY4JpO3Qn2KqaDiBvj2SLuqsErY8IMf
         WwVtousrJYett4p9pjubVqqLidcSBt0mJ3Vcve/WaIkb7josFKkagtCJbWbFZs0A70O+
         gmEA==
In-Reply-To: <20170907184745.GA20598@castle.DHCP.thefacebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, LKML <linux-kernel@vger.kernel.org>

On Thu, Sep 7, 2017 at 11:47 AM, Roman Gushchin <guro@fb.com> wrote:
> On Thu, Sep 07, 2017 at 11:44:12AM -0700, Shakeel Butt wrote:
>> >> As far as other types of pages go: page cache and anon are already
>> >> batched pretty well, but I think kmem might benefit from this
>> >> too. Have you considered using the stock in memcg_kmem_uncharge()?
>> >
>> > Good idea!
>> > I'll try to find an appropriate testcase and check if it really
>> > brings any benefits. If so, I'll master a patch.
>> >
>>
>> Hi Roman, did you get the chance to try this on memcg_kmem_uncharge()?
>
> Hi Shakeel!
>
> Not yet, I'll try to it asap.
> Do you have an example when it's costly?
>

Nah, I was also curious of such examples.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
