From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 10:40:49 +0100
Message-ID: <YEiUIf0old+AZssa@dhcp22.suse.cz>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <YEeM8AZczZt/irhR@dhcp22.suse.cz>
 <60275aa1-082e-af13-b048-76c5a5cf18fb@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615369249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zJQKktVYa3wa84qF+w5uVWbmtWsIJNjcXAKfh49Oeg0=;
        b=lix1ZQuYOb0cawiXu49zLpcCqr6ijVItGWAnwRq3PyFfThUwOVpiUwq6eEW+kNg4T9R4so
        BHKv13KSMBBciefgN1EaapJx5D07GRbt4KEcM5FfnYALh/CsujRgwPWSv+iGbf9D9au+pd
        tCxUlh2ZwnkogyNAYGm/5yBDTwMf+7A=
Content-Disposition: inline
In-Reply-To: <60275aa1-082e-af13-b048-76c5a5cf18fb-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 10-03-21 12:11:26, Vasily Averin wrote:
> On 3/9/21 5:57 PM, Michal Hocko wrote:
> > On Tue 09-03-21 11:03:48, Vasily Averin wrote:
> >> in_interrupt() check in memcg_kmem_bypass() is incorrect because
> >> it does not allow to account memory allocation called from task context
> >> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
> > 
> > Is there any existing user in the tree? Or is this more of a preparatory
> > patch for a later one which will need it? In other words, is this a bug
> > fix or a preparatory work.
> 
> struct fib6_node objects are allocated by this way
> net/ipv6/route.c::__ip6_ins_rt()
> ...        write_lock_bh(&table->tb6_lock);
>         err = fib6_add(&table->tb6_root, rt, info, mxc);
>         write_unlock_bh(&table->tb6_lock);
> 
> I spend some time to understand why properly entries from properly configured cache
> was not accounted to container's memcg.

OK, that is a valuable information. If there are no other users
currently then I would recommend squashing this patch into the one which
introduces accounting for fib6_node cache (patch 2, IIUC).
-- 
Michal Hocko
SUSE Labs
