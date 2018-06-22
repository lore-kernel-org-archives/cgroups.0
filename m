From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [16/32] kernfs, sysfs, cgroup, intel_rdt: Support fs_context
 [ver #8]
Date: Fri, 22 Jun 2018 09:57:16 -0700
Message-ID: <20180622165715.GA5361@outlook.office365.com>
References: <20180621184754.GB21326@outlook.office365.com>
 <152720682792.9073.14747437198191460035.stgit@warthog.procyon.org.uk>
 <29799.1529671936@warthog.procyon.org.uk>
 <20180622153029.GA3070@outlook.office365.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkiXMZa5MUzoD9vclYkSwey3xNxxZQYof+YxQw90bCA=;
 b=hwrsSKRgOTB0tNi+7YLg8XUFRQAAHxREwiZuX+9+ihGXL60tLAP9eBpvQmhOAQsAOIjWqWmTFweGdPffDyiu7NF7FuF0P15Bdq1u9Aqk76eMWW2c9tNaDNz9MvUFQXB3VBGTF/dGkqT4XinLUy6X2yTWfTSZVe12NngVqKNGen4=
Content-Disposition: inline
In-Reply-To: <20180622153029.GA3070@outlook.office365.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Fri, Jun 22, 2018 at 08:30:29AM -0700, Andrei Vagin wrote:
> On Fri, Jun 22, 2018 at 01:52:16PM +0100, David Howells wrote:
> > Andrei Vagin <avagin@virtuozzo.com> wrote:
> > 
> > >                 ret = 0;
> > > +               ctx->root = root;
> > >                 goto out_unlock;
> > 
> > Okay, I can see that.
> > 
> > >                 percpu_ref_reinit(&root->cgrp.self.refcnt);
> > >                 mutex_unlock(&cgroup_mutex);
> > >         }
> > > +       cgroup_get(&root->cgrp);
> > 
> > This probably needs to be conditional on ret == 0.
> 
> yes, you are right


I've read the code and I think it isn't obvious. A reference will be
released id cgroup_fs_context_free() even if ret isn't zero here.

I look at do_new_mount()

vfs_new_fs_context()
...
if (vfs_get_tree()) 
	goto out_fc;
....
out_fc:
put_fs_context(fc);
	fc->ops->free(fc);
		cgroup_fs_context_free()
			cgroup_put(&ctx->root->cgrp);

> 
> > 
> > Which version are you testing btw?  The patches in git have been fixed a
> > little from what was last posted.
> 
> I'm testing linux-next-20180621
> 
> commit 8439c34f07a3f58245e933ca2703239417288363 (tag: next-20180621,
> linux-next/master)
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Thu Jun 21 14:09:41 2018 +1000
> 
>     Add linux-next specific files for 20180621
>     
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> > 
> > David
