From: Bruce Merry <bmerry@ska.ac.za>
Subject: Re: [PATCH] memcg: reduce memcg tree traversals for stats collection
Date: Wed, 25 Jul 2018 13:26:25 +0200
Message-ID: <CAOm-9arFu63A9YJ6yVtm6_LdtbRKZg1Q3dz8WugdkBBQfoOWYw@mail.gmail.com>
References: <20180724224635.143944-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ska-ac-za.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4/LA+odJ6m0a+z3vChCwyKPhprbd9Dgo9CIEQyMnWKQ=;
        b=Ce34qY5A1EWdrbc5JqU+sTVU66bEpl3kyCeuRbiUPo8US47w38FPMEhpL3a7f80Tjh
         OjnPUigoZk3goW/rVkuWUj55Enh2A+I+FYO4qntVCuujx3a+xq3MEqDnjzQhyjtOUIPB
         mPFZlVqyMg7BC9FeBFOherpQ4KjFPEx95vPsFUnPCURufV5PpO1Eix6/NARNC3G5FPki
         TJLQeSn2N9EqdiXQjXFqOVX3BDWWZOno6jVFCNIga/Fz8XmJWi1WarFZwWMiX8T7GZHd
         QR/nkHqbxq5wZwoq3OHiLHA2AtPxxO7AZSQNbera37eLgvd1csSbOdatjbxJUUL+wosF
         vFog==
In-Reply-To: <20180724224635.143944-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>

On 25 July 2018 at 00:46, Shakeel Butt <shakeelb@google.com> wrote:
> I ran a simple benchmark which reads the root_mem_cgroup's stat file
> 1000 times in the presense of 2500 memcgs on cgroup-v1. The results are:
>
> Without the patch:
> $ time ./read-root-stat-1000-times
>
> real    0m1.663s
> user    0m0.000s
> sys     0m1.660s
>
> With the patch:
> $ time ./read-root-stat-1000-times
>
> real    0m0.468s
> user    0m0.000s
> sys     0m0.467s

Thanks for cc'ing me. I've tried this patch using my test case and the
results are interesting. With the patch applied, running my script
only generates about 8000 new cgroups, compared to 40,000 before -
presumably because the optimisation has altered the timing.

On the other hand, if I run the script 5 times to generate 40000
zombie cgroups, the time to get stats for the root cgroup (cgroup-v1)
is almost unchanged at around 18ms (was 20ms, but there were slightly
more cgroups as well), compared to the almost 4x speedup you're seeing
in your test.

Regards
Bruce
-- 
Bruce Merry
Senior Science Processing Developer
SKA South Africa
