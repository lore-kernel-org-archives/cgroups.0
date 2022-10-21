From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Fri, 21 Oct 2022 09:25:52 -0700
Message-ID: <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
References: <20221021160304.1362511-1-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sNPu8q/nEQ+Rmy7Su/VoleNiyJ0OnMotxKUK2gAU0uY=;
        b=C2vuIkV6NxalUVMmtDZIgEbOvdeVqSTHJ0CDZh5xIi5nemi4/4AGB8vtIe3vcfwk0v
         I/0iqJSeHSBkLwA9NbVxgEUEDoKNas8Z5qG8Ppw/t+HmWJAgmeQxPs9m38GX+WqH6N6K
         yhF3ahpKFBV+kqJ1PmU7xTOGIJD1fZ9O/xNiWNaLDuO/2R4aPx2fRDUKsb/NvyDLk8kG
         /sfsU6w01Yd0JP+yPp9nDlz4JBeKKBWm9vFd3z66ZGwiqw5vgQAoYp5rDN0bwO8O7HXQ
         5vka+zbV3IFXAK/reZ4c4Q1IZ/CsAwU408y7C9SycoR0nqeCvixEfv5+E6S5FnQsLjHE
         YDuw==
In-Reply-To: <20221021160304.1362511-1-kuba@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com, netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com, cgroups@vger.kernel.org, roman.gushchin@linux.dev, weiwan@google.com, ncardwell@google.com, ycheng@google.com

On Fri, Oct 21, 2022 at 9:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> As Shakeel explains the commit under Fixes had the unintended
> side-effect of no longer pre-loading the cached memory allowance.
> Even tho we previously dropped the first packet received when
> over memory limit - the consecutive ones would get thru by using
> the cache. The charging was happening in batches of 128kB, so
> we'd let in 128kB (truesize) worth of packets per one drop.
>
> After the change we no longer force charge, there will be no
> cache filling side effects. This causes significant drops and
> connection stalls for workloads which use a lot of page cache,
> since we can't reclaim page cache under GFP_NOWAIT.
>
> Some of the latency can be recovered by improving SACK reneg
> handling but nowhere near enough to get back to the pre-5.15
> performance (the application I'm experimenting with still
> sees 5-10x worst latency).
>
> Apply the suggested workaround of using GFP_ATOMIC. We will now
> be more permissive than previously as we'll drop _no_ packets
> in softirq when under pressure. But I can't think of any good
> and simple way to address that within networking.
>
> Link: https://lore.kernel.org/all/20221012163300.795e7b86@kernel.org/
> Suggested-by: Shakeel Butt <shakeelb@google.com>
> Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: weiwan@google.com
> CC: shakeelb@google.com
> CC: ncardwell@google.com
> CC: ycheng@google.com
> ---
>  include/net/sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 9e464f6409a7..22f8bab583dd 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2585,7 +2585,7 @@ static inline gfp_t gfp_any(void)
>
>  static inline gfp_t gfp_memcg_charge(void)
>  {
> -       return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
> +       return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
>  }
>

How about just using gfp_any() and we can remove gfp_memcg_charge()?
