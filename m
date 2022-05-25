From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 10/11] mm: lru: add VM_BUG_ON_FOLIO to lru maintenance
 function
Date: Wed, 25 May 2022 19:59:09 +0800
Message-ID: <Yo4aDaiADXqFnbk8@FVFYT0MHHV2J.usts.net>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-11-songmuchun@bytedance.com>
 <Yo01ghDEu4KcYKpH@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bBzKMMaiGL+EGEsjuc4MBX5f/qXIyEgcNNQtA6G0IvA=;
        b=W7qA8nhtY4E/Qs4zv/J+F2PtRVpVlxLTKZVl2y60rx5UXgTH2ir4JJQ4cbSwj/ka4Z
         rO3CyrijViPOhV/36HeqmSVxnym2O37IK10d0zhVBpBzZHKacaXQx1+fndmIU+betlvC
         iw6iu8+QfLGop+S1pacmy1CzRbKaSavv6qIFG+iLzCi0XSIRqXbUP+gXyGp+lVF+z14F
         36mEXTSjCD48u0oeV8RJ8CZcOVFWI6ZF3GLUHy9XoSh8gGflwQ04Uzb8TH2aqfQtcVHZ
         VpUMdEQbdzBoZSc/35me/V6E0Lm1H1LFQFBqhXSgfPRuNT5CutAP7Z35vIBGkL+FLptM
         UD3A==
Content-Disposition: inline
In-Reply-To: <Yo01ghDEu4KcYKpH-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 03:44:02PM -0400, Johannes Weiner wrote:
> On Tue, May 24, 2022 at 02:05:50PM +0800, Muchun Song wrote:
> > We need to make sure that the page is deleted from or added to the
> > correct lruvec list. So add a VM_BUG_ON_FOLIO() to catch invalid
> > users.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Makes sense, but please use VM_WARN_ON_ONCE_FOLIO() so the machine can
> continue limping along for extracting debug information.
>

Make sense. Will do.

Thanks. 
