From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 25 Jan 2023 09:33:49 +0100
Message-ID: <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674635630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E4rgGfWEon8mTJ3xQufUQx0PpIsnYpjp+SuGeR3ihNs=;
        b=nXei/ipLqEit9F4UME6bDn4D9KuCh4bbgFHAmK08auHOmzF/T17spkqIBC1wJ6MQznsFRL
        7WyZHH6mvlTVh5118YdfhDMWoJhUcbSuL3NzuyhsAcudR18NhCbfuhGq+kn4f1vPn6+fFi
        8cTLmCn9i8Gk0LpdQIuK4T1g8O8fC4U=
Content-Disposition: inline
In-Reply-To: <20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> Disclaimer:
> a - The cover letter got bigger than expected, so I had to split it in
>     sections to better organize myself. I am not very confortable with it.
> b - Performance numbers below did not include patch 5/5 (Remove flags
>     from memcg_stock_pcp), which could further improve performance for
>     drain_all_stock(), but I could only notice the optimization at the
>     last minute.
> 
> 
> 0 - Motivation:
> On current codebase, when drain_all_stock() is ran, it will schedule a
> drain_local_stock() for each cpu that has a percpu stock associated with a
> descendant of a given root_memcg.
> 
> This happens even on 'isolated cpus', a feature commonly used on workloads that
> are sensitive to interruption and context switching such as vRAN and Industrial
> Control Systems.
> 
> Since this scheduling behavior is a problem to those workloads, the proposal is
> to replace the current local_lock + schedule_work_on() solution with a per-cpu
> spinlock.

If IIRC we have also discussed that isolated CPUs can simply opt out
from the pcp caching and therefore the problem would be avoided
altogether without changes to the locking scheme. I do not see anything
regarding that in this submission. Could you elaborate why you have
abandoned this option?
-- 
Michal Hocko
SUSE Labs
