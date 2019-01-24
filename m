From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH 1/2] mm: Rename ambiguously named memory.stat counters
 and functions
Date: Wed, 23 Jan 2019 20:06:38 -0500
Message-ID: <20190124010638.GB9055@chrisdown.name>
References: <20190123223049.GA9149@chrisdown.name>
 <20190123235940.GA21563@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0AkmJA1QYcuNJ5TIP/Rznolsmj53RzAhmVndjUnRVJg=;
        b=r5uoAxGebrDBWOF9OJn2bE4s7TsgVYb4fgBaOXGxU4FWKr/zdeuE2H7v6JA02b/R2x
         d0GEE7UMADZLceRGSNsQP6t6zul1wJHInN4LWH4qXhrhcekXHT0yIPVHQMOPPdaIuCoU
         ng38WFvux3gqwU9dkRgxFHoC2QSaj+/ueAQFc=
Content-Disposition: inline
In-Reply-To: <20190123235940.GA21563@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

Roman Gushchin writes:
>I'd personally go with memcg_vmstat_percpu. Not insisting,
>but you end up using both vmstat and vmstats, which isn't very
>consistent.

Yeah, we also have similar naming in accumulated_vmstats. Hmm, let me think 
about this a bit and get back to you tomorrow. The main bit I was concerned 
about was memory_events vs. events -- I don't really have strong opinions on 
the percpu struct's exact naming/plurality.

>Other than that looks good to me. Please, feel free to add
>Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
