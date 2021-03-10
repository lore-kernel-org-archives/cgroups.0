From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Wed, 10 Mar 2021 12:11:26 +0300
Message-ID: <60275aa1-082e-af13-b048-76c5a5cf18fb@virtuozzo.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
 <YEeM8AZczZt/irhR@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Li5frmD9SCXBj5Pm1ZvYCMOqZm8Q7Kkqx/voF2Vx6iQ=;
 b=I17qZ20ISZOauP9RVDm+uEgnL9vfpJjwdb4fr6cYPHdFB61sR44d9jM4M3t6XsMk55+LZ+1bOx0u2SU0M5b6SkT2bGfrhku6FnpmGAkJAKhnkvL/caIMMSdhP0/Irn0FFrPfkYl3TCbUGREWlULT/4FIr0wndmVQ6G//iFAd6/Q=
In-Reply-To: <YEeM8AZczZt/irhR-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 3/9/21 5:57 PM, Michal Hocko wrote:
> On Tue 09-03-21 11:03:48, Vasily Averin wrote:
>> in_interrupt() check in memcg_kmem_bypass() is incorrect because
>> it does not allow to account memory allocation called from task context
>> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
> 
> Is there any existing user in the tree? Or is this more of a preparatory
> patch for a later one which will need it? In other words, is this a bug
> fix or a preparatory work.

struct fib6_node objects are allocated by this way
net/ipv6/route.c::__ip6_ins_rt()
...        write_lock_bh(&table->tb6_lock);
        err = fib6_add(&table->tb6_root, rt, info, mxc);
        write_unlock_bh(&table->tb6_lock);

I spend some time to understand why properly entries from properly configured cache
was not accounted to container's memcg.

Thank you,
	Vasily Averin
