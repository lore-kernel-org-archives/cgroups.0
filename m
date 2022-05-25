From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 04/11] mm: vmscan: rework move_pages_to_lru()
Date: Wed, 25 May 2022 19:41:26 +0800
Message-ID: <Yo4V5o0dasZSm2MF@FVFYT0MHHV2J.usts.net>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-5-songmuchun@bytedance.com>
 <Yo2Xt6zFxNrf9M5j@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Di7XV4IGWF77tQvxoeiNfKzeIQMl+KEXZAhavQki9xI=;
        b=4PIrBTtSY7gdXmJ5owF/C1/ZrJroXty20T94JZS01Q1mZd4fgW+U09Ylg34REtQHwg
         VvHo688nCXJo+Q7+koX9lz+0tbnGoEkPPGZ2AgZ66FiiIBz/6J2zuZ2o6ahZyYplwi5a
         ZpYwEegz5Et296T5u2GHEruAMZ0J0oFI2MrnGS/px1P5ZBQ3T4Fw9BIIQZ7ilJbngsZX
         RuccrSfBxgHlo3I+FuYajmX7kRE146DU7yk3DvUqdzSiPKw6IAB1msE3q4MepqWL+Drr
         HByjp0hRrmK7RyClGTppcHZFzyvg58pywiCu6oaOmRd1JgAsrEtQimpdgiRstKiuADI5
         INkw==
Content-Disposition: inline
In-Reply-To: <Yo2Xt6zFxNrf9M5j@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 07:43:03PM -0700, Roman Gushchin wrote:
> On Tue, May 24, 2022 at 02:05:44PM +0800, Muchun Song wrote:
> > In the later patch, we will reparent the LRU pages. The pages moved to
> > appropriate LRU list can be reparented during the process of the
> > move_pages_to_lru(). So holding a lruvec lock by the caller is wrong, we
> > should use the more general interface of folio_lruvec_relock_irq() to
> > acquire the correct lruvec lock.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> With changes asked by Johannes :
> 
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>

Thanks Roman.
 
