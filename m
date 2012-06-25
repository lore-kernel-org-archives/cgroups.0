From: Wanlong Gao <gaowanlong-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 19:41:07 +0800
Message-ID: <4FE84E53.6070604@cn.fujitsu.com>
References: <1340622900-13034-1-git-send-email-liwp.linux@gmail.com>
Reply-To: gaowanlong-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340622900-13034-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/25/2012 07:15 PM, Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Changelog:
> 
> * drop memcg: move recent_rotated and recent_scanned informations patch
> * drop memcg: replace unsigned long by u64 to avoid overflow
> * not add Add LRU_ALL_UNEVICTABLE
> * drop memcg: cleanup all typo in memory cgroup, if it really need, I will resend in single patch
> * drop memcg: optimize memcg_get_hierarchical_limit 
> 
> Wanpeng Li (2):
> 
> memcg: cleanup useless LRU_ALL_EVICTABLE
> memcg: change mem_control_xxx to mem_cgroup_xxx

You'd be better to send one version of patch set in the same thread.

Thanks,
Wanlong Gao

> 
> ---
>  include/linux/mmzone.h |    1 -
>  mm/memcontrol.c        |   8 +++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 

