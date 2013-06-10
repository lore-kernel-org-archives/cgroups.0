From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Mon, 10 Jun 2013 16:13:58 -0700
Message-ID: <20130610231358.GD12461@mtj.dyndns.org>
References: <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
 <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
 <20130607005242.GB16160@htj.dyndns.org>
 <20130607073754.GA8117@dhcp22.suse.cz>
 <20130607232557.GL14781@mtj.dyndns.org>
 <20130610080208.GB5138@dhcp22.suse.cz>
 <20130610195426.GC12461@mtj.dyndns.org>
 <20130610204801.GA21003@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wzH2CE1Eer2dpmOtKr1vkJJTCBuba8uB66DKmPcQxQs=;
        b=NOWe0EUhSjJuUcoKV7Li0e9oNmk17CC8yXZ8+ZC4EIIpcNQ79KxLbtruPMElrbBiRn
         /wQLnyqoQz01yCbXMpv/u0FQdpPPgJcT5Y1D+qJL+WZO1BiIHXWvxm0Rqh1S7anxcha8
         TVHPwpMs/NBB0JYC1tToOHa+5J7H8LktQrmnqkreGPCTOx9EJlKJDR+1ubFPa3Fm89dv
         8u/l1W/GhO0zqZijYf5Ysm6d6sKLy7uPLNqHWuiFz8BAiBsBhech0l44R6mI+tE+qOwX
         L933VTb2qp+n9LYdoJloph3os0nQ5u0iiXRDBA4atmMy/EpCPRe5sx7oP5++MS43xvav
         lI1g==
Content-Disposition: inline
In-Reply-To: <20130610204801.GA21003-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hey,

On Mon, Jun 10, 2013 at 10:48:01PM +0200, Michal Hocko wrote:
> > Ooh, right, we don't need cleanup of the cached cursors on destruction
> > if we get this correct - especially if we make cursors point to the
> > next cgroup to visit as self is always the first one to visit. 
> 
> You would need to pin the next-to-visit memcg as well, so you need a
> cleanup on the removal.

But that'd be one of the descendants of the said cgroup and there can
no descendant left when the cgroup is being removed.  What am I
missing?

Thanks.

-- 
tejun
