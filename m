From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: reduce size of memcg vmstats structures
Date: Wed, 7 Sep 2022 19:35:10 -0700
Message-ID: <CALvZod70Mvxr+Nzb6k0yiU2RFYjTD=0NFhKK-Eyp+5ejd1PSFw@mail.gmail.com>
References: <20220907043537.3457014-1-shakeelb@google.com> <20220907043537.3457014-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ky2nnvwk5aMRpug1OiXdRVfX6OZ/Blwf8y/RgQf3zCU=;
        b=IfqRKpQJZLtUUw3FK0nalBJ+FjJYspG6C1fY/6m//4cf4HJJhIsIsPGoRoTTNsCnQS
         7nDJRuNF1imN5jNzf1YM9DNRaGaBVS8u6DC8VjpdD21adZbQ2kRVjn0a8VcZc1183KRg
         2rXc26R4gdOX0PTflk+HqGryZp4BUoLR5cBn30bUaqne7zTicctxBSgJs9JtzcnYXyZL
         eRBGv7Lp6b5LRD1WAHxDRG+vdsi5AHQ5lB6HeYq6qn4StAAY1Di5cQn9AePJ9KKqSKPs
         z6NWDM0fVXaufe1qxDay/6XZqvQJgXE6wAeA8OLyScix0+vjawVxHPhgPncsveXFTinG
         czFA==
In-Reply-To: <20220907043537.3457014-4-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 6, 2022 at 9:36 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
>
>  static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
>  {
>         long x = 0;
>         int cpu;
> +       int index = memcg_events_index(event);
> +
> +       if (index < 0)
> +               return 0;
>
>         for_each_possible_cpu(cpu)
>                 x += per_cpu(memcg->vmstats_percpu->events[event], cpu);

Andrew, can you please replace 'event' in the above line with 'index'?
I had this correct in the original single patch but messed up while
breaking up that patch into three patches for easier review.
