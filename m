From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in
 kmem_create_cache
Date: Mon, 24 Sep 2012 17:39:49 +0000
Message-ID: <00000139f95d0ed4-ead604f1-6566-452f-85e9-6ea2cf5a05fa-000000@email.amazonses.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com> <506015E7.8030900@parallels.com> <00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
 <50605500.5050606@parallels.com> <00000139f8836571-6ddc9d5b-1d5f-4542-92f9-ad11070e5b7d-000000@email.amazonses.com> <506063B8.70305@parallels.com> <00000139f890a302-980aee84-40b2-433f-8dbd-e7b1d219f00d-000000@email.amazonses.com> <506066E3.6050705@parallels.com>
 <CAOJsxLGFWQFNUUN3sDeB2sn0S-QM-6Ut_d02HjmF6mB5aMytoA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOJsxLGFWQFNUUN3sDeB2sn0S-QM-6Ut_d02HjmF6mB5aMytoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "<devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>" <devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "<linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, 24 Sep 2012, Pekka Enberg wrote:

> So Christoph is proposing that the new caches appear somewhere under
> the cgroups directory and /proc/slabinfo includes aggregated counts,
> right? I'm certainly OK with that.

Caches would appear either in cgroup/slabinfo (which would have the same
format as /proc/slabinfo) or in cgroup/slab/<slabname>/<fieldname>
(similar to /sys/kernel/slab/...)



