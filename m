From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 20:48:31 +0100
Message-ID: <20200528194831.GA2017@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <CALvZod7rSeAKXKq_V0SggZWn4aL8pYWJiej4NdRd8MmuwUzPEw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2+YFw/wWl/gn1xFnRRoYscp8dj86Zd6xiRRZw5MlcAI=;
        b=tqHUV/QEgE202z+GHgPg+fGlRS0xZIz4uyNfmy01XYON7v71D5ZVVMVzwMsmXRUNCI
         +wNnZXjkMRgh04H+0uTAJCwfBZkoEkVZ2TXn4uuWhvn/5WhRwgj7zAmDEeqDyjIBwvFQ
         0yUVIbbFUXGJfXQzBRIqhjggve4tOXbOWWNl4=
Content-Disposition: inline
In-Reply-To: <CALvZod7rSeAKXKq_V0SggZWn4aL8pYWJiej4NdRd8MmuwUzPEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

Shakeel Butt writes:
>What was the initial reason to have different behavior in the first place?

This differing behaviour is simply a mistake, it was never intended to be this 
deviate from what happens elsewhere. To that extent this patch is as much a bug 
fix as it is an improvement.

>>  static void high_work_func(struct work_struct *work)
>> @@ -2378,16 +2384,20 @@ void mem_cgroup_handle_over_high(void)
>>  {
>>         unsigned long penalty_jiffies;
>>         unsigned long pflags;
>> +       unsigned long nr_reclaimed;
>>         unsigned int nr_pages = current->memcg_nr_pages_over_high;
>
>Is there any benefit to keep current->memcg_nr_pages_over_high after
>this change? Why not just use SWAP_CLUSTER_MAX?

I don't feel strongly either way, but current->memcg_nr_pages_over_high can be 
very large for large allocations.

That said, maybe we should just reclaim `max(SWAP_CLUSTER_MAX, current - high)` 
for each loop? I agree that with this design it looks like perhaps we don't 
need it any more.

Johannes, what do you think?
