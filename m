From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 12:04:05 -0700
Message-ID: <YIB3JYHvnuOi4CIt@carbon.dhcp.thefacebook.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH8o5iIau85FaeLw@carbon.DHCP.thefacebook.com>
 <CALvZod7dXuFPeMv5NGu96uCosFpWY_Gy07iDsfSORCA0dT_zsA@mail.gmail.com>
 <YH+U4X8PKWZpOpAA@carbon.dhcp.thefacebook.com>
 <CALvZod7x=QR=p73BAxWPbFm+V8KFwYCcxNp-bOBvGaAttxjm7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pmCvH+b8TCN+8GDVAOpl+l0ohuWQx7qmmsTRAgatbgI=;
 b=TB2FjrRSEly2Cw08PBeYWPjQS9JaaW/mgnByv2FONQNU7CyEWTDtDVA+l1PaPq8dq80+
 ess1pQiBkvzOxSNsg+HZgXpeiq9CCIal5/47VCSKPSGV92sxTizkB75V+hC5Cg9/TcNv
 GC+CKD60VD3GdufYf1CX0kKTLWDoQOuv1lQ= 
Content-Disposition: inline
In-Reply-To: <CALvZod7x=QR=p73BAxWPbFm+V8KFwYCcxNp-bOBvGaAttxjm7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 06:26:37AM -0700, Shakeel Butt wrote:
> On Tue, Apr 20, 2021 at 7:58 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> [...]
> > >
> > > Michal has suggested ALLOC_OOM which is less risky.
> >
> > The problem is that even if you'll serve the oom daemon task with pages
> > from a reserve/custom pool, it doesn't guarantee anything, because the task
> > still can wait for a long time on some mutex, taken by another process,
> > throttled somewhere in the reclaim.
> 
> I am assuming here by mutex you are referring to locks which
> oom-killer might have to take to read metrics or any possible lock
> which oom-killer might have to take which some other process can take
> too.
> 
> Have you observed this situation happening with oomd on production?

I'm not aware of any oomd-specific issues. I'm not sure if they don't exist
at all, but so far it's wasn't a problem for us. Maybe it because you tend to
have less pagecache (as I understand), maybe it comes to specific oomd
policies/settings.

I know we had different pains with mmap_sem and atop and similar programs,
where reading process data stalled on mmap_sem for a long time.

Thanks!
