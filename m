From: Haoran Luo <www-ZNkeOWAYW7z9CHvZ6l3MoQ@public.gmane.org>
Subject: Re: [BUG] blk-throttle panic on 32bit machine after startup
Date: Mon, 18 Oct 2021 08:00:27 +0000
Message-ID: <YW0pm5xcxgWnW98f@aegistudio>
Reply-To: CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhangyoufu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

(Sorry for the garbled message due to my mistaken the configuration of mutt)

I'm the college of the reporter and I would like to provide more
information.

The code in 5.15-rc6 in "blk-throttle.c" around line 791 is written as
below:

	/*
	 * Previous slice has expired. We must have trimmed it after
	 * last
	 * bio dispatch. That means since start of last slice, we never
	 * used
	 * that bandwidth. Do try to make use of that bandwidth while
	 * giving
	 * credit.
	 */
	if (time_after_eq(start, tg->slice_start[rw]))
		tg->slice_start[rw] = start;

I think this piece of code presumes all jiffies values are greater than
0, which is the initial value assigned when kzalloc-ing throtl_grp. It
fails on 32-bit linux for the first 5 minutes after booting, since the
jiffies value then will be less than 0.
