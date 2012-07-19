From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH mmotm] mm, oom: reduce dependency on tasklist_lock: fix
Date: Thu, 19 Jul 2012 19:11:07 +0900
Message-ID: <5007DD3B.8030703@jp.fujitsu.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291406110.6040@chino.kir.corp.google.com> <20120713143206.GA4511@tiehlicka.suse.cz> <alpine.LSU.2.00.1207160039120.3936@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1207160039120.3936-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/07/16 16:42), Hugh Dickins wrote:
> Slab poisoning gave me a General Protection Fault on the
> 	atomic_dec(&__task_cred(p)->user->processes);
> line of release_task() called from wait_task_zombie(),
> every time my dd to USB testing generated a memcg OOM.
>
> oom_kill_process() now does the put_task_struct(),
> mem_cgroup_out_of_memory() should not repeat it.
>
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thank you for catching !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>



