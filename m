From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 1/2] memcg: remove MEMCG_NR_FILE_MAPPED
Date: Fri, 15 Jun 2012 08:18:17 -0700
Message-ID: <xr937gv8vc1y.fsf@gthelen.mtv.corp.google.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        bh=RFGEgXbhg/NGmaHutMnDSPt0CTh+GcIQSdGIs0gCzGw=;
        b=lLO8Yv+Uhx8KZT6Kx5A+7UIfOBkUX3ROWWwSIOx4NshWO56oDWpMI/AYTlnEmYu8QB
         4cJMELEG4Ad0J7svZPAOR4I7LZHmnm1Hurm/C9bocIa/SZs3AEZiH8rLh8CNXI3Gr0YQ
         WiPRxkVdrC7Mx3EXVT5Ovbk1wDE9I+6zdoqB+1h9gse587A/3vV2OeAKJSb64yQyQh4S
         qhljw8Yvf5XaE8e4wsPrHDAbgeYiooMLbqPs/WAwF0biUvyYNbJSeE2rwLg+TqCUD6Cg
         MZANMMrDaUaOFdeyK1dzwPmEONc8APRKVyARPFkwDF/C6s6Z9Q30k/1rATewLjofRug5
         r3MQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, yinghan@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On Fri, Jun 15 2012, Sha Zhengju wrote:

> While doing memcg page stat accounting, there's no need to use MEMCG_NR_FILE_MAPPED
> as an intermediate, we can use MEM_CGROUP_STAT_FILE_MAPPED directly.
>
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> ---
>  include/linux/memcontrol.h |   22 ++++++++++++++++------
>  mm/memcontrol.c            |   25 +------------------------
>  mm/rmap.c                  |    4 ++--
>  3 files changed, 19 insertions(+), 32 deletions(-)

I assume this patch is relative to v3.4.

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f94efd2..a337c2e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -27,9 +27,19 @@ struct page_cgroup;
>  struct page;
>  struct mm_struct;
>  
> -/* Stats that can be updated by kernel. */
> -enum mem_cgroup_page_stat_item {
> -	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
> +/*
> + * Statistics for memory cgroup.
> + */
> +enum mem_cgroup_stat_index {
> +	/*
> +	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
> +	 */
> +	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
> +	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
> +	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
> +	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> +	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
> +	MEM_CGROUP_STAT_NSTATS,
>  };

This has unfortunate side effect of letting code outside of memcontrol.c
manipulate memcg internally managed statistics
(e.g. MEM_CGROUP_STAT_CACHE) with mem_cgroup_{dec,inc}_page_stat.  I
think that your change is fine.  The complexity and presumed performance
overhead of the extra layer of indirection was not worth it.

>  struct mem_cgroup_reclaim_cookie {
> @@ -170,17 +180,17 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>  }
>  
>  void mem_cgroup_update_page_stat(struct page *page,
> -				 enum mem_cgroup_page_stat_item idx,
> +				 enum mem_cgroup_stat_index idx,
>  				 int val);
>  
>  static inline void mem_cgroup_inc_page_stat(struct page *page,
> -					    enum mem_cgroup_page_stat_item idx)
> +					    enum mem_cgroup_stat_index idx)
>  {
>  	mem_cgroup_update_page_stat(page, idx, 1);
>  }
>  
>  static inline void mem_cgroup_dec_page_stat(struct page *page,
> -					    enum mem_cgroup_page_stat_item idx)
> +					    enum mem_cgroup_stat_index idx)
>  {
>  	mem_cgroup_update_page_stat(page, idx, -1);
>  }

You missed two more uses of enum mem_cgroup_page_stat_item in
memcontrol.h.

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a337c2e..08475b9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -390,12 +390,12 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
 }
 
 static inline void mem_cgroup_inc_page_stat(struct page *page,
-					    enum mem_cgroup_page_stat_item idx)
+					    enum mem_cgroup_stat_index idx)
 {
 }
 
 static inline void mem_cgroup_dec_page_stat(struct page *page,
-					    enum mem_cgroup_page_stat_item idx)
+					    enum mem_cgroup_stat_index idx)
 {
 }
