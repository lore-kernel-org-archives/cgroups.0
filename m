From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3] fs, mm: account buffer_head to kmemcg
Date: Tue, 19 Jun 2018 12:27:41 -0400
Message-ID: <20180619162741.GC27423@cmpxchg.org>
References: <20180619051327.149716-1-shakeelb@google.com>
 <20180619051327.149716-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IjzRyh3dGjs3iY1KTmpl8JPs/rIgpmEkG8uepgThUhg=; b=nd7imqtf/Bt7PIXzfoMP72TpvJ
        fcVl5OhKp5LuMWMtBUzrPXPexpbfBrKHpgX7cPhiUwFi700FVyXbJ15hbfZ8W/XH5wMX62k9qiK9M
        1yqEscaFfNPDQwB1xjupB5TmDP0srDPuWD8XtBQfssqtlhrioexcIeIw2/B1SwcVsumM=;
Content-Disposition: inline
In-Reply-To: <20180619051327.149716-4-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>

On Mon, Jun 18, 2018 at 10:13:27PM -0700, Shakeel Butt wrote:
> The buffer_head can consume a significant amount of system memory and
> is directly related to the amount of page cache. In our production
> environment we have observed that a lot of machines are spending a
> significant amount of memory as buffer_head and can not be left as
> system memory overhead.
> 
> Charging buffer_head is not as simple as adding __GFP_ACCOUNT to the
> allocation. The buffer_heads can be allocated in a memcg different from
> the memcg of the page for which buffer_heads are being allocated. One
> concrete example is memory reclaim. The reclaim can trigger I/O of pages
> of any memcg on the system. So, the right way to charge buffer_head is
> to extract the memcg from the page for which buffer_heads are being
> allocated and then use targeted memcg charging API.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/buffer.c                | 14 +++++++++++++-
>  include/linux/memcontrol.h |  7 +++++++
>  mm/memcontrol.c            | 21 +++++++++++++++++++++
>  3 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 8194e3049fc5..26389b7a3cab 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -815,10 +815,17 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
>  	struct buffer_head *bh, *head;
>  	gfp_t gfp = GFP_NOFS;
>  	long offset;
> +	struct mem_cgroup *old_memcg;
> +	struct mem_cgroup *memcg = get_mem_cgroup_from_page(page);
>  
>  	if (retry)
>  		gfp |= __GFP_NOFAIL;
>  
> +	if (memcg) {
> +		gfp |= __GFP_ACCOUNT;
> +		old_memcg = memalloc_memcg_save(memcg);
> +	}

Please move the get_mem_cgroup_from_page() call out of the
declarations and down to right before the if (memcg) branch.

>  	head = NULL;
>  	offset = PAGE_SIZE;
>  	while ((offset -= size) >= 0) {
> @@ -835,6 +842,11 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
>  		/* Link the buffer to its page */
>  		set_bh_page(bh, page, offset);
>  	}
> +out:
> +	if (memcg) {
> +		memalloc_memcg_restore(old_memcg);
> +#ifdef CONFIG_MEMCG
> +		css_put(&memcg->css);
> +#endif

Please add a put_mem_cgroup() ;)

Otherwise this looks fine to me.
