From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: fix test_kmem_memcg_deletion false
 positives
Date: Fri, 4 Aug 2023 12:37:16 -0400
Message-ID: <20230804163716.GA337691@cmpxchg.org>
References: <edpx3ejic2cxolhoynxvwal2i4a35akopg6hshcfxker6oxcn7@l32pzfyucgec>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1691167038; x=1691771838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iUJy9CxyJyDezGa57jwVulgOP6Mhmh9lxMHoUFNxQOg=;
        b=N8zywGIpRTGhPC/hd5Uaa9XnP65QfObz3MOaQDHYBSgg96x0lu4ubKHgZyvQjRg+92
         VimNYt6Qi+T2OSX2whxjKdAwU5/KjPFJAJ8FQDdIS6jXwklryXprXrKQGXj9+OlCaDkz
         3BPikSVV1zG++16OImjNF+EnR6jfDlpZjFzRRbEI2TKM1ALXkZgWSYisS9iRkCf9uPpL
         wBCvyMsghryoppGBxdYYnIv8JITuv327O30KANkFj9SkQRGLPKdUnIYxkMPnuCb+6MV2
         utPvzU/Zd0n7b7YmTIV2gNEhgfjpPjenS3EcryRbLfQHd44dgYs/kyhVn6CXzmHTcpuN
         jP0w==
Content-Disposition: inline
In-Reply-To: <edpx3ejic2cxolhoynxvwal2i4a35akopg6hshcfxker6oxcn7@l32pzfyucgec>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 04, 2023 at 11:37:33AM -0400, Lucas Karpinski wrote:
> The test allocates dcache inside a cgroup, then destroys the cgroups and
> then checks the sanity of numbers on the parent level. The reason it
> fails is because dentries are freed with an RCU delay - a debugging
> sleep shows that usage drops as expected shortly after.
> 
> Insert a 1s sleep after completing the cgroup creation/deletions. This
> should be good enough, assuming that machines running those tests are
> otherwise not very busy. This commit is directly inspired by Johannes
> over at the link below.
> 
> Link: https://lore.kernel.org/all/20230801135632.1768830-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
> 
> Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Maybe I'm missing something, but there isn't a limit set anywhere that
would cause the dentries to be reclaimed and freed, no? When the
subgroups are deleted, the objects are just moved to the parent. The
counters inside the parent (which are hierarchical) shouldn't change.

So this seems to be a different scenario than test_kmem_basic. If the
test is failing for you, I can't quite see why.
