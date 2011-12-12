From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
Date: Mon, 12 Dec 2011 09:27:25 -0800
Message-ID: <20111212172725.GA25802@google.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
 <1323614738-7405-3-git-send-email-glommer@parallels.com>
 <4EE4FCBB.9050600@gmail.com>
 <4EE51646.3030900@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DJYzLN6giJ6mB/V0n11GNdWf8O5BDHdcxPrK1cA2eyI=;
        b=C+JfOYQ/d5spcKyegGE3D6Kq/9RnMI+mRA8/UGe+9nIYAvbPSv3Zu8dVCRnoUlYlOJ
         yUVqjfHIjsNqt/zPOLOSxE8OCEqw5r1DukYoxgspZujWIgpT8OCq7meJTUkTYBz4amQx
         pzp9AP6wxK15q62l6ilVcpZmr2PVAq3MVT4JY=
Content-Disposition: inline
In-Reply-To: <4EE51646.3030900-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

Hello,

On Sun, Dec 11, 2011 at 09:44:54PM +0100, Glauber Costa wrote:
> On 12/11/2011 07:55 PM, KOSAKI Motohiro wrote:
> > Can you please tell us which compiler failed automatic inlining?
> > I suspect gcc is enough sane and we don't need this patch.
> 
> Of course we don't need, that's the very definition of a "nitpick".
> This patch is directed towards the reader, not the compiler. Maintainers
> are free to take it or not, although I believe being explicit is better.

These days, I don't think adding inline buys us much (other than
explicit cases where always_inline or noinline is necessary).  gcc
already does good enough job for inlining and 'inline' hint seems more
to hinder rather than help and I don't really see what it buys for
code readers either, so I won't be taking this one.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
