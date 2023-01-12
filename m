From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Track exported dma-buffers with memcg
Date: Wed, 11 Jan 2023 16:49:36 -0800
Message-ID: <CABdmKX0TAv=iRz0s+F6dVVX=xsK00BeUPkRM4bnsfemDAY9U4w__16610.871760507$1673484607$gmane$org@mail.gmail.com>
References: <20230109213809.418135-1-tjmercier@google.com> <CALvZod4ru7F38tAO-gM9ZFKaEhS0w3KqFbPwhwcTvgJs4xMUow@mail.gmail.com>
 <Y78+rfzXPq5XGs9O@phenom.ffwll.local>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hDrqeCy2isEAcEZutQc18fIgv9oWhVupwebw91lgye4=;
        b=qxxyHu+WDybsKdsOve3HdK7LpgzBN/3GZRqgrxvs9Q5W9Kzwd7Dzc9/jYzxkNuDrul
         kQkTCY47Z2auo0ah8YGi8N0fYkfJOF7YxzNDRGT2TVVKTxh3xTGn5tExmfv9+PHBUfjc
         yw/X/nMCu8FyYUb99VuG8LjTaud4O30po5zBH3LKaw5V6vBQRwOmH59u3sd47u/bsD8t
         wqFwxSQZsBtZNU5U8hrEp3462X5hXd5zeVSkG1FDkuO9G+kbmGLsdETBG2DaHv5igzc1
         rEShl5bXFHof6n5bFLnvY/qrSb9Wg1ns/Lu0eWyU8NcGpi2ojYMe7+hIT1ATndOFXF0A
         cgSA==
In-Reply-To: <Y78+rfzXPq5XGs9O-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: daniel.vetter-/w4YWyX8dFk@public.gmane.org

On Wed, Jan 11, 2023 at 2:56 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
>
> On Mon, Jan 09, 2023 at 04:18:12PM -0800, Shakeel Butt wrote:
> > Hi T.J.,
> >
> > On Mon, Jan 9, 2023 at 1:38 PM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > Based on discussions at LPC, this series adds a memory.stat counter for
> > > exported dmabufs. This counter allows us to continue tracking
> > > system-wide total exported buffer sizes which there is no longer any
> > > way to get without DMABUF_SYSFS_STATS, and adds a new capability to
> > > track per-cgroup exported buffer sizes. The total (root counter) is
> > > helpful for accounting in-kernel dmabuf use (by comparing with the sum
> > > of child nodes or with the sum of sizes of mapped buffers or FD
> > > references in procfs) in addition to helping identify driver memory
> > > leaks when in-kernel use continually increases over time. With
> > > per-application cgroups, the per-cgroup counter allows us to quickly
> > > see how much dma-buf memory an application has caused to be allocated.
> > > This avoids the need to read through all of procfs which can be a
> > > lengthy process, and causes the charge to "stick" to the allocating
> > > process/cgroup as long as the buffer is alive, regardless of how the
> > > buffer is shared (unless the charge is transferred).
> > >
> > > The first patch adds the counter to memcg. The next two patches allow
> > > the charge for a buffer to be transferred across cgroups which is
> > > necessary because of the way most dmabufs are allocated from a central
> > > process on Android. The fourth patch adds a SELinux hook to binder in
> > > order to control who is allowed to transfer buffer charges.
> > >
> > > [1] https://lore.kernel.org/all/20220617085702.4298-1-christian.koenig-5C7GfCeVMHo@public.gmane.org/
> > >
> >
> > I am a bit confused by the term "charge" used in this patch series.
> > From the patches, it seems like only a memcg stat is added and nothing
> > is charged to the memcg.
> >
> > This leads me to the question: Why add this stat in memcg if the
> > underlying memory is not charged to the memcg and if we don't really
> > want to limit the usage?
> >
> > I see two ways forward:
> >
> > 1. Instead of memcg, use bpf-rstat [1] infra to implement the
> > per-cgroup stat for dmabuf. (You may need an additional hook for the
> > stat transfer).
> >
> > 2. Charge the actual memory to the memcg. Since the size of dmabuf is
> > immutable across its lifetime, you will not need to do accounting at
> > page level and instead use something similar to the network memory
> > accounting interface/mechanism (or even more simple). However you
> > would need to handle the reclaim, OOM and charge context and failure
> > cases. However if you are not looking to limit the usage of dmabuf
> > then this option is an overkill.
>
> I think eventually, at least for other "account gpu stuff in cgroups" use
> case we do want to actually charge the memory.
>
Yes, I've been looking at this today.

> The problem is a bit that with gpu allocations reclaim is essentially "we
> pass the error to userspace and they get to sort the mess out". There are
> some exceptions (some gpu drivers to have shrinkers) would we need to make
> sure these shrinkers are tied into the cgroup stuff before we could enable
> charging for them?
>
I'm also not sure that we can depend on the dmabuf being backed at
export time 100% of the time? (They are for dmabuf heaps.) If not,
that'd make calling the existing memcg folio based functions a bit
difficult.

> Also note that at least from the gpu driver side this is all a huge
> endeavour, so if we can split up the steps as much as possible (and get
> something interim useable that doesn't break stuff ofc), that is
> practically need to make headway here. TJ has been trying out various
> approaches for quite some time now already :-/
> -Daniel
>
> > Please let me know if I misunderstood something.
> >
> > [1] https://lore.kernel.org/all/20220824233117.1312810-1-haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> >
> > thanks,
> > Shakeel
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
