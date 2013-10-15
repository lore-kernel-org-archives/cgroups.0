From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Tue, 15 Oct 2013 13:32:52 -0400
Message-ID: <20131015173252.GM31215@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1381741757-20888-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Mon, Oct 14, 2013 at 05:09:17PM +0800, Hong Zhiguo wrote:

[..]

Hi Hong,

Thanks for the token based throttling implementation. In general it looks
good and it simplies the logic. Couple of comments/concerns below.

> @@ -133,14 +135,13 @@ struct throtl_grp {
>  	/* IOPS limits */
>  	unsigned int iops[2];
>  
> -	/* Number of bytes disptached in current slice */
> -	uint64_t bytes_disp[2];
> -	/* Number of bio's dispatched in current slice */
> -	unsigned int io_disp[2];
> +	/* Token for throttling by bps */
> +	uint64_t bytes_token[2];
> +	/* Token for throttling by iops */
> +	unsigned int io_token[2];
>  
> -	/* When did we start a new slice */
> -	unsigned long slice_start[2];
> -	unsigned long slice_end[2];
> +	/* Time check-point */
> +	unsigned long t_c[2];

Can we rename this variable to say last_dispatch[2].

[..]
>  
> @@ -852,41 +708,26 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
>  				 unsigned long *wait)
>  {
>  	bool rw = bio_data_dir(bio);
> -	u64 bytes_allowed, extra_bytes, tmp;
> -	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
> -
> -	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
> -
> -	/* Slice has just started. Consider one slice interval */
> -	if (!jiffy_elapsed)
> -		jiffy_elapsed_rnd = throtl_slice;
> -
> -	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
> +	u64 extra_bytes, token;
> +	unsigned long jiffy_wait;
>  
> -	tmp = tg->bps[rw] * jiffy_elapsed_rnd;
> -	do_div(tmp, HZ);
> -	bytes_allowed = tmp;
> +	token = (u64)tg->bps[rw] * (jiffies - tg->t_c[rw]);

So here we seem to be calculating how many tokens a group is eligible
for. This is done based on since last time check. And last time check
was updated in last dispatch from the group.

What happens if no IO happens in a group for some time, say for 5 minutes,
and then one big IO comes in. IIUC, we will allow a big burst of IO for
the first IO (tokens worth of full 5 minutes will be given to this group).
I think we should have a mechanism where we don't allow too big a burst
for the first IO. (Possibly limit the burst to THROTL_BURST_IO and
THROTL_BURST_BYTES until and unless a bigger IO is already queued and
we are waiting for it).

In previous time slice logic, I took care of it by extend time slice
by 100ms and if no IO happens in the group for 100ms, time slice will
expire and next IO will get at max of 100ms of worth of credit (equivalent
of burst limits).

Thanks
Vivek
