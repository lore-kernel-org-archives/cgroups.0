From: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Subject: Re: [PATCH 3/3] block: Replace struct rq_depth with unsigned int in
 struct iolatency_grp
Date: Mon, 17 Oct 2022 14:27:18 -0400
Message-ID: <Y02ehhyqSSLIV5ZS@localhost.localdomain>
References: <20220929074055.30080-1-shikemeng@huawei.com>
 <20220929074055.30080-4-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zmaKaOskyDEP07VNlz3xmfh/tqhUu/L+2TquVBpNhZY=;
        b=irazOzM4ASvlywgucqMF4REBu2/swLVa43rA8LaqSR7jySzDQIligyjApbjGDuRMnS
         vQ9T4lVgXghfnASSDN1i8Xm5LuOSSmKrQeI+6Q3lSUMmcQ+S1ZMTwud4rwmdl2bKdUJb
         5A06jqIl6l0Q2ioGWFm1rgsyyv4+WVSI4vYkLYIuU7cq4ky+UG4BGvxh1YPFxlUM/mIS
         Aw95Uxl1xiMYZ1r6HA1cYcy6yLf9NSiyJC6i/20sgvkT64Wy2hfytLqNbB9lJrafEKAJ
         uYrMCySQfhbY4F4nodfn5APsYFVG5AQ69EqSfJVLIC4k3huk52b7fymAHztEqux5yncf
         8vfw==
Content-Disposition: inline
In-Reply-To: <20220929074055.30080-4-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 29, 2022 at 03:40:55PM +0800, Kemeng Shi wrote:
> We only need a max queue depth for every iolatency to limit the inflight io
> number. Replace struct rq_depth with unsigned int to simplfy "struct
> iolatency_grp" and save memory.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>

Thanks,

Josef
