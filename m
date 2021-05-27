From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 2/2] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Thu, 27 May 2021 12:45:23 -0700
Message-ID: <YK/20x1zGbjJ6mg8@carbon.DHCP.thefacebook.com>
References: <20210526222557.3118114-1-guro@fb.com>
 <20210526222557.3118114-3-guro@fb.com>
 <20210527112403.GC24486@quack2.suse.cz>
 <YK/bi1OU7bNgPBab@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fSfIG7r8/wS76RHFmp/8KL3FLU4e/faxcxSvO9e6uLc=;
 b=Fg53ALtEw/ZJgfTBkyykeuvlIAla3OcTRMxVWSawbjvvdvupEryJ28q2/VY0JQB7Zizu
 OWPdeXr1IuZNn4AbzdKQ7ui0RidEErDOM3P9qKXRY5x08oE3JTg6SMpSkQ65DDsYgXGH
 BB2kzQgx84zUClVbuO94E7BZnMoo/U0P45g= 
Content-Disposition: inline
In-Reply-To: <YK/bi1OU7bNgPBab@carbon.DHCP.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org

On Thu, May 27, 2021 at 10:48:59AM -0700, Roman Gushchin wrote:
> On Thu, May 27, 2021 at 01:24:03PM +0200, Jan Kara wrote:
> > On Wed 26-05-21 15:25:57, Roman Gushchin wrote:
> > > Asynchronously try to release dying cgwbs by switching clean attached
> > > inodes to the bdi's wb. It helps to get rid of per-cgroup writeback
> > > structures themselves and of pinned memory and block cgroups, which
> > > are way larger structures (mostly due to large per-cpu statistics
> > > data). It helps to prevent memory waste and different scalability
> > > problems caused by large piles of dying cgroups.
> > > 
> > > A cgwb cleanup operation can fail due to different reasons (e.g. the
> > > cgwb has in-glight/pending io, an attached inode is locked or isn't
> > > clean, etc). In this case the next scheduled cleanup will make a new
> > > attempt. An attempt is made each time a new cgwb is offlined (in other
> > > words a memcg and/or a blkcg is deleted by a user). In the future an
> > > additional attempt scheduled by a timer can be implemented.
> > > 
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > ---
> > >  fs/fs-writeback.c                | 35 ++++++++++++++++++
> > >  include/linux/backing-dev-defs.h |  1 +
> > >  include/linux/writeback.h        |  1 +
> > >  mm/backing-dev.c                 | 61 ++++++++++++++++++++++++++++++--
> > >  4 files changed, 96 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index 631ef6366293..8fbcd50844f0 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -577,6 +577,41 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
> > >  	kfree(isw);
> > >  }
> > >  
> > > +/**
> > > + * cleanup_offline_wb - detach associated clean inodes
> > > + * @wb: target wb
> > > + *
> > > + * Switch the inode->i_wb pointer of the attached inodes to the bdi's wb and
> > > + * drop the corresponding per-cgroup wb's reference. Skip inodes which are
> > > + * dirty, freeing, in the active writeback process or are in any way busy.
> > 
> > I think the comment doesn't match the function anymore.
> > 
> > > + */
> > > +void cleanup_offline_wb(struct bdi_writeback *wb)
> > > +{
> > > +	struct inode *inode, *tmp;
> > > +
> > > +	spin_lock(&wb->list_lock);
> > > +restart:
> > > +	list_for_each_entry_safe(inode, tmp, &wb->b_attached, i_io_list) {
> > > +		if (!spin_trylock(&inode->i_lock))
> > > +			continue;
> > > +		xa_lock_irq(&inode->i_mapping->i_pages);
> > > +		if ((inode->i_state & I_REFERENCED) != I_REFERENCED) {
> > 
> > Why the I_REFERENCED check here? That's just inode aging bit and I have
> > hard time seeing how it would relate to whether inode should switch wbs...
> 
> What I tried to say (and failed :) ) was that I_REFERENCED is the only accepted
> flag here. So there must be
> 	if ((inode->i_state | I_REFERENCED) != I_REFERENCED)

Sorry, I'm wrong. Must be:

if ((inode->i_state | I_REFERENCED) == I_REFERENCED) {
	...
}

or even simpler:

if (!(inode->i_state & ~I_REFERENCED)) {
	...
}
