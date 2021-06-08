From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v7 6/6] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Mon, 7 Jun 2021 17:20:25 -0700
Message-ID: <YL63yf3oIuLDlxNF@carbon.DHCP.thefacebook.com>
References: <20210604013159.3126180-1-guro@fb.com>
 <20210604013159.3126180-7-guro@fb.com>
 <YLvt8f+r7aFkmluG@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=IVK68f95zn6CENMdKH0iXxJ7dtkbyJAbPipxz4l/l/E=;
 b=Gg1bYcOKcOdtfQqzOfxhB2mIkAHABhPFYmTzTxy0cQCOkeHMLV9ZpQTw1TF/p8g01Ork
 hivXUndjD7iJl7RI/msjvt08SirvOXIejt/gUVpLzFfSa1+HpmTr+7lvgTpJkWzXpiak
 FTbzwRLwiS0tVKCi6Nh+Fy4fU95+28a1zKU= 
Content-Disposition: inline
In-Reply-To: <YLvt8f+r7aFkmluG-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 05, 2021 at 09:34:41PM +0000, Dennis Zhou wrote:
> Hello,
> 
> On Thu, Jun 03, 2021 at 06:31:59PM -0700, Roman Gushchin wrote:
> > Asynchronously try to release dying cgwbs by switching attached inodes
> > to the bdi's wb. It helps to get rid of per-cgroup writeback
> > structures themselves and of pinned memory and block cgroups, which
> > are significantly larger structures (mostly due to large per-cpu
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
> 
> I've been thinking about this for a little while and the only thing I'm
> not super thrilled by is that the subsequent cleanup work trigger isn't
> due to forward progress.
> 
> As future work, we could tag the inodes to switch when writeback
> completes instead of using a timer. This would be nice because then we
> only have to make a single (successful) pass switching the inodes we can
> and then mark the others to switch. Once a cgwb is killed no one else
> can attach to it so we should be good there.
> 
> I don't think this is a blocker or even necessary, I just wanted to put
> it out there as possible future direction instead of a timer.

Yeah, I agree that it's a good direction to explore. It will be likely
more intrusive and will require new inode flag. So I'd leave it for further
improvements.

Thank you for reviewing the series!
