From: patchwork-bot+netdevbpf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Date: Wed, 18 Aug 2021 10:50:05 +0000
Message-ID: <162928380597.20153.6653369000646773823.git-patchwork-notify@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629283806;
        bh=jAGprjy7lnIT0fLgWXQfA/u/yXFzXLk5oPCebenv9tg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TZTafczHFHDgQBAVOYKR9utr+27ZLtqF/lzrbPJCa6tfenxHt66ofUHPn91X6a4LH
         P6ydMgt0dChrrqGbgvbBORwSh7p+0L1beXQVY5ZqBlMyyfFQftYq5QISKmNeDsoDtT
         AJEfVa8++IGU8hFJnuh/jF46E270F6d04RQ/PZs4nfAw/RvCCniVOgL04Q/YkdzWYc
         OZNGL2GcdQTwv1E7EeQNixVWBN13BnoUHHpJYygv+rkRYJKBYiCoqVzIRf+BhpwDeC
         DVbhQgtlas9QBzSwqK8jDErOiS6QtYyJJGt8hQdvnGrfgm/V+ZyJWaN5Da5lgo7MJG
         sZbBtqrWrXDGQ==
In-Reply-To: <20210817194003.2102381-1-weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 12:40:03 -0700 you wrote:
> Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> to give more control to the networking stack and enable it to change
> memcg charging behavior. In the future, the networking stack may decide
> to avoid oom-kills when fallbacks are more appropriate.
> 
> One behavior change in mem_cgroup_charge_skmem() by this patch is to
> avoid force charging by default and let the caller decide when and if
> force charging is needed through the presence or absence of
> __GFP_NOFAIL.
> 
> [...]

Here is the summary with links:
  - [net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
    https://git.kernel.org/netdev/net-next/c/4b1327be9fe5

You are awesome, thank you!
