From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Wed, 5 Oct 2022 07:42:55 -1000
Message-ID: <Yz3CH7caP7H/C3gL@slm.duckdns.org>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
 <Yz2xDq0jo1WZNblz@slm.duckdns.org>
 <CAJD7tkawcrpmacguvyWVK952KtD-tP+wc2peHEjyMHesdM1o0Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rH6mIZfviwrycSmWdDaZAhXLCNY90027cxpX58MWWN4=;
        b=e+UiZaH7mX/rn0iDl2OGvojLjy1qpQQPt9uPJFVFT4kf60gWjlXFYLj34i23DMavAr
         BLndmyJyLVDXkKAxOK8h0A4Nle8Yxzo41yeII4R+bOLzRFK0WIa+pfDMCWnNOLsQ5XO6
         v2JY9sofXArGDOkK1ieQgGOqeDIPdG2f2o5rkt9E+rj1VQGRqKIBIZbkYveYHcRbQ3wB
         OmaUnNsYE7BwrFxCV2SyMa0nVXkcArpG+OvQCquJp8bQNq20rwhEAxBikni7cLDM9AED
         UewhKYeF+Z4GVxwlf5RiROYfcMWw0iPaYs2aO43v2hBVlWa89OnbnsboZUTb8XwP1tFh
         ulAQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkawcrpmacguvyWVK952KtD-tP+wc2peHEjyMHesdM1o0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Oct 05, 2022 at 10:20:54AM -0700, Yosry Ahmed wrote:
> > How long were the stalls? Given that rstats are usually flushed by its
> 
> I think 10 seconds while interrupts are disabled is what we need for a
> hard lockup, right?

Oh man, that's a long while. I'd really like to learn more about the
numbers. How many cgroups are being flushed across how many CPUs?

> IIUC you mean that the caller of cgroup_rstat_flush() can call a
> different variant that only flushes a part of the rstat tree then
> returns, and the caller makes several calls interleaved by re-enabling
> irq, right? Because the flushing code seems to already do this
> internally if the non irqsafe version is used.

I was thinking more that being done inside the flush function.

> I think this might be tricky. In this case the path that caused the
> lockup was memcg_check_events()->mem_cgroup_threshold()->__mem_cgroup_threshold()->mem_cgroup_usage()->mem_cgroup_flush_stats().
> Interrupts are disabled by callers of memcg_check_events(), but the
> rstat flush call is made much deeper in the call stack. Whoever is
> disabling interrupts doesn't have access to pause/resume flushing.

Hmm.... yeah I guess it's worthwhile to experiment with selective flushing
for specific paths. That said, we'd still need to address the whole flush
taking long too.

> There are also other code paths that used to use
> cgroup_rstat_flush_irqsafe() directly before mem_cgroup_flush_stats()
> was introduced like mem_cgroup_wb_stats() [1].
> 
> This is why I suggested a selective flushing variant of
> cgroup_rstat_flush_irqsafe(), so that flushers that need irq disabled
> have the ability to only flush a subset of the stats to avoid long
> stalls if possible.

I have nothing against selective flushing but it's not a free thing to do
both in terms of complexity and runtime overhead, so let's get some numbers
on how much time is spent where.

Thanks.

-- 
tejun
