From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [rfc][patch 2/3] mm, oom: introduce helper function to process
 threads during scan
Date: Tue, 26 Jun 2012 12:22:33 +0900
Message-ID: <4FE92AF9.4050309@jp.fujitsu.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206251846450.24838@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206251846450.24838-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/06/26 10:47), David Rientjes wrote:
> This patch introduces a helper function to process each thread during the
> iteration over the tasklist.  A new return type, enum oom_scan_t, is
> defined to determine the future behavior of the iteration:
>
>   - OOM_SCAN_OK: continue scanning the thread and find its badness,
>
>   - OOM_SCAN_CONTINUE: do not consider this thread for oom kill, it's
>     ineligible,
>
>   - OOM_SCAN_ABORT: abort the iteration and return, or
>
>   - OOM_SCAN_SELECT: always select this thread with the highest badness
>     possible.
>
> There is no functional change with this patch.  This new helper function
> will be used in the next patch in the memory controller.
>
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I like this.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
