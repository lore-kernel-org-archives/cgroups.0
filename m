From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 2/2] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Fri, 28 May 2021 09:22:45 -0700
Message-ID: <YLEY1RX3FhR9eWrv@carbon.DHCP.thefacebook.com>
References: <20210526222557.3118114-1-guro@fb.com>
 <20210526222557.3118114-3-guro@fb.com>
 <YLBcPCHJOYH4YGl6@T590>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YgXMFdH8CoZiTcSy9Dt4dq5N4bl/MNaWtdxCkfr4ojk=;
 b=orlYUHuV54UHcos61P8lmieM7T3n/uET9Wvs0BEm43dr7/qmbkr1CfFd+BZMCL8c++QG
 JJ0zgJ/Rqx9R8qdSr5WF3MGVeX/dfeHJ6nQdx3MH3RPVKstjHyRS7QiVWc8Foy9ubF6A
 06LbT7HuOqAlaZ676JJNJzXSMGbO1SAXME8= 
Content-Disposition: inline
In-Reply-To: <YLBcPCHJOYH4YGl6@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 28, 2021 at 10:58:04AM +0800, Ming Lei wrote:
> On Wed, May 26, 2021 at 03:25:57PM -0700, Roman Gushchin wrote:
> > Asynchronously try to release dying cgwbs by switching clean attached
> > inodes to the bdi's wb. It helps to get rid of per-cgroup writeback
> > structures themselves and of pinned memory and block cgroups, which
> > are way larger structures (mostly due to large per-cpu statistics
> > data). It helps to prevent memory waste and different scalability
> > problems caused by large piles of dying cgroups.
> > 
> > A cgwb cleanup operation can fail due to different reasons (e.g. the
> > cgwb has in-glight/pending io, an attached inode is locked or isn't
> > clean, etc). In this case the next scheduled cleanup will make a new
> > attempt. An attempt is made each time a new cgwb is offlined (in other
> > words a memcg and/or a blkcg is deleted by a user). In the future an
> > additional attempt scheduled by a timer can be implemented.
> > 
> > Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> > ---
> >  fs/fs-writeback.c                | 35 ++++++++++++++++++
> >  include/linux/backing-dev-defs.h |  1 +
> >  include/linux/writeback.h        |  1 +
> >  mm/backing-dev.c                 | 61 ++++++++++++++++++++++++++++++--
> >  4 files changed, 96 insertions(+), 2 deletions(-)
> > 
> 
> Hello Roman,
> 
> The following kernel panic is triggered by this patch:

Hello Ming!

Thank you for the report and for trying my patches!
I think I know what it is and will fix in the next version.

Thanks!
