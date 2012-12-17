From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/12] cfq-iosched: implement cfq_group->nr_active and
 ->level_weight
Date: Mon, 17 Dec 2012 13:20:23 -0800
Message-ID: <20121217212023.GE1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-7-git-send-email-tj@kernel.org>
 <20121217204609.GH7235@redhat.com>
 <20121217211517.GC1844@htj.dyndns.org>
 <20121217211843.GA13691@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=itbA1ZWU2tX/M8AGCqSA4QYESXuzWPvwqTxFhYRBO48=;
        b=F2U8kCkVL2KSyUdnTiMkS8VP03zjQPf7z7oTIoI9h2tAxvk+YfkzAWcQdZFYXHhGv1
         Cb/XvYNp2nS0mZOz/uUBqOl2tzhuBTinOOQ/xkCEEftqI/dC6l2uskhKGU6eCfpX9zPS
         IrwU2zC3LZA1Ny2Ag6kRtNU0GVS7vNtcFeggNI+qSbnklvYzuZIftnllae8tObDtRZVf
         DexhGIGf4atFRM3hEdChRz/IDiilV0uO/HQtFXuj1NfxDCzibld9vPm7K77EnjTFjk+E
         qUULUyyGuKH3aaQChbDAMipa7fAay2dVkKNXXCL9asZChTpNv1/84chItXNz8q35wZT4
         z2pw==
Content-Disposition: inline
In-Reply-To: <20121217211843.GA13691-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon, Dec 17, 2012 at 04:18:43PM -0500, Vivek Goyal wrote:
> > > I think confusion happens because we are overloading the definition of
> > > cfqg. It is competing with its siblings at the same time it is competing
> > > against its child groups (on behalf of its children tasks).
> > 
> > While I agree that part is a bit tricky, I can't think of a much
> > better way to describe it.  Any better ideas?
> 
> Can we call it cfqg->children_weight insted of cfqg->level_weight.

Hmmm... yeah, why not?  I'll rename it.

Thanks.

-- 
tejun
