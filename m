From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 1/2] writeback, cgroup: keep list of inodes attached
 to bdi_writeback
Date: Thu, 27 May 2021 09:32:57 -0700
Message-ID: <YK/JueoCO4LisjDo@carbon.DHCP.thefacebook.com>
References: <20210526222557.3118114-1-guro@fb.com>
 <20210526222557.3118114-2-guro@fb.com>
 <20210527103517.GA24486@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kBZoW71KNvinWsNxpEHmdIjaAW5oZLgT6CohaQ2MJms=;
 b=ideZhw5e52FYLchVn7XLAX7ZkU/NyaZSUpmXyk6mjxP9Ju8FLlBIhx1eJjCfqu6Q3GL5
 sYZb1PUvfrsDyBbjuvPGLgFc9DIyRs85n5PgmMOXfaN+B+qTPHINSYhm7cluaCiraJ+x
 VAgS2ZMNGPenenxhDJkghuGEictU1gW6yr8= 
Content-Disposition: inline
In-Reply-To: <20210527103517.GA24486-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 27, 2021 at 12:35:17PM +0200, Jan Kara wrote:
> On Wed 26-05-21 15:25:56, Roman Gushchin wrote:
> > Currently there is no way to iterate over inodes attached to a
> > specific cgwb structure. It limits the ability to efficiently
> > reclaim the writeback structure itself and associated memory and
> > block cgroup structures without scanning all inodes belonging to a sb,
> > which can be prohibitively expensive.
> > 
> > While dirty/in-active-writeback an inode belongs to one of the
> > bdi_writeback's io lists: b_dirty, b_io, b_more_io and b_dirty_time.
> > Once cleaned up, it's removed from all io lists. So the
> > inode->i_io_list can be reused to maintain the list of inodes,
> > attached to a bdi_writeback structure.
> > 
> > This patch introduces a new wb->b_attached list, which contains all
> > inodes which were dirty at least once and are attached to the given
> > cgwb. Inodes attached to the root bdi_writeback structures are never
> > placed on such list. The following patch will use this list to try to
> > release cgwbs structures more efficiently.
> > 
> > Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> Looks good. Just some minor nits below:
> 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index e91980f49388..631ef6366293 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -135,18 +135,23 @@ static bool inode_io_list_move_locked(struct inode *inode,
> >   * inode_io_list_del_locked - remove an inode from its bdi_writeback IO list
> >   * @inode: inode to be removed
> >   * @wb: bdi_writeback @inode is being removed from
> > + * @final: inode is going to be freed and can't reappear on any IO list
> >   *
> >   * Remove @inode which may be on one of @wb->b_{dirty|io|more_io} lists and
> >   * clear %WB_has_dirty_io if all are empty afterwards.
> >   */
> >  static void inode_io_list_del_locked(struct inode *inode,
> > -				     struct bdi_writeback *wb)
> > +				     struct bdi_writeback *wb,
> > +				     bool final)
> >  {
> >  	assert_spin_locked(&wb->list_lock);
> >  	assert_spin_locked(&inode->i_lock);
> >  
> >  	inode->i_state &= ~I_SYNC_QUEUED;
> > -	list_del_init(&inode->i_io_list);
> > +	if (final)
> > +		list_del_init(&inode->i_io_list);
> > +	else
> > +		inode_cgwb_move_to_attached(inode, wb);
> >  	wb_io_lists_depopulated(wb);
> >  }
> 
> With these changes the naming is actually somewhat confusing and the bool
> argument makes it even worse. Looking into the code I'd just fold
> inode_io_list_del_locked() into inode_io_list_del() and make it really
> delete inode from all IO lists. There are currently three other
> inode_io_list_del_locked() users:

Yeah, good idea. Will do in the next version. Thanks!
