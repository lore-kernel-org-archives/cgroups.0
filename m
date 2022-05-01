From: patchwork-bot+netdevbpf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH net] net: enable memcg accounting for veth queues
Date: Sun, 01 May 2022 12:20:12 +0000
Message-ID: <165140761218.13523.5811947461651207574.git-patchwork-notify@kernel.org>
References: <0b28d49b-605c-ac1a-df85-643164e69039@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651407612;
        bh=AoQC0Bv8lDzGTOPaC2dG32rWVQcHbDgTh28kzJFZqhg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WriJgoQmhF3p2p+0IkCw9Arskx+wbtOaGXP2OjQ3ynoLuvY6s/g/91dB/183vCzj6
         sZXSMzdMBNKL2t/qiNL53qV3nFJy5QtKT9rD0f5YDweheNbvLUnPPKf7MCby9fz74V
         UiHHzgwjAURWi5U/CI//ROFzNXhTGMcIOjh73QcnVGnVcyRP/uuZCWN+PIlWuTlA1b
         kAl22G7+rwyLCfcJRJ9108nsKgCRQnkgRVWTvxqVvR2LYkbfO47ieDqZ5/OyeXxzqb
         LeuMZH39YAtw7CA+yHTJt9kka6wk8nOVSU4iWEzHb9c0Bi4n+n8mt+gV1yjb/Q3vRt
         kCGwscvUpthSw==
In-Reply-To: <0b28d49b-605c-ac1a-df85-643164e69039-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>:

On Fri, 29 Apr 2022 08:17:35 +0300 you wrote:
> veth netdevice defines own rx queues and allocates array containing
> up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
> is quite huge and should be accounted to memcg.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/net/veth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: enable memcg accounting for veth queues
    https://git.kernel.org/netdev/net-next/c/961c6136359e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


