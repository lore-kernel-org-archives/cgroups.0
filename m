From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Thu, 7 Apr 2022 11:44:11 +0200
Message-ID: <Yk6ya5Ks0H6rHPx4@dhcp22.suse.cz>
References: <CAGWkznG4L3w=9bpZp8TjyWHmqFyZQk-3m4xCZ96zhHCLPawBgQ@mail.gmail.com>
 <CAGWkznGMRohE2_at4Qh8KbwSqNmNqOAG2N1EM+7uE9wKqzRm0A@mail.gmail.com>
 <Ykq7KUleuAg5QnNU@dhcp22.suse.cz>
 <CAGWkznGbd5TOTHZE8uUhak3SnHqEWx_9QCJVtUFUSg9rk3xYEQ@mail.gmail.com>
 <Ykrkx4JML4c81gBV@dhcp22.suse.cz>
 <CAGWkznEaEavCz9GeiYuTqsox2qZK43iQKevt8njkzaHv6KiW-A@mail.gmail.com>
 <YkwxNaJIg6ptJOYT@dhcp22.suse.cz>
 <CAGWkznG=QH3HRSzgum0sQBkyQAahqgiWf8nXCv1qXstxrn7e8w@mail.gmail.com>
 <Yk6VZlGnB48RqnYW@dhcp22.suse.cz>
 <CAGWkznG+V88f_DjtJAe4_Nr=32Q7Z4b1CaBCB0FVqhAAsuNsWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649324657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tNtnnv47l8kZs+TIL27Yd98JmTykdLmyWqvUcwUs4bc=;
        b=YvvqO5eCoJkTrKNvr0LemmEccjLFQD1q52bnbwoUP3Mp3BSM0wXsKR1i2bKn+G/Lp/LxJE
        UVUxyUL2mSlYBW0+xJmnPTkHgfVj2gOmG99QBtG6XoZNM1xnBiBLjkHX6XmcHZBavCuIiO
        6FU6nqP6u4FkABX4cukU832lSUGRxPY=
Content-Disposition: inline
In-Reply-To: <CAGWkznG+V88f_DjtJAe4_Nr=32Q7Z4b1CaBCB0FVqhAAsuNsWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

[...]
On Thu 07-04-22 16:59:50, Zhaoyang Huang wrote:
> > This means that limits are altered even if there is memory to be
> > reclaimed from other memcgs. Why? How does this line up with the
> > basic property of the low limit to act as a protection from the reclaim?
> ok, partially understand. I would like to say that low's original
> definition under this patch has changed, says the calculated low just
> provide protection when the psi value is lower than the setting and
> will introduce reclaiming if it exceed.

OK, I guess I finally get to understand what you are trying to say. So
effectivelly your new semantic defines the low limit as an initial
protection that is very soft and only preserved under a light global
memory pressure[1]. If the reclaim pressure is higher the user provided
protection is decreased. The new semantic is planned to be a global
opt-in.

Correct?

Now, that I (believe) to have a slightly better understanding I have to
say I really dislike the idea.
First of all the new semantic would have to be memcg reclaim aware. That
means that the scaling logic would need to be aware where the memory
pressure comes from.
More importantnly I really dislike the idea that the user provided input
is updated by the kernel without userspace knowledge about that. How is
the userspace supposed to know that the value has been changed? 
I can see how the effective values could be scaled down but this still
sounds dubious as the userspace would have hard time to understand what
is going on under the cover or even worse tune the value based on the
specific observed behavior for a specific kernel which would make this a
maintenance burden going forward.

All that being said I have hard time to make sense of a protection which
is unpredictably decreasing based on a global metrics without any
userspace view into why and how this is done. So I am afraid I have to
NACK this and I really do recommend you to start a discussion about your
specific usecase and try to find a different solution.

Best regards


[1] this is based on the global PSI metric.
-- 
Michal Hocko
SUSE Labs
