From: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Mon, 17 Jul 2023 09:23:44 -0500
Message-ID: <7b79f7b5-3313-3465-be4b-47648b93e63e@amd.com>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnGRLR2tZ1S3L61lfI649dIH7f8G6DiNExIwXPMtkZQ=;
 b=Flc5v0YuYM1VO2xf5loZMVuF131YcapTU/k1Ao+PiYjWAZz3lvOfaTyTMV9zmC7oPU/tVZHd6lwLTzX+iwG8fI8Jp3huiSqb4Z21J9WapoRYi2h5hUxg7j4HvGrgn6DuIP/buhgvhag0im8o+yd0E+EGuoT7BtSZamSlhzO88G4=
Content-Language: en-US
In-Reply-To: <20230717141852.153965-1-carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/17/23 09:18, Carlos Bilbao wrote:
> From: amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

Please disregard this "From" label.

> 
> Fix two type mismatch errors encountered while compiling blk-iocost.c with
> GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> result of the division operation to (unsigned int) to match the expected
> format specifier %u in two seq_printf invocations.
> 
> Reviewed-by: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
> ---
>   block/blk-iocost.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 495396425bad..4721009a3f03 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -3032,7 +3032,7 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
>   	struct ioc_gq *iocg = pd_to_iocg(pd);
>   
>   	if (dname && iocg->cfg_weight)
> -		seq_printf(sf, "%s %u\n", dname, iocg->cfg_weight / WEIGHT_ONE);
> +		seq_printf(sf, "%s %u\n", dname, (unsigned int)(iocg->cfg_weight / (unsigned int)WEIGHT_ONE));
>   	return 0;
>   }
>   
> @@ -3042,7 +3042,7 @@ static int ioc_weight_show(struct seq_file *sf, void *v)
>   	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
>   	struct ioc_cgrp *iocc = blkcg_to_iocc(blkcg);
>   
> -	seq_printf(sf, "default %u\n", iocc->dfl_weight / WEIGHT_ONE);
> +	seq_printf(sf, "default %u\n", (unsigned int) (iocc->dfl_weight / (unsigned int)WEIGHT_ONE));
>   	blkcg_print_blkgs(sf, blkcg, ioc_weight_prfill,
>   			  &blkcg_policy_iocost, seq_cft(sf)->private, false);
>   	return 0;

Thanks,
Carlos
