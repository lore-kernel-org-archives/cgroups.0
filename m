From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Bug in cgroup_do_mount()?
Date: Tue, 13 Jun 2017 15:27:27 +0100
Message-ID: <25030.1497364047@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com B4591F446C
Content-ID: <25029.1497364047.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I'm having a go at converting cgroups to use my fs_context stuff, and I've
spotted a potential bug in the existing code.  In cgroup_do_mount(), there is
the following snippet:

		mutex_lock(&cgroup_mutex);
		spin_lock_irq(&css_set_lock);

		cgrp = cset_cgroup_from_root(ns->root_cset, root);

		spin_unlock_irq(&css_set_lock);
		mutex_unlock(&cgroup_mutex);

		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);

Given that locks must be taken to call cset_cgroup_from_root(), is the value
of cgrp trustworthy once the locks are dropped?

David
