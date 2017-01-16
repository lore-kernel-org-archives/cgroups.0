From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: avoid spurious identity ->*attach()
 invocations
Date: Sun, 15 Jan 2017 19:04:30 -0500
Message-ID: <20170116000430.GG14446@mtj.duckdns.org>
References: <20161229221115.31995-1-tj@kernel.org>
 <58760D09.9010508@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kLpeH0A1fDeSv6L5IWFjN6FyG25B4GEghoEocrHRU1k=;
        b=Pcz4eAIXCVfLVhjmAMbvh8YzdWznVC8CIxtTkunEqh5Ij741h0zJNJWGa1gFA8kljT
         BxQ5HeO12VAbVW9WrJFAC9fol1jEiHxpDzsQG+ZEp0qoO9vaA9D7aFLNhnLnZxjnpoCh
         XaAtLbMB7GgiliazK3RZNe/LKOCcEawSKFlo1cHF3Vl4bwAn3HnFFqJKn74rq7VoJsAi
         4GVhV+Ngh7OVdRySlnyZX0Clw6ldPu0MYN4dn1DV1lvURn9Y5LKX+8YC6jP0hDQHswGK
         NLgIRVK9GvslAPBTapW1hpG7iTJSoREQ7VXvqze1VrUDn6wx84c2+eIPWx6W2UTnJ36r
         AUkQ==
Content-Disposition: inline
In-Reply-To: <58760D09.9010508-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 11, 2017 at 06:46:33PM +0800, Zefan Li wrote:
> On 2016/12/30 6:11, Tejun Heo wrote:
> > Hello,
> > 
> > On the v2 hierarchy, when controllers are enabled and disabled, other
> > ->*attach() callbacks of other controllers are called spuriously with
> > the same source and destination.  While this isn't critical, it's a
> > bit nasty and can lead to temporary double charging on certain
> > controllers.  This patchset fixes the issue.
> > 
> > This patchset contains the following three patches.
> > 
> >  0001-cgroup-cosmetic-update-to-cgroup_taskset_add.patch
> >  0002-cgroup-track-migration-context-in-cgroup_mgctx.patch
> >  0003-cgroup-call-subsys-attach-only-for-subsystems-which-.patch
> > 
> > 0001-0002 restructures migration context tracking so that extra state
> > can be tracked easily.  0003 fixes the spurious ->*attach()
> > invocations.
> > 
> > This patchset is also available in the following git branch.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-avoid-identity-attach
> > 
> > diffstat follows.
> > 
> >  kernel/cgroup/cgroup-internal.h |   69 +++++++++++++++--
> >  kernel/cgroup/cgroup-v1.c       |   10 +-
> >  kernel/cgroup/cgroup.c          |  161 ++++++++++++++++------------------------
> >  3 files changed, 135 insertions(+), 105 deletions(-)
> > 
> 
> Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.11.

Thanks.

-- 
tejun
