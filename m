From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] blk-throttle: simplify logic by token bucket algorithm
Date: Fri, 18 Oct 2013 11:55:33 -0400
Message-ID: <20131018155532.GD2277@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1382012272-26170-1-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1382012272-26170-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Thu, Oct 17, 2013 at 08:17:52PM +0800, Hong Zhiguo wrote:

[..]
> @@ -852,41 +710,30 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
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
> +	u64 extra_bytes, token;
> +	unsigned long jiffy_wait;
>  
> -	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
> +	token = (u64)tg->bps[rw] * (jiffies - tg->last_dispatch[rw]);
> +	do_div(token, HZ);
> +	token += tg->bytes_token[rw];
>  
> -	tmp = tg->bps[rw] * jiffy_elapsed_rnd;
> -	do_div(tmp, HZ);
> -	bytes_allowed = tmp;
> +	/* trim the token if the group is idle */
> +	if (!tg->service_queue.nr_queued[rw] && token > THROTL_BURST_BYTES)
> +		token = THROTL_BURST_BYTES;

I think same logic need to be applied to iops too?

Also, how does it work in case of hierarchy? IIUC, when bio is being
propogated upwards, we first add it to the parent, and then later
update dispatch time which will in turn call tg_with_in_bps_limit().

So by the time you come here after bio propogation, bio is already
on service queue and it will be entitiled to *unlimited* idle tokens.

On the flip side, we can't do blind truncation of idle tokens in
parent group. Reason being that once bio got queued in child group,
effectively it should be subjected to parent's limits too right now
and not necessarily when it climbs up the tree. 

To solve this problem I had put following patch.

commit 32ee5bc4787dfbdb280b4d81a338dcdd55918c1e
Author: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue May 14 13:52:38 2013 -0700

    blk-throttle: Account for child group's start time in parent while bio
climb


Above solution was not perfect but seemed like reasonable approximation.
We might have to do something similar. I think we can keep track of time
when an bio starts waiting in a group (gets to head of list) and then
when that bio is dispatched, pass that time to parent group. Now
parent can give more tokens to bio based on wait time start as passed
by children.

For example say Twaitstart is the time a bio started waiting on the head
of queue of a group. Say Tidle is time when parent became idle. Now when
child passes this bio to parent, it will also pass Twaitstart to parent.
When it comes time for token calculation, parent can do following.

If (time_after(Twaitstart, Tidle) 
	start_time = Twaitstart;
else
	start_time = Tidle;

token_eligibility = (jiffies - start_time) * rate;

This is far from perfect, but it should work reasonably.

Thanks
Vivek
