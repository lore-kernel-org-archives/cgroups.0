Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4182D5335B3
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789155115; cv=none; b=e+CZM7elBSm5emsbGT7gupiq18fN03w0HbIvHd1DKSpEtLoz65UjSA8hLiZZtiYweWTtEftrAOSFxqGCDsN08ROPNulWChAM9NDAnE878/Nlw4gLWFY6h5SIku6/1C72G60/7SVP7VZh70P1tQHlBK40YA55g3Mlt8+yT1NBtiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789155115; c=relaxed/simple;
	bh=ctriTL2wV/FrSDurRkcOk6jVLZ/hDTrETmmoOyfRcQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASwQqCSg450DBv9FlZkyXbwbKWN8JL6mJ0reSxOCnPuWyg2e4TZvJ84v+DXzxjgZKFUIA3G63ckWnvfiUYY/vpYUq7SNccw7ilU9xa68D26bQznBZxsolwba/jGVhymp9SEsEJ1XgbyV1t/cwm4atDYKA0h3w1PuucMydHUNPFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TeI1YNG8; arc=none smtp.client-ip=91.218.175.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TeI1YNG8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ctriTL2wV/FrSDurRkcOk6jVLZ/hDTrETmmoOyfRcQQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789155104; v=1; x=1789759904;
 b=TeI1YNG8Z4F8SNnZ/6i1A/zkFmufqDBvEtwLI3zyMhhxLkdSM1bZNSyTDVJAZggnsPiImaj1
 1JN7gkCVheUX78oO/Fgn+Y7M6qiCwNtQpBFOubchuH3rfNqxdA52vKJHXqn33OXoTSRr8IBIoOO
 Fark7nssqeKXgdwd8yE/HCUU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 30192da8139d2325;
	Fri, 11 Sep 2026 19:31:44 +0000
X-Mizu-Trace-ID: 30192da8139d2325
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 12:31:42 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sandeep Dhavale <dhavale@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Christian Brauner <christian@brauner.io>, 
	Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
Message-ID: <aqRWuffGKczUhegT@linux.dev>
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
 <20260821050507.2161607-5-shakeel.butt@linux.dev>
 <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>

