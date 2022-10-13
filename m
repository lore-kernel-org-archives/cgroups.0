From: Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH v2] blk-cgroup: Fix typo in comment
Date: Thu, 13 Oct 2022 19:49:22 +0530
Message-ID: <9662bcef-f901-fac6-1dff-dc2a2da216fe@quicinc.com>
References: <20221013141659.24032-1-shikemeng@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=aJUHKCeMONPiBv7qlHCAOXHfax7cF/SDLjjQwEaq4Y4=;
 b=Uvxx1SCL3EKf+l5Vo465umT20Yj4c9oRV3x0jIijFiDbAlwgUghlkz9289dK5xAdzm9B
 AaJ0VYAk6OWzIH5dBBoYozkkpMZ5mQbmqunjJxtBRC+QFBeyRbNCqMZl0VItAFg1erwF
 9DQ0nyQ0ums405O8ZHev43ddIrcPyENONUNiqOFq0aqgBlNr6Oos/P1Az4f9f7AZj9hQ
 RODm19kEeYouHIaybgFcjEdnVyTVPeIsyU0PzH2OYE/JdNFI1AQEgXKw0wHkZbJoOnUY
 qbDXcQR9erXKL6IDM3EGykQJLUCvQb0cWqa8akkgzQIvjulsVGuwCmp1zSZHK+xxnjb3 ng== 
Content-Language: en-US
In-Reply-To: <20221013141659.24032-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Kemeng Shi <shikemeng@huawei.com>, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On 10/13/2022 7:46 PM, Kemeng Shi wrote:
> Replace assocating with associating.
> Replace intiailized with initialized.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
> Changes in v2:
>   -based on current mainline code
>   -add acked-by
> 
>   block/blk-cgroup.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 6a5c849ee061..4c4bc874bd95 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -577,7 +577,7 @@ EXPORT_SYMBOL_GPL(blkcg_print_blkgs);
>    * @pd: policy private data of interest
>    * @v: value to print
>    *
> - * Print @v to @sf for the device assocaited with @pd.
> + * Print @v to @sf for the device associated with @pd.
>    */
>   u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
>   {
> @@ -765,7 +765,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
>   
>   /**
>    * blkg_conf_finish - finish up per-blkg config update
> - * @ctx: blkg_conf_ctx intiailized by blkg_conf_prep()
> + * @ctx: blkg_conf_ctx initialized by blkg_conf_prep()
>    *
>    * Finish up after per-blkg config update.  This function must be paired
>    * with blkg_conf_prep().


LGTM.
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh
