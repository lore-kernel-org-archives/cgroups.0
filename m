From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: per-cgroup memory reclaim stats
Date: Tue, 16 May 2017 11:29:56 +0200
Message-ID: <20170516092956.GF2481@dhcp22.suse.cz>
References: <1494530183-30808-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494530183-30808-1-git-send-email-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 11-05-17 20:16:23, Roman Gushchin wrote:
> Track the following reclaim counters for every memory cgroup:
> PGREFILL, PGSCAN, PGSTEAL, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE and
> PGLAZYFREED.

yes, those are definitely useful. I have an old patch to add them as
well but never managed to clean it up and post...

> These values are exposed using the memory.stats interface of cgroup v2.

Is there any reason to not add them to v1? This should be rather trivial
after recent changes from Johannes.

> The meaning of each value is the same as for global counters,
> available using /proc/vmstat.
> 
> Also, for consistency, rename mem_cgroup_count_vm_event() to
> count_memcg_event_mm().
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

the patch itself looks good to me. I will have to double check it after
I am done with what I am doing currently and then will add my Acked-by
-- 
Michal Hocko
SUSE Labs
