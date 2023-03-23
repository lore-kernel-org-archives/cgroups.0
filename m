From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 6/7] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Thu, 23 Mar 2023 12:00:30 -0400
Message-ID: <20230323160030.GD739026@cmpxchg.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-7-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1679587231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQQYR3tgoTZGjn44UlqD2Q/Bi/7ZZ0L1D2F+tNyu+vY=;
        b=JUSYGg90JZTT6Yd13pjG6DLnrb2PDfmyEiLktcz2+MNdTX1qhs8SEmuA54OaIlpPJb
         DxtqFpASEbLE1v0MWbPxSyp5iJvz/cWT8oHdtMYHkFXPLcVCi5GYkPZurEN1bWPwQDzC
         weuJE2NJS7RteJovT2yARUM6DjWrj4KVVFVUPsqLMqvDhc6sSQI6Mvr+an7mCsZje+Ma
         HzcrGuLfySAPmUsyXVd3Jh0ih8mkd/t0KaiLpkyblfIp5tKl5BXeCDVIuYG91jK7wKEU
         fOndc7BtP6DmMZ+/1A5temMFZBDYv1b7xByaHD0exVuhFbacP6Sn5JBtcOlh09PvP/Ah
         bUrw==
Content-Disposition: inline
In-Reply-To: <20230323040037.2389095-7-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 04:00:36AM +0000, Yosry Ahmed wrote:
> In workingset_refault(), we call mem_cgroup_flush_stats_delayed() to
> flush stats within an RCU read section and with sleeping disallowed.
> Move the call to mem_cgroup_flush_stats_delayed() above the RCU read
> section and allow sleeping to avoid unnecessarily performing a lot of
> work without sleeping.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
> 
> A lot of code paths call into workingset_refault(), so I am not
> generally sure at all whether it's okay to sleep in all contexts or not.
> Feedback here would be very helpful.
> 
> ---
>  mm/workingset.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 042eabbb43f6..410bc6684ea7 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *shadow)
>  	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
>  	eviction <<= bucket_order;
>  
> +	/* Flush stats (and potentially sleep) before holding RCU read lock */
> +	mem_cgroup_flush_stats_delayed(true);

Btw, it might be a good time to rename this while you're in the
area. delayed suggests this is using a delayed_work, but this is
actually sometimes flushing directly from the callsite.

What it's doing is ratelimited calls. A better name would be:

	mem_cgroup_flush_stats_ratelimited()
