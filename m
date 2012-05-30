From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 5/6] Also record sleep start for a task group
Date: Wed, 30 May 2012 16:24:40 +0400
Message-ID: <4FC61188.8000908@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-6-git-send-email-glommer@parallels.com> <CAPM31R+VXsffUOSOtMPG=g+G9OdzWMKQvx9usTFa3KBbrqPe6A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31R+VXsffUOSOtMPG=g+G9OdzWMKQvx9usTFa3KBbrqPe6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 03:35 PM, Paul Turner wrote:
> On Wed, May 30, 2012 at 2:48 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> When we're dealing with a task group, instead of a task, also record
>> the start of its sleep time. Since the test agains TASK_UNINTERRUPTIBLE
>> does not really make sense and lack an obvious analogous, we always
>> record it as sleep_start, never block_start.
>>
>> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> CC: Peter Zijlstra<a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
>> CC: Paul Turner<pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/sched/fair.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index c26fe38..d932559 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1182,7 +1182,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>>                                 se->statistics.sleep_start = rq_of(cfs_rq)->clock;
>>                         if (tsk->state&  TASK_UNINTERRUPTIBLE)
>>                                 se->statistics.block_start = rq_of(cfs_rq)->clock;
>> -               }
>> +               } else
>> +                       se->statistics.sleep_start = rq_of(cfs_rq)->clock;
>
> You can't sanely account sleep on a group entity.
>
> Suppose you have 2 sleepers on 1 cpu: you account 1s/s of idle
> Suppose you have 2 sleepers now on 2 cpus: you account 2s/s of idle
>
> Furthermore, in the latter case when one wakes up you still continue
> to accrue sleep time whereas in the former you don't.
>
> Just don't report/collect this.

sleep_start is not for iowait. This is for idle. And I know no other way 
to collect idle time per cgroup, other than the time during which it was 
out of the runqueue.

Now what you say about the sleepers don't make that much sense for idle 
because this information is per-cpu as well.

When the se is being dequeued, it means none of its children is running 
on that runqueue. That's idle.
>>   #endif
>>         }
>>
>> --
>> 1.7.10.2
>>
