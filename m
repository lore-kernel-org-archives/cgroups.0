From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 3/8] mm: memcg: inline mem_cgroup_charge_common()
Date: Wed, 12 Mar 2014 13:52:13 +0100
Message-ID: <20140312125213.GB11831@dhcp22.suse.cz>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
 <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 11-03-14 21:28:29, Johannes Weiner wrote:
[...]
> @@ -3919,20 +3919,21 @@ out:
>  	return ret;
>  }
>  
> -/*
> - * Charge the memory controller for page usage.
> - * Return
> - * 0 if the charge was successful
> - * < 0 if the cgroup is over its limit
> - */
> -static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
> -				gfp_t gfp_mask, enum charge_type ctype)
> +int mem_cgroup_newpage_charge(struct page *page,
> +			      struct mm_struct *mm, gfp_t gfp_mask)

s/mem_cgroup_newpage_charge/mem_cgroup_anon_charge/ ?

Would be a better name? The patch would be bigger but the name more
apparent...

Other than that I am good with this. Without (preferably) or without
rename:
Acked-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
