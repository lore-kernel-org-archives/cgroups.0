From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: fix a data race in scan count
Date: Sun, 9 Feb 2020 20:28:40 -0800
Message-ID: <20200209202840.2bf97ffcfa811550d733c461@linux-foundation.org>
References: <20200206034945.2481-1-cai@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581308920;
        bh=l1OeRezZzhe+y0mBNHwN5J5otTAGBbttv+vIF5SGOJk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=16CmDXbCPWS2GhluQtjfPjZiGcRa6DeS3CtEcGMYB8mhvGi20OtXYMbMkIR31W+2C
         5zAWDQKxBkgmbnZRu1EFfvvbU9j9vaofeckw1R3rowBSLuusqh01YIjP8JbNd3cLww
         44VYaNI4cEWAIktNi/gYtd6WzPyBlKFY/59jKcLo=
In-Reply-To: <20200206034945.2481-1-cai-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed,  5 Feb 2020 22:49:45 -0500 Qian Cai <cai-J5quhbR+WMc@public.gmane.org> wrote:

> struct mem_cgroup_per_node mz.lru_zone_size[zone_idx][lru] could be
> accessed concurrently as noticed by KCSAN,
> 
> ...
>
>  Reported by Kernel Concurrency Sanitizer on:
>  CPU: 95 PID: 50964 Comm: cc1 Tainted: G        W  O L    5.5.0-next-20200204+ #6
>  Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
> 
> The write is under lru_lock, but the read is done as lockless. The scan
> count is used to determine how aggressively the anon and file LRU lists
> should be scanned. Load tearing could generate an inefficient heuristic,
> so fix it by adding READ_ONCE() for the read.
> 
> ...
>
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -533,7 +533,7 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
>  	struct mem_cgroup_per_node *mz;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	return mz->lru_zone_size[zone_idx][lru];
> +	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
>  }

I worry about the readability/maintainability of these things.  A naive
reader who comes upon this code will wonder "why the heck is it using
READ_ONCE?".  A possibly lengthy trawl through the git history will
reveal the reason but that's rather unkind.  Wouldn't a simple

	/* modified under lru_lock, so use READ_ONCE */

improve the situation?


