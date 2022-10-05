From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: check references from all memcgs for
 swapbacked memory
Date: Wed, 5 Oct 2022 11:51:30 -0400
Message-ID: <Yz2oAjIRZKKwe8tY@cmpxchg.org>
References: <20221004233446.787056-1-yosryahmed@google.com>
 <Yz2O1dGeBGBTh6SM@cmpxchg.org>
 <CAJD7tkbMtHEN_1zGP=V1X4YGFCxEXv_j2Fqe8TFdOTy-ykiVUg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2AoFrEpz0B0RLbXAkzCCAczpNqzFmtnMjKTlufu6KsU=;
        b=WRGwEQZ1TNdFoAuwtXbuWLZNv41BDB32f4pY76uWbOKjuF0h37pCQt+Pwgr6xs+N2t
         D3Ce0vY+MNtiBU0bi16rH7EAwk2rwH6/Y9fr/aocmu4c85nzeYy8GCFbknxL3K4+qEzd
         40IHJJuCITJXg9IsZmrkfcNRrfq2hWvPKTqK1YMX7Gb+hQUx5Q+z0BrtPgGU0BY54P94
         gtlky2y6FXCCcmbRO3gE9nBlrZKwEMydG9XtAdUUXiytwyVJ7hjOOqF+itedleWm94fc
         6aO36P0obqVLPwdYQkOJWbILzVJApg/HncfimKv9PUP2TTW2yVhWp+7bArcfWYq5JqDG
         nJ7w==
Content-Disposition: inline
In-Reply-To: <CAJD7tkbMtHEN_1zGP=V1X4YGFCxEXv_j2Fqe8TFdOTy-ykiVUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Oct 05, 2022 at 07:54:25AM -0700, Yosry Ahmed wrote:
> On Wed, Oct 5, 2022 at 7:04 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > Would you mind moving this to folio_referenced() directly? There is
> > already a comment and branch in there that IMO would extend quite
> > naturally to cover the new exception:
> >
> >         /*
> >          * If we are reclaiming on behalf of a cgroup, skip
> >          * counting on behalf of references from different
> >          * cgroups
> >          */
> >         if (memcg) {
> >                 rwc.invalid_vma = invalid_folio_referenced_vma;
> >         }
> >
> > That would keep the decision-making and doc in one place.
> 
> Hi Johannes,
> 
> Thanks for taking a look!
> 
> I originally wanted to make the change in folio_referenced(). My only
> concern was that it wouldn't be clear for people looking at reclaim
> code in mm/vmscan.c. It would appear as if we are passing in the
> target memcg to folio_referenced(), and only if you look within you
> would realize that sometimes it ignores the passed memcg.
> 
> It seemed to me that deciding whether we want to check references from
> one memcg or all of them is a reclaim decision, while
> folio_referenced() is just an rmap API that does what it is told: "if
> I am passed a memcg, I only look at references coming from this
> memcg". On the other hand, it looks like the doc has always lived in
> folio_referenced()/page_referenced(), so I might be overthinking this
> (I have been known to do this).

I agree it would be nicer to have this policy in vmscan.c. OTOH it's a
policy that applies to all folio_referenced() callers, and it's
fragile to require them to opt into it individually.

Vmscan is the only user of the function, so it's not the worst thing
to treat it as an extension of the reclaim code.

If it helps convince you, there is another, actually quite similar
reclaim policy already encoded in folio_referenced():

			if (ptep_clear_flush_young_notify(vma, address,
						pvmw.pte)) {
				/*
				 * Don't treat a reference through
				 * a sequentially read mapping as such.
				 * If the folio has been used in another mapping,
				 * we will catch it; if this other mapping is
				 * already gone, the unmap path will have set
				 * the referenced flag or activated the folio.
				 */
				if (likely(!(vma->vm_flags & VM_SEQ_READ)))
					referenced++;
			}
