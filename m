From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 1/7] mm: memcontrol: fix NR_ANON_THPS account
Date: Tue, 8 Dec 2020 17:58:30 -0800
Message-ID: <20201209015830.GA2385286@carbon.DHCP.thefacebook.com>
References: <20201208041847.72122-1-songmuchun@bytedance.com>
 <20201208041847.72122-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=aydL4QXg8XURDf2KOlBrMWX/E75tPJ8ATtsmVoERNmQ=;
 b=W6kG7UAoQUNYWIJy2WWuZpDxaDsScbR3xDsevQzVfGWYpwKm6VKNruGodRnc2PMNUtj9
 0KEjKZlaWRClv0iwm74V+782zshPt5KKP3IJfdqFwtwjZQLGMWpUtuGQerBNjKrRyGTi
 C/EPky8BHdRLd4bLIbJ56X1ccTcFGlfCYdM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aydL4QXg8XURDf2KOlBrMWX/E75tPJ8ATtsmVoERNmQ=;
 b=UVJV2aSjngkSqBYVhHWAI9HoX73M8/ZzcKGWxENECd/M3B8O9q/s2R/SuBFSVtkCtIxt0+3HOOMo0vPf71Q++31ZjiHNfCdYYPeMQv/QsfBpfgtRAIfdwU+/l/EXCUrHU7DkzGK6ckUzLlXHjRX+cKQGLTNwqjDels6oho5hGrU=
Content-Disposition: inline
In-Reply-To: <20201208041847.72122-2-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Tue, Dec 08, 2020 at 12:18:41PM +0800, Muchun Song wrote:
> The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> by one rather than nr_pages.
> 
> Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!


> ---
>  mm/memcontrol.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b80328f52fb4..8818bf64d6fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5653,10 +5653,8 @@ static int mem_cgroup_move_account(struct page *page,
>  			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
>  			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
>  			if (PageTransHuge(page)) {
> -				__mod_lruvec_state(from_vec, NR_ANON_THPS,
> -						   -nr_pages);
> -				__mod_lruvec_state(to_vec, NR_ANON_THPS,
> -						   nr_pages);
> +				__dec_lruvec_state(from_vec, NR_ANON_THPS);
> +				__inc_lruvec_state(to_vec, NR_ANON_THPS);
>  			}
>  
>  		}
> -- 
> 2.11.0
> 
