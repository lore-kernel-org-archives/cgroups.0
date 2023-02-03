From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Fri, 3 Feb 2023 11:51:47 -0800
Message-ID: <a2d8d491-7410-2dd8-cc11-a0519e2025b6@acm.org>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <20230201045227.2203123-1-houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hou Tao <houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 1/31/23 20:52, Hou Tao wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index c8ae7c897f14..e0b9f73ef62a 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2038,17 +2038,27 @@ that attribute:
>   	Change the I/O priority class of all requests into IDLE, the lowest
>   	I/O priority class.
>   
> +  promote-to-rt
> +	For requests that have I/O priority class BE or that have I/O priority
> +        class IDLE, change it into RT. Do not modify the I/O priority class
> +        of requests that have priority class RT.

Please document whether or not this policy modifies the I/O priority
(IOPRIO_PRIO_DATA()). Do you agree that the I/O priority should be preserved
when promoting from BE to RT and that only the I/O priority class should be
modified for such promotions?

>   The following numerical values are associated with the I/O priority policies:
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
> +
> ++---------------+---------+-----+
> +| policy        | inst    | num |
> ++---------------+---------+-----+
> +| no-change     | demote  | 0   |
> ++---------------+---------+-----+
> +| none-to-rt    | demote  | 1   |
> ++---------------+---------+-----+
> +| rt-to-be      | demote  | 2   |
> ++---------------+---------+-----+
> +| idle          | demote  | 3   |
> ++---------------+---------+-----+
> +| promote-to-rt | promote | 1   |
> ++---------------+---------+-----+

I prefer that this table is not modified. The numerical values associated with
policies only matters for none-to-rt, rt-to-be and all-to-idle but not for
promote-to-rt. So I don't think that it is necessary to mention a numerical
value for the promote-to-rt policy. Additionally, "none-to-rt" is not a policy
that demotes the I/O priority but a policy that may promote the I/O priority.

> +-- If the instruction is promotion, change the request I/O priority class
> +-  into the minimum of the I/O priority class policy number and the numerical
> +-  I/O priority class.

Using the minimum value seems wrong to me because that will change
IOPRIO_VALUE(IOPRIO_CLASS_RT, 1) into IOPRIO_VALUE(IOPRIO_CLASS_RT, 0).

Thanks,

Bart.
