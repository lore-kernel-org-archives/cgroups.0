From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Wed, 25 Nov 2015 18:34:53 +0100
Message-ID: <CACT4Y+aWTOaTsSNBYB0F7Y8Ku9o6tF4LYGa+f5EeWGjvK9nn4w@mail.gmail.com>
References: <20150913185940.GA25369@htj.duckdns.org> <55FEC685.5010404@oracle.com>
 <20150921200141.GH13263@mtj.duckdns.org> <20151125144354.GB17308@twins.programming.kicks-ass.net>
 <20151125150207.GM11639@twins.programming.kicks-ass.net> <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=I+8TLoCmGYpDtLKKh03GixkWws9mc/dXSBEwnjtcLBU=;
        b=QJ3/LfVRojRxsenoRDmmo0mnWM176ArX9uL2ic2xH0lJddi0WWQnJ4Wfe/aGt18PAv
         zfHvLY57uB48pbTzKEQVrexM4v6vCsH+yVZ8o7a7S2Gg3A3rpoUorM0uRU8Sl0t43brJ
         kHLdMXkyCAokQPTa9ZnUBNXL/spGYYhpVH53b96CWYxcXgXaOo2BfjKlncUin0XQ7LjV
         Pf/+YTmGFhaK9iH87hCdAXdKH55zyx7jyg5gvK0lNkc0pWcBz3t37l539Jvcp7Y3ayg+
         FAhFAgWIC1LwEGAqgEvYuQUI20t/7ySz0/k1n6ugPVoBk4ELhC/N0zciNHt+enHZJrru
         62Tw==
In-Reply-To: <CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Nov 25, 2015 at 4:31 PM, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2015-11-25 18:02 GMT+03:00 Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
>> On Wed, Nov 25, 2015 at 03:43:54PM +0100, Peter Zijlstra wrote:
>>> On Mon, Sep 21, 2015 at 04:01:41PM -0400, Tejun Heo wrote:
>>> > So, the only way the patch could have caused the above is if someone
>>> > who isn't the task itself is writing to the bitfields while the task
>>> > is running.  Looking through the fields, ->sched_reset_on_fork seems a
>>> > bit suspicious.  __sched_setscheduler() looks like it can modify the
>>> > bit while the target task is running.  Peter, am I misreading the
>>> > code?
>>>
>>> Nope, that's quite possible. Looks like we need to break up those
>>> bitfields a bit. All the scheduler ones should be serialized by
>>> scheduler locks, but the others are fair game.
>>
>> Maybe something like so; but my brain is a complete mess today.
>>
>> ---
>>  include/linux/sched.h | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index f425aac63317..b474e0f05327 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1455,14 +1455,15 @@ struct task_struct {
>>         /* Used for emulating ABI behavior of previous Linux versions */
>>         unsigned int personality;
>>
>> -       unsigned in_execve:1;   /* Tell the LSMs that the process is doing an
>> -                                * execve */
>> -       unsigned in_iowait:1;
>> -
>> -       /* Revert to default priority/policy when forking */
>> +       /* scheduler bits, serialized by scheduler locks */
>>         unsigned sched_reset_on_fork:1;
>>         unsigned sched_contributes_to_load:1;
>>         unsigned sched_migrated:1;
>> +       unsigned __padding_sched:29;
>
> AFAIK the order of bit fields is implementation defined, so GCC could
> sort all these bits as it wants.
> You could use unnamed zero-widht bit-field to force padding:
>
>          unsigned :0; //force aligment to the next boundary.
>
>> +
>> +       /* unserialized, strictly 'current' */
>> +       unsigned in_execve:1; /* bit to tell LSMs we're in execve */
>> +       unsigned in_iowait:1;
>>  #ifdef CONFIG_MEMCG
>>         unsigned memcg_may_oom:1;
>>  #endif
>>

I've gathered some evidence that in my case the guilty bit is
sched_reset_on_fork:
https://groups.google.com/d/msg/syzkaller/o8VqvYNEu_I/I0pXGx79DQAJ

This patch should help.
