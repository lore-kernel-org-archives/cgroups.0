From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 10/11] mm: lru: add VM_BUG_ON_FOLIO to lru maintenance
 function
Date: Tue, 24 May 2022 15:44:02 -0400
Message-ID: <Yo01ghDEu4KcYKpH@cmpxchg.org>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-11-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=duLuqB8eb+MaAuTUNyV5BqcfLXI7fybo56wYzXWGIiA=;
        b=LQjPgH5pYVk+OZLBC5c+2LKzzjOPpoPsmIYf3dAjs7IR7wior+HPhi5DLXc2LN8Drl
         EoPOpIeoYB26pjGvRbHNNSnA83STJMvJOYq7RdgglpVduRGUsjLWU10mtO5H62JaXoF9
         vvdrZTi3UEoCva9nzg8aa+ette30RLNnKvAt1D0z2fJD1n7xhSZUHFvUzyk1gsVM0VGu
         pEoEpUMwmqNqgZVw0lPpHwqwyrHiZd6uvBB/uBLURbI24NimfrzoT/Ih/EthYiIFc3u+
         zvk+RxOEcP5uiATSRbIUpyJOVEjk6lS5kjo/wf6G+dhdXufA7bCE4Qi4FA0Ug0L+2n1p
         CCJw==
Content-Disposition: inline
In-Reply-To: <20220524060551.80037-11-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 02:05:50PM +0800, Muchun Song wrote:
> We need to make sure that the page is deleted from or added to the
> correct lruvec list. So add a VM_BUG_ON_FOLIO() to catch invalid
> users.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Makes sense, but please use VM_WARN_ON_ONCE_FOLIO() so the machine can
continue limping along for extracting debug information.
