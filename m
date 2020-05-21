From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 14:05:30 +0100
Message-ID: <20200521130530.GE990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
 <20200521123742.GO6462@dhcp22.suse.cz>
 <20200521125759.GD990580@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lIVlACF4LDO220gEGSvhc/aauhEeT3bDk/ER46APYDY=;
        b=lm15zqD7bQsCw4wiTNv6NzVw1jCgcLOsWTU1x6wfuW5NkSlsXD99ZPhpzoFHTLPOU8
         b29eUZlH28mu05WYQ2aUGv31+3wJp8CLc5ANp+8VlL/Yd5xKTarIVPKSxWu3uJWSpvsU
         I9xvM12xty15SeSsxedimd/k5ql9zjCbFIxvA=
Content-Disposition: inline
In-Reply-To: <20200521125759.GD990580-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Chris Down writes:
>>I believe I have asked in other email in this thread. Could you explain
>>why enforcint the requested target (memcg_nr_pages_over_high) is
>>insufficient for the problem you are dealing with? Because that would
>>make sense for large targets to me while it would keep relatively
>>reasonable semantic of the throttling - aka proportional to the memory
>>demand rather than the excess.
>
>memcg_nr_pages_over_high is related to the charge size. As such, if 
>you're way over memory.high as a result of transient reclaim failures, 
>but the majority of your charges are small, it's going to hard to make 
>meaningful progress:
>
>1. Most nr_pages will be MEMCG_CHARGE_BATCH, which is not enough to help;
>2. Large allocations will only get a single reclaim attempt to succeed.
>
>As such, in many cases we're either doomed to successfully reclaim a 
>paltry amount of pages, or fail to reclaim a lot of pages. Asking 
>try_to_free_pages() to deal with those huge allocations is generally 
>not reasonable, regardless of the specifics of why it doesn't work in 
>this case.

Oh, I somehow elided the "enforcing" part of your proposal. Still, there's no 
guarantee even if large allocations are reclaimed fully that we will end up 
going back below memory.high, because even a single other large allocation 
which fails to reclaim can knock us out of whack again.
