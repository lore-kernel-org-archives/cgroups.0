From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix blocking rstat function called from
 atomic cgroup1 thresholding code
Date: Tue, 27 Jul 2021 09:51:00 -0700
Message-ID: <CALvZod5JmcSpym6oXMXEUXEq2u13SVLRaVGPg84ubeYZt-6w_g@mail.gmail.com>
References: <20210726150019.251820-1-hannes@cmpxchg.org> <2b0b08f9385b25fb7750dbe453516b0c8bb27604.camel@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CluUB6u3e6vSvuTj9ZDWKd+9lXyRKKVlLnHCPzqySkA=;
        b=Y/LXubLHM6WaUYdSxC4yHzA/PTO+4Iqp9OsSGe3NsOGrtNlHl58r72AsYkXhdSCVQk
         D92+/e/bbScw3fEpORhyJziDUQ06Gip3vgD3hI415HLxOwopdy18WMhqzBtHqCVEgmxr
         SPY77804g9crzhfRDMDqNBaVg9Bl2zAu41NtTzjt29nfXSWgJUAXMlkN8MPczoEzISHv
         bbXgRZMI/bPixBkPOaTWs49nEb+UsiQSNOLJw9Q/S10QHZFu3H/OTvTsq+zZPxC0vjAh
         rrV7zb89dwiur8VffZobyLrz4fGDFLjJly+sTkMvJIcOfKoTB+1K2qPRuEuV0/d5a2z7
         XRQA==
In-Reply-To: <2b0b08f9385b25fb7750dbe453516b0c8bb27604.camel-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel-b10kYP2dOMg@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>, "dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 26, 2021 at 8:19 AM Rik van Riel <riel-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Mon, 2021-07-26 at 11:00 -0400, Johannes Weiner wrote:
> >
> > __mem_cgroup_threshold() indeed holds the rcu lock. In addition, the
> > thresholding code is invoked during stat changes, and those contexts
> > have irqs disabled as well. If the lock breaking occurs inside the
> > flush function, it will result in a sleep from an atomic context.
> >
> > Use the irsafe flushing variant in mem_cgroup_usage() to fix this
>
> While this fix is necessary, in the long term I think we may
> want some sort of redesign here, to make sure the irq safe
> version does not spin long times trying to get the statistics
> off some other CPU.
>
> I have seen a number of soft (IIRC) lockups deep inside the
> bowels of cgroup_rstat_flush_irqsafe, with the function taking
> multiple seconds to complete.

Can you please share a bit more detail on this lockup? I am wondering
if this was due to the flush not happening more often and thus the
update tree is large or if there are too many concurrent flushes
happening.

>
> Reviewed-by: Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>
