From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH-next v3] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Fri, 17 Dec 2021 20:48:47 +0100
Message-ID: <Ybzpn59+ecDCnULt@linutronix.de>
References: <20211214144412.447035-1-longman@redhat.com>
 <Ybx3ubNFfGpCqhn0@linutronix.de>
 <b82efbad-1eb2-9441-ab0b-cbb3d2b5eac6@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639770528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MOhtWEVpE/nHvAfkcQxgjTO8DE1E/CE1cP2TvinWtt8=;
        b=usmzDClfjRh8F0bmnhmCivgUEzP3w2hcvpAvIrtYeBpsuLRJn+4DKo6fxqVSJatueqh/bL
        y1U2c4vzTmXRimDg8GVoBZvKtFqEsvVdMgGej6G+EsDFhT6W1diHNgOIC0KfMfDjz5E2FR
        LWiq5pgDeVvuMmhGNiV9JI4DhVFmCJsTUFwyFHUab0bBZlhSSIZ2p4TXkp81D4DCO0Q8/D
        EuJEQqKeReqTl4+hXBoQ8YifN5FDSYOaMWrWNq9b2jedjnGk4vLa7oJhW6jbL2Ajeycnmm
        xF2VpEjm7wkrWwBTi+0oC4IPzUPaxG3GIo2P4qGbXGEE7KUOGmmWiY2Hg7lQqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639770528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MOhtWEVpE/nHvAfkcQxgjTO8DE1E/CE1cP2TvinWtt8=;
        b=/FtWHAeSunsf+hn8FNtZSk94a8f3FndZKtc38HIXjF5iIq4qp6jb4YV269837n+ncw/jYU
        wuiXPn983+tX6xDQ==
Content-Disposition: inline
In-Reply-To: <b82efbad-1eb2-9441-ab0b-cbb3d2b5eac6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 2021-12-17 13:46:53 [-0500], Waiman Long wrote:
> > annotation. Looking at the history, I'm also impressed by that fact that
> > disabling/ enabling interrupts is *so* expensive that all this is
> > actually worth it.
> 
> For !RT with voluntary or no preemption, preempt_disable() is just a
> compiler barrier. So it is definitely cheaper than disabling interrupt. The
> performance benefit is less with preemptible but !RT kernel. Microbenchmark
> testing shows a performance improvement of a few percents depending on the
> exact benchmark.

Thanks for confirming. I got the feeling that this optimisation is for
!CONFIG_PREEMPTION. So I instead of depending on CONFIG_PREEMPT_RT I'm
leaning towards CONFIG_PREEMPT instead.

> Cheers,
> Longman

Sebastian
