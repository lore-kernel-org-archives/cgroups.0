From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg: enable accounting for tty-related objects
Date: Fri, 23 Apr 2021 10:53:55 +0300
Message-ID: <03cb1ce9-143a-1cd0-f34b-d608c3bbc66c@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <da450388-2fbc-1bb8-0839-b6480cb0eead@virtuozzo.com>
 <YIFcqcd4dCiNcILj@kroah.com> <YIFhuwlXKaAaY3IU@dhcp22.suse.cz>
 <YIFjI3zHVQr4BjHc@kroah.com>
 <6e697a1f-936d-5ffe-d29f-e4dcbe099799@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=4pwG92yM2fjpXIGTDKC6EZlz3qmdV2q5+hDcSNXiuko=; b=FTAmvpZkjSs4QYU2y
        yLKl74kOcXThtovkdOC48exCrKIcORnGewNh+shIeW2yv8L8MnKiLCNMhf7uA5WgIyI6+6xcWwC/J
        zL/gMth+kk+raQ+6pt4UdLeq0CCUCWw7RRJE1unOZh4X135vZy33dymutENczgxF/KgWdd88XRm8w
        =;
In-Reply-To: <6e697a1f-936d-5ffe-d29f-e4dcbe099799-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 4/22/21 4:59 PM, Vasily Averin wrote:
> On 4/22/21 2:50 PM, Greg Kroah-Hartman wrote:
>> On Thu, Apr 22, 2021 at 01:44:59PM +0200, Michal Hocko wrote:
>>> On Thu 22-04-21 13:23:21, Greg KH wrote:
>>>> On Thu, Apr 22, 2021 at 01:37:53PM +0300, Vasily Averin wrote:
>>>>> At each login the user forces the kernel to create a new terminal and
>>>>> allocate up to ~1Kb memory for the tty-related structures.
>>>>
>>>> Does this tiny amount of memory actually matter?
>>>
>>> The primary question is whether an untrusted user can trigger an
>>> unbounded amount of these allocations.
>>
>> Can they?  They are not bounded by some other resource limit?
> 
> I'm not ready to provide usecase right now,
> but on the other hand I do not see any related limits.
> Let me take time out to dig this question.

By default it's allowed to create up to 4096 ptys with 1024 reserve for initns only
and the settings are controlled by host admin. It's OK.
Though this default is not enough for hosters with thousands of containers per node.
Host admin can be forced to increase it up to NR_UNIX98_PTY_MAX = 1<<20.

By default container is restricted by pty mount_opt.max = 1024, but admin inside container 
can change it via remount. In result one container can consume almost all allowed ptys 
and allocate up to 1Gb of unaccounted memory.

It is not enough per-se to trigger OOM on host, however anyway, it allows to significantly
exceed the assigned memcg limit and leads to troubles on the over-committed node.
So I still think it makes sense to account this memory.

Btw OpenVz have per-container pty accounting and limits, but upstream does not.

Thank you,
	Vasily Averin.
