From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memcg-devel updated for v3.3
Date: Thu, 22 Mar 2012 10:11:47 +0100
Message-ID: <20120322091147.GB18665@tiehlicka.suse.cz>
References: <20120321094545.GA10450@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120321094545.GA10450-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed 21-03-12 10:45:45, Michal Hocko wrote:
[...]
> Hugh Dickins (15):
>       memcg-clear-pc-mem_cgorup-if-necessary-fix-2
>       memcg-clear-pc-mem_cgorup-if-necessary fix 3
>       memcg: fix page migration to reset_owner
>       memcg: replace MEM_CONT by MEM_RES_CTLR
>       memcg: replace mem and mem_cont stragglers
>       memcg: lru_size instead of MEM_CGROUP_ZSTAT
>       memcg: enum lru_list lru
>       memcg: remove redundant returns
>       idr: make idr_get_next() good for rcu_read_lock()
>       cgroup: revert ss_id_lock to spinlock
>       memcg: let css_get_next() rely upon rcu_read_lock()
>       memcg: remove PCG_CACHE page_cgroup flag fix
>       memcg: remove PCG_CACHE page_cgroup flag fix2
>       memcg: remove PCG_FILE_MAPPED fix cosmetic fix
>       memcg: fix GPF when cgroup removal races with last exit

I have just noticed I forgot about one fix.
Hugh Dickins (1):
      memcg: fix deadlock by avoiding stat lock when anon

pushed and sorry

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
