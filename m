From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Thu, 27 Aug 2020 21:40:22 -0400
Message-ID: <20200828014022.y5xju6weysqpzxd2@ca-dmjordan1.us.oracle.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
 <20200826011946.spknwjt44d2szrdo@ca-dmjordan1.us.oracle.com>
 <01ed6e45-3853-dcba-61cb-b429a49a7572@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EE+MmSN3lbKnbvXBOhbYoQLeslJjSSgBP3XNEkQXgRQ=;
 b=KaSLqjJzENC36uaJMTkyhzgDkJ2KfQYLgzCz13xV15ZAZNT3+Y0xu9qgW9r6Uaf/gAhP
 p/lDkVi37vjz1X3j21WaOz3VEhVh+uLP7I5oV7vvRDXfw/0shmbpmn74a0y+4tP4xjqU
 x3aRGOIZW84msVY3kmzWTdP6c+eog5WiX3mRnth7Bd2ounWU/NfOFYXYmevJ5GQm0nWt
 ddMGf7ZSwZU52zu6MbpKxP5wvtfEqQl+OK/U3aaOvsGYwAPWZyczKh+77vwYt67QWAO1
 TObjUYzMQoddfUC8VNxwIAWvWeZzTcpoza+wl4TrPOCUu9X/cC/mcl+RtAUKi2r372IV eA== 
Content-Disposition: inline
In-Reply-To: <01ed6e45-3853-dcba-61cb-b429a49a7572-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, Aug 26, 2020 at 04:59:28PM +0800, Alex Shi wrote:
> I clean up my testing and make it reproducable by a Dockerfile and a case patch which
> attached. 

Ok, I'll give that a shot once I've taken care of sysbench.

> >>> Even better would be a description of the problem you're having in production
> >>> with lru_lock.  We might be able to create at least a simulation of it to show
> >>> what the expected improvement of your real workload is.
> >>
> >> we are using thousands memcgs in a machine, but as a simulation, I guess above case
> >> could be helpful to show the problem.
> > 
> > Using thousands of memcgs to do what?  Any particulars about the type of
> > workload?  Surely it's more complicated than page cache reads :)
> 
> Yes, the workload are quit different on different business, some use cpu a
> lot, some use memory a lot, and some are may mixed.

That's pretty vague, but I don't suppose I could do much better describing what
all runs on our systems  :-/

I went back to your v1 post to see what motivated you originally, and you had
some results from aim9 but nothing about where this reared its head in the
first place.  How did you discover the bottleneck?  I'm just curious about how
lru_lock hurts in practice.

> > Neither kernel compile nor git checkout in the root cgroup changed much, just
> > 0.31% slower on elapsed time for the compile, so no significant regressions
> > there.  Now for sysbench again.

Still working on getting repeatable sysbench runs, no luck so far.  The numbers
have stayed fairly consistent with your series but vary a lot on the base
kernel, not sure why yet.
