From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Date: Tue, 26 Jun 2012 11:08:05 -0700
Message-ID: <20120626180805.GQ3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-7-git-send-email-glommer@parallels.com>
 <20120625161720.ae13ae90.akpm@linux-foundation.org>
 <4FE9CEBB.80108@parallels.com>
 <20120626110142.b7cf6d7c.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=o1TDPAvWm66AGXw1dBR4f/Ldm73v9FaLs7Zg50ogPuM=;
        b=uTmR5vpOoqe1TsKbGm8xf387GwBYTPf1U/YvWsQzWd4VltUEeC202lnxmhy8WYEQkP
         c0uFg6apJRoV6k8f6R61OGZW3mZUsOdXG8SMUiqwBr1oOqUYY6UIBvAjEeeFbvwDvX0e
         /Kt6swL6GiCKz/if8lIlbu8lpNLzfj2I5mq/7O2p+ZW/xoPLsXpmMZhLSynJAa8id7Gv
         4eidercFue7itd4UJQJXvmHz6hwMhPmFKKgbD9iWKAec3rNCfUXGuILfsx3hyICeYH66
         XsROPqSCRe0YH9MYIsdF67thQ6YSk+Bif1SgjkTrdqZ1HA9jAGvlfbSaPAT7oDpBUljQ
         ntGg==
Content-Disposition: inline
In-Reply-To: <20120626110142.b7cf6d7c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, Jun 26, 2012 at 11:01:42AM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2012 19:01:15 +0400 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > On 06/26/2012 03:17 AM, Andrew Morton wrote:
> > >> +	memcg_uncharge_kmem(memcg, size);
> > >> >+	mem_cgroup_put(memcg);
> > >> >+}
> > >> >+EXPORT_SYMBOL(__mem_cgroup_free_kmem_page);
> > >> >  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> > >> >
> > >> >  #if defined(CONFIG_INET) && defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
> > >> >@@ -5645,3 +5751,69 @@ static int __init enable_swap_account(char *s)
> > >> >  __setup("swapaccount=", enable_swap_account);
> > >> >
> > >> >  #endif
> > >> >+
> > >> >+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> > > gargh.  CONFIG_MEMCG_KMEM, please!
> > >
> > 
> > Here too. I like it as much as you do.
> > 
> > But that is consistent with the rest of the file, and I'd rather have
> > it this way.
> 
> There's not much point in being consistent with something which is so
> unpleasant.  I'm on a little campaign to rename
> CONFIG_CGROUP_MEM_RES_CTLR to CONFIG_MEMCG, only nobody has taken my
> bait yet.  Be first!

+1.

Block cgroup recently did blkio / blkiocg / blkio_cgroup -> blkcg.
Join the cool crowd!  :P

-- 
tejun
