From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 23 Mar 2023 15:39:35 -1000
Message-ID: <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679621977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=diknpbDhmJOoggKEsWIo361E1xjQ+rSUkFKYJZdkY28=;
        b=gnLz9UYgts87Q3W2eAEqb/mHOi71mt9PGOMXo3NEdCjx7le5V/SdRfNH8QY4DX91PR
         mCvDShHmWN+U7wlmjHd9cNHfFqLwHTUB+uMCgGW9/AhNY0yULgXlcZ4Yr6gh/o4Q76pD
         cpevHL0IWLcIVZwFvShEgeRYVAOmSQ439XwAhpgltMNrVpWg6AP/2rmWh2ioK5uFVZu+
         5o1qQYTV+9U6tf8A347nKJPhMMsepQ9SGZRRmNplq7DNiyWcq7TmfeLRBH8sG0ZbzbPv
         0nPC1d127qZAyd2STxenO3kLgZbv3SE2IDCsan4ukhVtSm1eAZoY1dhs1c1XqtCOMOe9
         nA2Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230323040037.2389095-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Mar 23, 2023 at 04:00:31AM +0000, Yosry Ahmed wrote:
> Currently, when sleeping is not allowed during rstat flushing, we hold
> the global rstat lock with interrupts disabled throughout the entire
> flush operation. Flushing in an O(# cgroups * # cpus) operation, and
> having interrupts disabled throughout is dangerous.
> 
> For some contexts, we may not want to sleep, but can be interrupted
> (e.g. while holding a spinlock or RCU read lock). As such, do not
> disable interrupts throughout rstat flushing, only when holding the
> percpu lock. This breaks down the O(# cgroups * # cpus) duration with
> interrupts disabled to a series of O(# cgroups) durations.
> 
> Furthermore, if a cpu spinning waiting for the global rstat lock, it
> doesn't need to spin with interrupts disabled anymore.

I'm generally not a fan of big spin locks w/o irq protection. They too often
become a source of unpredictable latency spikes. As you said, the global
rstat lock can be held for quite a while. Removing _irq makes irq latency
better on the CPU but on the other hand it makes a lot more likely that the
lock is gonna be held even longer, possibly significantly so depending on
the configuration and workload which will in turn stall other CPUs waiting
for the lock. Sure, irqs are being serviced quicker but if the cost is more
and longer !irq context multi-cpu stalls, what's the point?

I don't think there's anything which requires the global lock to be held
throughout the entire flushing sequence and irq needs to be disabled when
grabbing the percpu lock anyway, so why not just release the global lock on
CPU boundaries instead? We don't really lose anything significant that way.
The durations of irq disabled sections are still about the same as in the
currently proposed solution at O(# cgroups) and we avoid the risk of holding
the global lock for too long unexpectedly from getting hit repeatedly by
irqs while holding the global lock.

Thanks.

-- 
tejun
