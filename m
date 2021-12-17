From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH-next v3] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Fri, 17 Dec 2021 19:21:37 +0100
Message-ID: <YbzVMURu2b2/++yi@linutronix.de>
References: <20211214144412.447035-1-longman@redhat.com>
 <Ybx3ubNFfGpCqhn0@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639765299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fm8Ji21c2eiKP0yW1lKrfGVuKLVJyDvJbeQwn/ZsYvM=;
        b=YqrU3fHSQRfaFxUWraZUi980r3t8h7vYSYTYzSR3s0gWO5X9yKrM2rWbqwY39lGVyl0lSX
        ONjIGeqwz29rc6M5TyE4S/cLoCfB9Dckz1DMBhjwSy0asb+U2J3j6IYEjiK4jOfYnQzpwA
        Qi9+Idkz9wWSoDviGb6NrcMSxjOkBxKODW47A99mUb+LDX1V+mNK+rg9+7m5XI/FWfo/ak
        29Qzc4S7++v3EotbBhJ1xtorSGNzhcAsKrH9ISvrSYT+I58TA4csXrlM3Ggtaqx5WK6/ZV
        4o7mi8wdT3FZFilT5Znj32LIkdmV+NKQ28BWl9WBQfaDNg1qFHolx2kunWfE2Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639765299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fm8Ji21c2eiKP0yW1lKrfGVuKLVJyDvJbeQwn/ZsYvM=;
        b=9Tm2o/FLsPj4spSSiHLUbXy/DCYZ3PjoY5s5g+ZQy2QGHF7KQk9kTv/yEF/a//9Ryn4TzC
        sA45eR7TuPsNTiDQ==
Content-Disposition: inline
In-Reply-To: <Ybx3ubNFfGpCqhn0-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 2021-12-17 12:42:51 [+0100], To Waiman Long wrote:
> On 2021-12-14 09:44:12 [-0500], Waiman Long wrote:
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2096,7 +2096,12 @@ struct obj_stock {

so I made something based on this. Let me clean this up and test it
first. So it is just a heads up :)

Sebastian
