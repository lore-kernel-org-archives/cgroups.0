From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 2/2] kernfs: do not account ino_ida allocations to memcg
Date: Tue, 5 May 2015 19:04:59 +0300
Message-ID: <20150505160459.GA23654@esperanza>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
 <0cf48f4219721952f182715a61910f626d7c4aca.1430819044.git.vdavydov@parallels.com>
 <20150505134521.GL1971@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150505134521.GL1971@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 05, 2015 at 09:45:21AM -0400, Tejun Heo wrote:
> On Tue, May 05, 2015 at 12:45:43PM +0300, Vladimir Davydov wrote:
> > root->ino_ida is used for kernfs inode number allocations. Since IDA has
> > a layered structure, different IDs can reside on the same layer, which
> > is currently accounted to some memory cgroup. The problem is that each
> > kmem cache of a memory cgroup has its own directory on sysfs (under
> > /sys/fs/kernel/<cache-name>/cgroup). If the inode number of such a
> > directory or any file in it gets allocated from a layer accounted to the
> > cgroup which the cache is created for, the cgroup will get pinned for
> > good, because one has to free all kmem allocations accounted to a cgroup
> > in order to release it and destroy all its kmem caches. That said we
> > must not account layers of ino_ida to any memory cgroup.
> > 
> > Since per net init operations may create new sysfs entries directly
> > (e.g. lo device) or indirectly (nf_conntrack creates a new kmem cache
> > per each namespace, which, in turn, creates new sysfs entries), an easy
> > way to reproduce this issue is by creating network namespace(s) from
> > inside a kmem-active memory cgroup.
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> 
> Man, that's nasty.  For the kernfs part,
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

> 
> Can you please repost this patch w/ Greg KH cc'd?

OK.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
