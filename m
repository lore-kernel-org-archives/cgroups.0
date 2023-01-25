From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] memcg: Track exported dma-buffers
Date: Wed, 25 Jan 2023 12:04:22 -0800
Message-ID: <CABdmKX09S3bYzX+xBkhfkFULk2BtzS11RhzrvWv94j+cHSezPA@mail.gmail.com>
References: <20230123191728.2928839-1-tjmercier@google.com>
 <20230123191728.2928839-2-tjmercier@google.com> <Y8/ybgp2FW+e3bjc@dhcp22.suse.cz>
 <20230124194628.d44rtcfsv23fndxw@google.com> <Y9EX+usSpAjZ/8LS@dhcp22.suse.cz>
 <347560bc-d06a-92b7-8003-133d2b8af2df@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g4Z/KcaPjXn69aR2a4PJBdKAtPbyRD5H10aHIp7bfig=;
        b=VpJEl0p6UP5EG1JMEX/1nNDeCM09VjlGrBKHAR7qp8btAZslvIHihzbIA13ZtSxRAX
         WuaIPCP6sD8HlMb2hrns/dRfH/bmdnOgQ1sZN7uFKnUUUHnpoUxAt2UMRTWNojIyGG+T
         xmmR6IIViD6PvKYlzJaRkmylrswdZcEbNZHOZshGQ3AM45NWyRTN8XsSPHOhfmTx455a
         7oYN+oJVapBqJHx8tefnhKROowuFVoyO/I5YRWl6bA8nfAFNyLbo+Do+EwhPB4Xq1WMs
         +8XS3GU5BQ8dabju+VBOqRec/CdS3xVciRlQDrZuCRpyCm9w6ZbThEuVRa01YkyD0AVp
         SvUw==
In-Reply-To: <347560bc-d06a-92b7-8003-133d2b8af2df-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.>

On Wed, Jan 25, 2023 at 9:31 AM Tvrtko Ursulin
<tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
>
> Hi,
>
> On 25/01/2023 11:52, Michal Hocko wrote:
> > On Tue 24-01-23 19:46:28, Shakeel Butt wrote:
> >> On Tue, Jan 24, 2023 at 03:59:58PM +0100, Michal Hocko wrote:
> >>> On Mon 23-01-23 19:17:23, T.J. Mercier wrote:
> >>>> When a buffer is exported to userspace, use memcg to attribute the
> >>>> buffer to the allocating cgroup until all buffer references are
> >>>> released.
> >>>
> >>> Is there any reason why this memory cannot be charged during the
> >>> allocation (__GFP_ACCOUNT used)?
> >>> Also you do charge and account the memory but underlying pages do not
> >>> know about their memcg (this is normally done with commit_charge for
> >>> user mapped pages). This would become a problem if the memory is
> >>> migrated for example.
> >>
> >> I don't think this is movable memory.
> >>
> >>> This also means that you have to maintain memcg
> >>> reference outside of the memcg proper which is not really nice either.
> >>> This mimicks tcp kmem limit implementation which I really have to say I
> >>> am not a great fan of and this pattern shouldn't be coppied.
> >>>
> >>
> >> I think we should keep the discussion on technical merits instead of
> >> personal perference. To me using skmem like interface is totally fine
> >> but the pros/cons need to be very explicit and the clear reasons to
> >> select that option should be included.
> >
> > I do agree with that. I didn't want sound to be personal wrt tcp kmem
> > accounting but the overall code maintenance cost is higher because
> > of how tcp take on accounting differs from anything else in the memcg
> > proper. I would prefer to not grow another example like that.
> >
> >> To me there are two options:
> >>
> >> 1. Using skmem like interface as this patch series:
> >>
> >> The main pros of this option is that it is very simple. Let me list down
> >> the cons of this approach:
> >>
> >> a. There is time window between the actual memory allocation/free and
> >> the charge and uncharge and [un]charge happen when the whole memory is
> >> allocated or freed. I think for the charge path that might not be a big
> >> issue but on the uncharge, this can cause issues. The application and
> >> the potential shrinkers have freed some of this dmabuf memory but until
> >> the whole dmabuf is freed, the memcg uncharge will not happen. This can
> >> consequences on reclaim and oom behavior of the application.
> >>
> >> b. Due to the usage model i.e. a central daemon allocating the dmabuf
> >> memory upfront, there is a requirement to have a memcg charge transfer
> >> functionality to transfer the charge from the central daemon to the
> >> client applications. This does introduce complexity and avenues of weird
> >> reclaim and oom behavior.
> >>
> >>
> >> 2. Allocate and charge the memory on page fault by actual user
> >>
> >> In this approach, the memory is not allocated upfront by the central
> >> daemon but rather on the page fault by the client application and the
> >> memcg charge happen at the same time.
> >>
> >> The only cons I can think of is this approach is more involved and may
> >> need some clever tricks to track the page on the free patch i.e. we to
> >> decrement the dmabuf memcg stat on free path. Maybe a page flag.
> >>
> >> The pros of this approach is there is no need have a charge transfer
> >> functionality and the charge/uncharge being closely tied to the actual
> >> memory allocation and free.
> >>
> >> Personally I would prefer the second approach but I don't want to just
> >> block this work if the dmabuf folks are ok with the cons mentioned of
> >> the first approach.
> >
> > I am not familiar with dmabuf internals to judge complexity on their end
> > but I fully agree that charge-when-used is much more easier to reason
> > about and it should have less subtle surprises.
>
> Disclaimer that I don't seem to see patches 3&4 on dri-devel so maybe I
> am missing something, but in principle yes, I agree that the 2nd option
> (charge the user, not exporter) should be preferred. Thing being that at
> export time there may not be any backing store allocated, plus if the
> series is restricting the charge transfer to just Android clients then
> it seems it has the potential to miss many other use cases. At least
> needs to outline a description on how the feature will be useful outside
> Android.
>
There is no restriction like that. It's available to anybody who wants
to call dma_buf_charge_transfer if they actually have a need for that,
which I don't really expect to be common since most users/owners of
the buffers will be the ones causing the export in the first place.
It's just not like that on Android with the extra allocator process in
the middle most of the time.

> Also stepping back for a moment - is a new memory category really
> needed, versus perhaps attempting to charge the actual backing store
> memory to the correct client? (There might have been many past
> discussions on this so it's okay to point me towards something in the
> archives.)
>
Well the dmabuf counter for the stat file is really just a subcategory
of memory that is charged. Its existence is not related to getting the
charge attributed to the right process/cgroup. We do want to know how
much of the memory attributed to a process is for dmabufs, which is
the main point of this series.

> Regards,
>
> Tvrtko
