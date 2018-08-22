From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 2/3] proc/kpagecgroup: report also inode numbers of
 offline cgroups
Date: Wed, 22 Aug 2018 07:58:46 -0700
Message-ID: <20180822145846.GT3978217@devbig004.ftw2.facebook.com>
References: <153414348591.737150.14229960913953276515.stgit@buzz>
 <153414348994.737150.10057219558779418929.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9Z9ZfxIvUwL3fTrnXWg72P1xFzFw2cH2SiyagF+m3Ms=;
        b=cxLCjBAFu7j/d2L0Tm6YIzL3cE2bztqZbmJR4SvwQ3gHVGDljOrSHO6Xni3bAUQVrM
         m4iub27LZ/QhR2ie5ktWFPELifPMo0GQ1G25G5Tbj3jRi8AkQU+KKGlYd/Q6u/rVeSgF
         G6fYjy3lHgw7Pey5/vTx3bUMTVqhlbwLSjn4pvbLveTgbwHdDT+2PxdIWk/DHwASAD9v
         svkpoMB6qxbrD60qRwLwcRmxjCmlfbXQ04JcDRMAamicEXm/yLwy5EqKhcglZDJCvtJg
         tYpYXxoHeXMbk61oVIRomfksz3nH5Bg6k9gD5pIl0a70VGr1AlUHGskCBRWX2lZbDmjh
         YfGQ==
Content-Disposition: inline
In-Reply-To: <153414348994.737150.10057219558779418929.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello,

On Mon, Aug 13, 2018 at 09:58:10AM +0300, Konstantin Khlebnikov wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 19a4348974a4..7ef6ea9d5e4a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -333,6 +333,7 @@ struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
>  /**
>   * page_cgroup_ino - return inode number of the memcg a page is charged to
>   * @page: the page
> + * @online: return closest online ancestor
>   *
>   * Look up the closest online ancestor of the memory cgroup @page is charged to
>   * and return its inode number or 0 if @page is not charged to any cgroup. It
> @@ -343,14 +344,14 @@ struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
>   * after page_cgroup_ino() returns, so it only should be used by callers that
>   * do not care (such as procfs interfaces).
>   */
> -ino_t page_cgroup_ino(struct page *page)
> +ino_t page_cgroup_ino(struct page *page, bool online)
>  {
>  	struct mem_cgroup *memcg;
>  	unsigned long ino = 0;
>  
>  	rcu_read_lock();
>  	memcg = READ_ONCE(page->mem_cgroup);
> -	while (memcg && !(memcg->css.flags & CSS_ONLINE))
> +	while (memcg && online && !(memcg->css.flags & CSS_ONLINE))
>  		memcg = parent_mem_cgroup(memcg);
>  	if (memcg)
>  		ino = cgroup_ino(memcg->css.cgroup);

We pin the ino till the cgroup is actually released now but that's an
implementation detail which may change in the future, so I'm not sure
this is a good idea.  Can you instead use the 64bit filehandle exposed
by kernfs?  That's currently also based on ino (+gen) but it's
something guarnateed to stay unique per cgroup and you can easily get
to the cgroup using the fh too.

Thanks.

-- 
tejun
