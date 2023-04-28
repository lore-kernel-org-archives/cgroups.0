From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v4] blk-ioprio: Introduce promote-to-rt policy
Date: Fri, 28 Apr 2023 14:36:13 +0700
Message-ID: <ab90dcf6-5861-48dc-f261-d6851e150863@gmail.com>
References: <20230428074404.280532-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682667379; x=1685259379;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r4T9X6ORTgiJIhVcjeFoQF4kfGQPAh+aPhJ9TCOLtx4=;
        b=gTkMq43ck648y6RXcRGmriNhxjIOInPfKt5o9jPe9LMJ3iz00MefD9rJqTbBvvgyoE
         n+YGdtHh9a37pUY7eFw4CB/nD1D3437E2uZD/SRcEaKHSghT3u7OufYEJmPsnIlmBVHb
         p6VDeiJIpWJ6f37+X2fopxRBcna17GK/b+ymsPcLVyv7yZ2cAfOmnC6VHLvfZ/6XebZY
         hQ0zkF8NMjv+pmrpO6wx+qAS/A0tvdSo8SrZMcOiZxZaF6FGxDBXxzSUfBBxfN4MvuHC
         D5KmyFkVJHu07yYZwCnG36VzBr4mK+BQogBKOP8A4lm3amFn6dwayw9KhWFDrGn5SUh5
         x3QA==
Content-Language: en-US
In-Reply-To: <20230428074404.280532-1-houtao@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hou Tao <houtao@huaweicloud.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Chaitanya Kulkarni <kch@nvidia.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On 4/28/23 14:44, Hou Tao wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index f67c0829350b..7544ce00e0cb 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2024,31 +2024,33 @@ that attribute:
>    no-change
>  	Do not modify the I/O priority class.
>  
> -  none-to-rt
> -	For requests that do not have an I/O priority class (NONE),
> -	change the I/O priority class into RT. Do not modify
> -	the I/O priority class of other requests.
> +  promote-to-rt
> +	For requests that have a non-RT I/O priority class, change it into RT.
> +	Also change the priority level of these requests to 4. Do not modify
> +	the I/O priority of requests that have priority class RT.
>  
>    restrict-to-be
>  	For requests that do not have an I/O priority class or that have I/O
> -	priority class RT, change it into BE. Do not modify the I/O priority
> -	class of requests that have priority class IDLE.
> +	priority class RT, change it into BE. Also change the priority level
> +	of these requests to 0. Do not modify the I/O priority class of
> +	requests that have priority class IDLE.
>  
>    idle
>  	Change the I/O priority class of all requests into IDLE, the lowest
>  	I/O priority class.
>  
> +  none-to-rt
> +	Deprecated. Just an alias for promote-to-rt.
> +
>  The following numerical values are associated with the I/O priority policies:
>  
> -+-------------+---+
> -| no-change   | 0 |
> -+-------------+---+
> -| none-to-rt  | 1 |
> -+-------------+---+
> -| rt-to-be    | 2 |
> -+-------------+---+
> -| all-to-idle | 3 |
> -+-------------+---+
> ++----------------+---+
> +| no-change      | 0 |
> ++----------------+---+
> +| rt-to-be       | 2 |
> ++----------------+---+
> +| all-to-idle    | 3 |
> ++----------------+---+
>  
>  The numerical value that corresponds to each I/O priority class is as follows:
>  
> @@ -2064,9 +2066,13 @@ The numerical value that corresponds to each I/O priority class is as follows:
>  
>  The algorithm to set the I/O priority class for a request is as follows:
>  
> -- Translate the I/O priority class policy into a number.
> -- Change the request I/O priority class into the maximum of the I/O priority
> -  class policy number and the numerical I/O priority class.
> +- If I/O priority class policy is promote-to-rt, change the request I/O
> +  priority class to IOPRIO_CLASS_RT and change the request I/O priority
> +  level to 4.
> +- If I/O priorityt class is not promote-to-rt, translate the I/O priority
> +  class policy into a number, then change the request I/O priority class
> +  into the maximum of the I/O priority class policy number and the numerical
> +  I/O priority class.
>  
>  PID
>  ---

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

