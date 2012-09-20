From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Thu, 20 Sep 2012 13:18:15 -0700
Message-ID: <20120920201815.GB7264@google.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Iv8X6JfSq0e4yeO+wboUo1TD5uN+eZIeiK1wmsWHEy4=;
        b=sYH2L1+nv9VIfnFqAIlhnPtMGwXCzF3XgH+Z8TpO4C6+4ewXpoERPMPZmNjbtPtS1P
         wMGKFPlPnI60tDKsdrFqrRrRnQ/4LJ5GjJ7gbGlDSVwB3jLFuW3BPdd8TULV/HwTyOGp
         P8u808ZruWPvRZDVJEXoUevLfiTZz0M6D9Gb/yDUG1gociBeoV2cqvJrMs7lm0Kg9sVE
         REnqWIkJErswwnh901ABSbi6TLq9ObRcOFZeaBEn0RyKFxXo3LWJ5fXlvlaZgCHKekBr
         sI4bwLur3vBeDPTJGFdVy4XEI11DEQU/nvRQZt3CRNLVp5qBRKuOmibtJ7S9jQAnGg1h
         OiFg==
Content-Disposition: inline
In-Reply-To: <20120920195759.GK4681-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 20, 2012 at 03:57:59PM -0400, Vivek Goyal wrote:
> > Yeah, I incorrectly assumed that bio based drivers would call
> > blk_init_allocated_queue().  I think we need to move the initial
> > bypass_end call to blk_register_queue().  Like the following.  Not
> > completely sure yet tho.
> 
> I can confirm that with this patch, hang issue is gone. I tried it on
> a dm device.

Thanks, will prep a patch.

-- 
tejun
