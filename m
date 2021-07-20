From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v5 13/16] memcg: enable accounting for signals
Date: Tue, 20 Jul 2021 11:35:19 +0300
Message-ID: <56816a9d-c2e5-127d-4d90-5d7d17782c8a@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
 <b19f065e-f3c9-2b20-2798-b60f0fc6b05f@virtuozzo.com>
 <87k0lmryyp.fsf@disp2133>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=GCfwuXuzQlyWhoFqI2bAb5C2O3u0V1H4t9sAk8gyaiU=; b=o2x2uM9kxU9Ii8mcM
        ngv33zeb7qweb0P3mK2R8eAhFqaxQt6ZcEaksmqdwoZYzXdctpdlMovEX+oZSjSFpM8uxJ6gLHMkO
        Mu0Ncl43GqGbeSSpHpKFig1cIERZbIr86yVht+RnKUlNXocFFbYkh9yY1cEeu5YE7PC2U+Mx7Foi8
        =;
In-Reply-To: <87k0lmryyp.fsf@disp2133>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/19/21 8:32 PM, Eric W. Biederman wrote:
> Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
> 
>> When a user send a signal to any another processes it forces the kernel
>> to allocate memory for 'struct sigqueue' objects. The number of signals
>> is limited by RLIMIT_SIGPENDING resource limit, but even the default
>> settings allow each user to consume up to several megabytes of memory.
>> Moreover, an untrusted admin inside container can increase the limit or
>> create new fake users and force them to sent signals.
> 
> Not any more.  Currently the number of sigqueue objects is limited
> by the rlimit of the creator of the user namespace of the container.
> 
>> It makes sense to account for these allocations to restrict the host's
>> memory consumption from inside the memcg-limited container.
> 
> Does it?  Why?  The given justification appears to have bit-rotted
> since -rc1.

Could you please explain what was changed in rc1?
From my POV accounting is required to help OOM-killer to select proper target.

> I know a lot of these things only really need a limit just to catch a
> program that starts malfunctioning.  If that is indeed the case
> reasonable per-resource limits are probably better than some great big
> group limit that can be exhausted with any single resource in the group.
> 
> Is there a reason I am not aware of that where it makes sense to group
> all of the resources together and only count the number of bytes
> consumed?

Any new limits:
a) should be set properly depending on huge number of incoming parameters.
b) should properly notify about hits
c) should be updated properly after b) 
d) do a)-c) automatically if possible

In past OpenVz had own accounting subsystem, user beancounters (UBC).
It accounted and limited 20+ resources  per-container: numfiles, file locks,
signals, netfilter rules, socket buffers and so on.
I assume you want to do something similar, so let me share our experience. 

We had a lot of problems with UBC:
- it's quite hard to set up the limit. 
  Why it's good to consume N entities of some resource but it's bad to consume N+1 ones? 
  per-process? per-user? per-thread? per-task? per-namespace? if nested? per-container? per-host?
  To answer the questions host admin should have additional knowledge and skills.

- Ok, we have set all limits. Some application hits it and fails.
  It's quite hard to understand that application hits the limit, and failed due to this reason.
  From users point of view, if some application does not work (stable enough)
  inside container => containers are guilty.

- It's quite hard to understand that failed application just want to increase limit X up to N entities.

As result both host admins and container users was unhappy.
So after years of such fights we decided just to limit accounted memory instead.

Anyway, OOM-killer must know who consumed memory to select proper target.

Thank you,
	vasily Averin
 
