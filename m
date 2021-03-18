From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: set page->private before calling swap_readpage
Date: Thu, 18 Mar 2021 11:03:10 -0400
Message-ID: <YFNrrlPBmdgdanH1@cmpxchg.org>
References: <20210318015959.2986837-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z7lTVVRuSUfjS6oFurvBuW+lqnBMNQb+/M9MCKQeJGA=;
        b=hAWWBQ5r7q2qGQHnUkSAaN9SgxOHXzxDQuWPR9UYpiwDv9bKlXuBl9O9bQwvhnecCX
         V9pMmBkWY/uctykn77aF8/spzsmXw8rM3L1lJxcvgPVmo/SS9Om1LTqmDdxw+UClUl+U
         PxAWoeJhP4OsOJtOJ3+na7BN9Glh4mTVNyUPNu/gGjoJ8vh5fbhD8H07IOHGxhH7LMjr
         /V8tIIGrAfHjCGBzUlMuMltFDshNKlOb9J2//RnV6fYCAyAd27Oo3Bu4BbmmqdwkJW4D
         sh9KvbypBkoy7kBfHZUEhCtnPsonmS0cioBYmureMdgxGY8s8YIfL0vdL0H+/uwAz82k
         8e7w==
Content-Disposition: inline
In-Reply-To: <20210318015959.2986837-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

On Wed, Mar 17, 2021 at 06:59:59PM -0700, Shakeel Butt wrote:
> The function swap_readpage() (and other functions it call) extracts swap
> entry from page->private. However for SWP_SYNCHRONOUS_IO, the kernel
> skips the swapcache and thus we need to manually set the page->private
> with the swap entry before calling swap_readpage().
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

LGTM
