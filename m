From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 21/31] blk-throttle: implement sq_to_tg(), sq_to_td() and
 throtl_log()
Date: Mon, 6 May 2013 13:43:05 -0700
Message-ID: <20130506204305.GG800@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <1367455189-6957-22-git-send-email-tj@kernel.org>
 <20130506173644.GD11731@redhat.com>
 <20130506203827.GE800@mtj.dyndns.org>
 <20130506204141.GF11731@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=uHj7pF6b+TkQq4ct/+IEI7VUVwUv9uqosWUp3dTuqLM=;
        b=wa6nZTGiJKtDjjzQaLJhHNZ1XdVHsKlk40wJ/EOyeBgDllJH3ipc0yYD9yRvq09I1E
         HsaYK62IfPCuMVQymXXUJ14oZe4KAqt0Y90DMxlgm2n5g+Up/NUnUU/FqmOjbJ/aaPHA
         h3V7sB4cwp0idSr2hGi8Yg9W6895kXedAh9Y/sLgY4kDJAR1vPEb/4I2PwfyK8hN2KSn
         iKfmJNIgZ2aBxI/MKy/wNNz77s9nRFHgyu8fsSI0ppDO23GFbNdLjm84CnV5vGGXwhej
         phR7xBz4svU4WmzcHJcDmKvG7kqDIFLjSRDyGf2vZOXKY4Lt793blC9lMFHetXuLdCyJ
         xU8g==
Content-Disposition: inline
In-Reply-To: <20130506204141.GF11731-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 06, 2013 at 04:41:41PM -0400, Vivek Goyal wrote:
> On Mon, May 06, 2013 at 01:38:27PM -0700, Tejun Heo wrote:
> > On Mon, May 06, 2013 at 01:36:44PM -0400, Vivek Goyal wrote:
> > > On Wed, May 01, 2013 at 05:39:39PM -0700, Tejun Heo wrote:
> > > 
> > > [..]
> > > > +#define throtl_log(sq, fmt, args...)	do {				\
> > > > +	struct throtl_grp *__tg = sq_to_tg((sq));			\
> > > > +	struct throtl_data *__td = sq_to_td((sq));			\
> > > >  	char __pbuf[128];						\
> > > >  									\
> > > > -	blkg_path(tg_to_blkg(tg), __pbuf, sizeof(__pbuf));		\
> > > > -	blk_add_trace_msg((tg)->td->queue, "throtl %s " fmt, __pbuf, ##args); \
> > > > +	__pbuf[0] = ' ';						\
> > > > +	__pbuf[1] = '\0';						\
> > > > +	if ((__tg))							\
> > > > +		blkg_path(tg_to_blkg(__tg), __pbuf + 1, sizeof(__pbuf) - 1); \
> > > > +	blk_add_trace_msg(__td->queue, "throtl%s" fmt, __pbuf, ##args); \
> > > 
> > > We need one extra space ("throtl%s "), otherwise all the messages
> > > start right after cgroup path. We need a space between cgroup path
> > > and actual message.
> > 
> > Okay, we don't - __pbuf[0] = ' '.  The reason it's doing the above
> > instead of "throtl %s " is because when the path is nil, we don't
> > wanna print out two consecutive spaces, so AFAICS the code is correct.
> 
> What about space after the cgroup path info (when path is not nil).

Yeah, I mis-read it.  Fixing it right now.

-- 
tejun
