From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 2/6] memcg: split part of memcg creation to
 css_online
Date: Fri, 25 Jan 2013 15:52:49 -0800
Message-ID: <20130125155249.402c40dd.akpm@linux-foundation.org>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com>
	<1358862461-18046-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358862461-18046-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Tue, 22 Jan 2013 17:47:37 +0400
Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> This patch is a preparatory work for later locking rework to get rid of
> big cgroup lock from memory controller code.

Is this complete?  From my reading, the patch is also a bugfix.  It
prevents stale tunable values from getting installed into new children?

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

That describes the problem, but not the fix.  Don't we need something
like "therefore move the propagation of tunables into the css_online
handler".

What remains unclear is how we prevent races during the operation of
the css_online handler.  Suppose mem_cgroup_css_online() is
mid-execution and userspace comes in and starts modifying the parent's
tunables?

