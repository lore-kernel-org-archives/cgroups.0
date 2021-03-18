From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: set page->private before calling swap_readpage
Date: Thu, 18 Mar 2021 11:02:17 -0400
Message-ID: <YFNreYne/27T9XA8@cmpxchg.org>
References: <20210318015959.2986837-1-shakeelb@google.com>
 <YFNdNeczjnmF55bm@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ODku1sNI+qzXn1A0+oyYPRNoNufpW48D4xQgC/ecSb8=;
        b=hywKb9JeRd9aGyWq9FNaxWtEEW+yd82HTdswTVDd+YNG4CK4ZnSRTzRkxPwIlz3Wvy
         vUYCvr9m0vMQnHTsXASTFTDUD3quCYQd9i5tW7wERWnJdNCkzr67eUw5wTX6qg17tofO
         9RIb8wyrDa16vhsBdb2rZ68Ayv/cCciBiG1872zqL2E2adC+QLbEOFMixg2/K3jZEHJr
         JhI2uGgNAw1Z8EZKhaw9kxkZp1+2fdIJhxiq9F9xa/NdGrlZyijiKRnp1DmGv4d0ldn6
         MmiSWRlu3ortORbGmJAt5W7Uvf/CRMcPBb+0uOhER92DsjeQfjpL7iqD81yoelklufuB
         KhXA==
Content-Disposition: inline
In-Reply-To: <YFNdNeczjnmF55bm-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Thu, Mar 18, 2021 at 03:01:25PM +0100, Michal Hocko wrote:
> On Wed 17-03-21 18:59:59, Shakeel Butt wrote:
> > The function swap_readpage() (and other functions it call) extracts swap
> > entry from page->private. However for SWP_SYNCHRONOUS_IO, the kernel
> > skips the swapcache and thus we need to manually set the page->private
> > with the swap entry before calling swap_readpage().
> 
> One thing that is not really clear to me is whether/why this is only
> needed with your patch. Can you expand a bit on that please? Maybe I am
> just missing something obvious but I just do not see any connection.

It was always needed, his original patch erroneously removed it.
