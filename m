From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 16:00:13 +0800
Message-ID: <Y1jpDfwBQId3GkJC@feng-clx>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666771230; x=1698307230;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ekxMYdeASdyQHgs8vqRYA2eL9dBearRTLTiGUWM3A6g=;
  b=TxV3QIOnhkk07JW6hn6qadSaweG0TSpZr93y3R00ftxj6Y2NLEn6ljQM
   vuJmccrAUFjQcdm8R32OSI310HPjW5pVV/diacpnDiB1Pk+U2FIzItlU/
   PITy55u37e46rFrP+CfRBY2vTyMz9ld9VXU3duIK3vxDYIk71FKmYh9zP
   KJAqNQAmc6kGR8xGT9rMYzYNWQ12BrO1L8u/Kged5TNgHZ2nxwbMIJMyz
   WWxmkVR8PY20fSrQ3rZpECzYwRW3HPOtoct6u9vn9Dg62hA1IDSHQ8MyD
   Y1XceRbpumaDY1ZXIErXHd0Q+fC3kYj7QXVLp8HJU9TyubS4nojKM/ukh
   A==;
Content-Disposition: inline
In-Reply-To: <dc453287-015d-fd1c-fe7f-6ee45772d6aa-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Hocko, Michal" <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Oct 26, 2022 at 03:49:48PM +0800, Aneesh Kumar K V wrote:
> On 10/26/22 1:13 PM, Feng Tang wrote:
> > In page reclaim path, memory could be demoted from faster memory tier
> > to slower memory tier. Currently, there is no check about cpuset's
> > memory policy, that even if the target demotion node is not allowd
> > by cpuset, the demotion will still happen, which breaks the cpuset
> > semantics.
> > 
> > So add cpuset policy check in the demotion path and skip demotion
> > if the demotion targets are not allowed by cpuset.
> > 
> 
> What about the vma policy or the task memory policy? Shouldn't we respect
> those memory policy restrictions while demoting the page? 
 
Good question! We have some basic patches to consider memory policy
in demotion path too, which are still under test, and will be posted
soon. And the basic idea is similar to this patch.

Thanks,
Feng

> -aneesh
