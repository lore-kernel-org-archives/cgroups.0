From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation counter
Date: Mon, 3 Feb 2020 15:16:21 -0800
Message-ID: <CAHS8izNq17U6i-RzHZ6tCOVQza_CGngJc0X2ZmqPHTH7y4kfdg@mail.gmail.com>
References: <20200115012651.228058-1-almasrymina@google.com> <alpine.DEB.2.21.2001291303230.175731@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gsc+LSdKFmfEHsLu/PX4b/f2W5uTYqD7V4ZzUh0Ir80=;
        b=PuWaEsvTmioKz64Q7uPVIOp/N9rPTq6akD7fqQtuRHWmOto7GXFjEFiiaZpfiF2Oxm
         iiczLvMdxA7gX9/mjBZ8ZtnwN2sHqrC4OBRhqMuKo/g8CFJUF+GRekmD2R+YG1Iv8ntP
         fvondbVEOz76kPzh9Un/lXTwJbkoWs/H0ReXrgjISGWRnNPuEoN9WDxUbtR5u29xfZkT
         oAskXk7P2RCKYytwQ3FeJKx5ywr9hbBBXemLv/eTKuTK7Wqc8IrNS1TLr78w9ZSqkxGE
         M2MJ58f6NMmbvet66LP8q6Ze6KZ4eCoAqPGksDNrj2NLgtH1atGYQqMO7zviLvsOv0oa
         pnWQ==
In-Reply-To: <alpine.DEB.2.21.2001291303230.175731-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> > Proposed Solution:
> > A new page counter named
> > 'hugetlb.xMB.reservation_[limit|usage|max_usage]_in_bytes'. This counter has
> > slightly different semantics than
> > 'hugetlb.xMB.[limit|usage|max_usage]_in_bytes':
> >
>
> Changelog looks like it needs to be updated with the new resv naming.
>

I updated to the rsvd naming, which you suggested earlier and Mike
agreed was better.

> > +
> >  static inline
> >  struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
> >  {
>
> Small nit: hugetlb_cgroup_get_counter(), to me, implies incrementing a
> reference count, perhaps a better name would be in order.  No strong
> preference.
>

Changed
> >       /* Add the events file */
> > -     cft = &h->cgroup_files_dfl[2];
> > +     cft = &h->cgroup_files_dfl[4];
> >       snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events", buf);
> >       cft->private = MEMFILE_PRIVATE(idx, 0);
> >       cft->seq_show = hugetlb_events_show;
>
> Any cleanup to __hugetlb_cgroup_file_dfl_init() and
> __hugetlb_cgroup_file_legacy_init() that is possible would be great in a
> follow-up patch :)
>

Will do!

> Other than that, this looks very straight forward.
>
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
