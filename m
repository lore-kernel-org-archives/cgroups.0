From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Tue, 4 Jun 2013 14:49:10 -0700
Message-ID: <20130604214910.GL14916@htj.dyndns.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
 <20130604214050.GP15576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4SXO8E1BMQSlOf8cdwM45w/88Dz3s3bKMKBKxjQLvqU=;
        b=BwKeyQbXRmY3eyPwC1fzZwpq/+MtZfOF82hKWHXObtgLQuP+O42b93z8FDsDKQ4XuC
         kTpQIpXd74maf3Bz412geui6wT3oNU4yDeJLsMTQMLhV1L1g+p9AD4QS9ekYOgktuqjb
         SMGBjleMwH17gL8d+Wdwhuzz4RWEmAbeUDJmwIn3A06URYL7xoMKe5msTZKycXzzKexu
         lRlXyMBjgbyccaNkYqUeif4mNQ5jn+QnTCnlml8ltSwpNBDkjGdTtKyGaB0+HDyi5L5f
         1o3OEbLxY8yx/v9YAAbffjVGpTDY9sCNrSmBoRt1yC5okrB4MDnU0f/iKm9vpieWYJRY
         iukg==
Content-Disposition: inline
In-Reply-To: <20130604214050.GP15576-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Johannes.

On Tue, Jun 04, 2013 at 05:40:50PM -0400, Johannes Weiner wrote:
> We might pin them indefinitely.  In a hierarchy with hundreds of
> groups that is short by 10M of memory, we only reclaim from a couple
> of groups before we stop and leave the iterator pointing somewhere in
> the hierarchy.  Until the next reclaimer comes along, which might be a
> split second later or three days later.
> 
> There is a reclaim iterator for every memcg (since every memcg
> represents a hierarchy), so we could pin a lot of csss for an
> indefinite amount of time.

As long as it's bound by the actual number of memcgs in the system and
dead cgroups don't pin any other resources, I don't think pinning css
and thus memcg struct itself is something we need to worry about.
Especially not at the cost of this weak referencing thing.  If the
large number of unused but pinned css's actually is a problem (which I
seriously doubt), we can implement a trivial timer based cache
expiration which can be extremely coarse - ie. each iterator just
keeps the last time stamp it was used and cleanup runs every ten mins
or whatever.  It'll be like twenty lines of completely obvious code.

Thanks.

-- 
tejun
