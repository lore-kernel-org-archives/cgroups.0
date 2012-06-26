From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Date: Tue, 26 Jun 2012 11:01:42 -0700
Message-ID: <20120626110142.b7cf6d7c.akpm@linux-foundation.org>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-7-git-send-email-glommer@parallels.com>
	<20120625161720.ae13ae90.akpm@linux-foundation.org>
	<4FE9CEBB.80108@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FE9CEBB.80108-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 26 Jun 2012 19:01:15 +0400 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> On 06/26/2012 03:17 AM, Andrew Morton wrote:
> >> +	memcg_uncharge_kmem(memcg, size);
> >> >+	mem_cgroup_put(memcg);
> >> >+}
> >> >+EXPORT_SYMBOL(__mem_cgroup_free_kmem_page);
> >> >  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> >> >
> >> >  #if defined(CONFIG_INET) && defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
> >> >@@ -5645,3 +5751,69 @@ static int __init enable_swap_account(char *s)
> >> >  __setup("swapaccount=", enable_swap_account);
> >> >
> >> >  #endif
> >> >+
> >> >+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> > gargh.  CONFIG_MEMCG_KMEM, please!
> >
> 
> Here too. I like it as much as you do.
> 
> But that is consistent with the rest of the file, and I'd rather have
> it this way.

There's not much point in being consistent with something which is so
unpleasant.  I'm on a little campaign to rename
CONFIG_CGROUP_MEM_RES_CTLR to CONFIG_MEMCG, only nobody has taken my
bait yet.  Be first!
