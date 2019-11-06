From: Thibaut Sautereau <thibaut@sautereau.fr>
Subject: Re: NULL pointer deref in put_fs_context with unprivileged LXC
Date: Wed, 6 Nov 2019 22:06:46 +0100
Message-ID: <20191106210646.GA1495@gandi.net>
References: <20191010213512.GA875@gandi.net>
 <20191011141403.ghjptf4nrttgg7jd@wittgenstein>
 <20191105205830.GA871@gandi.net>
 <20191106072407.GU26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191106072407.GU26530@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Christian Brauner <christian@brauner.io>, cgroups@vger.kernel.org

On Wed, Nov 06, 2019 at 07:24:07AM +0000, Al Viro wrote:
> On Tue, Nov 05, 2019 at 09:58:30PM +0100, Thibaut Sautereau wrote:
> 
> > > > 	BUG: kernel NULL pointer dereference, address: 0000000000000043
> 
> ERR_PTR(something)->d_sb, most likely.
> 
> > > > 	493		if (fc->root) {
> > > > 	494			sb = fc->root->d_sb;
> > > > 	495			dput(fc->root);
> > > > 	496			fc->root = NULL;
> > > > 	497			deactivate_super(sb);
> > > > 	498		}
> 
> > 	fs_context: DEBUG: fc->root = fffffffffffffff3
> > 	fs_context: DEBUG: fc->source = cgroup2
> 
> Yup.  That'd be ERR_PTR(-13), i.e. ERR_PTR(-EACCES).  Most likely
> from
>                 nsdentry = kernfs_node_dentry(cgrp->kn, sb);
>                 dput(fc->root);
>                 fc->root = nsdentry;
>                 if (IS_ERR(nsdentry)) {
>                         ret = PTR_ERR(nsdentry);
>                         deactivate_locked_super(sb);
>                 }
> 
> in cgroup_do_get_tree().  As a quick test, try to add fc->root = NULL;
> next to that deactivate_locked_super(sb); inside the if (IS_ERR(...))
> body and see if it helps; it's not the best way to fix it (I'd rather
> go for
>                 if (IS_ERR(nsdentry)) {
>                         ret = PTR_ERR(nsdentry);
>                         deactivate_locked_super(sb);
> 			nsdentry = NULL;
>                 }
>                 fc->root = nsdentry;
> ), but it would serve to verify that this is the source of that crap.

Yes, you're absolutely right. Your first suggestion fixes the bug, as
well as your second one. Thanks!

By the way, I had just finished the bisection, confirming that
71d883c37e8d ("cgroup_do_mount(): massage calling conventions") brought
the issue.

Do you want me to send a patch or are you dealing with that?

-- 
Thibaut
