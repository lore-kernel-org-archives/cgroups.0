From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Expose misc.current on cgroup v2 root
Date: Wed, 21 Jun 2023 10:43:49 -1000
Message-ID: <ZJNhBSAn6qhOLRK0@slm.duckdns.org>
References: <20230613105929.269318-1-lei.zhou@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687380231; x=1689972231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+49NAgEqOiDg9ErZI4UsnhhSCDSXIrp5gIeiK/rsvQ=;
        b=Zsng8D4rHRjYU5Uyeat02PAAU5+4Y03qlINFGH1nNpCkpG3UffejdbXXtJgvDxhiL7
         xk9wATuj8Iksx0cxXhcjf1G/2GRSUam/mlT8cpz2d6A23ny4SErw/WFyiRmMikKUyfmR
         x25pFP2IuuEWh7bOrbB6TN7zX3Ie0iqWif42H71vy1uMCa4em3944tg8MjRTvNo3E+Dg
         jG+pvmvmEbAAb1APfmFo/7tlBp63pjsEBXN+E2d0T5t/5W6ZFDZfYZD4SgxnZadsGhEm
         sOHPRl3x9CXRxNt65S+HMuwyICQumqozNEro8ezqkNvyQHXnHHVLm7tCvelbKu+F+lOx
         qvSg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230613105929.269318-1-lei.zhou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LeiZhou-97 <lei.zhou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 13, 2023 at 06:59:29PM +0800, LeiZhou-97 wrote:
> Hello,
> 
> This patch is to expose misc.current on cgroup v2 root for tracking
> how much of the resource has been consumed in total on the system.
> 
> Most of the cloud infrastucture use cgroup to fetch the host
> information for scheduling purpose.
> 
> Currently, the misc controller can be used by Intel TDX HKIDs and
> AMD SEV ASIDs, which are both used for creating encrypted VMs.
> Intel TDX and AMD SEV are mostly be used by the cloud providers
> for providing confidential VMs.
> 
> In actual use of a server, these confidential VMs may be launched
> in different ways. For the cloud solution, there are kubvirt and
> coco (tracked by kubepods.slice); on host, they can be booted
> directly through qemu by end user (tracked by user.slice), etc.
> 
> In this complex environment, when wanting to know how many resource
> is used in total it has to iterate through all existing slices to
> get the value of each misc.current and add them up to calculate
> the total number of consumed keys.
> 
> So exposing misc.current to root cgroup tends to give much easier
> when calculates how much resource has been used in total, which
> helps to schedule and count resources for the cloud infrastucture.
> 
> Signed-off-by: LeiZhou-97 <lei.zhou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
