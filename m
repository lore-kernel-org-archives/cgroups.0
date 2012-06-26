From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 05/11] Add a __GFP_KMEMCG flag
Date: Tue, 26 Jun 2012 02:03:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206260202190.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252123230.26640@chino.kir.corp.google.com> <4FE95FF0.3000300@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=Av87wKL1iL7B3UgmPX+99oDQtSI3gWc9JdKKnhRfc5g=;
        b=XZT8/u19RaxURCPe9dGH+iORO8+yO+QDGKGjoyBAwlMij9SQp5Ak5tOQYVUJ0lkTno
         sLSsk+orY1XQxxWw5HcfCdbp3NPOgUE7Kp6/4VTL9FGLOzSh1PyOATqwKT0EzPIcUmN2
         iMU1GqKMqUilBNv+aYNzGdn4+jd17/bnkW1Sv7QpGrQSmlMGRxjC6gRKPQAzUAkMw1ni
         PgkbPcWRA9n+5U0QlG0TbtCzD4bgnzn6sbwExR6ujuLperRFOcpFXZ6bcy0RHgr1baf2
         OZLjvN+9QWWwID/AT6iuZ8Kz3pNTKxLNv8xMyHiD/U+eKl4/uQiGqfm78Be18wlzXxN4
         tH5g==
In-Reply-To: <4FE95FF0.3000300@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > >This flag is used to indicate to the callees that this allocation will be
> > > >serviced to the kernel. It is not supposed to be passed by the callers
> > > >of kmem_cache_alloc, but rather by the cache core itself.
> > > >
> > Not sure what "serviced to the kernel" means, does this mean that the
> > memory will not be accounted for to the root memcg?
> > 
> In this context, it means that is a kernel allocation, not a userspace one
> (but in process context, of course), *and* it is to be accounted a
> specific memcg.
> 

Ah, that makes sense.  I think it would help if this was included in the 
changelog as well as a specifying that it is accounted to current's memcg 
at the time of the allocation in a comment in the code.
