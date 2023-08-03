From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] selftests: cgroup: fix test_kmem_basic slab1 check
Date: Thu, 3 Aug 2023 12:08:28 -0400
Message-ID: <20230803160828.GA223746@cmpxchg.org>
References: <ix6vzgjqay2x7bskle7pypoint4nj66fwq7odvd5hektatvp2l@kukoifnfj3dr>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1691078909; x=1691683709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+XToHAF3Tp6ttDMOwj4eUjXmrH43hQkGliAE52bu3OI=;
        b=nwBfuP1EF89+aISDQLUPsPs557pMHRTYHh/moPt/GEUf3VZSegFJN2WLjwtOxNaeVr
         tELhzCnpQiVVzn/p9TxTM40ypLAI9Wl8Dm00Ma0u6gCG9cYdJZyEwo/8Du3Xb48kiI3S
         aj+mMtHg5P4dd9nwwPCbs602BbZueBi9x/ZXCX+ClObKOCBNOJ2QGS2u1cys65T6jh4F
         sdy7Pm6FD7EqT02Lj5dytAzyu/Lm8M/yCK7CYer/QhZjZ1QXAsA3k1m/WtIhfHYpfDaQ
         JTwBdRXqxtir8UKBvShgRNW5OjaHl24g01HNtAzPqjO+63i2Pwtjedb13yOisZI7uZQ1
         KP1A==
Content-Disposition: inline
In-Reply-To: <ix6vzgjqay2x7bskle7pypoint4nj66fwq7odvd5hektatvp2l@kukoifnfj3dr>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 03, 2023 at 12:00:47PM -0400, Lucas Karpinski wrote:
> test_kmem_basic creates 100,000 negative dentries, with each one mapping
> to a slab object. After memory.high is set, these are reclaimed through
> the shrink_slab function call which reclaims all 100,000 entries. The
> test passes the majority of the time because when slab1 is calculated,
> it is often above 0, however, 0 is also an acceptable value.
> 
> Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

> @@ -71,7 +71,7 @@ static int test_kmem_basic(const char *root)
>  
>  	cg_write(cg, "memory.high", "1M");
>  	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
> -	if (slab1 <= 0)
> +	if (slab1 < 0)
>  		goto cleanup;

This conflicts with a recent patch already queued up in -mm:

  selftests: cgroup: fix test_kmem_basic false positives

which adds a sleep(1) between cg_write() and cg_read_key_long().

Can you please rebase on top of

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable

and re-send the patch with

  To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

? Thanks

