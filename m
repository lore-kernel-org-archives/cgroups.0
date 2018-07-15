From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Sun, 15 Jul 2018 10:10:10 +0800
Message-ID: <CALOAHbDV73+X-y7V2Z4nX1C7uCY6yzBPTPZhEvTpN3f7_qWwUw@mail.gmail.com>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com> <CALvZod57QFRVQ7kM4LSNQJACQ+dGC_otJkqK-5+i-0b53Zq5aA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=kqJSv2Ubljjt/IjTKrl1FAo40tWJZsUFjKXl1ffUHqA=;
        b=XPzgGwem3J1j0z49Ln85QCWkZl6/MRuHIe4Ep2JbH5r5bBDuHy4mvGwcQqOtvUgVox
         yDxgtLUICSGdPZ8Lcy9DGeurC7cn6s2p5ndbDZWdF4Hy6310dd1edj8GPgrsuc+Agxvu
         65QIYT/9oZCw5JkjulBgJYvdbnytcv5wInB73ATfVHxdU/fQzvSo8YwapGkElGY26SJL
         sUoRc3C3uJNd9y7zDAXNINW3GIfrLOo+rhtpZpUX/83fS54ZhUdtVsBL24kyVbbrdN+f
         upIwKKZCwswbPXboZbdRVC1iEIh2CxOhwJi+n37gpn/uH8nU6iqHEpxGxzL6EfOunbbM
         dP0g==
In-Reply-To: <CALvZod57QFRVQ7kM4LSNQJACQ+dGC_otJkqK-5+i-0b53Zq5aA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, Jul 14, 2018 at 11:38 PM, Shakeel Butt <shakeelb@google.com> wrote:
> On Sat, Jul 14, 2018 at 1:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>> try_charge maybe executed in packet receive path, which is in interrupt
>> context.
>> In this situation, the 'current' is the interrupted task, which may has
>> no relation to the rx softirq, So it is nonsense to use 'current'.
>>
>
> Have you actually seen this occurring?

Hi Shakeel,

I'm trying to produce this issue, but haven't find it occur yet.

> I am not very familiar with the
> network code but I can think of two ways try_charge() can be called
> from network code. Either through kmem charging or through
> mem_cgroup_charge_skmem() and both locations correctly handle
> interrupt context.
>

Why do you say that mem_cgroup_charge_skmem() correctly hanle
interrupt context ?

Let me show you why mem_cgroup_charge_skmem isn't hanling interrupt
context correctly.

mem_cgroup_charge_skmem() is calling  try_charge() twice.
The first one is with GFP_NOWAIT as the gfp_mask, and the second one
is with  (GFP_NOWAIT |  __GFP_NOFAIL) as the gfp_mask.

If page_counter_try_charge() failes at the first time, -ENOMEM is returned.
Then mem_cgroup_charge_skmem() will call try_charge() once more with
__GFP_NOFAIL set, and this time if If page_counter_try_charge() failes
again the '
force' label in  try_charge() will be executed and 0 is returned.

No matter what, the 'current' will be used and touched, that is
meaning mem_cgroup_charge_skmem() isn't hanling the interrupt context
correctly.

Pls. let me know if I miss something.


Thanks
Yafang
