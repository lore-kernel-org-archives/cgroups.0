From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 03/18] memcontrol: present maximum used memory also for
 cgroup-v2
Date: Tue, 14 Jun 2016 09:01:31 +0200
Message-ID: <20160614070130.GB5681@dhcp22.suse.cz>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-4-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465847065-3577-4-git-send-email-toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon 13-06-16 22:44:10, Topi Miettinen wrote:
> Present maximum used memory in cgroup memory.current_max.

It would be really much more preferable to present the usecase in the
patch description. It is true that this information is presented in the
v1 API but the current policy is to export new knobs only when there is
a reasonable usecase for it.

> Signed-off-by: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/page_counter.h |  7 ++++++-
>  mm/memcontrol.c              | 13 +++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 7e62920..be4de17 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -9,9 +9,9 @@ struct page_counter {
>  	atomic_long_t count;
>  	unsigned long limit;
>  	struct page_counter *parent;
> +	unsigned long watermark;
>  
>  	/* legacy */
> -	unsigned long watermark;
>  	unsigned long failcnt;
>  };
>  
> @@ -34,6 +34,11 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
>  	return atomic_long_read(&counter->count);
>  }
>  
> +static inline unsigned long page_counter_read_watermark(struct page_counter *counter)
> +{
> +	return counter->watermark;
> +}
> +
>  void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
>  void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
>  bool page_counter_try_charge(struct page_counter *counter,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 75e7440..5513771 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4966,6 +4966,14 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
>  	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
>  }
>  
> +static u64 memory_current_max_read(struct cgroup_subsys_state *css,
> +				   struct cftype *cft)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +
> +	return (u64)page_counter_read_watermark(&memcg->memory) * PAGE_SIZE;
> +}
> +
>  static int memory_low_show(struct seq_file *m, void *v)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> @@ -5179,6 +5187,11 @@ static struct cftype memory_files[] = {
>  		.read_u64 = memory_current_read,
>  	},
>  	{
> +		.name = "current_max",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.read_u64 = memory_current_max_read,
> +	},
> +	{
>  		.name = "low",
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  		.seq_show = memory_low_show,
> -- 
> 2.8.1

-- 
Michal Hocko
SUSE Labs
