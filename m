From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/6] sched,timer: Use __set_current_state()
Date: Thu, 3 Jun 2021 08:39:05 +0200
Message-ID: <YLh5CaqPHBhBhfVu__8177.99907397188$1622702510$gmane$org@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.524487671@infradead.org>
 <20210602195458.uj3rsci4suz4mufj@offworld>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kX55QmPWFxDII3Sge2GJJeSnbWWFYdnRducRMGOGHKQ=; b=hARedGyAr0sDE+BtvdYhtLLhqT
        xBRJL5OHbgF/0VaAM6QvlBJXr83HT5NVS7V8DRpuXyYFELaqdsUVDKE7xdQXCUsOoQxD+ZryBn0Lj
        TQUUpF9nIf+OhCYb2DCINiYA10TI8AImzzNG9gBDI61JDK4y9IyT9HC7swn3WceMAMX+pproGTr+z
        euH2oJmi+z8yDYk4o986bBSmMqnp2oduWzGnBnR6zXjKvIqpkjAsnYAK7TaquLehFRzRkMRw2LFzB
        sQkU84q2RHe9CpB6m2+QJnfPaODcV/HKj6IpiHproIA95ZpBeuavpXhNkqQKbgxpRXe24aJvU2Taj
        vd1R75YA==;
Content-Disposition: inline
In-Reply-To: <20210602195458.uj3rsci4suz4mufj@offworld>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 12:54:58PM -0700, Davidlohr Bueso wrote:
> On Wed, 02 Jun 2021, Peter Zijlstra wrote:
> 
> -ENOCHANGELONG

I completely failed to come up with something useful, still do. Subject
says it all.

> But yeah, I thought we had gotten rid of all these.

I too was surprised to find it :-)
