From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/3] rename MEM_CGROUP_STAT_SWAPOUT as
 MEM_CGROUP_STAT_SWAP
Date: Wed, 6 Jun 2012 09:18:09 +0200
Message-ID: <20120606071809.GD1761@cmpxchg.org>
References: <4FCD609E.8070704@jp.fujitsu.com>
 <4FCD61CA.6010209@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FCD61CA.6010209-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Tue, Jun 05, 2012 at 10:32:58AM +0900, Kamezawa Hiroyuki wrote:
> 
> MEM_CGROUP_STAT_SWAPOUT represents the usage of swap rather than
> the number of swap-out events. Rename it to be MEM_CGROUP_STAT_SWAP.
> 
> Changelog:
>  - use MEM_CGROUP_STAT_SWAP instead of MEM_CGROUP_STAT_NR_SWAP.
> 
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
