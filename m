From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCHSET v2] slab: make memcg slab destruction scalable
Date: Wed, 18 Jan 2017 16:54:48 +0900
Message-ID: <20170118075448.GA1255@js1304-P5Q-DELUXE>
References: <20170114184834.8658-1-tj@kernel.org>
 <20170117001256.GB25218@js1304-P5Q-DELUXE>
 <20170117164913.GB28948@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170117164913.GB28948@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Tue, Jan 17, 2017 at 08:49:13AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 17, 2017 at 09:12:57AM +0900, Joonsoo Kim wrote:
> > Could you confirm that your series solves the problem that is reported
> > by Doug? It would be great if the result is mentioned to the patch
> > description.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=172991
> 
> So, that's an issue in the creation path which is already resolved by
> switching to an ordered workqueue (it'd probably be better to use
> per-cpu wq w/ @max_active == 1 tho).  This patchset is about relesae
> path.  slab_mutex contention would definitely go down with this but
> I don't think there's more connection to it than that.

That problem is caused by slow release path and then contention on the
slab_mutex. With an ordered workqueue, kworker would not be created a
lot but it can be possible that a lot of work items to create a new
cache for memcg is pending for a long time due to slow release path.

Your patchset replaces optimization for release path so it's better to
check that the work isn't pending for a long time in above workload.

Thanks.
