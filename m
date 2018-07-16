From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Mon, 16 Jul 2018 17:45:06 +0800
Message-ID: <CALOAHbD1+eYHDo5-q1--nsBTNj66ZX6iw2YU4koLgZD_0ZDy+w@mail.gmail.com>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com> <20180716075836.GC17280@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=sJTq8AniM1Z+6gTI66hjrVaMXxjjiH/dBEBAepNZTdg=;
        b=DQX6jEAbElBeid5Yo7I0Ir0LxYpc8pAjADQdZ7sO0ZCYpyfiykk5YjN+IbXvUyuZGS
         aKomHEWgv0WOdOcVgy5Ru+Cnzgl/JbRRnXhQGFFGg2wdWHkuraTXHvR52sHqqbMdkbj9
         UM5elV3DwCLqz3G24z79uEVPYnjYTyP31r+GPxes70IzZFtLe0eWsh6A+yHeMo2Z+pi7
         Hevkx/5+MSF4wmctL5N1CqVzCr/RA60W1MSSIRW9a7YNovrB0+87N/9vhrKoL7CMoGhr
         dBm21Xnwfi0LeLLVqhvB6FkEj0QiPTy54Khk2VGWat6rjS7YJqzXmejlJZT5BKZkHtfo
         LhXQ==
In-Reply-To: <20180716075836.GC17280@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jul 16, 2018 at 3:58 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Sat 14-07-18 16:32:02, Yafang Shao wrote:
>> try_charge maybe executed in packet receive path, which is in interrupt
>> context.
>> In this situation, the 'current' is the interrupted task, which may has
>> no relation to the rx softirq, So it is nonsense to use 'current'.
>>
>> Avoid bothering the interrupted if page_counter_try_charge failes.
>
> I agree with Shakeel that this changelog asks for more information about
> "why it matters". Small inconsistencies should be tolerable because the
> state we rely on is so rarely set that it shouldn't make a visible
> difference in practice.
>

HI Michal,

No, it can make a visible difference in pratice.
The difference is in __sk_mem_raise_allocated().

Without this patch, if the random interrupted task is oom victim or
fatal signal pending or exiting, the charge will success anyway. That
means the cgroup limit doesn't work in this situation.

With this patch, in the same situation the charged memory will be
uncharged as it hits the memcg limit.

That is okay if the memcg of the interrupted task is same with the
sk->sk_memcg,  but it may not okay if they are difference.

I'm trying to prove it, but seems it's very hard to produce this issue.

>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>> ---
>>  mm/memcontrol.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 68ef266..13f95db 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2123,6 +2123,9 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>               goto retry;
>>       }
>>
>> +     if (in_softirq())
>> +             goto nomem;
>> +
>
> If anything would it make more sense to use in_interrupt() to be more
> bullet proof for future?
>
>>       /*
>>        * Unlike in global OOM situations, memcg is not in a physical
>>        * memory shortage.  Allow dying and OOM-killed tasks to
>> --
>> 1.8.3.1
>
> --
> Michal Hocko
> SUSE Labs