On Fri, Sep 11, 2026 at 11:33:01AM -0700, Sandeep Dhavale wrote:
> Hi Shakeel and Christian,
> 
> On Thu, Aug 20, 2026 at 10:05 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > kernfs_dop_revalidate() takes kernfs_rwsem for read once per path component
> > of every walk into a kernfs mount. Linux rwsems do not permit reader lock
> > stealing once a writer is queued, so a single writer parks the whole
> > incoming reader stream in uninterruptible sleep, stalling cgroup-polling
> > daemons for minutes.
> >
> > Nothing the callback reads requires the semaphore. kn->active is an
> > atomic_t that kernfs_find_and_get_node_by_id() already tests through
> > __kernfs_active(); kn->__parent and kn->name are RCU pointers whose old
> > values are freed only after a grace period; kn->ns is now compared rather
> > than dereferenced; parent->dir.rev was annotated earlier in this series.
> >
> > What the semaphore does provide is a coherent snapshot, and that is not
> > needed. ->d_revalidate() answers a question about a single instant, and the
> > answer is already stale when it returns: a rename landing just after
> > up_read() gives the same outcome as one observed mid-read. A lockless
> > reader can only return "valid" for the (parent, name, namespace) triple
> > identifying the dentry it was handed, and that triple was true when the
> > dentry was instantiated, so it reports a genuine past state exactly as the
> > locked version did. Removal is backstopped by kernfs_get_active() failing
> > in the subsequent open().
> >
> > Take an RCU read lock instead. kernfs_parent() and kernfs_rcu_name() work
> > unchanged: the condition in their rcu_dereference_check() is an alternative
> > to holding the RCU read lock, not an extra requirement. The negative dentry
> > path needs nothing, as @dir pins the parent. The namespace check can use
> > @parent directly once the preceding check establishes it equals
> > kernfs_parent(kn), so the kn_parent local and its NULL test go away.
> >
> > kernfs_ns_enabled() reads @parent->flags, which KERNFS_ACTIVATED and
> > KERNFS_REMOVING update as a plain read-modify-write under kernfs_rwsem.
> > Those bits are not read here and KERNFS_NS cannot change once the directory
> > has children, so mark the read data_race() rather than READ_ONCE(), which
> > would not silence KCSAN against the unmarked writers anyway.
> >
> > kernfs_iop_permission() still forces every walk out of RCU-walk before
> > children are revalidated, so lifting the LOOKUP_RCU bail here would have no
> > observable effect; it is left to the series fixing that path.
> >
> > Readers walking cgroupfs and sysfs against concurrent cgroup and netdev
> > churn: kernfs_rwsem read acquisitions drop from 48,593,360 to 1,280,280,
> > and kernfs_dop_revalidate() no longer appears among its contention sites.
> >
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  fs/kernfs/dir.c | 49 ++++++++++++++++++++-----------------------------
> >  1 file changed, 20 insertions(+), 29 deletions(-)
> >
> > diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> > index 27949b0e027c..cd7a8ff8b6b2 100644
> > --- a/fs/kernfs/dir.c
> > +++ b/fs/kernfs/dir.c
> > @@ -1171,9 +1171,8 @@ struct kernfs_node *kernfs_create_empty_dir(struct kernfs_node *parent,
> >  static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
> >                                  struct dentry *dentry, unsigned int flags)
> >  {
> > -       struct kernfs_node *kn, *kn_parent;
> >         struct kernfs_node *parent = dir->i_private;
> > -       struct kernfs_root *root;
> > +       struct kernfs_node *kn;
> >         const char *kn_name;
> >
> >         if (flags & LOOKUP_RCU)
> > @@ -1191,49 +1190,41 @@ static int kernfs_dop_revalidate(struct inode *dir, const struct qstr *name,
> >                  * changes and the lookup re-done so that a new positive
> >                  * dentry can be properly created.
> >                  */
> > -               root = kernfs_root(parent);
> > -               down_read(&root->kernfs_rwsem);
> > -               if (kernfs_dir_changed(parent, dentry)) {
> > -                       up_read(&root->kernfs_rwsem);
> > -                       return 0;
> > -               }
> > -               up_read(&root->kernfs_rwsem);
> > -
> > -               /* The kernfs parent node hasn't changed, leave the
> > -                * dentry negative and return success.
> > -                */
> > -               return 1;
> > +               return !kernfs_dir_changed(parent, dentry);
> >         }
> >
> >         kn = kernfs_dentry_node(dentry);
> > -       root = kernfs_root(kn);
> > -       down_read(&root->kernfs_rwsem);
> > +
> > +       guard(rcu)();
> >
> >         /* The kernfs node has been deactivated */
> > -       if (!kernfs_active(kn))
> > -               goto out_bad;
> > +       if (!__kernfs_active(kn))
> > +               return 0;
> >
> 
> I have couple of reports on android kernel based on 6.12 with callstack
> 
> [   41.137176][ T5373] pc : kernfs_dop_revalidate+0x28/0x108
> [   41.137180][ T5373] lr : path_openat+0x7ec/0x1b04
> [   41.137183][ T5373] sp : ffffffc0b02fbba0
> [   41.137184][ T5373] x29: ffffffc0b02fbba0 x28: ffffffc0b02fbda4
> x27: ffffff8917f90000
> [   41.137187][ T5373] x26: 0000000000000030 x25: ffffff8918985860
> x24: 0000000000028000
> [   41.137189][ T5373] x23: ffffff8918985040 x22: 0000000000000040
> x21: 0000000000000000
> [   41.137192][ T5373] x20: ffffff8918985040 x19: ffffff894321d000
> x18: ffffffdc3adec8c0
> [   41.137194][ T5373] x17: 000000004495e485 x16: 000000004495e485
> x15: ffffffffff000000
> [   41.137197][ T5373] x14: 7d6770f3f4cee991 x13: 0000000000737365
> x12: 0000000000737365
> [   41.137199][ T5373] x11: ffffff8918985088 x10: 0000000000000018 x9
> : 0000000100000000
> [   41.137202][ T5373] x8 : ffffff89dc6c3d30 x7 : 705f636f6c6c6100 x6
> : 0080808080808080
> [   41.137204][ T5373] x5 : ffffffc0b02fbad0 x4 : 0000000000000000 x3
> : 0000000000000000
> [   41.137207][ T5373] x2 : 0000000000000000 x1 : 0000000000000100 x0
> : ffffff8918985040
> [   41.137210][ T5373] Call trace:
> [   41.137211][ T5373]  kernfs_dop_revalidate+0x28/0x108
> [   41.137213][ T5373]  path_openat+0x7ec/0x1b04
> [   41.137215][ T5373]  do_filp_open+0xac/0x130
> [   41.137216][ T5373]  do_sys_openat2+0x140/0x21c
> [   41.137219][ T5373]  __arm64_sys_openat+0x70/0x9c
> [   41.137222][ T5373]  invoke_syscall+0x58/0xf0
> [   41.137224][ T5373]  do_el0_svc+0x64/0xe0
> [   41.137226][ T5373]  el0_svc+0x4c/0xdc
> [   41.137228][ T5373]  el0t_64_sync_handler+0x20/0xf4
> [   41.137230][ T5373]  el0t_64_sync+0x1bc/0x1c0
> 
> After investigation it seems there is race where
> kernfs_dop_revalidate() crashed dereferencing kn->__parent in
> kernfs_root(kn) at offset 0x8).
> Although your patch eliminates kernfs_root(kn), the underlying race
> where kn == NULL still exists in this patch and will now crash in
> __kernfs_active(kn) at offset 0x4.
> 
> Scenario seems to be during lockless VFS path lookup (lookup_fast()),
> cached dentries are revalidated without holding dentry locks:
> 
>   1. lookup_fast() finds a cached positive dentry where dentry->d_inode != NULL.
>   2. In kernfs_dop_revalidate(), d_really_is_negative(dentry)
> evaluates to false, so it skips the negative dentry branch.
>   3. Concurrently, slab memory reclaim under memory pressure evicts
> unused dentries:
>     shrink_node() -> shrink_slab() -> super_cache_scan()
>       -> prune_dcache_sb() -> shrink_dentry_list()
>         -> dentry_unlink_inode()
>              -> __d_clear_type_and_inode(dentry)
>                   -> dentry->d_inode = NULL;
> 
>   4. kernfs_dop_revalidate() now runs:
>     kn = kernfs_dentry_node(dentry);
>   kernfs_dentry_node() tests if (d_really_is_negative(dentry)) return NULL;.
>   Because dentry->d_inode was cleared to NULL by
> dentry_unlink_inode(), kernfs_dentry_node(dentry) returns NULL

Hi Sandeep, thanks for the report. Do you have a reproducer? If yes, can you
reproduce with this series?

> 
> While crafting fix for 6.12, I found this series reworking
> kernfs_dop_revalidate().
> Just to be clear, your series is not introducing the problem.
> 
> But perhaps we can improve this with a check like below?
> 
>   -    /* The kernfs node has been deactivated */
>   -    if (!__kernfs_active(kn))
>   +    /* The kernfs node is unlinked or deactivated */
>   +    if (!kn || !__kernfs_active(kn))
>              return 0;
> 
> Let me know your thoughts or if you want a separate patch

I think first we need a real reproducer before considering anything. I would not
add a check unless we have proof that it is really needed.
