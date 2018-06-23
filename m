From: David Howells <dhowells@redhat.com>
Subject: Re: [16/32] kernfs, sysfs, cgroup, intel_rdt: Support fs_context [ver #8]
Date: Sun, 24 Jun 2018 00:34:36 +0100
Message-ID: <16505.1529796876@warthog.procyon.org.uk>
References: <20180622165715.GA5361@outlook.office365.com> <20180621184754.GB21326@outlook.office365.com> <152720682792.9073.14747437198191460035.stgit@warthog.procyon.org.uk> <29799.1529671936@warthog.procyon.org.uk> <20180622153029.GA3070@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622165715.GA5361@outlook.office365.com>
Content-ID: <16504.1529796876.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Andrei Vagin <avagin@virtuozzo.com> wrote:

> > > >                 percpu_ref_reinit(&root->cgrp.self.refcnt);
> > > >                 mutex_unlock(&cgroup_mutex);
> > > >         }
> > > > +       cgroup_get(&root->cgrp);
> > > 
> > > This probably needs to be conditional on ret == 0.
> > 
> > yes, you are right
> 
> 
> I've read the code and I think it isn't obvious. A reference will be
> released id cgroup_fs_context_free() even if ret isn't zero here.
> 
> I look at do_new_mount()
> 
> vfs_new_fs_context()
> ...
> if (vfs_get_tree()) 
> 	goto out_fc;
> ....
> out_fc:
> put_fs_context(fc);
> 	fc->ops->free(fc);
> 		cgroup_fs_context_free()
> 			cgroup_put(&ctx->root->cgrp);

Yeah, you're right: ctx->root is set above, so the put will trigger anyway.
I'll fold both of these changes in.

David
