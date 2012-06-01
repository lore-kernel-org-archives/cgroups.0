From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] rename MEM_CGROUP_CHARGE_TYPE_MAPPED as
 MEM_CGROUP_CHARGE_TYPE_ANON
Date: Fri, 1 Jun 2012 18:54:37 +0200
Message-ID: <20120601165437.GB1761@cmpxchg.org>
References: <4FC89D22.6020802@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FC89D22.6020802-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 01, 2012 at 07:44:50PM +0900, Kamezawa Hiroyuki wrote:
> Now, in memcg, 2 "MAPPED" enum/macro are found
>  MEM_CGROUP_CHARGE_TYPE_MAPPED
>  MEM_CGROUP_STAT_FILE_MAPPED
> 
> Their names looks similar to each other but the former is used for
> accounting anonymous memory, the latter is mapped-file.
> (I've received questions caused by this naming issue 3 times..)
> 
> This patch renames MEM_CGROUP_CHARGE_TYPE_MAPPED  as MEM_CGROUP_CHARGE_TYPE_ANON.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
