From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: synchronously enforce memory.high
Date: Thu, 10 Feb 2022 14:22:36 -0800
Message-ID: <CALvZod5xFmCVV_AZO1be8pYakmDvYh-QXmNYtTNT4zvCw-m4bQ@mail.gmail.com>
References: <20220210081437.1884008-1-shakeelb@google.com> <20220210081437.1884008-5-shakeelb@google.com>
 <YgVyZrDPxVgP6OLG@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bwpOdgFQsH734At37yjdv4Nb0bvjgu3SgbDAbXyvUB4=;
        b=fI0xbKcdzpA+8Va5155Mdfuw440giBRX8QLLR8+CLcUsOBdRYP4z5OQCb57mF1a8N6
         t4s6l4rmrsyAyL1hj58kI/rAt3V/SV8/lSX51xzZhhhpDCqA409AECsie1YGy4IeHGLE
         +GVtYOgiHoGkj9QW0fe8XD1crWNgUuUWYkRV89jW49qmBY2DLgAVREQwkcLu3xvYYS9r
         kgPtnyKJRn30npoDJjXj4RnYDRe+JgEthHfR2mGk6dY1Mcg5fOQAR3nblzbsl3+Mdw+7
         HYI9DpKPo3laQm7w7tXBN9WHS9Ql//I9J2NxCSL2J+brvwZ7zgOSXv0otFoAhUzNRBlM
         BG4A==
In-Reply-To: <YgVyZrDPxVgP6OLG-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 10, 2022 at 12:15 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
[...]
>
> Has this approach been extensively tested in the production?
>
> Injecting sleeps at return-to-userspace moment is safe in terms of priority
> inversions: a slowed down task will unlikely affect the rest of the system.
>
> It way less predictable for a random allocation in the kernel mode, what if
> the task is already holding a system-wide resource?
>
> Someone might argue that it's not better than a system-wide memory shortage
> and the same allocation might go into a direct reclaim anyway, but with
> the way how memory.high is used it will happen way more often.
>

Thanks for the review.

This patchset is tested in the test environment for now and I do plan
to test this in production but that is a slow process and will take
some time.

Let me answer the main concern you have raised i.e. the safety of
throttling a task synchronously in the charge code path. Please note
that synchronous memory reclaim and oom-killing can already cause the
priority inversion issues you have mentioned. The way we usually
tackle such issues are through userspace controllers. For example oomd
is the userspace solution for catering such issues related to
oom-killing. Here we have a similar userspace daemon monitoring the
workload and deciding if it should let the workload grow or kill it.

Now should we keep the current high limit enforcement implementation
and let it be ineffective for some real workloads or should we make
the enforcement more robust and let the userspace tackle some corner
case priority inversion issues. I think we should follow the second
option as we already have precedence of doing the same for reclaim and
oom-killing.

thanks,
Shakeel
