From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Thu, 21 May 2015 18:09:08 -0400
Message-ID: <20150521220908.GJ4914@htj.duckdns.org>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
 <20150521141225.GB14475@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2TI3Lq7U2+mdVSAjtpbrnPnVa8AOUCMKAViASDXTty8=;
        b=UtC/iDI2tyaV5IOkoZ6SL880YyajH+Ubc6Xup4Vj4x4Azytskbve/gTMEbWDvzWP4+
         BDVOB9Nol2gAjjNhA8RQVd1ilG/aK9yELooGM1X0BHsaFMIK24vlKIL7jBvQxPsc9DvX
         VwBvTpXeGpuZmXG2gAz5cGUOc1b+nGXwFoe9hP9RCUSDKNXInjTdaLQh+7F99ij0rJZo
         eBV/5/YIfUctO0jvQzwGUdO8E1PNDL2cZueylcVvZaQY0maI1XUHSmjFF7cdFJkKM6vl
         uEyBrzwk1F0TWuTfDqb4JDqAITh3/uENHMU4mzpAIavigA0x01Ux6QLjuUVI7CRKAQSx
         Gncw==
Content-Disposition: inline
In-Reply-To: <20150521141225.GB14475-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, May 21, 2015 at 04:12:26PM +0200, Michal Hocko wrote:
> On Mon 18-05-15 15:49:51, Tejun Heo wrote:
> > If move_charge flag is set, memcg tries to move memory charges to the
> > destnation css.  The current implementation migrates memory whenever
> > any thread of a process is migrated making the behavior somewhat
> > arbitrary.  Let's tie memory operations to the threadgroup leader so
> > that memory is migrated only when the leader is migrated.
> > 
> > While this is a behavior change, given the inherent fuziness, this
> > change is not too likely to be noticed and allows us to clearly define
> > who owns the memory (always the leader) and helps the planned atomic
> > multi-process migration.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> OK, I guess the discussion with Oleg confirmed that the patch is not
> really needed because mm_struct->owner check implies thread group
> leader. This should be sufficient for your purpose Tejun, right?

Hmmm... we still need to update so that it actually iterates leaders
to find the owner as first in taskset == leader assumption is going
away but yeah this patch in itself can go away.  I'll update the next
patch accordingly.

Thanks.

-- 
tejun
