From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v4 3/3] block, bfq: do not idle if only one group
 is activated
Date: Thu, 28 Apr 2022 13:24:42 +0200
Message-ID: <20220428112442.m4cx6uc6f4qaicby@quack3.lan>
References: <20220428111907.3635820-1-yukuai3@huawei.com>
 <20220428111907.3635820-4-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651145082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eskgHgHhEq1Wx+VmExpxr/07kCvTFnpRTsUSvj7Vrk4=;
        b=QSbzbmYJDo3PGNt6gMolptedWIYKl/qUh7pJJNT0xu14YEN3XIwbwXAFlBLh0ibgUCEhm2
        /YnT5BLZALgeRjUv2RBQ0PGtuVD6V3M8fF83cyKK8Wf9xjgqS1NP3Jm610ub8t/9GTpvoq
        DsEaE3EY5PtGePslTBbBqpWurhHjh38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651145082;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eskgHgHhEq1Wx+VmExpxr/07kCvTFnpRTsUSvj7Vrk4=;
        b=N97sJgAS8Z3gNWh1Y5NqmLhE0sT0yAxga8mT+3HsUDKkfQ9mdBavXUQ4KpL5kDK3pzKCnx
        wHBpG3IOJkUjr8Cg==
Content-Disposition: inline
In-Reply-To: <20220428111907.3635820-4-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu 28-04-22 19:19:07, Yu Kuai wrote:
> Now that root group is counted into 'num_groups_with_busy_queues',
> 'num_groups_with_busy_queues > 0' is always true in
> bfq_asymmetric_scenario(). Thus change the condition to '> 1'.
> 
> On the other hand, this change can enable concurrent sync io if only
> one group is activated.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  block/bfq-iosched.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 609b4e894684..aeba9001da0b 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -844,7 +844,7 @@ static bool bfq_asymmetric_scenario(struct bfq_data *bfqd,
>  
>  	return varied_queue_weights || multiple_classes_busy
>  #ifdef CONFIG_BFQ_GROUP_IOSCHED
> -	       || bfqd->num_groups_with_busy_queues > 0
> +	       || bfqd->num_groups_with_busy_queues > 1
>  #endif
>  		;
>  }
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
