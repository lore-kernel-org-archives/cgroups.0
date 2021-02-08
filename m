From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 7/8] mm: memcontrol: consolidate lruvec stat flushing
Date: Sun, 7 Feb 2021 18:28:37 -0800
Message-ID: <CALvZod4ex5V2Xs_6YHmmLJw91rjKTSZ9XobXiRx4ftj=L=A6MA@mail.gmail.com>
References: <20210205182806.17220-1-hannes@cmpxchg.org> <20210205182806.17220-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=prVjlOxJgxegYr5WyW9Puejur2UOLsJUAHlf/hcHxi4=;
        b=P3vCF0PGHm1O1esy5AM5oRBJYOvhkYL9KaghBGfStowxVodRdE6aeYoKVs07gQqCRV
         /KDTE5iE1GBcC277I9pstoXCyEU29eULNB63ExV6UmFLrRdZgK8cat9bk3XBYQWEqBKZ
         /u53kzhG9DHRjLKqrk6f1wV8sTD2D+qeNK6tUSVqb8+zFZWF61kH4Xc8fRs9lLv3r3MI
         6HdoVrX+/2iVx51pPmhaEOfLaGjMlZY73hR6+llJr0bs/KK4S8dT42noXnH9cMoNKDav
         oH6zlOgD5ZCAqGqOIFzXdtV42/msvCRIF4YGwFet67mFYidyVgIrsOpZ9fhTmaF0qdpd
         wr1w==
In-Reply-To: <20210205182806.17220-8-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Fri, Feb 5, 2021 at 10:28 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> There are two functions to flush the per-cpu data of an lruvec into
> the rest of the cgroup tree: when the cgroup is being freed, and when
> a CPU disappears during hotplug. The difference is whether all CPUs or
> just one is being collected, but the rest of the flushing code is the
> same. Merge them into one function and share the common code.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

BTW what about the lruvec stats? Why not convert them to rstat as well?
