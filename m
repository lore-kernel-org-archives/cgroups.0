From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcg: return value of the function
 mem_cgroup_from_css() is not checked
Date: Thu, 22 Aug 2019 09:05:50 +0200
Message-ID: <20190822070550.GA12785@dhcp22.suse.cz>
References: <20190822062210.18649-1-yzhai003@ucr.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190822062210.18649-1-yzhai003@ucr.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yizhuo <yzhai003@ucr.edu>
Cc: csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed 21-08-19 23:22:09, Yizhuo wrote:
> Inside function mem_cgroup_wb_domain(), the pointer memcg
> could be NULL via mem_cgroup_from_css(). However, this pointer is
> not checked and directly dereferenced in the if statement,
> which is potentially unsafe.

Could you describe circumstances when this would happen? The code is
this way for 5 years without any issues. Are we just lucky or something
has changed recently to make this happen?
 
> Signed-off-by: Yizhuo <yzhai003@ucr.edu>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 661f046ad318..bd84bdaed3b0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3665,7 +3665,7 @@ struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
>  
> -	if (!memcg->css.parent)
> +	if (!memcg || !memcg->css.parent)
>  		return NULL;
>  
>  	return &memcg->cgwb_domain;
> -- 
> 2.17.1
> 

-- 
Michal Hocko
SUSE Labs
