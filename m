From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Tue, 3 Aug 2021 09:11:25 +0200
Message-ID: <YQjsHTW+46bG9XsV@dhcp22.suse.cz>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com>
 <YQNsxVPsRSBZcfGG@carbon.lan>
 <YQOhGs3k9rHx3mmT@dhcp22.suse.cz>
 <4a3c23c4-054c-2896-29c5-8cf9a4deee98@huawei.com>
 <YQi6lOT6j2DtOGlT@carbon.dhcp.thefacebook.com>
 <95629d91-6ae8-b445-e7fc-b51c888cad59@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627974687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yTB1aRzTEEw2dTSaIA3iMc8Rd5LQIIGML6amfYHIZt4=;
        b=bwvEpu8IwlMFzHs+yKzQ5BkflANLVPluliOGC2khS0BvVK9MnKiTUjZtExbHtFh63auwUB
        A2SyUrkYvGA5kzCzUMoQ2b6UCYU84Nn/R6P49iaFug5gcjrDZ5SLblSEEmEXSS6LWs/dko
        mnKrOFfiafycrcdUJ2jxarlFUwEfmJk=
Content-Disposition: inline
In-Reply-To: <95629d91-6ae8-b445-e7fc-b51c888cad59-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 03-08-21 14:29:13, Miaohe Lin wrote:
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 616d1a72ece3..6210b1124929 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2208,11 +2208,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>   */
>  static void drain_all_stock(struct mem_cgroup *root_memcg)
>  {
> -       static DEFINE_MUTEX(percpu_charge_mutex);
>         int cpu, curcpu;
> +       static atomic_t drainer = ATOMIC_INIT(0);
> 
>         /* If someone's already draining, avoid adding running more workers. */
> -       if (!mutex_trylock(&percpu_charge_mutex))
> +       if (atomic_cmpxchg(&drainer, 0, 1) != 0)
>                 return;
>         /*
>          * Notify other cpus that system-wide "drain" is running
> @@ -2244,7 +2244,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>                 }
>         }
>         put_cpu();
> -       mutex_unlock(&percpu_charge_mutex);
> +       atomic_set(&drainer, 0);

atomic_set doesn't imply memory barrier IIRC. Is this safe?

-- 
Michal Hocko
SUSE Labs
