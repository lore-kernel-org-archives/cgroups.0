From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Tue, 28 May 2019 20:39:59 +0300
Message-ID: <20190528173959.h4hq55b3ajlfpjrk@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-6-guro@fb.com>
 <20190528170828.zrkvcdsj3d3jzzzo@esperanza>
 <96b8a923-49e4-f13e-b1e3-3df4598d849e@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vrqv9/Iv3MI1xIjyN3OV08sjxDNX6ztkzOcRbglOqYU=;
        b=Jn3UOoYxRmXz0/8P3Xa1ogBoFdvfiEZw2RtmGsb44RMcX1DAy1oLZBJOdc0yUZWgsp
         7xDsDDfSRzse0HMpWGBh+B3/3KZdzQ4RtrR+ai9HHSTWdS3W/lOCz6XGCV5nioxnzy3g
         AwWANrslZw+zkzTcIFqpiBH42mm9qs6k6c4jUaNec5p3+Arjs9kmm3FEZBYRfWmeK26h
         6ejUGFeY6UP0HWbJH8dR+3FOeATW/2hzFzPARvfhKKOZJ6UoquVGdUZ3TROyy3I3JWb4
         3sNArYlNTwUNXs+RoRHymG/wz6N1UARoP5AZjl8pud20oUsrVARyF1KV3pz9bv2T89ep
         c0YA==
Content-Disposition: inline
In-Reply-To: <96b8a923-49e4-f13e-b1e3-3df4598d849e@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org

On Tue, May 28, 2019 at 01:37:50PM -0400, Waiman Long wrote:
> On 5/28/19 1:08 PM, Vladimir Davydov wrote:
> >>  static void flush_memcg_workqueue(struct kmem_cache *s)
> >>  {
> >> +	/*
> >> +	 * memcg_params.dying is synchronized using slab_mutex AND
> >> +	 * memcg_kmem_wq_lock spinlock, because it's not always
> >> +	 * possible to grab slab_mutex.
> >> +	 */
> >>  	mutex_lock(&slab_mutex);
> >> +	spin_lock(&memcg_kmem_wq_lock);
> >>  	s->memcg_params.dying = true;
> >> +	spin_unlock(&memcg_kmem_wq_lock);
> > I would completely switch from the mutex to the new spin lock -
> > acquiring them both looks weird.
> >
> >>  	mutex_unlock(&slab_mutex);
> >>  
> >>  	/*
> 
> There are places where the slab_mutex is held and sleeping functions
> like kvzalloc() are called. I understand that taking both mutex and
> spinlocks look ugly, but converting all the slab_mutex critical sections
> to spinlock critical sections will be a major undertaking by itself. So
> I would suggest leaving that for now.

I didn't mean that. I meant taking spin_lock wherever we need to access
the 'dying' flag, even if slab_mutex is held. So that we don't need to
take mutex_lock in flush_memcg_workqueue, where it's used solely for
'dying' synchronization.
