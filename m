From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RESEND PATCH v2 01/12] mm: memcontrol: fix NR_ANON_THPS account
Date: Mon, 7 Dec 2020 13:52:50 +0100
Message-ID: <20201207125250.GI25569@dhcp22.suse.cz>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1607345572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T2DF9O2lPDvLvfews6H05qh+q6mo2ifpg+3z0NLWOmU=;
        b=JkyuanwBZGAl7RP5f3fJExBD/P0ZzLwtz+Af1nqTdRM3Vqs5oNB+EEsHDGtrTVSpPOhWIT
        sNA4l1XPtCSQT2s6qIAKvQrQ+DT6mTBBlatmSjeQBjVhCzIyESGcTijKtlEwsRd+JHmLPl
        foGxCrElXFdr6rIbq4+xwnMSquqGoBc=
Content-Disposition: inline
In-Reply-To: <20201206101451.14706-2-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Sun 06-12-20 18:14:40, Muchun Song wrote:
> The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> by one rather than nr_pages.
> 
> Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22d9bd688d6d..695dedf8687a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5634,10 +5634,8 @@ static int mem_cgroup_move_account(struct page *page,
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

-- 
Michal Hocko
SUSE Labs
