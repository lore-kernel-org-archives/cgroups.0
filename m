From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 cgroup/for-5.20] cgroup: Replace cgroup->ancestor_ids[]
 with ->ancestors[]
Date: Wed, 21 Sep 2022 21:05:20 -0700
Message-ID: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
References: <YuQvcCrcgNWbtndU@slm.duckdns.org> <YuRJ7uzKY5/fokH5@slm.duckdns.org>
 <YuRo2PLFH6wLgEkm@slm.duckdns.org> <Yvq33G14AU0cuswB@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yvq33G14AU0cuswB-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hi Tejun,

On Mon, Aug 15, 2022 at 2:17 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, Jul 29, 2022 at 01:10:16PM -1000, Tejun Heo wrote:
> > Every cgroup knows all its ancestors through its ->ancestor_ids[]. There's
> > no advantage to remembering the IDs instead of the pointers directly and
> > this makes the array useless for finding an actual ancestor cgroup forcing
> > cgroup_ancestor() to iteratively walk up the hierarchy instead. Let's
> > replace cgroup->ancestor_ids[] with ->ancestors[] and remove the walking-up
> > from cgroup_ancestor().
> >
> > While at it, improve comments around cgroup_root->cgrp_ancestor_storage.
> >
> > This patch shouldn't cause user-visible behavior differences.
> >
> > v2: Update cgroup_ancestor() to use ->ancestors[].
> >
> > v3: cgroup_root->cgrp_ancestor_storage's type is updated to match
> >     cgroup->ancestors[]. Better comments.
> >
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Acked-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Applied to cgroup/for-6.1.

I've realized that perf stat change needs backward compatibility.
Will send a fix soon.

Thanks,
Namhyung
