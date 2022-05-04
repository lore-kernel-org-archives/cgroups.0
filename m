From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH memcg v2] memcg: accounting for objects allocated for new
 netdevice
Date: Wed, 4 May 2022 13:50:41 -0700
Message-ID: <YnLnIXmamiEuQAo3@bombadil.infradead.org>
References: <53613f02-75f2-0546-d84c-a5ed989327b6@openvz.org>
 <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LUcWUXDVgRzdq1jJHmWhPb5IAqTKtI0mu9qnJVWCZic=; b=rp3tULafgJwVBqrzXLuxhcy/Cp
        Wr2a2vR1oJIDTyhyFZkUrOdOCxirZ2u/G22uY4Av/ItDlm8otE7VnKe2fXojanNUlEyWaoabC/Dwf
        J00DWqbXLn8bndSSTnYoI7TYITG2H1IuBQTQDwOBB2xkJ54dCtWZaJdGf7tPVNYb2Vv/DytdhX/9G
        mkkKPJFcyJNGSDSfFKs5+TawT4xG+qSCMyicGkYx7J42cZLKgWN8TXYzigWCjfDrJU+N1CBm8rp3Q
        9Nhb3PnTxJBMO3I7UEL15fBIw8+A+jwvNz2yOFgwpv22O76MwcP35joAhD4t8jR+dnFu06TC+1DRI
        1otRHafw==;
Content-Disposition: inline
In-Reply-To: <354a0a5f-9ec3-a25c-3215-304eab2157bc-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: Luis Chamberlain <mcgrof-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 02, 2022 at 03:15:51PM +0300, Vasily Averin wrote:
> Creating a new netdevice allocates at least ~50Kb of memory for various
> kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
> creating an unlimited number of netdevice inside a memcg-limited container
> does not fall within memcg restrictions, consumes a significant part
> of the host's memory, can cause global OOM and lead to random kills of
> host processes.
> 
> The main consumers of non-accounted memory are:
>  ~10Kb   80+ kernfs nodes
>  ~6Kb    ipv6_add_dev() allocations
>   6Kb    __register_sysctl_table() allocations
>   4Kb    neigh_sysctl_register() allocations
>   4Kb    __devinet_sysctl_register() allocations
>   4Kb    __addrconf_sysctl_register() allocations
> 
> Accounting of these objects allows to increase the share of memcg-related
> memory up to 60-70% (~38Kb accounted vs ~54Kb total for dummy netdevice
> on typical VM with default Fedora 35 kernel) and this should be enough
> to somehow protect the host from misuse inside container.
> 
> Other related objects are quite small and may not be taken into account
> to minimize the expected performance degradation.
> 
> It should be separately mentonied ~300 bytes of percpu allocation
> of struct ipstats_mib in snmp6_alloc_dev(), on huge multi-cpu nodes
> it can become the main consumer of memory.
> 
> This patch does not enables kernfs accounting as it affects
> other parts of the kernel and should be discussed separately.
> However, even without kernfs, this patch significantly improves the
> current situation and allows to take into account more than half
> of all netdevice allocations.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
> v2: 1) kernfs accounting moved into separate patch, suggested by
>     Shakeel and mkoutny@.
>     2) in ipv6_add_dev() changed original "sizeof(struct inet6_dev)"
>     to "sizeof(*ndev)", according to checkpath.pl recommendation:
>       CHECK: Prefer kzalloc(sizeof(*ndev)...) over kzalloc(sizeof
>         (struct inet6_dev)...)
> ---
>  fs/proc/proc_sysctl.c | 2 +-

for proc_sysctl:

Acked-by: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

  Luis
