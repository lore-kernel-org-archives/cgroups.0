From: Hou Tao <houtao@huaweicloud.com>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Sun, 5 Feb 2023 15:04:17 +0800
Message-ID: <ffcf2d84-7f0a-21b7-8840-433227bc6afb@huaweicloud.com>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
 <4f7dcb3e-2d5a-cae3-0e1c-a82bcc3d2217@huaweicloud.com>
 <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
 <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
 <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

Hi,

On 2/4/2023 3:45 AM, Bart Van Assche wrote:
> On 2/2/23 17:48, Hou Tao wrote:
>> I don't get it on how to remove IOPRIO_POL_PROMOTION when calculating the final
>> ioprio for bio. IOPRIO_POL_PROMOTION is not used for IOPRIO_CLASS values but
>> used to determinate on how to calculate the final ioprio for bio: choosing the
>> maximum or minimum between blkcg ioprio and original bio bi_ioprio.
>
> Do the block layer code changes shown below implement the functionality that you
> need?
Yes, something like that. The reason for introducing IOPRIO_POL_PROMOTION is to
support other promotion policy (e.g., promote-to-be), but now I think the
possibility of adding other promotion policies is low, so the code below is fine
to me.
>
> Thanks,
>
> Bart.
>
>
>
> diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
> index 8bb6b8eba4ce..4a56da95168e 100644
> --- a/block/blk-ioprio.c
> +++ b/block/blk-ioprio.c
> @@ -27,6 +27,8 @@
>   * @POLICY_RESTRICT_TO_BE: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_RT into
>   *        IOPRIO_CLASS_BE.
>   * @POLICY_ALL_TO_IDLE: change the I/O priority class into IOPRIO_CLASS_IDLE.
> + * @POLICY_PROMOTE_TO_RT: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_BE into
> + *         IOPRIO_CLASS_RT.
>   *
>   * See also <linux/ioprio.h>.
>   */
> @@ -35,6 +37,7 @@ enum prio_policy {
>      POLICY_NONE_TO_RT    = 1,
>      POLICY_RESTRICT_TO_BE    = 2,
>      POLICY_ALL_TO_IDLE    = 3,
> +    POLICY_PROMOTE_TO_RT,
>  };
>
>  static const char *policy_name[] = {
> @@ -42,6 +45,7 @@ static const char *policy_name[] = {
>      [POLICY_NONE_TO_RT]    = "none-to-rt",
>      [POLICY_RESTRICT_TO_BE]    = "restrict-to-be",
>      [POLICY_ALL_TO_IDLE]    = "idle",
> +    [POLICY_PROMOTE_TO_RT]    = "promote-to-rt",
>  };
>
>  static struct blkcg_policy ioprio_policy;
> @@ -189,17 +193,23 @@ void blkcg_set_ioprio(struct bio *bio)
>      if (!blkcg || blkcg->prio_policy == POLICY_NO_CHANGE)
>          return;
>
> -    /*
> -     * Except for IOPRIO_CLASS_NONE, higher I/O priority numbers
> -     * correspond to a lower priority. Hence, the max_t() below selects
> -     * the lower priority of bi_ioprio and the cgroup I/O priority class.
> -     * If the bio I/O priority equals IOPRIO_CLASS_NONE, the cgroup I/O
> -     * priority is assigned to the bio.
> -     */
> -    prio = max_t(u16, bio->bi_ioprio,
> -            IOPRIO_PRIO_VALUE(blkcg->prio_policy, 0));
> -    if (prio > bio->bi_ioprio)
> -        bio->bi_ioprio = prio;
> +    if (blkcg->prio_policy == PROMOTE_TO_RT) {
> +        if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) != IOPRIO_CLASS_RT)
> +            bio->bi_ioprio = IOPRIO_CLASS_RT;
> +    } else {
> +        /*
> +         * Except for IOPRIO_CLASS_NONE, higher I/O priority numbers
> +         * correspond to a lower priority. Hence, the max_t() below
> +         * selects the lower priority of bi_ioprio and the cgroup I/O
> +         * priority class.  If the bio I/O priority equals
> +         * IOPRIO_CLASS_NONE, the cgroup I/O priority is assigned to the
> +         * bio.
> +         */
> +        prio = max_t(u16, bio->bi_ioprio,
> +                 IOPRIO_PRIO_VALUE(blkcg->prio_policy, 0));
> +        if (prio > bio->bi_ioprio)
> +            bio->bi_ioprio = prio;
> +    }
>  }
>
>  void blk_ioprio_exit(struct gendisk *disk)
>

