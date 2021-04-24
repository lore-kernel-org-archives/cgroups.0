From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 0/1] memcg: enable accounting for pids in nested pid
 namespaces
Date: Sat, 24 Apr 2021 14:54:26 +0300
Message-ID: <163b816f-0655-1b4d-9c59-7878981be44e@virtuozzo.com>
References: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=29HYTylwYhZ3dYsWBx6VPp71dTboK0VaoGXB6Hg/UoQ=; b=uijsUv9twbDkh0f/HsZ
        s3sQlHADWWDS3ZGT4302e/GJiseFOrKGcqCclo1Eva/7ahcHfoRfv0GEuR3IhtmXv1sD8goSwNKXX
        EmJ+AOqquy+3jDiiZB+n7dNUxk7Hd0PS+CsAZQWj/hBNOUKa+dKc6m4G6MgIKCu1CW/vtLzb7kc=
In-Reply-To: <7b777e22-5b0d-7444-343d-92cbfae5f8b4-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

Pid was one the first kernel objects enabled for memcg accounting, see
5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")

init_pid_ns.pid_cachep marked by SLAB_ACCOUNT and we can expect that any new pids 
in the system are memcg-accounted.

Though recently I've noticed that it is wrong. nested pid namespaces creates 
own slab caches for pid objects, nested pids have increased size because contain 
id both for all parent and for own pid namespaces. The problem is that these slab
caches are _NOT_ marked by SLAB_ACCOUNT,as a result any pids allocated in 
nested pid namespaces are not memcg-accounted.

Pid struct in nested pid namespace consumes up to 500 bytes memory,
100000 such objects gives us up to ~50Mb unaccounted memory.
This allow container to exceed assigned memcg limits.

For me this issue lookslike bug and I would like to ask to push this fix 
both to upstream and to stable

Vasily Averin (1):
  memcg: enable accounting for pids in nested pid namespaces

 kernel/pid_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.3.1

