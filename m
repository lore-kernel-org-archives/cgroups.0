From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] fix bad behavior in use_hierarchy file
Date: Tue, 26 Jun 2012 09:56:53 +0200
Message-ID: <20120626075653.GD6713@tiehlicka.suse.cz>
References: <1340616061-1955-1-git-send-email-glommer@parallels.com>
 <20120625204908.GL3869@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120625204908.GL3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

[Adding Ying to CC - they are using hierarchies AFAIU in their workloads]

On Mon 25-06-12 13:49:08, Tejun Heo wrote:
[...]
> A bit of delta but is there any chance we can either deprecate
> .use_hierarhcy or at least make it global toggle instead of subtree
> thing?  

So what you are proposing is to have all subtrees of the root either
hierarchical or not, right?

> This seems needlessly complicated. :(

Toggle wouldn't help much I am afraid. We would still have to
distinguish (non)hierarchical cases. And I am not sure we can make
everything hierarchical easily. 
Most users (from my experience) ignored use_hierarchy for some reasons
and the end results might be really unexpected for them if they used
deeper subtrees (which might be needed due to combination with other
controller(s)).
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
