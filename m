From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v4 5/9] hugetlb: remove duplicated code
Date: Mon, 16 Sep 2019 15:25:57 -0700
Message-ID: <9fc3270a-4da8-a126-ba91-9e2950b4c36e@oracle.com>
References: <20190910233146.206080-1-almasrymina@google.com>
 <20190910233146.206080-6-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=a+S1+HQwi5n9jZN3U+l0LFhmQpDYNrmD4hYD1N1Wn6s=;
 b=X1qADWrWfJBrJOCtBrR/TNHFIPhsfiR72RsEufBpspSnngcBKcXilsY0DoCAgNp0xka6
 E/d8uvN7yBYar8SrfmBtDJSG+mty/Q4Ame2or6pWws7jUHHigdOfOzPLMKlHnMb6QeLo
 ecr+rvubyPXz6jpIyThb1z2Xj1bSQ2lN+xueU55zAehVUGPi01SrNAbZ0DkaQf91h59K
 5pJWayeDr/5NDtmh/uDYDMoQphTgBGbSR+btDiuHK/wuQ622ufyQ/QHB9zWoDStJmsog
 IeT7qzpr7B+rEFRKcIvRuPgHoLVId2v/StXY8yiHM9OJHAoQpOb5T+1L6d0+8DlXKwdP yw== 
In-Reply-To: <20190910233146.206080-6-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com

On 9/10/19 4:31 PM, Mina Almasry wrote:
> Remove duplicated code between region_chg and region_add, and refactor it into
> a common function, add_reservation_in_range. This is mostly done because
> there is a follow up change in this series that disables region
> coalescing in region_add, and I want to make that change in one place
> only. It should improve maintainability anyway on its own.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Like the previous patch, this is a good improvement indepentent of the
rest of the series.  Thanks!

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

> ---
>  mm/hugetlb.c | 116 ++++++++++++++++++++++++---------------------------
>  1 file changed, 54 insertions(+), 62 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bea51ae422f63..ce5ed1056fefd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -244,6 +244,57 @@ struct file_region {
>  	long to;
>  };
> 
> +static long add_reservation_in_range(
> +		struct resv_map *resv, long f, long t, bool count_only)
> +{
> +
> +	long chg = 0;
> +	struct list_head *head = &resv->regions;
> +	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
> +
> +	/* Locate the region we are before or in. */
> +	list_for_each_entry(rg, head, link)
> +		if (f <= rg->to)
> +			break;
> +
> +	/* Round our left edge to the current segment if it encloses us. */
> +	if (f > rg->from)
> +		f = rg->from;
> +
> +	chg = t - f;
> +
> +	/* Check for and consume any regions we now overlap with. */
> +	nrg = rg;
> +	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
> +		if (&rg->link == head)
> +			break;
> +		if (rg->from > t)
> +			break;
> +
> +		/* We overlap with this area, if it extends further than
> +		 * us then we must extend ourselves.  Account for its
> +		 * existing reservation.
> +		 */
> +		if (rg->to > t) {
> +			chg += rg->to - t;
> +			t = rg->to;
> +		}
> +		chg -= rg->to - rg->from;
> +
> +		if (!count_only && rg != nrg) {
> +			list_del(&rg->link);
> +			kfree(rg);
> +		}
> +	}
> +
> +	if (!count_only) {
> +		nrg->from = f;
> +		nrg->to = t;
> +	}
> +
> +	return chg;
> +}
> +
>  /*
>   * Add the huge page range represented by [f, t) to the reserve
>   * map.  Existing regions will be expanded to accommodate the specified
> @@ -257,7 +308,7 @@ struct file_region {
>  static long region_add(struct resv_map *resv, long f, long t)
>  {
>  	struct list_head *head = &resv->regions;
> -	struct file_region *rg, *nrg, *trg;
> +	struct file_region *rg, *nrg;
>  	long add = 0;
> 
>  	spin_lock(&resv->lock);
> @@ -287,38 +338,7 @@ static long region_add(struct resv_map *resv, long f, long t)
>  		goto out_locked;
>  	}
> 
> -	/* Round our left edge to the current segment if it encloses us. */
> -	if (f > rg->from)
> -		f = rg->from;
> -
> -	/* Check for and consume any regions we now overlap with. */
> -	nrg = rg;
> -	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
> -		if (&rg->link == head)
> -			break;
> -		if (rg->from > t)
> -			break;
> -
> -		/* If this area reaches higher then extend our area to
> -		 * include it completely.  If this is not the first area
> -		 * which we intend to reuse, free it. */
> -		if (rg->to > t)
> -			t = rg->to;
> -		if (rg != nrg) {
> -			/* Decrement return value by the deleted range.
> -			 * Another range will span this area so that by
> -			 * end of routine add will be >= zero
> -			 */
> -			add -= (rg->to - rg->from);
> -			list_del(&rg->link);
> -			kfree(rg);
> -		}
> -	}
> -
> -	add += (nrg->from - f);		/* Added to beginning of region */
> -	nrg->from = f;
> -	add += t - nrg->to;		/* Added to end of region */
> -	nrg->to = t;
> +	add = add_reservation_in_range(resv, f, t, false);
> 
>  out_locked:
>  	resv->adds_in_progress--;
> @@ -345,8 +365,6 @@ static long region_add(struct resv_map *resv, long f, long t)
>   */
>  static long region_chg(struct resv_map *resv, long f, long t)
>  {
> -	struct list_head *head = &resv->regions;
> -	struct file_region *rg;
>  	long chg = 0;
> 
>  	spin_lock(&resv->lock);
> @@ -375,34 +393,8 @@ static long region_chg(struct resv_map *resv, long f, long t)
>  		goto retry_locked;
>  	}
> 
> -	/* Locate the region we are before or in. */
> -	list_for_each_entry(rg, head, link)
> -		if (f <= rg->to)
> -			break;
> -
> -	/* Round our left edge to the current segment if it encloses us. */
> -	if (f > rg->from)
> -		f = rg->from;
> -	chg = t - f;
> -
> -	/* Check for and consume any regions we now overlap with. */
> -	list_for_each_entry(rg, rg->link.prev, link) {
> -		if (&rg->link == head)
> -			break;
> -		if (rg->from > t)
> -			goto out;
> +	chg = add_reservation_in_range(resv, f, t, true);
> 
> -		/* We overlap with this area, if it extends further than
> -		 * us then we must extend ourselves.  Account for its
> -		 * existing reservation. */
> -		if (rg->to > t) {
> -			chg += rg->to - t;
> -			t = rg->to;
> -		}
> -		chg -= rg->to - rg->from;
> -	}
> -
> -out:
>  	spin_unlock(&resv->lock);
>  	return chg;
>  }
> --
> 2.23.0.162.g0b9fbb3734-goog
> 
