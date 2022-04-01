From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 15:49:19 +0200
Message-ID: <YkcC3z5ReeQ5vdg9@dhcp22.suse.cz>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648820963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fz7xTr9l8MJUB0+OMSqplN0cGq108K0n8faUQPVz55Q=;
        b=Yu6NjHMt7T3hEovFrCYTCNQDHNBMSEIGAC7vtE5HdIeJTjdGaWPWuvtWkga9n+f3kw4n0n
        PqfdHfFycik3IpsR4/PmGi/vQOQ0uItdxsWVm4bR3cwidS1vlHAXFuPREHmtv48DMB9I8Y
        5ch54gnY21D9R4t1J5IzGwMspvIfdEk=
Content-Disposition: inline
In-Reply-To: <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Thu 31-03-22 10:25:23, Roman Gushchin wrote:
> On Thu, Mar 31, 2022 at 08:41:51AM +0000, Yosry Ahmed wrote:
[...]
> > - A similar per-node interface can also be added to support proactive
> >   reclaim and reclaim-based demotion in systems without memcg.
> 
> Maybe an option to specify a timeout? That might simplify the userspace part.

What do you mean by timeout here? Isn't
timeout $N echo $RECLAIM > ....

enough?
-- 
Michal Hocko
SUSE Labs
