From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 13 Apr 2017 12:01:47 -0400
Message-ID: <20170413160147.GB29727@cmpxchg.org>
References: <20170317231636.142311-1-timmurray@google.com>
 <20170330155123.GA3929@cmpxchg.org>
 <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw@mail.gmail.com>
 <20170413043047.GA16783@bbox>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E166PNWoPctjRr7OTCJPXUh0fu3idwk2BPr7k8BsimA=; b=p1tfeedFUpV1J3sJm+ReeQfWc6
        h6sjdoV8904Oss2PR/ymA62jLJnrbfNA+ACPX0gFQ2MsnRrWDH+iLhugK+3ovC1w/rd/JjGUJXKwJ
        RVqTdTxdGlmHGwr7XsCh3JkArfpOKAjKJKv9YEtaM8sTHdrLnOZSDw/qDvRn/nge8I4U=;
Content-Disposition: inline
In-Reply-To: <20170413043047.GA16783@bbox>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patrik Torstensson <totte-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

On Thu, Apr 13, 2017 at 01:30:47PM +0900, Minchan Kim wrote:
> On Thu, Mar 30, 2017 at 12:40:32PM -0700, Tim Murray wrote:
> > As a result, I think there's still a need for relative priority
> > between mem cgroups, not just an absolute limit.
> > 
> > Does that make sense?
> 
> I agree with it.
> 
> Recently, embedded platform's workload for smart things would be much
> diverse(from game to alarm) so it's hard to handle the absolute limit
> proactively and userspace has more hints about what workloads are
> more important(ie, greedy) compared to others although it would be
> harmful for something(e.g., it's not visible effect to user)
> 
> As a such point of view, I support this idea as basic approach.
> And with thrashing detector from Johannes, we can do fine-tune of
> LRU balancing and vmpressure shooting time better.
> 
> Johannes,
> 
> Do you have any concern about this memcg prority idea?

While I fully agree that relative priority levels would be easier to
configure, this patch doesn't really do that. It allows you to set a
scan window divider to a fixed amount and, as I already pointed out,
the scan window is no longer representative of memory pressure.

[ Really, sc->priority should probably just be called LRU lookahead
  factor or something, there is not much about it being representative
  of any kind of urgency anymore. ]

With this patch, if you configure the priorities of two 8G groups to 0
and 4, reclaim will treat them exactly the same*. If you configure the
priorities of two 100G groups to 0 and 7, reclaim will treat them
exactly the same. The bigger the group, the more of the lower range of
the priority range becomes meaningless, because once the divider
produces outcomes bigger than SWAP_CLUSTER_MAX(32), it doesn't
actually bias reclaim anymore.

So that's not a portable relative scale of pressure discrimination.

But the bigger problem with this is that, as sc->priority doesn't
represent memory pressure anymore, it is merely a cut-off for which
groups to scan and which groups not to scan *based on their size*.

That is the same as setting memory.low!

* For simplicity, I'm glossing over the fact here that LRUs are split
  by type and into inactive/active, so in reality the numbers are a
  little different, but you get the point.

> Or
> Do you think the patchset you are preparing solve this situation?

It's certainly a requirement. In order to implement a relative scale
of memory pressure discrimination, we first need to be able to really
quantify memory pressure.

Then we can either allow setting absolute latency/slowdown minimums
for each group, with reclaim skipping groups above those thresholds,
or we can map a relative priority scale against the total slowdown due
to lack of memory in the system, and each group gets a relative share
based on its priority compared to other groups.

But there is no way around first having a working measure of memory
pressure before we can meaningfully distribute it among the groups.

Thanks
