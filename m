From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 2/6] memcg: split part of memcg creation to css_online
Date: Tue, 29 Jan 2013 09:12:35 +0900
Message-ID: <510713F3.9040207@jp.fujitsu.com>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com> <1358862461-18046-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358862461-18046-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2013/01/22 22:47), Glauber Costa wrote:
> This patch is a preparatory work for later locking rework to get rid of
> big cgroup lock from memory controller code.
> 
> The memory controller uses some tunables to adjust its operation. Those
> tunables are inherited from parent to children upon children
> intialization. For most of them, the value cannot be changed after the
> parent has a new children.
> 
> cgroup core splits initialization in two phases: css_alloc and css_online.
> After css_alloc, the memory allocation and basic initialization are
> done. But the new group is not yet visible anywhere, not even for cgroup
> core code. It is only somewhere between css_alloc and css_online that it
> is inserted into the internal children lists. Copying tunable values in
> css_alloc will lead to inconsistent values: the children will copy the
> old parent values, that can change between the copy and the moment in
> which the groups is linked to any data structure that can indicate the
> presence of children.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>


