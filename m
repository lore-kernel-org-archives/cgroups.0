From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH v2 4/4] memcg: synchronously enforce memory.high for
 large overcharges
Date: Wed, 16 Feb 2022 13:12:33 +0000
Message-ID: <Ygz4QQmtrhXwCpG4@chrisdown.name>
References: <20220211064917.2028469-1-shakeelb@google.com>
 <20220211064917.2028469-5-shakeelb@google.com>
 <YgZS+YijLo0/WmEd@chrisdown.name>
 <CALvZod6FwcSyi3B-3fkw4e+7BGrjFF2iRLEZVeurLp2+v-k-dg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m421YRZGEJntA1XH4znYoSO6mB7oCx7u3N2gxq1kXl8=;
        b=aOXX1rJua9aTg8AxXa9i5j/RrNeJ8pxuXHF6ZRAFhiRvpVqHcKu6sdF8v3yuqEvhZz
         dfuCOtY2syT4cnOPJ03kMrqcmIXW+VpNH5kcwGYC0m0PKGxdCthSHpXwTqbzkxAGfREd
         Ox9zBsQGMJZdE/5KrTAyqzsm2d6gLjY19hn2g=
Content-Disposition: inline
In-Reply-To: <CALvZod6FwcSyi3B-3fkw4e+7BGrjFF2iRLEZVeurLp2+v-k-dg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Shakeel Butt writes:
>> Thanks, I was going to comment on v1 that I prefer to keep the implementation
>> of mem_cgroup_handle_over_high if possible since we know that the mechanism has
>> been safe in production over the past few years.
>>
>> One question I have is about throttling. It looks like this new
>> mem_cgroup_handle_over_high callsite may mean that throttling is invoked more
>> than once on a misbehaving workload that's failing to reclaim since the
>> throttling could be invoked both here and in return to userspace, right? That
>> might not be a problem, but we should think about the implications of that,
>> especially in relation to MEMCG_MAX_HIGH_DELAY_JIFFIES.
>>
>
>Please note that mem_cgroup_handle_over_high() clears
>memcg_nr_pages_over_high and if on the return-to-userspace path
>mem_cgroup_handle_over_high() finds that memcg_nr_pages_over_high is
>non-zero, then it means the task has further accumulated the charges
>over high limit after a possibly synchronous
>memcg_nr_pages_over_high() call.

Oh sure, my point was only that MEMCG_MAX_HIGH_DELAY_JIFFIES was to more 
reliably ensure we are returning to userspace at some point in the near future 
to allow the task to have another chance at good behaviour instead of being 
immediately whacked with whatever is monitoring PSI -- for example, in the case 
where we have a daemon which is monitoring its own PSI contributions and will 
make a proactive attempt to free structures in userspace.

That said, the throttling here still isn't unbounded, and it's not likely that 
anyone doing such large allocations after already exceeding memory.high is 
being a good citizen, so I think the patch makes sense as long as the change is 
understood and documented internally.

Thanks!

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
