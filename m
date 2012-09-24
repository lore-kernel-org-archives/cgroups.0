From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in
 kmem_create_cache
Date: Mon, 24 Sep 2012 13:42:05 +0000
Message-ID: <00000139f8836571-6ddc9d5b-1d5f-4542-92f9-ad11070e5b7d-000000@email.amazonses.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com> <506015E7.8030900@parallels.com> <00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
 <50605500.5050606@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50605500.5050606-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "<devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>" <devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "<linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, 24 Sep 2012, Glauber Costa wrote:

> But that is orthogonal, isn't it? People will still expect to see it in
> the old slabinfo file.

The current scheme for memory statistics is

/proc/meminfo contains global counters

/sys/devices/system/node/nodeX/meminfo

contains node specific counters.

The cgroups directory already contains various files. Adding a slabinfo
file would make sense and it could be found easily.

The sysfs hierachy /sys/kernel/slab could also show up there as a "slab"
directory under which all the details of the various caches would be
available and tunable. Very much in sync with the way the cgroups
directories operate.

