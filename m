From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/13] blkcg: introduce common blkg association logic
Date: Fri, 30 Nov 2018 01:52:09 -0800
Message-ID: <20181130095209.GA17103@infradead.org>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-5-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6q7jY9M3Xxr98uF8PXjB8K4B1EQ3wKAhciyGEAcP45I=; b=NuXkr1HNdwTZYBGmox5iKZ5Ou
        O5Ma6ijWm7rEaCXJ540DexIl8KDjQrS81yjU2lgr3+eCcSD7oXwnai/iof3ozxYA0Qlusj9xNIrAO
        /cczBNoLVDYv9rK8tezQccZMlXLmqDUlmtl+sQNDZS0nuoEG9Cqflp8j4sI6Q/Q2CeN8a1qLGOKsc
        g9YjzP3YR31b7lwsW72NYVBMA4HVLnH4ykDqplDTq2jLuVVh4cYVEaRvqwQZbsw9TIlaerbpJyTDf
        T3Y+7R12Hsl2HguZgh34JSzdSUSAcvFgZ1fuqH1USz4vFO+jzxdqN1pvenYV/4qlWjpgIXz8eNQKT
    
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-5-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

>  EXPORT_SYMBOL_GPL(bio_associate_blkcg);
>  
>  /**
> - * bio_associate_blkg - associate a bio with the a blkg
> + * bio_has_queue - required check for blkg association
> + * @bio: target bio
> + *
> + * A blkg represents the relationship between a blkcg and a request_queue.
> + * If there is no request_queue, there is no blkg and therefore nothing to
> + * associate with.
> + */
> +static inline bool bio_has_queue(struct bio *bio)
> +{
> +	return bio->bi_disk && bio->bi_disk->queue;
> +}

How do you ever see a bio without a queue?  We can't even do I/O in
that case.
