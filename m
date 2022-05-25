From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v4 06/11] mm: thp: make split queue lock safe when LRU
 pages are reparented
Date: Wed, 25 May 2022 19:44:31 +0800
Message-ID: <Yo4Wn7IBdNBR8dWx@FVFYT0MHHV2J.usts.net>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-7-songmuchun@bytedance.com>
 <Yo2aa661fepAOvjO@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nCNfEzGqMIoFCilTHapRIVeS9mBRmJZJ0gWnXehqDrw=;
        b=KKorYnAd9m8FFqkZWn1KRNBoG7l7TplARvR9C9P62KHQROZ+jCx3jrm3pqL/gal3c9
         tFxlYeVI5en3DpBcz9uCwkckr9YIthe+s0N26u6nJlmW2jp2woFwMCKEv8tbOJ6Ue3TI
         WbS9a4byWlYC8V9D8SCd2meKPqDE/U0FTn5968T/hQciYJlyiEq9tZ94pXPADWkvFk0j
         eBCLDxzMmIeDgmSoxpS+Db6wfsGf6U2Vh4SNWSSt6qCjruPdllqx+6OFrhWa3ZcNnszL
         b/ePL8Ohf4qX+HlckCZ2au3uCxyAFMSgsiIR8AcKFf1o7nK3X+9eTEmBH7FOmpCbJ/vp
         WKyQ==
Content-Disposition: inline
In-Reply-To: <Yo2aa661fepAOvjO@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 07:54:35PM -0700, Roman Gushchin wrote:
> On Tue, May 24, 2022 at 02:05:46PM +0800, Muchun Song wrote:
> > Similar to the lruvec lock, we use the same approach to make the split
> > queue lock safe when LRU pages are reparented.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Please, merge this into the previous patch (like Johannes asked
> for the lruvec counterpart).
>

Will do in v5.
 
> And add:
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> .
>

Thanks Roman.

