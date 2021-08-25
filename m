From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Avoid memory migration when nodemasks
 match
Date: Wed, 25 Aug 2021 06:53:18 -1000
Message-ID: <YSZ1fgJgJfWmvaC4@slm.duckdns.org>
References: <20210825105415.1365360-1-nsaenzju@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=srVnwyk0M43QpIH9IWOJ5w3oSSwwz3TSpreIbqK83Xs=;
        b=lT5qxDybPBPTxb0wcojuyHLh0Egws6+mz9Hc2y2CD7S75wniTMbgVo4hdCWeNFWzh8
         30PWMBRHvgxzpl5/EruxpGhrFnrXY9fEgoD/4zolXt0ETXXGvzFa56n/TYR5ilttSAMW
         /dg9Uy3C373fE6mP6FUWYyYfyD+7z6+P2paYqoIcjvFvoVe3XpLqJq2CuJP7EPHJ5AVv
         yUn7xnnVPIgzDRw/wt2WokHM4ujxNpAp35gjoMKQrlH86vcZXFKs+0Z6PcTBUCbWfBAm
         ZxGda03WTfTYUZxY2VGmQ89MYV+4ntgrDN8KmGUy1ni7qvq41hr6dxCdTGaQb1T4Fo72
         8sVg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210825105415.1365360-1-nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicolas Saenz Julienne <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, Aug 25, 2021 at 12:54:15PM +0200, Nicolas Saenz Julienne wrote:
> With the introduction of ee9707e8593d ("cgroup/cpuset: Enable memory
> migration for cpuset v2") attaching a process to a different cgroup will
> trigger a memory migration regardless of whether it's really needed.
> Memory migration is an expensive operation, so bypass it if the
> nodemasks passed to cpuset_migrate_mm() are equal.
> 
> Note that we're not only avoiding the migration work itself, but also a
> call to lru_cache_disable(), which triggers and flushes an LRU drain
> work on every online CPU.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
