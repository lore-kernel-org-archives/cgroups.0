From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 22:14:41 +0100
Message-ID: <20200528211441.GA3410@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <CALvZod7rSeAKXKq_V0SggZWn4aL8pYWJiej4NdRd8MmuwUzPEw@mail.gmail.com>
 <20200528194831.GA2017@chrisdown.name>
 <20200528202944.GA76514@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Md5HCLgP2FEvxYLu9x06BehC1qjXovJHaXEUB6IGroo=;
        b=tVtux6suf22nedoh998nr2nUX5JUphMEZFx1Mo5ltS8yQR6kIabLVyb+3YEpbDz5OG
         vQXWDGS1o1GyJcdyLG/lH+pz8BSLyVItVBFyS1IDgO033yA5fsTuAysRfzYRrHiwtbxP
         t9F33VrCQRi12tf3yFgiOPMHjDXOjcKQ8rFW4=
Content-Disposition: inline
In-Reply-To: <20200528202944.GA76514-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

Johannes Weiner writes:
>> I don't feel strongly either way, but current->memcg_nr_pages_over_high can
>> be very large for large allocations.
>>
>> That said, maybe we should just reclaim `max(SWAP_CLUSTER_MAX, current -
>> high)` for each loop? I agree that with this design it looks like perhaps we
>> don't need it any more.
>>
>> Johannes, what do you think?
>
>How about this:
>
>Reclaim memcg_nr_pages_over_high in the first iteration, then switch
>to SWAP_CLUSTER_MAX in the retries.
>
>This acknowledges that while the page allocator and memory.max reclaim
>every time an allocation is made, memory.high is currently batched and
>can have larger targets. We want the allocating thread to reclaim at
>least the batch size, but beyond that only what's necessary to prevent
>premature OOM or failing containment.
>
>Add a comment stating as much.
>
>Once we reclaim memory.high synchronously instead of batched, this
>exceptional handling is no longer needed and can be deleted again.
>
>Does that sound reasonable?

That sounds good to me, thanks. I'll change that in v2 soonish and update the 
changelog.
