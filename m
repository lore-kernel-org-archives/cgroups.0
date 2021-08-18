From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Wed, 18 Aug 2021 10:15:24 -0400
Message-ID: <YR0V/KhKSYZs+ksn@cmpxchg.org>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
 <YRwRzjOexeXbkirV@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rg02+w1DlkJobhoJY9bM97YQwIjcX3dhjCH/vsEFgP0=;
        b=IJM3/57oMfrwBGTxX1IHTSufxeq6P3Ds6XRZvE9DZaQYu6SrVcwDRerEYF25qu7X1B
         P60N9RrgrRNag8tqLyPwd2wzaLi9O55qN9diwm9sZAtemcAodh0vkx7GORHTW9R5W2LY
         rV/W0SNTLdFLW8cLcW0Qu/6ySAJpxaO6I9bAxGJSjR5kQXqiY7nMpO/wVGbIlV0HDfjw
         dYuz+g7ZxYVhUxmQisLCpNH+9kMNrqw8fYLGpqtTiUzPzHScZLMpGUR7odgvREoOGyvq
         uG3PAzekn0lUz/hG2/KBgIhbNa18vFUOGqnNMOmaodYK+aTh4+ylfiWpcrP7Zlm5Pd0x
         G6kA==
Content-Disposition: inline
In-Reply-To: <YRwRzjOexeXbkirV-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Aug 17, 2021 at 12:45:18PM -0700, Roman Gushchin wrote:
> On Tue, Aug 17, 2021 at 02:05:06PM -0400, Johannes Weiner wrote:
> > We've noticed occasional OOM killing when memory.low settings are in
> > effect for cgroups. This is unexpected and undesirable as memory.low
> > is supposed to express non-OOMing memory priorities between cgroups.
> > 
> > The reason for this is proportional memory.low reclaim. When cgroups
> > are below their memory.low threshold, reclaim passes them over in the
> > first round, and then retries if it couldn't find pages anywhere else.
> > But when cgroups are slighly above their memory.low setting, page scan
> > force is scaled down and diminished in proportion to the overage, to
> > the point where it can cause reclaim to fail as well - only in that
> > case we currently don't retry, and instead trigger OOM.
> > 
> > To fix this, hook proportional reclaim into the same retry logic we
> > have in place for when cgroups are skipped entirely. This way if
> > reclaim fails and some cgroups were scanned with dimished pressure,
> > we'll try another full-force cycle before giving up and OOMing.
> > 
> > Reported-by: Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thank you.

> I guess it's a stable material, so maybe adding:
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")

Yes, that Fixes makes sense. Plus:

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.4+

I initially didn't tag it because the issue is over two years old and
we've had no other reports of this. But thinking about it, it's
probably more a lack of users rather than severity. At FB we only
noticed with a recent rollout of memory_recursiveprot
(8a931f801340c2be10552c7b5622d5f4852f3a36) because we didn't have
working memory.low configurations before that. But now that we do
notice, it's a problem worth fixing. So yes, stable makes sense.

Thanks.
