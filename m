From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: fix cgroup creation failure after many
 small jobs
Date: Thu, 16 Jun 2016 16:06:17 -0400
Message-ID: <20160616200617.GD3262@mtj.duckdns.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H1sfn0WpaHQfnqkAECgbSyTPdSfWH9b96/BKfQdfkk0=;
        b=TL95e/ma5I+8xzq1k4NtR2vQFvl3SbEIWGTWanPXVSxbwA5mLcV9+XNChlHxkeNFUR
         5odYQ8zxh6FAc1u/74oXnrUvtBu66iu1tQs64JE5aptvKhk5igbn1zpP4VSO+3RzHUB8
         LCZ7e/92lMhWhdM+BKU+j5ltLK6U51wBTYRURpPfaKvdNJWLqNto5kRwLoknyeqnbRp+
         zqnVFs60U1iV8oG9S1BxoeoTPATodqZhdMMXbvqFru52ezDACrMGwBe72T3SFcBXQjYh
         D4giE6bJX2+FUep5Lue4nF5oartI7W6SFIjCl9ysbDf2nYgCGdp/LPAOAj7b65UVjuug
         NPCQ==
Content-Disposition: inline
In-Reply-To: <20160616034244.14839-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

Looks generally good to me.  Some comments below.

On Wed, Jun 15, 2016 at 11:42:44PM -0400, Johannes Weiner wrote:
> @@ -6205,6 +6205,24 @@ struct cgroup *cgroup_get_from_path(const char *path)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_get_from_path);
>  
> +/**
> + * css_id_free - relinquish an existing CSS's ID
> + * @css: the CSS
> + *
> + * This releases the @css's ID and allows it to be recycled while the
> + * CSS continues to exist. This is useful for controllers with state
> + * that extends past a cgroup's lifetime but doesn't need precious ID
> + * address space.
> + *
> + * This invalidates @css->id, and css_from_id() might return NULL or a
> + * new css if the ID has been recycled in the meantime.
> + */
> +void css_id_free(struct cgroup_subsys_state *css)
> +{
> +	cgroup_idr_remove(&css->ss->css_idr, css->id);
> +	css->id = 0;
> +}

I don't quite get why we're trying to free css->id earlier when memcg
is gonna be using its private id anyway.  From cgroup core side, the
id space isn't restricted.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 75e74408cc8f..1d8a6dffdc25 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
...
> +static void mem_cgroup_id_put(struct mem_cgroup *memcg)
> +{
> +	if (atomic_dec_and_test(&memcg->id.ref)) {
> +		idr_remove(&mem_cgroup_idr, memcg->id.id);

Maybe this should do "memcg->id.id = 0"?

> +		css_id_free(&memcg->css);
> +		css_put(&memcg->css);
> +	}
> +}
> +
> +/**
> + * mem_cgroup_from_id - look up a memcg from a memcg id
> + * @id: the memcg id to look up
> + *
> + * Caller must hold rcu_read_lock().
> + */
> +struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> +{
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	return id > 0 ? idr_find(&mem_cgroup_idr, id) : NULL;
> +}

css_from_id() has it too but I don't think id > 0 test is necessary.
We prolly should take it out of css_from_id() too.

It might be useful to add comment explaining why memcg needs private
ids.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
