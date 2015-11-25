From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in handle_mm_fault
Date: Wed, 25 Nov 2015 14:12:26 +0100
Message-ID: <CACT4Y+aeD+dwi79JfC4GOUjFZvbhkPbFh08yWrUWc1JMYoiHgQ@mail.gmail.com>
References: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg@mail.gmail.com>
 <20151124223116.GA2874@cmpxchg.org> <CACT4Y+ZbBNji+176aZmxf5McxS+EV3Sj6Gw+D292JPYx1nyuwQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=d38oV5vcElscTZ7uTgqptRkzMFAg2gobPQNl9KHVYgg=;
        b=liXGCar0D+u756zAORccBo41Bza7otKbsEOYNUn/MRYJu+2VpWOB47QxuKdI/FlnYV
         VTReAkTDf8IuxkzquZJSLx6/vJ2Rw9xj51fQg9CsfenWVPLLsgOZoaEvCKskyrp9FVei
         YKyG4dkCwkKXPhjY/zhs5vFb8BiCDuXNAPYQvRrdhlvmFxJHC7pFVXmPkzx0kis2pTOZ
         JjqQlNWI/TK1m39fWHJjuekxjyFpo2tZ8cp1HucKVyNPrkDXTv5m+prFiL2q7jRdvT8W
         T6F9Nzsn1SbwfdFk02ERdUNxpnZherCKkrwkBE0o6aE+Hj7/Q9LOydP8UyP59cHt4XDa
         Zz8A==
In-Reply-To: <CACT4Y+ZbBNji+176aZmxf5McxS+EV3Sj6Gw+D292JPYx1nyuwQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>

On Wed, Nov 25, 2015 at 2:05 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Tue, Nov 24, 2015 at 11:31 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> Hi Dmitry,
>>
>> On Tue, Nov 24, 2015 at 02:50:26PM +0100, Dmitry Vyukov wrote:
>>> As a blind guess, I've added the following BUG into copy_process:
>>>
>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>> index b4dc490..c5667e8 100644
>>> --- a/kernel/fork.c
>>> +++ b/kernel/fork.c
>>> @@ -1620,6 +1620,8 @@ static struct task_struct *copy_process(unsigned
>>> long clone_flags,
>>>         trace_task_newtask(p, clone_flags);
>>>         uprobe_copy_process(p, clone_flags);
>>>
>>> +       BUG_ON(p->memcg_may_oom);
>>> +
>>>         return p;
>>
>> Thanks for your report.
>>
>> I don't see how this could happen through the legitimate setters of
>> p->memcg_may_oom. Something must clobber it. What happens with the
>> following patch applied?
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index edad7a4..42e1285 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1463,9 +1463,11 @@ struct task_struct {
>>         unsigned sched_reset_on_fork:1;
>>         unsigned sched_contributes_to_load:1;
>>         unsigned sched_migrated:1;
>> +       unsigned dummy_a:1;
>>  #ifdef CONFIG_MEMCG
>>         unsigned memcg_may_oom:1;
>>  #endif
>> +       unsigned dummy_b:1;
>>  #ifdef CONFIG_MEMCG_KMEM
>>         unsigned memcg_kmem_skip_account:1;
>>  #endif
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index f97f2c4..ab6f7ba 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1617,6 +1617,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>         trace_task_newtask(p, clone_flags);
>>         uprobe_copy_process(p, clone_flags);
>>
>> +       if (p->dummy_a || p->dummy_b || p->memcg_may_oom) {
>> +               printk(KERN_ALERT "dummy_a:%d dummy_b:%d memcg_may_oom:%d\n",
>> +                      p->dummy_a, p->dummy_b, p->memcg_may_oom);
>> +               BUG();
>> +       }
>> +
>>         return p;
>>
>>  bad_fork_cancel_cgroup:
>
>
> I cannot reproduce the condition again, either with your patch or with
> mine patch... Will try harder.

I mean that I still can reproduce the original warning, but I can't
catch memcg_may_oom=1 in copy_process.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
