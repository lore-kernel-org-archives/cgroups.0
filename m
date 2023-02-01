From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Wed, 1 Feb 2023 09:33:24 -0800
Message-ID: <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230201045227.2203123-1-houtao@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hou Tao <houtao@huaweicloud.com>, linux-block@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On 1/31/23 20:52, Hou Tao wrote:
>   /**
>    * enum prio_policy - I/O priority class policy.
>    * @POLICY_NO_CHANGE: (default) do not modify the I/O priority class.
> @@ -27,21 +34,30 @@
>    * @POLICY_RESTRICT_TO_BE: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_RT into
>    *		IOPRIO_CLASS_BE.
>    * @POLICY_ALL_TO_IDLE: change the I/O priority class into IOPRIO_CLASS_IDLE.
> - *
> + * @POLICY_PROMOTE_TO_RT: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_BE into
> + * 		IOPRIO_CLASS_RT.
>    * See also <linux/ioprio.h>.
>    */
>   enum prio_policy {
> -	POLICY_NO_CHANGE	= 0,
> -	POLICY_NONE_TO_RT	= 1,
> -	POLICY_RESTRICT_TO_BE	= 2,
> -	POLICY_ALL_TO_IDLE	= 3,
> +	POLICY_NO_CHANGE	= IOPRIO_CLASS_NONE,
> +	POLICY_NONE_TO_RT	= IOPRIO_CLASS_RT,
> +	POLICY_RESTRICT_TO_BE	= IOPRIO_CLASS_BE,
> +	POLICY_ALL_TO_IDLE	= IOPRIO_CLASS_IDLE,
> +	POLICY_PROMOTE_TO_RT	= IOPRIO_CLASS_RT | IOPRIO_POL_PROMOTION,
> +};

The above change complicates the ioprio code. Additionally, I'm 
concerned that it makes the ioprio code slower. Has it been considered 
to keep the numerical values for the existing policies, to assign the 
number 4 to POLICY_PROMOTE_TO_RT and to use a lookup-array in 
blkcg_set_ioprio() to convert the policy number into an IOPRIO_CLASS value?

Thanks,

Bart.

