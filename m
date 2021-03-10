From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 12:17:41 +0300
Message-ID: <818da0d3-80bb-cf68-2807-6604de36998a@virtuozzo.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWpyRahM3scPgduj2VZeje83N5LT4t9feie9QxWPmu0=;
 b=lmJMQ/APfy8c5LbaSrrZTmmqLmyAJvEFJnnDn2z3M5SlsY5q09jf5oJeJkGUVcWc01b1wfGat9JSA7i1Uz67fywe8tGfIoLSf4mP5Pndyv+fR8lq1XIh9ZY/Al3arU3cshz7emjj1THOtAN76Qb3ouQEzj4ECGjsnUZAMS4FUYU=
In-Reply-To: <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 3/9/21 10:39 PM, Shakeel Butt wrote:
> On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>
>> in_interrupt() check in memcg_kmem_bypass() is incorrect because
>> it does not allow to account memory allocation called from task context
>> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
>>
>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> 
> In that file in_interrupt() is used at other places too. Should we
> change those too?

Yes, you're right, in_interrupt() is used incorrectly in other places too,
but 
1) these cases are not so critical as this one,
2) and are not related to current patch set

They can be replaced later without urgency
(unless I missed something imporant).

thank you,
	Vasily Averin

>> ---
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 845eec0..568f2cb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>>                 return false;
>>
>>         /* Memcg to charge can't be determined. */
>> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>>                 return true;
>>
>>         return false;
>> --
>> 1.8.3.1
>>

