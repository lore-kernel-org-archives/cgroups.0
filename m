From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Mon, 7 Nov 2022 16:05:37 +0800
Message-ID: <Y2i8UbaOjGyqwJQ6@feng-clx>
References: <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
 <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
 <87fsf9k3yg.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1p5vaN1AWhpNWZx@dhcp22.suse.cz>
 <87bkpwkg24.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1+J7+1V1nJXF+3b@dhcp22.suse.cz>
 <Y1/XC+witPxFj04T@feng-clx>
 <Y1/cgrgdVP+KdYzf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667808538; x=1699344538;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Sc/4SmMJODGAVdDTinFVOCgagW93gfpE74RU20Dl3ag=;
  b=Uuf+gTvcBjM8+UUczAvWAx5nkC7+E7DY2/XAmdfloxz/wVM7dEcykiTw
   mYwIXTVgtE7vL7CCtH+m4+ah4ecn3ZVpyJ70xbpAySGKo7/BbJ9szAuGm
   40N/MDOTSa7RaGbWySdilyPaAFKk1QXxLlcguqHhHgVPhD96GkbkjmDsD
   orcCtNr/CJNHlA/aQosWRJN+MSmDtWLpcRASn7Z8H1Kc2squnp1o3yf8e
   gdrm3kgBlu8qKtmRzhDBQO0K8rqV4xrak9MgbmxSXh7ZgyFowmSMni2zM
   y8oaRvEqwvwmnIuahdSLRRe5xNBu+oZWhMlZ25Ai93Oc67rtGspdVQ8zD
   w==;
Content-Disposition: inline
In-Reply-To: <Y1/cgrgdVP+KdYzf-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, Oct 31, 2022 at 03:32:34PM +0100, Michal Hocko wrote:
> > > OK, then let's stop any complicated solution right here then. Let's
> > > start simple with a per-mm flag to disable demotion of an address space.
> > > Should there ever be a real demand for a more fine grained solution
> > > let's go further but I do not think we want a half baked solution
> > > without real usecases.
> > 
> > Yes, the concern about the high cost for mempolicy from you and Yang is
> > valid. 
> > 
> > How about the cpuset part?
> 
> Cpusets fall into the same bucket as per task mempolicies wrt costs. Geting a
> cpuset requires knowing all tasks associated with a page. Or am I just
> missing any magic? And no memcg->cpuset association is not a proper
> solution at all.

No, you are not missing anything. It's really difficult to find a
solution for all holes. And the patch is actually a best-efforts
approach, trying to cover cgroup v2 + memory controller enabled case,
which we think is a common user case for newer platforms with tiering
memory.
 
> > We've got bug reports from different channels
> > about using cpuset+docker to control meomry placement in memory tiering
> > system, leading to 2 commits solving them:
> > 
> > 2685027fca38 ("cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in
> > cpuset_init_smp()") 
> > https://lore.kernel.org/all/20220419020958.40419-1-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> > 
> > 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and
> > bail out early")
> > https://lore.kernel.org/all/1632481657-68112-1-git-send-email-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> > 
> > >From these bug reports, I think it's reasonable to say there are quite
> > some real world users using cpuset+docker+memory-tiering-system.
> 
> I don't think anybody is questioning existence of those usecases. The
> primary question is whether any of them really require any non-trivial
> (read nodemask aware) demotion policies. In other words do we know of
> cpuset policy setups where demotion fallbacks are (partially) excluded?

For cpuset numa memory binding, there are possible usercases:

* User wants cpuset to bind some important containers to faster
  memory tiers for better latency/performance (where simply disabling
  demotion should work, like your per-mm flag solution)

* User wants to bind to a set of physically closer nodes (like faster
  CPU+DRAM node and slower PMEM node). With initial demotion code,
  our HW will have 1:1 demotion/promotion pair for one DRAM node and
  its closer PMEM node, and user's binding can work fine. And there
  are many other types of memory tiering system from other vendors,
  like many CPU-less DRAM nodes in system, and Aneesh's patchset[1]
  created a more general tiering interface, where IIUC each tier has
  a nodemask, and an upper tier can demote to the whole lower tier,
  where the demotion path is N:N mapping. And for this, fine-tuning
  cpuset nodes binding needs this handling.

[1]. https://lore.kernel.org/lkml/20220818131042.113280-1-aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org/

Thanks,
Feng

> -- 
> Michal Hocko
> SUSE Labs
