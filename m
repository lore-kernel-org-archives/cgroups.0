From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 01:44:56 -0700
Message-ID: <20130605084456.GA7990@mtj.dyndns.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
 <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605083628.GE15997@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XhV7pveF67DTv+nKCsKT+8CCEQW+IHirSDfMHmaVIHs=;
        b=NtXYU6nxoD6lxU/hTKcI3eCZ8j0EDcohqLApJhVqsI7OQ9HH5hLldXwWZWJwOfipLJ
         Qkc3mLsGA/YjRcvqZfg6Wj6gKbh/GDaXvGjWg0CB2oRLQtiKmjuk4UotwhQHzMWUv+J6
         cwVeTTiBQqzsBFhhwFuBMb2eVC6afKVxOu7l8Zyj+NApsDkvDTJa0M945BvbxvhRLpw6
         c9iAW92iU/aJg69FkByWl1+7mGPvAhqA47pDBn7BVqRcZeKf6I2SklzKbF2q6ysrzSNH
         rDyZ3HafTVpYifn0vViW9qnylxbSYZLxO33rbfsYEkYbTJzNNIjbCy60NHC8Aba2gj36
         k0mQ==
Content-Disposition: inline
In-Reply-To: <20130605083628.GE15997@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

Hey,

On Wed, Jun 05, 2013 at 10:36:28AM +0200, Michal Hocko wrote:
> > It's still bound, no?  Each live memcg can only keep limited number of
> > cgroups cached, right?
> 
> Assuming that they are cleaned up when the memcg is offlined then yes.

Oh yeah, that's just me being forgetful.  We definitely need to clean
it up on offlining.

> > Do you think that the number can actually grow harmful?  Would you be
> > kind enough to share some calculations with me?
> 
> Well, each intermediate node might pin up-to NR_NODES * NR_ZONES *
> NR_PRIORITY groups. You would need a big hierarchy to have chance to
> cache different groups so that it starts matter.

Yeah, NR_NODES can be pretty big.  I'm still not sure whether this
would be a problem in practice but yeah it can grow pretty big.

> And do what? css_try_get to find out whether the cached memcg is still

Hmmm? It can just look at the timestamp and if too old do

	cached = xchg(&iter->hint, NULL);
	if (cached)
		css_put(cached);

> alive. Sorry, I do not like it at all. I find it much better to clean up
> when the group is removed. Because doing things asynchronously just
> makes it more obscure. There is no reason to do such a thing on the
> background when we know _when_ to do the cleanup and that is definitely
> _not a hot path_.

Yeah, that's true.  I just wanna avoid the barrier dancing.  Only one
of the ancestors can cache a memcg, right?  Walking up the tree
scanning for cached ones and putting them should work?  Is that what
you were suggesting?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
