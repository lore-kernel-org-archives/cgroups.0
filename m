From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Wed, 19 Jul 2017 16:07:28 +0200
Message-ID: <20170719140728.3mcg6uemqyy5muc4@hirez.programming.kicks-ass.net>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
 <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
 <20170718175456.GH585283@devbig577.frc2.facebook.com>
 <20170718184135.auf6d2clsdxseka3@hirez.programming.kicks-ass.net>
 <20170718184714.GA3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=atInUPFEZOM0dzoNG3Z/aX8Lc+1P04Udi0zYTdDwkwM=; b=hL3juR8EU7PKWV17i6bpj2dtR
        25ANVZwx6FRr40Q9kXI626VpDIkxOOdj85hGzN18buKxdLEwlt1iGt21azaCigqVyxkslf/PJbbth
        tnHHZUpHaG7DTBjLTdqVbfiUWVG7xDqo/7BiKyQ9TUx9XuZce7RoUIow269drwMUS5TMBzYkSo4WU
        /kagOrdCRvOP4MPCcO8J4KDmNluW6RaLl/RhUou/VWWoUJ5I5d9QuuaPNa3hNjFmKrq9wqp/VkIQh
        p8gt3nM+sce4nFiDJD7WF8MDXBm1TH0Oq5X14WsauNXB9JVbs8qnrkVDyPzAZdjqNVwTxgHs0oDzt
    
Content-Disposition: inline
In-Reply-To: <20170718184714.GA3365493-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Tue, Jul 18, 2017 at 02:47:14PM -0400, Tejun Heo wrote:
> Were there other things that caught your eyes?

I didn't immediately see the point of "domain (threaded" output, and I
think it might be useful to have a "threaded" column in /proc/cgroups.
But no, I've been over this a few times now and I think we're good.

Yes, I think we can work with this. Thanks!
