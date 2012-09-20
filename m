From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Thu, 20 Sep 2012 11:31:53 -0700
Message-ID: <20120920183153.GI28934@google.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tvHQrre3klaZ2dydoJLBwKS0vKppHmfkwhmQDp9URNo=;
        b=AE9rQplakwNVYeXOpNcVZOUOEjo5CWIc6NGzgkqjgcjgOBJ5+8zu/E6X2P8ofUPFf3
         CkPLnx+TnlBu9Bg7Vs6/UUK7RCCOf0rK0qeYCu+uamH2ku1g4ajNO0DRZUe8xOKK4Fqz
         QksoFQsLf1MiaCe2gVO5ZVGY3+Ws7zHCyUJ2dJwImFUr6S6NGFrmhSZJERZgrbx1+46h
         JrJOKCtq806S3f+6dcH+0OXI87SkyDH9k30ZFjmT8wCmyTL7uuXDQx/JCK6syPrBTS8F
         4a+00fHjBZ/jd14tULOMfGDTWl91Tx2Z1r/9/d4u8oKzZU6SbvYB2Tz/PAQrGE1G0+ab
         DQfg==
Content-Disposition: inline
In-Reply-To: <20120919194231.GF31860-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Sep 19, 2012 at 03:42:31PM -0400, Vivek Goyal wrote:
> On Thu, Sep 20, 2012 at 04:20:42AM +1000, Joseph Glanville wrote:
> > Hi,
> > 
> > I booted the machine under bare metal to continue bisecting.
> > Thankfully this allowed me to locate the commit that causes the
> > problem.
> > 
> 
> I tested it and I am also noticing the hang. I can see this hang on
> dm devices also.
> 
> I suspect this issue is related to bio based drivers. We exit the
> bypass mode in blk_init_allocated_queue() and that will be called
> only for request based drivers. So for bio based drivers may be 
> we never exit the bypass mode and this issue is somehow side
> affect of that.

Can you please trigger sysrq-t and post the result?

Thanks.

-- 
tejun
