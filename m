From: Carlos Bilbao <carlos.bilbao@amd.com>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Fri, 21 Jul 2023 17:32:04 -0500
Message-ID: <93557f79-c12c-3c3f-2c25-9ba50a618daa@amd.com>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy3CkHHD08KXI1WtPjJHbxkoeubnMx5bYdUu1zKe7F8=;
 b=ZLLB0avLMM5yUjOxfrthheHk2x7t5dk4C2GbF/eWUaD8XpuDmk1az1hLDL9JTabhipngLwjnkvVHoIchdW6tOl31Y+UzjmaRgwcZMPOvhGpKHLA07sdk3aU/1dK4+O49JWdoIyUEWWWdyq25WNDPLYrG/yzJHoFWsRUN5uHNlNE=
Content-Language: en-US
In-Reply-To: <20230717141852.153965-1-carlos.bilbao@amd.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, amd <amd@localhost.localdomain>

On 7/17/23 9:18 AM, Carlos Bilbao wrote:
> From: amd <amd@localhost.localdomain>
> 
> Fix two type mismatch errors encountered while compiling blk-iocost.c with
> GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> result of the division operation to (unsigned int) to match the expected
> format specifier %u in two seq_printf invocations.
> 
> Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
This should have been:

Signed-off-by: Carlos Bilbao <carlos.bilbao@amd.com>

> ---
>  block/blk-iocost.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 495396425bad..4721009a3f03 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -3032,7 +3032,7 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
>  	struct ioc_gq *iocg = pd_to_iocg(pd);
>  
>  	if (dname && iocg->cfg_weight)
> -		seq_printf(sf, "%s %u\n", dname, iocg->cfg_weight / WEIGHT_ONE);
> +		seq_printf(sf, "%s %u\n", dname, (unsigned int)(iocg->cfg_weight / (unsigned int)WEIGHT_ONE));
>  	return 0;
>  }
>  
> @@ -3042,7 +3042,7 @@ static int ioc_weight_show(struct seq_file *sf, void *v)
>  	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
>  	struct ioc_cgrp *iocc = blkcg_to_iocc(blkcg);
>  
> -	seq_printf(sf, "default %u\n", iocc->dfl_weight / WEIGHT_ONE);
> +	seq_printf(sf, "default %u\n", (unsigned int) (iocc->dfl_weight / (unsigned int)WEIGHT_ONE));
>  	blkcg_print_blkgs(sf, blkcg, ioc_weight_prfill,
>  			  &blkcg_policy_iocost, seq_cft(sf)->private, false);
>  	return 0;

Thanks,
Carlos
