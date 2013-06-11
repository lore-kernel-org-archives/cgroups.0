From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Tue, 11 Jun 2013 00:44:04 -0700
Message-ID: <20130611074404.GE22530@mtj.dyndns.org>
References: <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
 <20130607005242.GB16160@htj.dyndns.org>
 <20130607073754.GA8117@dhcp22.suse.cz>
 <20130607232557.GL14781@mtj.dyndns.org>
 <20130610080208.GB5138@dhcp22.suse.cz>
 <20130610195426.GC12461@mtj.dyndns.org>
 <20130610204801.GA21003@dhcp22.suse.cz>
 <20130610231358.GD12461@mtj.dyndns.org>
 <20130611072743.GB24031@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9xpc8jq2HGlRJqxWZwcBzRbZrIDgBQT26/r74DxJ1VQ=;
        b=LWAWOVKX+0MZpVAmxhqEl8HqrTu2Wks1tdHoXpIAn63iRIf0by2svbdkxDZmgqEI3C
         4GPWvUaT4BUp6FM50BbsXSYx+Jv91qGtoBn9bJ6rY332FzGF84MNMaE/x48aUeYIMTcs
         iJu2m8mIgOPb2HxM7Dh0S3y8uVx7NCRtkD0dYIuXIGs9hOOkulqsmy+DbzH5cV6PYMw7
         /+y8e8ymmmvP4u65g9lFAvpYo7aTwMs17sAkfb/h2LpWdF++Jp82ArirGs36BXVbLWqK
         aNGkrZ/GzIuX/0QCjKQhvWPDTK9Kv2lxn9RjLw6KFJviKhLD8KYGx96NrKzceq3/DD+E
         ifvg==
Content-Disposition: inline
In-Reply-To: <20130611072743.GB24031@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On Tue, Jun 11, 2013 at 09:27:43AM +0200, Michal Hocko wrote:
>           .
>           .
>           .
>           A (cached=E)
>          /|\____________
>         / |             \
> 	 B  D (cached=E)   F<
> 	/   |               \
>      C<   E                G
>           ^
> 	 removed
> 
> * D level cache - nobody left for either approach approach
> * A level is 
> 	- F for next-to-visit
> 	- C for last_visited
> 
> You have to get up the hierarchy and handle root cgroup as a special
> case for !root->use_hierarchy. Once you have non-NULL new cache the it
> can be propagated without a new search (which I haven't realized when
> working on this approach the last time - not that it would safe some
> code in the end).
> 
> Makes sense?

I don't think we're talking about the same thing.  I wasn't talking
about skipping walking up the hierarchy (differently depending on
use_hierarchy of course) when E is removed.  I was talking about
skipped cleaning E's cache when removing E as it's guaranteed to be
empty by then.  The difference between caching the last and next one
is that if we put the last one in the cache, E's cache could be
pointing to itself and needs to be scanned.

Not a big difference either way but if you combine that with the need
for special rewinding which will basically come down to traversing the
sibling list again, pointing to the next entry is just easier.

Anyways, I think we're getting too deep into details but one more
thing, what do you mean by "non-NULL new cache"?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
