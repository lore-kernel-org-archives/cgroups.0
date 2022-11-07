From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Mon, 7 Nov 2022 09:17:36 +0100
Message-ID: <Y2i/IMs/KWpppQtS@dhcp22.suse.cz>
References: <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
 <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
 <87fsf9k3yg.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1p5vaN1AWhpNWZx@dhcp22.suse.cz>
 <87bkpwkg24.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Y1+J7+1V1nJXF+3b@dhcp22.suse.cz>
 <Y1/XC+witPxFj04T@feng-clx>
 <Y1/cgrgdVP+KdYzf@dhcp22.suse.cz>
 <Y2i8UbaOjGyqwJQ6@feng-clx>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667809057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yhWHJ2J3mSTc7a4l8DLtwjtj9XcPdTj9FcFSpoWpr2c=;
        b=t8ZU6zp1GfpIYKpTERHBEmxxZa1ZI6WSDt+HtNFMqEM9YuuAhN7Wf8M0WRha9BmexJQ1Hx
        BeGVslsxal3j4CZgzDRp2e2bavLZV1suFz3jlmJaCyOpqMA6D0iyMIxDeAtZLOiFCJIZKX
        37ufVDxAE4xTtaolcw6E4ze1Q1exgJI=
Content-Disposition: inline
In-Reply-To: <Y2i8UbaOjGyqwJQ6@feng-clx>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon 07-11-22 16:05:37, Feng Tang wrote:
> On Mon, Oct 31, 2022 at 03:32:34PM +0100, Michal Hocko wrote:
> > > > OK, then let's stop any complicated solution right here then. Let's
> > > > start simple with a per-mm flag to disable demotion of an address space.
> > > > Should there ever be a real demand for a more fine grained solution
> > > > let's go further but I do not think we want a half baked solution
> > > > without real usecases.
> > > 
> > > Yes, the concern about the high cost for mempolicy from you and Yang is
> > > valid. 
> > > 
> > > How about the cpuset part?
> > 
> > Cpusets fall into the same bucket as per task mempolicies wrt costs. Geting a
> > cpuset requires knowing all tasks associated with a page. Or am I just
> > missing any magic? And no memcg->cpuset association is not a proper
> > solution at all.
> 
> No, you are not missing anything. It's really difficult to find a
> solution for all holes. And the patch is actually a best-efforts
> approach, trying to cover cgroup v2 + memory controller enabled case,
> which we think is a common user case for newer platforms with tiering
> memory.

Best effort is OK but it shouldn't create an unexpected behavior and
this approach does that.

I thought I have already explained that. But let me be more
explicit this time.  Please have a look at how controllers can be
enabled/disabled at different levels of the hierarchy. Unless memcg
grows a hard dependency on another controller (as it does with the blk
io controller) then this approach can point to a wrong cpuset. See my
point?

Really, solution for this is not going to be cheap and also I am not
sure all the hessles is really worth it until there is a clear usecase
in sight.
-- 
Michal Hocko
SUSE Labs
