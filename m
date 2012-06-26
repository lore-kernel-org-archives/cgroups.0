From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 17:37:19 +0200
Message-ID: <20120626153719.GC27816@cmpxchg.org>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com>
 <20120626141127.GA27816@cmpxchg.org>
 <4FE9D5C9.805@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FE9D5C9.805-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, Jun 26, 2012 at 07:31:21PM +0400, Glauber Costa wrote:
> On 06/26/2012 06:11 PM, Johannes Weiner wrote:
> >I find the warning message a bit terse.  Maybe include something like
> >"restructure the cgroup directory structure to match your accounting
> >requirements or complain to (linux-mm, cgroups list etc.)  if not
> >possible"
> 
> How about:
> 
> WARN_ONCE(!parent_memcg && memcg->use_hierarchy,
>    "Non-hierarchical memcg is considered for deprecation\n"
>    "Please consider reorganizing your tree to work with hierarchical
> accounting\n"
>    "If you have any reason not to, let us know at
> cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org\n");

Sounds good to me, thanks!
