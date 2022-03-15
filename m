From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v2 2/3] mm/memcg: __mem_cgroup_remove_exceeded could
 handle a !on-tree mz properly
Date: Tue, 15 Mar 2022 09:52:57 +0100
Message-ID: <YjBT6emPlZD1lg5z@dhcp22.suse.cz>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-2-richard.weiyang@gmail.com>
 <Yi8Qu/1V4H1M9qZV@dhcp22.suse.cz>
 <20220314225150.fhwny4yhxgjevwxx@master>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647334378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Wb88545i+4GjfuUzkTW0/rBBA3pVcbxmgsSI00NEnI=;
        b=DTOMEkvVV36MyxPlreZceP6EZiM5h4C63EtctwZ4uxDogkFL8tBVACTedPBu/dClCDmcIZ
        hCSKjspYoyWJDZSlu2YAP6haQbp8EaN73pjliwk5JJXNJ9Oa8EUfwuY2OT8CVvjmjPhczi
        pl9mPWWpMH0w+tdop26PYTgxzZIg4m4=
Content-Disposition: inline
In-Reply-To: <20220314225150.fhwny4yhxgjevwxx@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 14-03-22 22:51:50, Wei Yang wrote:
> On Mon, Mar 14, 2022 at 10:54:03AM +0100, Michal Hocko wrote:
> >On Sat 12-03-22 07:16:22, Wei Yang wrote:
> >> There is no tree operation if mz is not on-tree.
> >
> >This doesn't explain problem you are trying to solve nor does it make
> >much sense to me TBH.
> >
> 
> This just tries to make the code looks consistent.

I guess this is rather subjective. One could argue that the check is
more descriptive because it obviously removes the node from the tree
when it is on the tree.
-- 
Michal Hocko
SUSE Labs
