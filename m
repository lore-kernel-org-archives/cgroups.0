From: Haoran Luo <www-ZNkeOWAYW7z9CHvZ6l3MoQ@public.gmane.org>
Subject: Re: [BUG] blk-throttle panic on 32bit machine after startup
Date: Mon, 18 Oct 2021 09:25:11 +0000
Message-ID: <YW09dxyhhsMwaO7T@aegistudio>
Reply-To: YW0pm5xcxgWnW98f@aegistudio
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haoran Luo <www-ZNkeOWAYW7z9CHvZ6l3MoQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, zhangyoufu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Pardon me for elaborating some of my opinions.

> I think this piece of code presumes all jiffies values are greater than
> 0, which is the initial value assigned when kzalloc-ing throtl_grp. It
> fails on 32-bit linux for the first 5 minutes after booting, since the
> jiffies value then will be less than 0.

Expressing the jiffies value as greater or less than 0 is a mistake of vagueness. I actually means that comparison in macro "time_after_eq", which written as below in "5.16-rc2" in "include/linux/jiffies.h" at around line 110.

	#define time_after_eq(a,b)	\
		(typecheck(unsigned long, a) && \
		 typecheck(unsigned long, b) && \
		 ((long)((a) - (b)) >= 0))

The "INITIAL_JIFFIES" which is defined as "((unsigned long)(unsigned int)-300*HZ)", converts to "((long)-300*HZ)" and is smaller than "((long)0)". And similarily "timer_after_eq(x, 0)" being evaluated to false holds for x ranged from `INITIAL_JIFFIES <= x <= MAX_LONG` on 32-bit linux.

The same thing will not happen for 64-bit linux, since "((unsigned long)(unsigned int)-300*HZ)" is evaluated to a value greater than zero in the macro above.

I actually cannot figure out a fix for this problem on 32-bit, if it presumes the jiffies value in "tg->slice_start[rw]" to be either "0" or jiffies "x" holding property of "time_after_eq(x, 0)".
