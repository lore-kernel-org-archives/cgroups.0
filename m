From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: fix a deadlock due to incomplete patching of
 cpusets_enabled()
Date: Thu, 27 Jul 2017 12:51:12 -0700
Message-ID: <20170727125112.5c200880d7580525e24210e3@linux-foundation.org>
References: <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
        <20170727164608.12701-1-dmitriyz@waymo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170727164608.12701-1-dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dima Zavin <dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cliff Spradlin <cspradlin-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>

On Thu, 27 Jul 2017 09:46:08 -0700 Dima Zavin <dmitriyz-FA3Td6GO0iIAvxtiuMwx3w@public.gmane.org> wrote:

>  - Applied on top of v4.12 since one of the callers in page_alloc.c changed.
>    Still only tested on v4.9.36 and compile tested against v4.12.

That's a problem - this doesn't come close to applying on current
mainline.  I can fix that I guess, but the result should be tested
well.
