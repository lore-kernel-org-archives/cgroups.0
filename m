From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [RFC PATCH v2 0/8] lru_lock scalability and SMP list functions
Date: Fri, 19 Oct 2018 08:35:55 -0700
Message-ID: <20181019153555.mza7t5siubhk3ohu@ca-dmjordan1.us.oracle.com>
References: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
 <2705c814-a6b8-0b14-7ea8-790325833d95@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=HXYgnJ3P5i00nVrBX3BRh1qEJz/jjKvHMDodfy1uMuE=;
 b=S4hxkkoLtY2CG3AX8T3NKKAwJtfSaIa2PdQa+iW3yGgtRkhaErLLAQ50/XRDzZ5YU/kw
 q6EKwrKf0aRM9hjaWyIM7R92BdSQ9lOH9e17cPXyI5imH5feGnydW8Fqa1XJgvL1lz3Z
 flr7RTVhKdAwsO9BIL2fkqZpuv4QoJ5Jzmnvqrx7/QYfZOY/YGuM/MP7ubtiAqwCTSQ4
 QKdk82m+NbObQIk52pkxDYj8vIaDyZ6+pE3FfUWDAskz0+h0jnxLyuvW43nJQYXUoHU+
 zonC1VGbSNSvynYNjms2h46whCjAGhK/7RbgzaE/WfSe4JkA0pAhKVruaAq5gJCKA33U cQ== 
Content-Disposition: inline
In-Reply-To: <2705c814-a6b8-0b14-7ea8-790325833d95@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, aaron.lu@intel.com, ak@linux.intel.com, akpm@linux-foundation.org, dave.dice@oracle.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, levyossi@icloud.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, Pavel.Tatashin@microsoft.com, steven.sistare@oracle.com, tim.c.chen@intel.com, vdavydov.dev@gmail.com, ying.huang@intel.com

On Fri, Oct 19, 2018 at 01:35:11PM +0200, Vlastimil Babka wrote:
> On 9/11/18 2:42 AM, Daniel Jordan wrote:
> > On large systems, lru_lock can become heavily contended in memory-intensive
> > workloads such as decision support, applications that manage their memory
> > manually by allocating and freeing pages directly from the kernel, and
> > workloads with short-lived processes that force many munmap and exit
> > operations.  lru_lock also inhibits scalability in many of the MM paths that
> > could be parallelized, such as freeing pages during exit/munmap and inode
> > eviction.
> 
> Interesting, I would have expected isolate_lru_pages() to be the main
> culprit, as the comment says:
> 
>  * For pagecache intensive workloads, this function is the hottest
>  * spot in the kernel (apart from copy_*_user functions).

Yes, I'm planning to stress reclaim to see how lru_lock responds.  I've
experimented some with using dd on lots of nvme drives to keep kswapd busy, but
I'm always looking for more realistic stuff.  Suggestions welcome :)

> It also says "Some of the functions that shrink the lists perform better
> by taking out a batch of pages and working on them outside the LRU
> lock." Makes me wonder why isolate_lru_pages() also doesn't cut the list
> first instead of doing per-page list_move() (and perhaps also prefetch
> batch of struct pages outside the lock first? Could be doable with some
> care hopefully).

Seems like the batch prefetching and list cutting would go hand in hand, since
cutting requires walking the LRU to find where to cut, which could miss on all
the page list nodes along the way.

I'll experiment with this.

> > Second, lru_lock is converted from a spinlock to a rwlock.  The idea is to
> > repurpose rwlock as a two-mode lock, where callers take the lock in shared
> > (i.e. read) mode for code using the SMP list functions, and exclusive (i.e.
> > write) mode for existing code that expects exclusive access to the LRUs.
> > Multiple threads are allowed in under the read lock, of course, and they use
> > the SMP list functions to synchronize amongst themselves.
> > 
> > The rwlock is scaffolding to facilitate the transition from big-hammer lru_lock
> > as it exists today to just using the list locking primitives and getting rid of
> > lru_lock entirely.  Such an approach allows incremental conversion of lru_lock
> > writers until everything uses the SMP list functions and takes the lock in
> > shared mode, at which point lru_lock can just go away.
> 
> Yeah I guess that will need more care, e.g. I think smp_list_del() can
> break any thread doing just a read-only traversal as it can end up with
> an entry that's been deleted and its next/prev poisoned.

As far as I can see from checking everywhere the kernel takes lru_lock, nothing
currently walks the LRUs.  LRU-using code just deletes a page from anywhere, or
adds one page at a time from the head or tail, so it seems safe to use
smp_list_* for all LRU paths.

This RFC doesn't handle adding and removing from list tails yet, but that seems
doable.

> It's a bit
> counterintuitive that "read lock" is now enough for selected modify
> operations, while read-only traversal would need a write lock.

Yes, I considered introducing wrappers to clarify this, e.g. an inline function
exclusive_lock_irqsave that just calls write_lock_irqsave, to let people know
the locks are being used specially.  Would be happy to add these in.

Thanks for taking a look, Vlastimil, and for your comments!
