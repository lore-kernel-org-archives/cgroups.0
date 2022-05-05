From: patchwork-bot+netdevbpf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH memcg v2] memcg: accounting for objects allocated for new
 netdevice
Date: Thu, 05 May 2022 03:50:14 +0000
Message-ID: <165172261402.3043.8768888843456379249.git-patchwork-notify@kernel.org>
References: <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651722614;
        bh=4dZ1A8x6z9o0xBW3mvbt9kERx1ptdza+ot3uRKX85RI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OINEX8NI+m2lY6VcIdMmGXP5yNQYrvaFkv7urohtnNjDBW0aWA+cj6gG+BBc3i1GP
         FFN88R4csBepant6j0jIZPS3L2NiKKB1HBgOdzVeRPzqIRNEE+aeg1vtdDrWPifriN
         hfKLpxlHiCYT8Con3AUFMziOpsTSmUeAazo06Glp+BItdUaBuBTgQXcDP+PYlbfLVF
         h9ikV4IJDCk38DKh3XhfBTrgKcB8OVioOP7LDWdflpEf8i/bCAN2kxXpG1jXCPt1oe
         jS2rolX5yyJnw11AMUXwgrrpv1D8rpnkjzLHrKXTBJQaugOHIUlPwY6Hbksz0VQEV2
         kvXTYPvWU3wgQ==
In-Reply-To: <354a0a5f-9ec3-a25c-3215-304eab2157bc-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:

On Mon, 2 May 2022 15:15:51 +0300 you wrote:
> Creating a new netdevice allocates at least ~50Kb of memory for various
> kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
> creating an unlimited number of netdevice inside a memcg-limited container
> does not fall within memcg restrictions, consumes a significant part
> of the host's memory, can cause global OOM and lead to random kills of
> host processes.
> 
> [...]

Here is the summary with links:
  - [memcg,v2] memcg: accounting for objects allocated for new netdevice
    https://git.kernel.org/netdev/net-next/c/425b9c7f51c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


