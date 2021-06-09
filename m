From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v9 8/8] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Tue, 8 Jun 2021 17:12:37 -0700
Message-ID: <20210608171237.be2f4223de89458841c10fd4@linux-foundation.org>
References: <20210608230225.2078447-1-guro@fb.com>
        <20210608230225.2078447-9-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197558;
        bh=Np2CNaI10f2uKvZB+8HAW9VBjJUZilRyHauJK0qYGM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UnB1q0jQlepG/n+9aunHOVHnESQHqNJO0tnNJiaZReW3e+zFEQDsENcwOJkkw9VFN
         3pOvqYOf63gtypGuz/jPXvIjdIW/SOhYrSTfPrJ0kaArAGVJYON1mq5qHbxVqL1XSq
         yu58wXvf/psjV9Um+ReIXRJThocZ1wDtmkDD+EHY=
In-Reply-To: <20210608230225.2078447-9-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 8 Jun 2021 16:02:25 -0700 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:

> Asynchronously try to release dying cgwbs by switching attached inodes
> to the nearest living ancestor wb. It helps to get rid of per-cgroup
> writeback structures themselves and of pinned memory and block cgroups,
> which are significantly larger structures (mostly due to large per-cpu
> statistics data). This prevents memory waste and helps to avoid
> different scalability problems caused by large piles of dying cgroups.
> 
> Reuse the existing mechanism of inode switching used for foreign inode
> detection. To speed things up batch up to 115 inode switching in a
> single operation (the maximum number is selected so that the resulting
> struct inode_switch_wbs_context can fit into 1024 bytes). Because
> every switching consists of two steps divided by an RCU grace period,
> it would be too slow without batching. Please note that the whole
> batch counts as a single operation (when increasing/decreasing
> isw_nr_in_flight). This allows to keep umounting working (flush the
> switching queue), however prevents cleanups from consuming the whole
> switching quota and effectively blocking the frn switching.
> 
> A cgwb cleanup operation can fail due to different reasons (e.g. not
> enough memory, the cgwb has an in-flight/pending io, an attached inode
> in a wrong state, etc). In this case the next scheduled cleanup will
> make a new attempt. An attempt is made each time a new cgwb is offlined
> (in other words a memcg and/or a blkcg is deleted by a user). In the
> future an additional attempt scheduled by a timer can be implemented.
> 
> ...
>
> +/*
> + * Maximum inodes per isw.  A specific value has been chosen to make
> + * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
> + */
> +#define WB_MAX_INODES_PER_ISW	115

Can't we do 1024/sizeof(struct inode_switch_wbs_context)?


