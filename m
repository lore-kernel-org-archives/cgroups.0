From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v9 8/8] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Tue, 8 Jun 2021 17:23:34 -0700
Message-ID: <YMAKBgVgOhYHhB3N@carbon.dhcp.thefacebook.com>
References: <20210608230225.2078447-1-guro@fb.com>
 <20210608230225.2078447-9-guro@fb.com>
 <20210608171237.be2f4223de89458841c10fd4@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uatrukWuEvod5FAWT7mQFdvX2+y3oONeh+6XRBeakRo=;
 b=IF1cZutx5UUbLrcjhOaBIAwFFMorjTpwmACwED6vg4dF15zNLTQJJ5fAbXXHWJF/ZnHL
 7fR2h+2Z5LzU5vqNxbw/LgQBKbX3o/8F1LZQRrQaE07mAS3xZgIgznzRvwSzdaX3tmH/
 aaAb+HOyoHyKuJsRUvmM0eQTMzo7j7veC2M= 
Content-Disposition: inline
In-Reply-To: <20210608171237.be2f4223de89458841c10fd4-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 08, 2021 at 05:12:37PM -0700, Andrew Morton wrote:
> On Tue, 8 Jun 2021 16:02:25 -0700 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> 
> > Asynchronously try to release dying cgwbs by switching attached inodes
> > to the nearest living ancestor wb. It helps to get rid of per-cgroup
> > writeback structures themselves and of pinned memory and block cgroups,
> > which are significantly larger structures (mostly due to large per-cpu
> > statistics data). This prevents memory waste and helps to avoid
> > different scalability problems caused by large piles of dying cgroups.
> > 
> > Reuse the existing mechanism of inode switching used for foreign inode
> > detection. To speed things up batch up to 115 inode switching in a
> > single operation (the maximum number is selected so that the resulting
> > struct inode_switch_wbs_context can fit into 1024 bytes). Because
> > every switching consists of two steps divided by an RCU grace period,
> > it would be too slow without batching. Please note that the whole
> > batch counts as a single operation (when increasing/decreasing
> > isw_nr_in_flight). This allows to keep umounting working (flush the
> > switching queue), however prevents cleanups from consuming the whole
> > switching quota and effectively blocking the frn switching.
> > 
> > A cgwb cleanup operation can fail due to different reasons (e.g. not
> > enough memory, the cgwb has an in-flight/pending io, an attached inode
> > in a wrong state, etc). In this case the next scheduled cleanup will
> > make a new attempt. An attempt is made each time a new cgwb is offlined
> > (in other words a memcg and/or a blkcg is deleted by a user). In the
> > future an additional attempt scheduled by a timer can be implemented.
> > 
> > ...
> >
> > +/*
> > + * Maximum inodes per isw.  A specific value has been chosen to make
> > + * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
> > + */
> > +#define WB_MAX_INODES_PER_ISW	115
> 
> Can't we do 1024/sizeof(struct inode_switch_wbs_context)?

It must be something like
DIV_ROUND_DOWN_ULL(1024 - sizeof(struct inode_switch_wbs_context), sizeof(struct inode *)) + 1

But honestly 1024 came out of a thin air too, so I'm not sure it worth it.
I liked the number 128 but then made it fit into the closest kmalloc cache.

Btw, thank you for picking these patches up!
