From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.8] cgroup: add cpu.stat file to root cgroup
Date: Wed, 27 May 2020 12:08:21 -0400
Message-ID: <20200527160821.GC42293@cmpxchg.org>
References: <20200526200800.3969430-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w8h0j9dH4yYJY4/vfPJevkjnamNxkzeTwIjaJ077JR0=;
        b=wr9R8e/kt+6YZN51MgGSrgrQKN+iV0+U0w3YDiUZds+tcdj7UMMAPuL2YRAryMtohX
         VNKbvNrG4bIjPWETOEhzA2c4U/E+X4CVY2EgJ/5ySPQ3LlqJidyQIRGPfTzASiiFnl+S
         uHmbW0X2xvXgxyXg4abfE1eHxfYdyOP2KHd5y4aqtb2dKO5FWfHDDlvh4G4leXuoDM2X
         6k6SD1XYo3XXhbqc/Ijv/Mz+1Egec9v2tRNzcTRPdOlPecpv6ZUeA9Eni8M8qGoWVGYI
         25JlCJx5lZcI/qzgwceu2T05yXTObMsf3EZfQHFHZ6afE2C5Lsf9qFojbh1qNErXd8RZ
         b0/A==
Content-Disposition: inline
In-Reply-To: <20200526200800.3969430-1-boris-UrQYPotlwNs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, May 26, 2020 at 01:08:00PM -0700, Boris Burkov wrote:
> Currently, the root cgroup does not have a cpu.stat file. Add one which
> is consistent with /proc/stat to capture global cpu statistics that
> might not fall under cgroup accounting.
> 
> We haven't done this in the past because the data are already presented
> in /proc/stat and we didn't want to add overhead from collecting root
> cgroup stats when cgroups are configured, but no cgroups have been
> created.
> 
> By keeping the data consistent with /proc/stat, I think we avoid the
> first problem, while improving the usability of cgroups stats.
> We avoid the second problem by computing the contents of cpu.stat from
> existing data collected for /proc/stat anyway.
> 
> Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Looks good to me, but Boris can you please update
Documentation/admin-guide/cgroup-v2.rst as well in this patch?

  cpu.stat
        A read-only flat-keyed file which exists on non-root cgroups.

Thanks!
