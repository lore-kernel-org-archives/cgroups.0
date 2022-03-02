From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Use irqsave in cgroup_rstat_flush_locked().
Date: Tue, 1 Mar 2022 20:38:51 -1000
Message-ID: <Yh8Q+wjgk6dkDphR@slm.duckdns.org>
References: <[PATCH0/2]CorrectlockingassumptiononPREEMPT_RT>
 <20220301122143.1521823-1-bigeasy@linutronix.de>
 <20220301122143.1521823-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K4RKtZ4EM/v8P4fEu3jSYrerGRfgI+G2IZ0OObJQr4k=;
        b=j1HfZ85jE8z4taKaq8Wr1YttYtwHmHsIKldoldrrQSTsgqOxVM4cs32oAUlhIT4+qK
         j4TLqlA3XWATSrnLL3yV2FkNzyCj7dDJuMOHZBykJT6qR7X88qL8TjI2oaYzo+M+cAbt
         tfs+DYMPDwHpM4ZZY/5rNTTvyr1sFdFs+z5vXsYSq08M7KjCT+OdfKPvMVQmcXHOcQNW
         zMl2yWg+QNS5K8uEP/ZG357TZMisvH+aA3ZU6l7gX/VRKI0H+yVrsYUjorF5TOAQu3GE
         kg3MhOIDOGPciobnNiaLlYzM4tT45kpkdwdZEBi/jt3MDPUoFqFmw/Y8BFUnAv5ikHno
         Ln8w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220301122143.1521823-2-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Hello,

On Tue, Mar 01, 2022 at 01:21:42PM +0100, Sebastian Andrzej Siewior wrote:
> All callers of cgroup_rstat_flush_locked() acquire cgroup_rstat_lock
> either with spin_lock_irq() or spin_lock_irqsave().
> cgroup_rstat_flush_locked() itself acquires cgroup_rstat_cpu_lock which
> is a raw_spin_lock. This lock is also acquired in cgroup_rstat_updated()
> in IRQ context and therefore requires _irqsave() locking suffix in
> cgroup_rstat_flush_locked().
> Since there is no difference between spin_lock_t and raw_spin_lock_t
> on !RT lockdep does not complain here. On RT lockdep complains because
> the interrupts were not disabled here and a deadlock is possible.
> 
> Acquire the raw_spin_lock_t with disabled interrupts.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Can you please add a comment explaining why irqsave is being used? As it
stands, it just looks spurious.

Thanks.

-- 
tejun
