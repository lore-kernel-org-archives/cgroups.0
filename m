From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: NULL pointer deref in put_fs_context with unprivileged LXC
Date: Wed, 6 Nov 2019 07:24:07 +0000
Message-ID: <20191106072407.GU26530@ZenIV.linux.org.uk>
References: <20191010213512.GA875@gandi.net>
 <20191011141403.ghjptf4nrttgg7jd@wittgenstein>
 <20191105205830.GA871@gandi.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191105205830.GA871@gandi.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thibaut Sautereau <thibaut@sautereau.fr>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Christian Brauner <christian@brauner.io>, cgroups@vger.kernel.org

On Tue, Nov 05, 2019 at 09:58:30PM +0100, Thibaut Sautereau wrote:

> > > 	BUG: kernel NULL pointer dereference, address: 0000000000000043

ERR_PTR(something)->d_sb, most likely.

> > > 	493		if (fc->root) {
> > > 	494			sb = fc->root->d_sb;
> > > 	495			dput(fc->root);
> > > 	496			fc->root = NULL;
> > > 	497			deactivate_super(sb);
> > > 	498		}

> 	fs_context: DEBUG: fc->root = fffffffffffffff3
> 	fs_context: DEBUG: fc->source = cgroup2

Yup.  That'd be ERR_PTR(-13), i.e. ERR_PTR(-EACCES).  Most likely
from
                nsdentry = kernfs_node_dentry(cgrp->kn, sb);
                dput(fc->root);
                fc->root = nsdentry;
                if (IS_ERR(nsdentry)) {
                        ret = PTR_ERR(nsdentry);
                        deactivate_locked_super(sb);
                }

in cgroup_do_get_tree().  As a quick test, try to add fc->root = NULL;
next to that deactivate_locked_super(sb); inside the if (IS_ERR(...))
body and see if it helps; it's not the best way to fix it (I'd rather
go for
                if (IS_ERR(nsdentry)) {
                        ret = PTR_ERR(nsdentry);
                        deactivate_locked_super(sb);
			nsdentry = NULL;
                }
                fc->root = nsdentry;
), but it would serve to verify that this is the source of that crap.
