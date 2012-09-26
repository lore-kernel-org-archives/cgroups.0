From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 09:36:48 -0700
Message-ID: <20120926163648.GO16296@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CYbQUDFNrG5WRz3VeuXBS2fEOq3veC2oE7BtqcsH/j8=;
        b=b9Ci/g+QEWi55Rk6vaEb3Qk8oVZSfcC7hSfnjuFngBTz2QK/5R/ekq0A3DLGEPwIQ5
         1W55lS9o6eddG5IBKSDbQ/xJNgxNwRxPqAYOQRI5tp5AIaynHWddV5NSX5mKZPX3yThB
         pob81//oto63i0INEvDWUKbJppgkvYqxfRDBlZUs0Z3+WQ6kB9cpud/ZAbusBQ3k6W1g
         QNKrqbNbWVrswure/TrpI0ZMCtwu5y3ki15xqpIievSJwFi7qvg0HnwDMlg0VvE63+Xa
         QQCovrBhwrb77Oix9E84F2e2xbHnZHJXhQE2MI626C/in2k6DDKcJPv4MOjXhToECE6d
         5jrA==
Content-Disposition: inline
In-Reply-To: <20120926140347.GD15801-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Michal, Glauber.

On Wed, Sep 26, 2012 at 04:03:47PM +0200, Michal Hocko wrote:
> Haven't we already discussed that a new memcg should inherit kmem_accounted
> from its parent for use_hierarchy?
> Say we have
> root
> |
> A (kmem_accounted = 1, use_hierachy = 1)
>  \
>   B (kmem_accounted = 0)
>    \
>     C (kmem_accounted = 1)
> 
> B find's itself in an awkward situation becuase it doesn't want to
> account u+k but it ends up doing so becuase C.

Do we really want this level of flexibility?  What's wrong with a
global switch at the root?  I'm not even sure we want this to be
optional at all.  The only reason I can think of is that it might
screw up some configurations in use which are carefully crafted to
suit userland-only usage but for that isn't what we need a transition
plan rather than another ultra flexible config option that not many
really understand the implication of?

In the same vein, do we really need both .kmem_accounted and config
option?  If someone is turning on MEMCG, just include kmem accounting.

Thanks.

-- 
tejun
