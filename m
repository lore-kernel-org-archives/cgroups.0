From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 2 Jun 2022 06:58:52 -1000
Message-ID: <YpjsTNZx4DG+kot4@slm.duckdns.org>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220602133543.128088-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bpaHA6RKJwrtXGcXqeUi+P0iPjqY+qIkOSMvToigMF4=;
        b=YbkF3Bopk5iHZi38j/bnSLcSgcib6kts8DPsAbi7ASX7PWFeH9aWGQPR7qEvhWPyGF
         Bzxi9qm6V9Fd7zQU6FLI5JX6Tjz+mgDPRXaBi/jXNOjQ32wHCB/nSSdrGORlCu12XvTL
         CuUVhVjfZg13kXV8ZsTc+FmAZWgjaW9KmN0VB8p4Y3V7PRvlp262bqZdy2mAYTPyKlwV
         pqenRp2LmjuA6yQWSbE7HNltyJRkJA7XAGKcXyvVwMOzpZnAA1bxou2/TNdSZyiwgCcG
         GjHPKawxnP6G+vhr4BHV2jFwQZ2oj6iGeXayhYpz+fWwz2vF7OMFkxND7qOwxVHsl975
         3V3w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220602133543.128088-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

Hello,

On Thu, Jun 02, 2022 at 09:35:43AM -0400, Waiman Long wrote:
> @@ -2011,9 +2076,16 @@ void blk_cgroup_bio_start(struct bio *bio)
>  	}
>  	bis->cur.ios[rwd]++;
>  
> +	if (!READ_ONCE(bis->lnode.next)) {
> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +
> +		llist_add(&bis->lnode, lhead);
> +		percpu_ref_get(&bis->blkg->refcnt);

Hmm... what guarantees that more than one threads race here? llist assumes
that there's a single writer for a given llist_node and the ref count would
be off too, right?

Thanks.

-- 
tejun
