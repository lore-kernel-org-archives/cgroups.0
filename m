From: Aaron Lu <aaron.lwe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Wed, 9 Sep 2020 10:44:32 +0800
Message-ID: <20200909024432.GA9736@desktop-ziqianlu>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
 <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
 <20200826011946.spknwjt44d2szrdo@ca-dmjordan1.us.oracle.com>
 <01ed6e45-3853-dcba-61cb-b429a49a7572@linux.alibaba.com>
 <20200828014022.y5xju6weysqpzxd2@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ZdmUVaaik0Cd28h3Zbe2m43Ssgf1GR/sAhP0i4ZEkE=;
        b=AnELXMNtpHPPvFIglx8F3SVHWevil/Qj/z/vpbBRAvIn5Z+8QZvRRdtDrnet3+bsLM
         5mCLGxCFpyFhqz95Hx4U4HTvz5lQjzyhOuSdSEsfTMrNQimYLdlqYew1C5g66rd5/su2
         CNH0k30TqQpa5zqkDQirUnbrGnTL0LJeLOdkLsfi2Z7BI4YZu/TDAbvV38KLLXcrhNH6
         zfotW278dwua1xutDu6WQ4z4I55XsYNz9vIlb2ToKsKtYIXaTYjXBj6Dr7qzfXmWutZN
         ZY89N3EA5hpaqooLt1MKRRrIEkQhWYLwuREAdK6vuhA2hQvMXg+kaJBSOiAgPVm5ebo/
         hrTA==
Content-Disposition: inline
In-Reply-To: <20200828014022.y5xju6weysqpzxd2-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Aug 27, 2020 at 09:40:22PM -0400, Daniel Jordan wrote:
> I went back to your v1 post to see what motivated you originally, and you had
> some results from aim9 but nothing about where this reared its head in the
> first place.  How did you discover the bottleneck?  I'm just curious about how
> lru_lock hurts in practice.

I think making lru_lock per-memcg helps in colocated environment: some
workloads are of high priority while some workloads are of low priority.

For these low priority workloads, we may even want to use some swap for
it to save memory and this can cause frequent alloc/reclaim, depending
on its workingset etc. and these alloc/reclaim need to hold the global
lru lock and zone lock. And then when the high priority workloads do
page fault, their performance can be adversely affected and that is not
acceptible since these high priority workloads normally have strict SLA
requirement.
