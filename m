From: Kemeng Shi <shikemeng@huawei.com>
Subject: Re: [PATCH v2] blk-cgroup: Fix typo in comment
Date: Wed, 23 Nov 2022 14:07:17 +0800
Message-ID: <c8bc1792-7a54-260e-4c07-66b2ea02d925@huawei.com>
References: <20221013141659.24032-1-shikemeng@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221013141659.24032-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Friendly ping

on 10/13/2022 10:16 PM, Kemeng Shi wrote:
> Replace assocating with associating.
> Replace intiailized with initialized.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
> Changes in v2:
>  -based on current mainline code
>  -add acked-by
> 
>  block/blk-cgroup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 6a5c849ee061..4c4bc874bd95 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -577,7 +577,7 @@ EXPORT_SYMBOL_GPL(blkcg_print_blkgs);
>   * @pd: policy private data of interest
>   * @v: value to print
>   *
> - * Print @v to @sf for the device assocaited with @pd.
> + * Print @v to @sf for the device associated with @pd.
>   */
>  u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
>  {
> @@ -765,7 +765,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
>  
>  /**
>   * blkg_conf_finish - finish up per-blkg config update
> - * @ctx: blkg_conf_ctx intiailized by blkg_conf_prep()
> + * @ctx: blkg_conf_ctx initialized by blkg_conf_prep()
>   *
>   * Finish up after per-blkg config update.  This function must be paired
>   * with blkg_conf_prep().
> 

-- 
Best wishes
Kemeng Shi
