From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Wed, 23 Jan 2013 12:12:15 +0400
Message-ID: <50FF9B5F.9050402@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com> <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com> <50FD3123.6090003@parallels.com> <20130123010226.GF5359@htj.dyndns.org> <CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 01/23/2013 05:53 AM, Colin Cross wrote:
> On Tue, Jan 22, 2013 at 5:02 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Hello,
>>
>> On Mon, Jan 21, 2013 at 04:14:27PM +0400, Glauber Costa wrote:
>>>> Android userspace is currently using both cpu and cpuacct, and not
>>>> co-mounting them.  They are used for fundamentally different uses such
>>>> that creating a single hierarchy for both of them while maintaining
>>>> the existing behavior is not possible.
>>>>
>>>> We use the cpu cgroup primarily as a priority container.  A simple
>>>> view is that each thread is assigned to a foreground cgroup when it is
>>>> user-visible, and a background cgroup when it is not.  The foreground
>>>> cgroup is assigned a significantly higher cpu.shares value such that
>>>> when each group is fully loaded the background group will get 5% and
>>>> the foreground group will get 95%.
>>>>
>>>> We use the cpuacct cgroup to measure cpu usage per uid, primarily to
>>>> estimate one cause of battery usage.  Each uid gets a cgroup, and when
>>>> spawning a task for a new uid we put it in the appropriate cgroup.
>>>
>>> As we are all in a way sons of Linus the Great, the fact that you have
>>> this usecase should be by itself a reason for us not to deprecate it.
>>>
>>> I still view this, however, as a not common use case. And from the
>>> scheduler PoV, we still have all the duplicate hierarchy walks. So
>>> assuming we would carry on all the changes in this patchset, except the
>>> deprecation, would it be okay for you?
>>>
>>> This way we could take steps to make sure the scheduler codepaths for
>>> cpuacct are not taking during normal comounted operation, and you could
>>> still have your setup unchanged.
>>>
>>> Tejun, any words here?
>>
>> I think the only thing we can do is keeping cpuacct around.  We can
>> still optimize comounted cpu and cpuacct as the usual case.  That
>> said, I'd really like to avoid growing new use cases for separate
>> hierarchies for cpu and cpuacct (well, any controller actually).
>> Having multiple hierarchies is fundamentally broken in that we can't
>> say whether a given resource belongs to certain cgroup independently
>> from the current task, and we're definitnely moving towards unified
>> hierarchy.
> 
> I understand why it makes sense from a code perspective to combine cpu
> and cpuacct, but by combining them you are enforcing a strange
> requirement that to measure the cpu usage of a group of processes you
> force them to be treated as a single scheduling entity by their parent
> group, effectively splitting their time as if they were a single task.
>  That doesn't make any sense to me.
> 
That is a bit backwards.

The question is not if it makes sense to enforce that tasks that are
having their cputime measured needs to be grouped for scheduling
purposes, but rather, if it makes sense to collect timing information
collectively for something that is not a scheduling entity.

The fact that you can do it today, is an artifact of the way cgroups
were implemented in the first place. If controllers were bound to a
single hierarchy from the very beginning, I really doubt you would have
any luck convincing people that allowing separate hierarchy grouping
would be necessary for this.

Again, all that said, now that I survived 2012, I would like to be alive
next year as well. And if we break your use case, Linus will kill us. So
we don't plan to do it.
