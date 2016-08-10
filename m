From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and OOM
Date: Wed, 10 Aug 2016 11:21:17 +1000
Message-ID: <CAKTCnzkXaZHaJVJGodphFRAnDfDzh9NKTYQqJ-90CMZ93epk3Q@mail.gmail.com>
References: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
 <20160809062900.GD4906@mtj.duckdns.org> <0a7ffe43-c0c6-85df-9bc2-d00fc837e284@gmail.com>
 <20160809142603.GE4906@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2xaBl7XbdGekyLj7nlM7pO+KzSHrgJ7fEFmntnvvgsc=;
        b=sz6KJpE5Gi2RVZLhInR6QiU3rwdwjMFKkAK+3yMMv3eIi4v2yR7vwERyZOBiK8e3dB
         AxcDK/I8j+hWOhV/rUb8LQewalFCVcNlIfImzqNb9JXO0cmtiAezZkRQxDCTqEylRtLq
         WtRp2tensEn/Df5Ph2Wbe/6/rA85oagb48mFc8kgvYrTN5lIk5MyaD6Dif6PwroLNRYz
         63Q0JQjBlKPHCZi631bGRnKnW3roA7MokvmTkaC0G+a7NUtQV/N0YXfcM5Psx6t9IA5/
         i5t9SYOT+EYNA6V9SEtwwwJUiL+yKsveE8XeMmCUs4X1bJWQ6p/04u0AZSD6DuQWDnru
         lqew==
In-Reply-To: <20160809142603.GE4906-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Aug 10, 2016 at 12:26 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Balbir.
>
> On Tue, Aug 09, 2016 at 05:02:47PM +1000, Balbir Singh wrote:
>> > Hmm? Where does mem_cgroup_iter grab cgroup_mutex?  cgroup_mutex nests
>> > outside cgroup_threadgroup_rwsem or most other mutexes for that matter
>> > and isn't exposed from cgroup core.
>> >
>>
>> I based my theory on the code
>>
>> mem_cgroup_iter -> css_next_descendant_pre which asserts
>>
>> cgroup_assert_mutex_or_rcu_locked(),
>>
>> although you are right, we hold RCU lock while calling css_* routines.
>
> That's "or".  The iterator can be called either with RCU lock or
> cgroup_mutex.  cgroup core may use it under cgroup_mutex.  Everyone
> else uses it with rcu.
>
> Thanks.
>

Hi, Tejun

Thanks agreed! Could you please consider queuing the fix after review.

Balbir Singh.
