From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 19:31:21 +0400
Message-ID: <4FE9D5C9.805@parallels.com>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com> <20120626141127.GA27816@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120626141127.GA27816-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 06/26/2012 06:11 PM, Johannes Weiner wrote:
> I find the warning message a bit terse.  Maybe include something like
> "restructure the cgroup directory structure to match your accounting
> requirements or complain to (linux-mm, cgroups list etc.)  if not
> possible"

How about:

WARN_ONCE(!parent_memcg && memcg->use_hierarchy,
    "Non-hierarchical memcg is considered for deprecation\n"
    "Please consider reorganizing your tree to work with hierarchical 
accounting\n"
    "If you have any reason not to, let us know at 
cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org\n");

