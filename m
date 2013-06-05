From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 15:20:21 -0700
Message-ID: <20130605222021.GL10693@mtj.dyndns.org>
References: <20130604205025.GG14916@htj.dyndns.org>
 <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605143949.GQ15576@cmpxchg.org>
 <20130605172212.GA10693@mtj.dyndns.org>
 <20130605194552.GI15721@cmpxchg.org>
 <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TwI0NvLiZwnoy7tD/VHL/0sbV+4S8aqv6qM87WcOLdc=;
        b=XJozBRSY+3ANDxbr8Xz7Jaxo2Bpct9JWLfe2wwTthvRwIEeJwA5LuPnpNVSnzAnf/1
         jtw/g/wnpEZNumcp15acl8op00jZZRSnfzsq/sDBMkSGiLL2q8cGZfbW6tuAr/llXTg9
         tjRiQo28zf3YK0j4S51+oDa1mhhwzQ1qcsIp63GPxvZFF04Wve+YmThV2UfzxutI2M06
         /T5QQ9jX9d0k+kJnUMnT896l395OTqGHVr5t8DqPrGkxzmlWx1A1Lcs9yt9NS26fcTKC
         XAj0H3Etn/+6ugnPI01l9LN2SordQLN4fw2R8V2GFUDmL2VNJqj7+aOIt18d9uhQUowO
         StnQ==
Content-Disposition: inline
In-Reply-To: <20130605211704.GJ15721@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

Yo,

On Wed, Jun 05, 2013 at 05:17:04PM -0400, Johannes Weiner wrote:
> That could be an advantage, yes.  But keep in mind that every
> destruction has to perform this invalidation operation against the
> global root_mem_cgroup's nr_node * nr_zone * nr_priority_levels
> iterators, so you can't muck around forever, while possibly holding a
> lock at this level.  It's not a hot path, but you don't want to turn
> it into one, either.

nr_node tends to be pretty low in most cases, so it shouldn't be a
problem there but yeah with high enough nodes and high enough rate of
cgroup destruction, I guess it could be an issue in extreme cases.

> The upshot for me is this: whether you do long-term pinning or greedy
> iterator invalidation, the cost of cgroup destruction increases.
> Either in terms of memory usage or in terms of compute time.  I would
> have loved to see something as simple as the long-term pinning work
> out in practice, because it truly would have been simpler.  But at
> this point, I don't really care much because the projected margins of
> reduction in complexity and increase of cost from your proposal are
> too small for me to feel strongly about one solution or the other, or
> go ahead and write the code.  I'll look at your patches, though ;-)

I don't know.  I've developed this deep-seated distrust of any code
which makes creative use of barriers and object lifetimes.  We get
them wrong too often, it makes other devs a lot more reluctant to
review and dive into the code, and it's hellish to track down when
something actually goes wrong.  I'd happily pay a bit of computation
or memory overhead for more conventional construct.  In extremely hot
paths, sure, we just bite and do it but I don't think this reaches
that level.

> Either way, I'll prepare the patch set that includes the barrier fix
> and a small cleanup to make the weak pointer management more
> palatable.  I'm still open to code proposals, so don't let it distract
> you, but we might as well make it a bit more readable in the meantime.

Sure thing.  We need to get it fixed for -stable anyway.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
