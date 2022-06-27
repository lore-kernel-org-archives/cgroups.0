From: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled()
Date: Mon, 27 Jun 2022 06:35:28 +0530
Message-ID: <CAFqt6zYd2GVv4kb4tWVVen-pq4ynN=q8jbE+AWmsjfeD8SJmqg@mail.gmail.com>
References: <20220625061844.226764-1-xiangyang3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEDEWM/uIediVqxTgHJ1ffqjVVrgXA7HPhbIDVnGRjA=;
        b=N0kobSzdTz1T5pZSU48sBPPO1LDhIsX6IU8x3mwYeyaf9BsgbSveanERApsoUkF6e3
         2wR3FtV9u/Fx6PCJX7oe/R/5ul4XjCJrnIh3GJEMSR88iF6j3rkjiJoncM+02Z4fLOYB
         v+QcK249wDse+JdkMxAOzb0lLtvlrlJv/8Qf4iY4B9Vy302menS+GWt0kexRSOQj4bvN
         HUv0frlzdNtwdCCnJ+gIESQUF0ZynlonbAkkqOFNPPg8MyUnxKZzVb7n/S0KvPajOWF/
         tX63CdA8mNYxHFVjGEh9J+rrhsvA3T0EEJ27F1MI8qmjVWMWIIw9zeNB4yqYo2mo52SV
         b3mA==
In-Reply-To: <20220625061844.226764-1-xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 25, 2022 at 11:51 AM Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> mem_cgroup_kmem_disabled() checks whether the kmem accounting is off.
> Therefore, replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled(),
> which is the same work in percpu.c and slab_common.c.
>
> Signed-off-by: Xiang Yang <xiangyang3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Souptick Joarder (HPE) <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 85adc43c5a25..4672c9ddd188 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3815,7 +3815,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>  #ifdef CONFIG_MEMCG_KMEM
>  static int memcg_online_kmem(struct mem_cgroup *memcg)
>  {
> -       if (cgroup_memory_nokmem)
> +       if (mem_cgroup_kmem_disabled())
>                 return 0;
>
>         if (unlikely(mem_cgroup_is_root(memcg)))
> @@ -3830,7 +3830,7 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
>
>  static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  {
> -       if (cgroup_memory_nokmem)
> +       if (mem_cgroup_kmem_disabled())
>                 return;
>
>         if (unlikely(mem_cgroup_is_root(memcg)))
> --
> 2.22.0
>
>
