From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: enable memcg oom-kill for __GFP_NOFAIL
Date: Wed, 24 Feb 2021 15:38:05 -0500
Message-ID: <YDa5LcoaaUXszPXz@cmpxchg.org>
References: <20210223204337.2785120-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k+Ml1eYPwjOONJLtwcZvZvyigCe2sKPobwXhkk2LCr8=;
        b=o683AocjgiZ8dTsfbgOPsZ0aNJ93D7mHTzh53sWfdoei5j0GUCUom8CTWS2haEcrTz
         Etc0lxlpqsu/wejXMugE69CVKPANUh9/hPseekOUrWhEMhp+HxppQ7M5KMfPNpi+8uv6
         Pz2E9Ft44GezYCi1smMUl2sf/q2/uIT6JFHyb6POyQmgE90TJJO+qvx9OvOLjRQKQrPP
         98KVonZFM0YhzjL/p4lSzkDV2hP53C4rZNzuKz6HucLSusO72qjeKVfWwXEzBL94NV7/
         wCsvay/o2YDZeBYyR/5tRu7x7EKdsyXlFM45IJLzvzrmNl71lG8xorzEwLULc3Ys92bd
         6NaQ==
Content-Disposition: inline
In-Reply-To: <20210223204337.2785120-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 23, 2021 at 12:43:37PM -0800, Shakeel Butt wrote:
> In the era of async memcg oom-killer, the commit a0d8b00a3381 ("mm:
> memcg: do not declare OOM from __GFP_NOFAIL allocations") added the code
> to skip memcg oom-killer for __GFP_NOFAIL allocations. The reason was
> that the __GFP_NOFAIL callers will not enter aync oom synchronization
> path and will keep the task marked as in memcg oom. At that time the
> tasks marked in memcg oom can bypass the memcg limits and the oom
> synchronization would have happened later in the later userspace
> triggered page fault. Thus letting the task marked as under memcg oom
> bypass the memcg limit for arbitrary time.
> 
> With the synchronous memcg oom-killer (commit 29ef680ae7c21 ("memcg,
> oom: move out_of_memory back to the charge path")) and not letting the
> task marked under memcg oom to bypass the memcg limits (commit
> 1f14c1ac19aa4 ("mm: memcg: do not allow task about to OOM kill to bypass
> the limit")), we can again allow __GFP_NOFAIL allocations to trigger
> memcg oom-kill. This will make memcg oom behavior closer to page
> allocator oom behavior.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
