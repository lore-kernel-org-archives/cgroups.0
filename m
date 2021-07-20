From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v5 13/16] memcg: enable accounting for signals
Date: Tue, 20 Jul 2021 11:42:47 -0500
Message-ID: <87wnplos1k.fsf@disp2133>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
        <cover.1626688654.git.vvs@virtuozzo.com>
        <b19f065e-f3c9-2b20-2798-b60f0fc6b05f@virtuozzo.com>
        <87k0lmryyp.fsf@disp2133>
        <56816a9d-c2e5-127d-4d90-5d7d17782c8a@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56816a9d-c2e5-127d-4d90-5d7d17782c8a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> (Vasily
        Averin's message of "Tue, 20 Jul 2021 11:35:19 +0300")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On 7/19/21 8:32 PM, Eric W. Biederman wrote:
>> Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
>> 
>>> When a user send a signal to any another processes it forces the kernel
>>> to allocate memory for 'struct sigqueue' objects. The number of signals
>>> is limited by RLIMIT_SIGPENDING resource limit, but even the default
>>> settings allow each user to consume up to several megabytes of memory.
>>> Moreover, an untrusted admin inside container can increase the limit or
>>> create new fake users and force them to sent signals.
>> 
>> Not any more.  Currently the number of sigqueue objects is limited
>> by the rlimit of the creator of the user namespace of the container.
>> 
>>> It makes sense to account for these allocations to restrict the host's
>>> memory consumption from inside the memcg-limited container.
>> 
>> Does it?  Why?  The given justification appears to have bit-rotted
>> since -rc1.
>
> Could you please explain what was changed in rc1?
> From my POV accounting is required to help OOM-killer to select proper target.

You can no longer escape the rlimit of the creator of the user
namespace, by creating multiple users inside of the user namespace.  The
users (in the user namespace) will have their individual rlimits but
are jointly by the limit of the creator of the user namespace at the
time the user namespace was created.

>> I know a lot of these things only really need a limit just to catch a
>> program that starts malfunctioning.  If that is indeed the case
>> reasonable per-resource limits are probably better than some great big
>> group limit that can be exhausted with any single resource in the group.
>> 
>> Is there a reason I am not aware of that where it makes sense to group
>> all of the resources together and only count the number of bytes
>> consumed?
>
> Any new limits:
> a) should be set properly depending on huge number of incoming parameters.
> b) should properly notify about hits
> c) should be updated properly after b) 
> d) do a)-c) automatically if possible
>
> In past OpenVz had own accounting subsystem, user beancounters (UBC).
> It accounted and limited 20+ resources  per-container: numfiles, file locks,
> signals, netfilter rules, socket buffers and so on.
> I assume you want to do something similar, so let me share our experience. 
>
> We had a lot of problems with UBC:
> - it's quite hard to set up the limit. 
>   Why it's good to consume N entities of some resource but it's bad to consume N+1 ones? 
>   per-process? per-user? per-thread? per-task? per-namespace? if nested? per-container? per-host?
>   To answer the questions host admin should have additional knowledge and skills.
>
> - Ok, we have set all limits. Some application hits it and fails.
>   It's quite hard to understand that application hits the limit, and failed due to this reason.
>   From users point of view, if some application does not work (stable enough)
>   inside container => containers are guilty.
>
> - It's quite hard to understand that failed application just want to increase limit X up to N entities.
>
> As result both host admins and container users was unhappy.
> So after years of such fights we decided just to limit accounted
> memory instead.


Which is a perfectly fine justification.  However the justification
presented in the change log was that there is no existing limit, and
that is what is factually wrong.

Different kinds of limits serve different purposes.  An accounting of how
many instance of a resource has been used serve the purpose of detecting
when an application has gone completely out of spec.

Limits like you are implementing here are much better for just sharing and
managing system resources.

> Anyway, OOM-killer must know who consumed memory to select proper
> target.

The limits I am talking about are not useful to the OOM killer as
usually the amount of resources that indicates something has gone wrong
are too small to be a system-wide problem.

So please just correct the justification in the commit message and I
will be happy.

Eric  
