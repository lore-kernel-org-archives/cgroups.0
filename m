From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/13] blkcg: associate blkg when associating a device
Date: Fri, 30 Nov 2018 01:54:26 -0800
Message-ID: <20181130095426.GB17103@infradead.org>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-6-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p6IDe3bNmVkdaqZzqzDEjWVzPy/63DcTYLmFYB4F5G0=; b=SceZ3EYkvE8T71CX9GkyfDZS4
        otcQyrPL1cYn89V2MIKJAD8qdIX8lhfrBtcd9ddngw4Yos8ezI6xzzUcXOi1J/qXlH5GzNYcEuSs6
        ESpF1WyHF3HFmgCHjz5Z3nqHa0mP4n14lC23NTGuarFdjFOxfo4kebs+trm9SfIF1LzCR/XOXjuzL
        C0hwMQJHHBgxP8ynhAA93j2tMrGSnnxB/qpCvsQlCC2ZqqBVwJK5eRBJDyJRcxFgPkzWe2dHYx89V
        XGRCRR/dJ5NhIbOMbbaFTFt/Pkv1befuvT9WTQPLRyHzdIKFHhZfafqI7OsGrtSPuJinKua9tByPb
    
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-6-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 62715a5a4f32..8bc9d9b29fd3 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -486,6 +486,12 @@ extern unsigned int bvec_nr_vecs(unsigned short idx);
>  extern const char *bio_devname(struct bio *bio, char *buffer);
>  
>  #define bio_set_dev(bio, bdev) 			\
> +do {						\
> +	bio_set_dev_only(bio, bdev);		\
> +	bio_associate_blkg(bio);		\
> +} while (0)
> +
> +#define bio_set_dev_only(bio, bdev)		\

This lacks any explanation on when you would use bio_set_dev_only or
bio_set_dev.  Please document why we need both and why you'd choose or
the other.
