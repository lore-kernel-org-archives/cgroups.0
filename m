From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Mon, 10 Jun 2013 22:48:01 +0200
Message-ID: <20130610204801.GA21003@dhcp22.suse.cz>
References: <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
 <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
 <20130607005242.GB16160@htj.dyndns.org>
 <20130607073754.GA8117@dhcp22.suse.cz>
 <20130607232557.GL14781@mtj.dyndns.org>
 <20130610080208.GB5138@dhcp22.suse.cz>
 <20130610195426.GC12461@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bOWskGk2Kbxgm78yzCaikEZI8GzxtvF6r/aVxl1KcZs=;
        b=m7Oh/m6TS02QC00THSGFqnN+z2eTbUiD5Bpzu/RDeToLZwB/rDU12OXNj4rFDp0G7D
         Ju/5mrm+fCBUy7p/b73/M0vT58GyrOIdA46mnzpx4HEpGbUB7e+v+WNm5vdW3+XXTg8x
         egJfUzIqgM6ATgG8laU1cR74YRDIW+fsfYUkMzKGX3ddQHssJ7XrcioNYoS1wsezj2Bu
         A+95aDauKhwNMsQOqgqx4M1ldlVMgcjMBf+cmkyuFQ43UjqvfV/BISDsCaQ1cvevoxMm
         4aFbQeI/yz1VFI+uE8umM+ixBRI0k/j86OWwBy4akbaoDihxWgisrCAIhl+xPKg9yn9E
         tSyQ==
Content-Disposition: inline
In-Reply-To: <20130610195426.GC12461@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On Mon 10-06-13 12:54:26, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Jun 10, 2013 at 10:02:08AM +0200, Michal Hocko wrote:
> > Sure a next visit on the same root subtree (same node, zone and prio)
> > would css_put it but what if that root goes away itself. Still fixable,
> > if every group checks its own cached iters and css_put everybody but
> > that is even uglier. So doing the up-the-hierarchy cleanup in RCU
> > callback is much easier.
> 
> Ooh, right, we don't need cleanup of the cached cursors on destruction
> if we get this correct - especially if we make cursors point to the
> next cgroup to visit as self is always the first one to visit. 

You would need to pin the next-to-visit memcg as well, so you need a
cleanup on the removal.

> Yeah, if we can do away with that, doing that way is definitely
> better.

The only advantage I can see from next-to-visit caching is that the
destruction path can reuse __mem_cgroup_iter_next unlike last_visited
which would need to develop a code to get the previous member. Maybe it
is worth a try.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
