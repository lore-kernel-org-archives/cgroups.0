From: Li Zhong <lizhongfs@gmail.com>
Subject: Re: [PATCH v11 25/25] list_lru: dynamically adjust node arrays
Date: Wed, 19 Jun 2013 17:12:28 +0800
Message-ID: <1371633148.2984.18.camel@ThinkPad-T5421>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
	 <1370550898-26711-26-git-send-email-glommer@openvz.org>
	 <1371548521.2984.6.camel@ThinkPad-T5421>
	 <20130619073154.GA1990@localhost.localdomain>
Reply-To: lizhongfs@gmail.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=Ky5M9sesvYgjpoJPmQqbDiYN1LzZbqNFh/gGYrCumv8=;
        b=mgl/X2SM2iI9ua0lpL4M8LkKYu+ExJFE04CxggfTQKyoa7PFQZjX1uKUf9XLp1Sxrb
         DvyG8i1qHofymmOIIQ4CIJUV2Ak1cyJvcLDkMMa1fdCNud1sdQtLqteNeWT1ngJkZkuy
         mhKjquqvJkw4WhwSIiqD2IWSXnOMDjS3Ay5YG50AIVv71dOInCsDdVvNOIH3akvWiVYX
         B5ICsksjGu+9bF3HH3Xn1fnywCVuL4ARYI1pW3Asz4XLoPSXBGMIsBCdffq4wV4Mx5jV
         G92wVhjSnMqgVJ4FEUtB1YANxXN85dO4vPslfrwwkCnazeo+eMsn23pPgbKTS+zUg03g
         k7Xg==
In-Reply-To: <20130619073154.GA1990@localhost.localdomain>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@gmail.com>
Cc: Glauber Costa <glommer@openvz.org>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, Dave Chinner <dchinner@redhat.com>

On Wed, 2013-06-19 at 11:31 +0400, Glauber Costa wrote:
> On Tue, Jun 18, 2013 at 05:42:01PM +0800, Li Zhong wrote:
> > On Fri, 2013-06-07 at 00:34 +0400, Glauber Costa wrote:
>  > 
> > > diff --git a/fs/super.c b/fs/super.c
> > > index 85a6104..1b6ef7b 100644
> > > --- a/fs/super.c
> > > +++ b/fs/super.c
> > > @@ -199,8 +199,12 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
> > >  		INIT_HLIST_NODE(&s->s_instances);
> > >  		INIT_HLIST_BL_HEAD(&s->s_anon);
> > >  		INIT_LIST_HEAD(&s->s_inodes);
> > > -		list_lru_init(&s->s_dentry_lru);
> > > -		list_lru_init(&s->s_inode_lru);
> > > +
> > > +		if (list_lru_init(&s->s_dentry_lru))
> > > +			goto err_out;
> > > +		if (list_lru_init(&s->s_inode_lru))
> > > +			goto err_out_dentry_lru;
> > > +
> > >  		INIT_LIST_HEAD(&s->s_mounts);
> > >  		init_rwsem(&s->s_umount);
> > >  		lockdep_set_class(&s->s_umount, &type->s_umount_key);
> > > @@ -240,6 +244,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
> > >  	}
> > >  out:
> > >  	return s;
> > > +
> > > +err_out_dentry_lru:
> > > +	list_lru_destroy(&s->s_dentry_lru);
> > >  err_out:
> > >  	security_sb_free(s);
> > >  #ifdef CONFIG_SMP
> > 
> > It seems we also need to call list_lru_destroy() in destroy_super()? 
> > like below:
> >  
> > -----------
> > diff --git a/fs/super.c b/fs/super.c
> > index b79e732..06ee3af 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -269,6 +269,8 @@ err_out:
> >   */
> >  static inline void destroy_super(struct super_block *s)
> >  {
> > +	list_lru_destroy(&s->s_inode_lru);
> > +	list_lru_destroy(&s->s_dentry_lru);
> >  #ifdef CONFIG_SMP
> >  	free_percpu(s->s_files);
> >  #endif
> 
> Hi
> 
> Thanks for taking a look at this.
> 
> list_lru_destroy is called by deactivate_lock_super, so we should be fine already.

Sorry, I'm a little confused...

I didn't see list_lru_destroy() called in deactivate_locked_super().
Maybe I missed something? 

But it seems other memory allocated in alloc_super(), are freed in
destroy_super(), e.g. ->s_files, why don't we also free this one here? 

Thanks, Zhong


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
