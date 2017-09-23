From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Sat, 23 Sep 2017 15:37:31 +0200
Message-ID: <20170923133731.uq5qekjypndpjv2l@hirez.programming.kicks-ass.net>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170922180530.GG828415@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vSFGAZOVoN9mcBIi2NxukMgyZJWc0ea5x/mMcfR7n/s=; b=C3nKca6tVyOC1dTGiLfhuT71V
        nWWA6BneZ6UjzJC00ey0S5ejx/kAdUzoIgwre4mNDWWg3WoThXtF086HqlN5xYBHY1ICxVBRUT6BW
        zUVJoIfu+lyy1FvPyAIA+DzZqMxBs23iz1Q7LoHD4GPcT/LtDLubFSKWCDHPU57Ljm8PLRGcbCw7C
        15N9LY/Dp7qnAcv4aUs7RaGNZPtILyz+4sgZrAUv/uDjJ0B0/UV1EJkAbf6SqfHcmZYZvMI0+erSD
        MbYEOx6t0jYDC2tcimfNRT1S4kjIBAwYf1d9iZHAvrjTSXFsXn8vcnRGGNBSFqp8EfAaMB2v4J4qp
    
Content-Disposition: inline
In-Reply-To: <20170922180530.GG828415-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Fri, Sep 22, 2017 at 11:05:30AM -0700, Tejun Heo wrote:
> Peter, ping?

Humm,. So I think I was good, but I was under the impression you'd send
a new version better explaining the need/design of that iteration stuff.
Could be I lost the plot somehow.
