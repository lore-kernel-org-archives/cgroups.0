From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
Date: Wed, 27 Jun 2012 10:59:18 +0200
Message-ID: <20120627085917.GA5683@tiehlicka.suse.cz>
References: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
 <4FEAC7C6.7030601@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FEAC7C6.7030601-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 27-06-12 12:43:50, Glauber Costa wrote:
> On 06/27/2012 04:16 AM, Wanpeng Li wrote:
> >From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >
> >Changelog:
> >
> >V2 -> V1:
> >
> >* replace memory_cgroup_xxx by memcg_xxx
> >
> >Unify memcg functions to memcg_xxx.
> 
> 
> This patch achieves nothing.
> You're changing a couple of function names. Andrew stated goal was
> to change *all* function names from mem_cgroup_xxx to memcg_xxx, not
> just one or two.

No mass things now, please.
git grep mem_cgroup_ mm/ include/ | wc -l
863

This will be real pain for merging.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
