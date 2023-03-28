From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v1 7/9] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Tue, 28 Mar 2023 14:43:21 -0400
Message-ID: <ZCM1Sayt3nYZ9LL9@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-8-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680029002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rj2RQnjDsXwaVL7ntpieUXva4Ffe8kxZx/xthWWU0bA=;
        b=gsJgxRHD3bOgSTLtfz5lc8JsyfjCFq9/1NiJAHhPimNN7eSlnuIqbiYFd01bZKnjkP
         vevcfEYFS4Wi1X3PMT55jO0hLoanb2YDgLQB0gSA0WRGTU7cKXBQ7FdqWZXGIUTi0z/D
         uwwS34T9zxFwD124x/eKhqE+Q3wUyFb+2h4s1O+zEfRZmy/OhHw2EFVJgNUkqIBI9O3W
         P1W537yWyPHsem/Dbp1zlCM6bVIkxo4eis/m7QM9I4yKYCM8l+XkutscKtdNCdql72dA
         78QHdu1hsBdcel8kv8irSlL4e6NqUJGVkREQTZ4WoslS1aU7O0XplLGhNFJ9T9qXSA5z
         Fklw==
Content-Disposition: inline
In-Reply-To: <20230328061638.203420-8-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 06:16:36AM +0000, Yosry Ahmed wrote:
> @@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *shadow)
>  	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
>  	eviction <<= bucket_order;
>  
> +	/* Flush stats (and potentially sleep) before holding RCU read lock */
> +	mem_cgroup_flush_stats_ratelimited();
>  	rcu_read_lock();

Minor nit, but please keep the lock section visually separated by an
empty line between the flush and the rcu lock.

Other than that,

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
