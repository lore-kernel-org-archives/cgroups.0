From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: use helper macro FLUSH_TIME
Date: Mon, 5 Jun 2023 13:32:19 +0200
Message-ID: <9c475907-0c58-98a2-adaa-6c94b671db9e@redhat.com>
References: <20230603072116.1101690-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685964743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAZyxjHSKhdNxeHRuvnFvS4kEsJUoO6wNay6Vh0Axqo=;
        b=ZrzObrYtQX3hNDNhM6KLzVrwAtg6Mj2D9XxmSA7kCzUSjD7Bc93KseZg8cnYzM9yq6ki+s
        ysud7k57WE46TNAmpY1aBP3Y2EoKyW5IdWk5aDtFoMQyZvErDGsez/j5AWFV4WJJXosvxb
        +4yCcbE/UTc3W9texzyLpc1GjJdJQKc=
Content-Language: en-US
In-Reply-To: <20230603072116.1101690-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03.06.23 09:21, Miaohe Lin wrote:
> Use helper macro FLUSH_TIME to indicate the flush time to improve the
> readability a bit. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d8569594239c..f204c9f2e69c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5397,7 +5397,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>   
>   	if (unlikely(mem_cgroup_is_root(memcg)))
>   		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
> -				   2UL*HZ);
> +				   FLUSH_TIME);
>   	lru_gen_online_memcg(memcg);
>   	return 0;
>   offline_kmem:

Reviewed-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Cheers,

David / dhildenb

