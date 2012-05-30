From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
Date: Wed, 30 May 2012 04:00:37 -0700
Message-ID: <CAPM31RL-X2GYju-opjUumPq_cfGiRzGowXEOx9Tq4kVEG-z3SA@mail.gmail.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
 <1338371317-5980-2-git-send-email-glommer@parallels.com> <1338373759.26856.238.camel@twins>
 <4FC5F727.2040804@parallels.com> <1338374555.26856.243.camel@twins> <4FC5F99B.2060109@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=CTrgDUXN9B0+31/P8W/BowtAF8nbq6Wm5ASjDI3ao8w=;
        b=DeyJ/YMUC0NTsOWMzuDooHjt5W7T9smKSRYid8kmRUvjTfaZzgWf3rpq09KzRRtrrs
         V6euTgULYgfaY/onWfuSN6KESdhkhaOciFWDJgy4vCRRwxq1L4yJ69xDF1wN0+7OLYJT
         Z2rUMdvGJwKcoAIybGtlzu5bz8y2Rs5nxWkFAhk5cImWO66Y14+pmmsEThJ9WrBDnFnv
         0MYiuDBDVRSQzEYmYtRIuVz8yqdffevUAokHnELtnWl646C+n1FP+WexHzBBhMf6cjc+
         Xm6SaR57fl9CEjAvlJbCNsuCwq/+YgHhgvuSd8dPKl7QFjC+qbTBgs51phKLWrjZ7k/T
         NOQw==
In-Reply-To: <4FC5F99B.2060109-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, May 30, 2012 at 3:42 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 05/30/2012 02:42 PM, Peter Zijlstra wrote:
>>
>> On Wed, 2012-05-30 at 14:32 +0400, Glauber Costa wrote:
>>>>>
>>>>> + =A0 =A0for_each_sched_rt_entity(rt_se) {
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0rt_rq =3D rt_rq_of_se(rt_se);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0schedstat_add(rt_rq, exec_clock, delta_e=
xec);
>>>>> + =A0 =A0}
>>>>> +
>>>>> =A0 =A0 =A0if (!rt_bandwidth_enabled())
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>>>>
>>>>
>>>> See, this just makes me sad.. you now have a double
>>>> for_each_sched_rt_entity() loop.
>>>
>>>
>>> The way I read the rt.c code, it it is called from enqueue_task_rt =
only
>>> once.
>>
>>
>> Ah, what I meant was, right after that !rt_bandwidth_enabled() muck =
we
>> do another for_each_sched_rt_entity() walk.
>
> I guess I can fold it there...
>

Does this even need to be hierarchical?  While it's natural for it to
be in the CFS case, it feels forced here.

You could instead make this rt_rq->local_exec_clock  charging only to
the parenting rt_rq and post-aggregate when you want to report.  The
only thing you'd need to be careful of is also accounting children
somewhere on the parent on destruction (reaped_exec_clock?).

Harking back to symmetry, local_exec_clock is also a potentially
useful stat on the CFS side of things since it allows you to usefully
disambiguate versus your children (common case where this is useful is
calculating usage of threads in the root cgroup); so it wouldn't need
to be unique to rt_rq.
