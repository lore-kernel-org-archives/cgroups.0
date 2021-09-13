From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] block, bfq: fix UAF in bfq_io_set_weight_legacy()
Date: Mon, 13 Sep 2021 07:50:32 -1000
Message-ID: <YT+PaFSxfcJAgTs7@slm.duckdns.org>
References: <20210910034642.2838054-1-lijinlin3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GXuhVb2mAgwRJ4d5JAgKMNDM1IDwp61QdPvAadqK8Do=;
        b=YxPJcxJPOqB7IuMrPYi3hee6d8psUNevLnc8b5zSKyMPh/QH6j6uM1pwEEHFl2bH0c
         4Nt+YQwlZBISDoy0cC8Qaa8FgTFtqbs1ajc9BgSCwutdtly6qzs4NuYa6VufizF78Jx+
         J7cBmNXde423BBLs6dYRM9oA6vtq8eWLkfj7AiFjxZuQYjU2eDEG5YEm2RlmSUdu1edt
         o+NzGdJcVK28vrqlyvtQtFVrTYD8c9XaNK9UZj59Ky+ms6qH9J3taiiJUBXhtGVn5lh6
         qeSszGBEFIqWgxJah0ZN2BrQ9bNwSnWCgwLq4Dk/eup0bNu8nTAGHPS8QPLtIA28LkA8
         1OIQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210910034642.2838054-1-lijinlin3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Jinlin <lijinlin3@huawei.com>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, louhongxiang@huawei.com

Hello,

On Fri, Sep 10, 2021 at 11:46:42AM +0800, Li Jinlin wrote:
> Freeing bfqg is protected by queue lock in blkcg_deactivate_policy(), 
> but getting/using bfqg is protected by blkcg lock in
> bfq_io_set_weight_legacy(). If bfq_io_set_weight_legacy() get bfqg
> before freeing bfqg and use bfqg in the after, the use-after-free
> will occur.
> 
> CPU0                             CPU1
> blkcg_deactivate_policy
>   spin_lock_irq(&q->queue_lock)
>                                  bfq_io_set_weight_legacy  
>                                    spin_lock_irq(&blkcg->lock)
>                                    blkg_to_bfqg(blkg)
>                                      pd_to_bfqg(blkg->pd[pol->plid])
>                                      ^^^^^^blkg->pd[pol->plid] != NULL
>                                            bfqg != NULL
>   pol->pd_free_fn(blkg->pd[pol->plid])
>     pd_to_bfqg(blkg->pd[pol->plid])
>     bfqg_put(bfqg)
>       kfree(bfqg)
>   blkg->pd[pol->plid] = NULL
>   spin_unlock_irq(q->queue_lock);
>                                    bfq_group_set_weight(bfqg, val, 0)
>                                      bfqg->entity.new_weight
>                                      ^^^^^^trigger uaf here 
>                                    spin_unlock_irq(&blkcg->lock);
> 
> To fix this use-after-free, instead of holding blkcg->lock while
> walking ->blkg_list and getting/using bfqg, RCU walk ->blkg_list and
> hold the blkg's queue lock while getting/using bfqg.

I think this is a bug in blkcg_deactivate_policy() than the other way
around. blkgs are protected by both q and blkcg locks and holding either
should stabilize them. The blkcg lock nests inside q lock, so I think
blkcg_deactivate_policy() just needs to grab the matching blkcg lock before
trying to destroy blkgs.

Thanks.

-- 
tejun
