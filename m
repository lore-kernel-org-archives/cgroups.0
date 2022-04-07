From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Thu, 7 Apr 2022 20:36:51 +0800
Message-ID: <CAGWkznH1NhfDXy94cOs0YWnw_uOOVbcbrygT5X6CAZ44CTf78Q@mail.gmail.com>
References: <CAGWkznG4L3w=9bpZp8TjyWHmqFyZQk-3m4xCZ96zhHCLPawBgQ@mail.gmail.com>
 <CAGWkznGMRohE2_at4Qh8KbwSqNmNqOAG2N1EM+7uE9wKqzRm0A@mail.gmail.com>
 <Ykq7KUleuAg5QnNU@dhcp22.suse.cz> <CAGWkznGbd5TOTHZE8uUhak3SnHqEWx_9QCJVtUFUSg9rk3xYEQ@mail.gmail.com>
 <Ykrkx4JML4c81gBV@dhcp22.suse.cz> <CAGWkznEaEavCz9GeiYuTqsox2qZK43iQKevt8njkzaHv6KiW-A@mail.gmail.com>
 <YkwxNaJIg6ptJOYT@dhcp22.suse.cz> <CAGWkznG=QH3HRSzgum0sQBkyQAahqgiWf8nXCv1qXstxrn7e8w@mail.gmail.com>
 <Yk6VZlGnB48RqnYW@dhcp22.suse.cz> <CAGWkznG+V88f_DjtJAe4_Nr=32Q7Z4b1CaBCB0FVqhAAsuNsWA@mail.gmail.com>
 <Yk6ya5Ks0H6rHPx4@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqCQYphQwwg0rtGAZWw99jUbVGx79hxU7jjCsADQw+A=;
        b=aGbfgoA3tkur8brwef7kNg7t1ICec7XOSo1+xO3axQPqmqJMR4SwQDy9Ro8HMErUIw
         EZbH6DzmcCOFb8F3X/ooGfjNIjvTEoV9Idv/rym45HJvHuXWDJ/27yYnbmkNdo5fY0up
         kwxWkmaTAm8lkFyiITVQGl9aqg4Bwbj7QmsIgihMOWOZ5IP3Uv/Wv1ymFGr7htmaDWOr
         jv4VkZwKyY7weM1wt9Mr1kO6azVn1GBfjJP1v2eHObkxUWfZNieBrrMDvsgoUivaw+8A
         OIn/XsaBiCgWfNmJwrdi76Rm5irA1oZ87NVq3rl205OAtMdKAzj7Vp+1u5jmzo8Wp5rp
         SyDA==
In-Reply-To: <Yk6ya5Ks0H6rHPx4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 7, 2022 at 5:44 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> [...]
> On Thu 07-04-22 16:59:50, Zhaoyang Huang wrote:
> > > This means that limits are altered even if there is memory to be
> > > reclaimed from other memcgs. Why? How does this line up with the
> > > basic property of the low limit to act as a protection from the reclaim?
> > ok, partially understand. I would like to say that low's original
> > definition under this patch has changed, says the calculated low just
> > provide protection when the psi value is lower than the setting and
> > will introduce reclaiming if it exceed.
>
> OK, I guess I finally get to understand what you are trying to say. So
> effectivelly your new semantic defines the low limit as an initial
> protection that is very soft and only preserved under a light global
> memory pressure[1]. If the reclaim pressure is higher the user provided
> protection is decreased. The new semantic is planned to be a global
> opt-in.
>
> Correct?
right. But I don't think the original protection is soft which could
be proved by the test result that the memcg is protected in a certain
range of pressure and could also help to release the system by
breaking low limit.
>
> Now, that I (believe) to have a slightly better understanding I have to
> say I really dislike the idea.
> First of all the new semantic would have to be memcg reclaim aware. That
> means that the scaling logic would need to be aware where the memory
> pressure comes from.
I don't follow. Does it mean that the protected should distinguish the
pressure from global and other memcgs? I don't know why.
> More importantnly I really dislike the idea that the user provided input
> is updated by the kernel without userspace knowledge about that. How is
> the userspace supposed to know that the value has been changed?
Actually, the purpose of this patch is to free the userspace during
runtime which require proper setup of parameter and then let the
scheme decide rest things.
> I can see how the effective values could be scaled down but this still
> sounds dubious as the userspace would have hard time to understand what
> is going on under the cover or even worse tune the value based on the
> specific observed behavior for a specific kernel which would make this a
> maintenance burden going forward.
This kind of memcg is supposed to be used by the user who is aware of
the scheme and would like the scheme to perform as it is.
>
> All that being said I have hard time to make sense of a protection which
> is unpredictably decreasing based on a global metrics without any
> userspace view into why and how this is done. So I am afraid I have to
> NACK this and I really do recommend you to start a discussion about your
> specific usecase and try to find a different solution.
As I have mentioned before, EAS scheduler is also a self-motivating
scheme which is based on load tracking and energy calculation. The
user could also be hard to know when the schedule entity could be
scheduled to big core. The admin could turn it off if dislike.
I would like to push this patch forward and get more feedback from
real scenarios.
>
> Best regards
>
>
> [1] this is based on the global PSI metric.
> --
> Michal Hocko
> SUSE Labs
