From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v18 06/32] mm/thp: narrow lru locking
Date: Sun, 13 Sep 2020 16:27:03 +0100
Message-ID: <20200913152703.GI6583@casper.infradead.org>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-7-git-send-email-alex.shi@linux.alibaba.com>
 <20200910134923.GR6583@casper.infradead.org>
 <514f6afa-dbf7-11c5-5431-1d558d2c20c9@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=C1bbDqi5VCfzqw76j0WaYj+8YMSHM3OKpSoM0GoYCKo=; b=OZONTHLY9/TgFfO41JQ+xf6am3
        GJdQeLzpPTtraP+6usD99lKEXnWfjZkuGOgAo/Cj4cPBjC0sXLpR/6bOD43DcmCv65a+BtJX0DB/E
        iJj620MXIapmzXo0y5OoRIGq8YjAylAfC2KBLSG8SqqgFvaJoGD2aCJK7bK/CZJXhrNH7gZZwCyq0
        ud+9D0y83Gyi7Ng6HsQp6NfE7Qc+y/cF2xnZ9Ilrw0WN2JKzxieVj/i4pyQXRZXSAnnFIGDlnYhNE
        XVPdPUH0RHEUs5gBqZ3pm4qm/eCgkvV+Sx18YN3Glw8zlK1Uhba6tusVYMJK5NLL3QfI7zbal90lH
        K/pli+oQ==;
Content-Disposition: inline
In-Reply-To: <514f6afa-dbf7-11c5-5431-1d558d2c20c9-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Sep 11, 2020 at 11:37:50AM +0800, Alex Shi wrote:
> 
> 
> 在 2020/9/10 下午9:49, Matthew Wilcox 写道:
> > On Mon, Aug 24, 2020 at 08:54:39PM +0800, Alex Shi wrote:
> >> lru_lock and page cache xa_lock have no reason with current sequence,
> >> put them together isn't necessary. let's narrow the lru locking, but
> >> left the local_irq_disable to block interrupt re-entry and statistic update.
> > 
> > What stats are you talking about here?
> 
> Hi Matthew,
> 
> Thanks for comments!
> 
> like __dec_node_page_state(head, NR_SHMEM_THPS); will have preemptive warning...

OK, but those stats are guarded by 'if (mapping)', so this patch doesn't
produce that warning because we'll have taken the xarray lock and disabled
interrupts.

> > How about this patch instead?  It occurred to me we already have
> > perfectly good infrastructure to track whether or not interrupts are
> > already disabled, and so we should use that instead of ensuring that
> > interrupts are disabled, or tracking that ourselves.
> 
> So your proposal looks like;
> 1, xa_lock_irq(&mapping->i_pages); (optional)
> 2, spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
> 3, spin_lock_irqsave(&pgdat->lru_lock, flags);
> 
> Is there meaningful for the 2nd and 3rd flags?

Yes.  We want to avoid doing:

	if (mapping)
		spin_lock(&ds_queue->split_queue_lock);
	else
		spin_lock_irq(&ds_queue->split_queue_lock);
...
	if (mapping)
		spin_unlock(&ds_queue->split_queue_lock);
	else
		spin_unlock_irq(&ds_queue->split_queue_lock);

Just using _irqsave has the same effect and is easier to reason about.

> IIRC, I had a similar proposal as your, the flags used in xa_lock_irqsave(),
> but objected by Hugh.

I imagine Hugh's objection was that we know it's safe to disable/enable
interrupts here because we're in a sleepable context.  But for the
other two locks, we'd rather not track whether we've already disabled
interrupts or not.

Maybe you could dig up the email from Hugh?  I can't find it.

