From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
Date: Wed, 27 Jun 2012 12:43:50 +0400
Message-ID: <4FEAC7C6.7030601@parallels.com>
References: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340756175-3420-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/27/2012 04:16 AM, Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> Changelog:
>
> V2 -> V1:
>
> * replace memory_cgroup_xxx by memcg_xxx
>
> Unify memcg functions to memcg_xxx.


This patch achieves nothing.
You're changing a couple of function names. Andrew stated goal was to 
change *all* function names from mem_cgroup_xxx to memcg_xxx, not just 
one or two.

This can be done mechanically by replacing occurrences of mem_cgroup_xxx 
with memcg_xxx, and verifying that your final result is correct by 
compiling the kernel with and without the combination of config options 
that matters here, plus a set of randconfigs - or anything like that.

Make sure you have Andrew's latest patch in your tree, that converts the 
config option names.

