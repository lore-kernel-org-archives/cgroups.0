From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: Extract memcg maxable seq_file logic to
 seq_show_memcg_tunable
Date: Thu, 24 Jan 2019 16:18:58 -0500
Message-ID: <20190124211858.GB14136@cmpxchg.org>
References: <20190124194100.GA31425@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8QPyzRVQ4R9ubbGUT3VNVZFb5dATQ9TpxnhOu99Lads=;
        b=nQVJEQVXSIbr+sl2nooGWUwi1XOyYrbkDY5MU4zGNF6ylfmVIkl6HDKC23kg9lGtbq
         BMWdw1WUXFzg6pzTdMgeJ8pwu8KS5EjVQ03erOwZb/l0A8MXYnQJ2HQuCO6ZyS6uCihD
         z7qBw+J7yvGaPa6RjBUX3tcwUrtbRCXaUbLuhsVYFXfo6WiI97D6B58I2fffjgpKEr+s
         va45jfQ/1CPpWhMlUn+yMmlYK8jxtptGV22VP0Fe/V7HfOmmnuBCx21yWtI7Lhpz9l/T
         iB3LIKtxLTrAC2VtOi08y5JdjVKTSUQf1Gcf/f0Q5kg1FsBWh90koZ3gh8zsHjaWK2BN
         2ONA==
Content-Disposition: inline
In-Reply-To: <20190124194100.GA31425@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu, Jan 24, 2019 at 02:41:00PM -0500, Chris Down wrote:
> memcg has a significant number of files exposed to kernfs where their
> value is either exposed directly or is "max" in the case of
> PAGE_COUNTER_MAX.
> 
> This patch makes this generic by providing a single function to do this
> work. In combination with the previous patch adding mem_cgroup_from_seq,
> this makes all of the seq_show feeder functions significantly more
> simple.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com
> ---
>  mm/memcontrol.c | 64 +++++++++++++++----------------------------------
>  1 file changed, 19 insertions(+), 45 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 98aad31f5226..81b6f752471a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5375,6 +5375,16 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
>  		root_mem_cgroup->use_hierarchy = false;
>  }
>  
> +static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
> +{
> +	if (value == PAGE_COUNTER_MAX)
> +		seq_puts(m, "max\n");
> +	else
> +		seq_printf(m, "%llu\n", (u64)value * PAGE_SIZE);
> +
> +	return 0;
> +}
> +
>  static u64 memory_current_read(struct cgroup_subsys_state *css,
>  			       struct cftype *cft)
>  {
> @@ -5385,15 +5395,8 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
>  
>  static int memory_min_show(struct seq_file *m, void *v)
>  {
> -	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> -	unsigned long min = READ_ONCE(memcg->memory.min);
> -
> -	if (min == PAGE_COUNTER_MAX)
> -		seq_puts(m, "max\n");
> -	else
> -		seq_printf(m, "%llu\n", (u64)min * PAGE_SIZE);
> -
> -	return 0;
> +	return seq_puts_memcg_tunable(m,
> +		READ_ONCE(mem_cgroup_from_seq(m)->memory.min));
>  }

Thanks for doing this.

The main thing that bugged me about the macro is that the data lookup
was split into two places:

	DEFINE_MEMCG_THING(seq, memory_min_show, memory.min);

where memory.min is just a fragment of a designator and you have to
look at the macro to find out what exactly it gets turned into.

With this patch it's obvious, and you don't have to look at the
implementation of seq_puts_memcg_tunable() to understand what's being
printed out.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
