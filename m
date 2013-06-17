From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/2] slightly rework memcg cache id determination
Date: Mon, 17 Jun 2013 15:30:49 +0200
Message-ID: <20130617133049.GC5018@dhcp22.suse.cz>
References: <1371233076-936-1-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371233076-936-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

On Fri 14-06-13 14:04:34, Glauber Costa wrote:
> Michal,
> 
> Let me know if this is more acceptable to you. I didn't take your suggestion of
> having an id and idx functions, because I think this could potentially be even
> more confusing: in the sense that people would need to wonder a bit what is the
> difference between them.

Any clean up is better than nothing. I still think that split up and
making the 2 functions explicit would be better but I do not think this
is really that important. 

> Note please that we never use the id as an array index outside of memcg core.

Now but that doesn't prevent future abuse.

> So for memcg core, I have changed, in Patch 2, each direct use of idx as an
> index to include a VM_BUG_ON in case we would get an invalid index.

OK. If you had an _idx variant then you wouldn't need to add that
VM_BUG_ON at every single place where you use it as an index and do not
risk that future calls would forget about VM_BUG_ON.

> For the other cases, I have consolidated a bit the usage pattern around
> memcg_cache_id.  Now the tests are all pretty standardized.

OK, Great!
 
> Glauber Costa (2):
>   memcg: make cache index determination more robust
>   memcg: consolidate callers of memcg_cache_id
> 
>  mm/memcontrol.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> -- 
> 1.8.1.4
> 

-- 
Michal Hocko
SUSE Labs
