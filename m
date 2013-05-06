From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 21/31] blk-throttle: implement sq_to_tg(), sq_to_td() and
 throtl_log()
Date: Mon, 6 May 2013 13:39:59 -0700
Message-ID: <20130506203959.GF800@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-22-git-send-email-tj@kernel.org>
 <20130506173644.GD11731@redhat.com>
 <20130506203827.GE800@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=STX4WLkTHElbihse3TIpDj+l7GnaxjgR2jRFRXeADPA=;
        b=ij0JrxWD/a+c7cb6uBNX5iBUP4m7CbnEPoibXce78mgUnnGzAQHNCbWd2nCF+/mYjQ
         0hIn8A7AGo58n++PBdBHWSr7shyVHExV/xGyvOuJYAE032MvTAlEI63xnRhb+Ipoocs3
         kzuwcl+XhIxxs1jYA45sNxFyECk87S+tur1uBvVbZqGpvemwprvj7gD6k2W8HwOsC5X8
         50+iAHzC6BsndAdYyfTHEW/WIzGM9MWa+I89ZAT8CtObxAn3py2TJZtsvDYsOyeA1SlS
         faIURFOXa8aVg1ELTN7bvslBbBbPJZARsl7gApQhtKibHG31ScZc+8wYrMEEXhdtJEaS
         bBEQ==
Content-Disposition: inline
In-Reply-To: <20130506203827.GE800-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 06, 2013 at 01:38:27PM -0700, Tejun Heo wrote:
> On Mon, May 06, 2013 at 01:36:44PM -0400, Vivek Goyal wrote:
> > On Wed, May 01, 2013 at 05:39:39PM -0700, Tejun Heo wrote:
> > 
> > [..]
> > > +#define throtl_log(sq, fmt, args...)	do {				\
> > > +	struct throtl_grp *__tg = sq_to_tg((sq));			\
> > > +	struct throtl_data *__td = sq_to_td((sq));			\
> > >  	char __pbuf[128];						\
> > >  									\
> > > -	blkg_path(tg_to_blkg(tg), __pbuf, sizeof(__pbuf));		\
> > > -	blk_add_trace_msg((tg)->td->queue, "throtl %s " fmt, __pbuf, ##args); \
> > > +	__pbuf[0] = ' ';						\
> > > +	__pbuf[1] = '\0';						\
> > > +	if ((__tg))							\
> > > +		blkg_path(tg_to_blkg(__tg), __pbuf + 1, sizeof(__pbuf) - 1); \
> > > +	blk_add_trace_msg(__td->queue, "throtl%s" fmt, __pbuf, ##args); \
> > 
> > We need one extra space ("throtl%s "), otherwise all the messages
> > start right after cgroup path. We need a space between cgroup path
> > and actual message.
> 
> Okay, we don't - __pbuf[0] = ' '.  The reason it's doing the above
> instead of "throtl %s " is because when the path is nil, we don't
> wanna print out two consecutive spaces, so AFAICS the code is correct.

Oops, I was wrong again, you mean after '%s'.  Yeah, right.  I need to
change it so that it does __pbuf[0] = '\0' if no path and add space
after '%s'.  Updating...

Sorry about the confusion.

-- 
tejun
