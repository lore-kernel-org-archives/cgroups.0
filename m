From: Li Zhong <lizhongfs@gmail.com>
Subject: Re: [PATCH v11 25/25] list_lru: dynamically adjust node arrays
Date: Thu, 20 Jun 2013 09:35:31 +0800
Message-ID: <1371692131.2555.13.camel@ThinkPad-T5421>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
	 <1370550898-26711-26-git-send-email-glommer@openvz.org>
	 <1371548521.2984.6.camel@ThinkPad-T5421>
	 <20130619073154.GA1990@localhost.localdomain>
	 <1371633148.2984.18.camel@ThinkPad-T5421>
	 <20130619132904.GA4031@localhost.localdomain>
Reply-To: lizhongfs@gmail.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=Teo1j0cEeGBUk7wTJAym0GDq1lL1TbATyDHmpK2ZdPI=;
        b=Ne+JcczGnL74mt66OEyGcYCv+kB6C/OEUVgUf8vJTtui/wbcMQlw8ynMXdIqkSBoXt
         UdNbRrU3L6KOfB1Nz6u/QOokL0aiSI1GIXDtuKJEmTN23fTXVlbczpnmMLDyTsj5LBKd
         cXqjyBSn1uxEg4tZf7mYtpquOW3e6ZfRqM0Ts7H0Gdj1RUhOqE0nHANVCxgL+bhAT6rt
         oPoqe69fRTRXCfxpWvoiyV4bZfsI1MjrLMa/YMsseNH7vGVlZm5aaRW3AG/ZEc9Y8M6h
         rHuPvZrSlTUD655c7PF9vNp5zaIBWIS9GJDn8wvmMBhkoTQHliL4NOVCHSBrP1Ezdlr5
         iKJg==
In-Reply-To: <20130619132904.GA4031@localhost.localdomain>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@gmail.com>
Cc: Glauber Costa <glommer@openvz.org>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, Dave Chinner <dchinner@redhat.com>

On Wed, 2013-06-19 at 17:29 +0400, Glauber Costa wrote:
> On Wed, Jun 19, 2013 at 05:12:28PM +0800, Li Zhong wrote:
> > On Wed, 2013-06-19 at 11:31 +0400, Glauber Costa wrote:
> > > On Tue, Jun 18, 2013 at 05:42:01PM +0800, Li Zhong wrote:
> > > > On Fri, 2013-06-07 at 00:34 +0400, Glauber Costa wrote:
> > >  > 
> > > > > diff --git a/fs/super.c b/fs/super.c
> > > > > index 85a6104..1b6ef7b 100644
> > > > > --- a/fs/super.c
> > > > > +++ b/fs/super.c
> > > > > @@ -199,8 +199,12 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
> > > > >  		INIT_HLIST_NODE(&s->s_instances);
> > > > >  		INIT_HLIST_BL_HEAD(&s->s_anon);
> > > > >  		INIT_LIST_HEAD(&s->s_inodes);
> > > > > -		list_lru_init(&s->s_dentry_lru);
> > > > > -		list_lru_init(&s->s_inode_lru);
> > > > > +
> > > > > +		if (list_lru_init(&s->s_dentry_lru))
> > > > > +			goto err_out;
> > > > > +		if (list_lru_init(&s->s_inode_lru))
> > > > > +			goto err_out_dentry_lru;
> > > > > +
> > > > >  		INIT_LIST_HEAD(&s->s_mounts);
> > > > >  		init_rwsem(&s->s_umount);
> > > > >  		lockdep_set_class(&s->s_umount, &type->s_umount_key);
> > > > > @@ -240,6 +244,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
> > > > >  	}
> > > > >  out:
> > > > >  	return s;
> > > > > +
> > > > > +err_out_dentry_lru:
> > > > > +	list_lru_destroy(&s->s_dentry_lru);
> > > > >  err_out:
> > > > >  	security_sb_free(s);
> > > > >  #ifdef CONFIG_SMP
> > > > 
> > > > It seems we also need to call list_lru_destroy() in destroy_super()? 
> > > > like below:
> > > >  
> > > > -----------
> > > > diff --git a/fs/super.c b/fs/super.c
> > > > index b79e732..06ee3af 100644
> > > > --- a/fs/super.c
> > > > +++ b/fs/super.c
> > > > @@ -269,6 +269,8 @@ err_out:
> > > >   */
> > > >  static inline void destroy_super(struct super_block *s)
> > > >  {
> > > > +	list_lru_destroy(&s->s_inode_lru);
> > > > +	list_lru_destroy(&s->s_dentry_lru);
> > > >  #ifdef CONFIG_SMP
> > > >  	free_percpu(s->s_files);
> > > >  #endif
> > > 
> > > Hi
> > > 
> > > Thanks for taking a look at this.
> > > 
> > > list_lru_destroy is called by deactivate_lock_super, so we should be fine already.
> > 
> > Sorry, I'm a little confused...
> > 
> > I didn't see list_lru_destroy() called in deactivate_locked_super().
> > Maybe I missed something? 
> 
> Err... the code in my tree reads:
> 
>         unregister_shrinker(&s->s_shrink);
>         list_lru_destroy(&s->s_dentry_lru);
>         list_lru_destroy(&s->s_inode_lru);
>         put_filesystem(fs);
>         put_super(s);
> 
> But then I have just checked Andrew's, and it is not there - thank you.
> 
> Andrew, should I send a patch for you to fold it ?
> 
> 
> > 
> > But it seems other memory allocated in alloc_super(), are freed in
> > destroy_super(), e.g. ->s_files, why don't we also free this one here? 
> Because we want this close to unregister_shrinker, it is a more natural
> location for this.

OK, I see. However, in some rare cases, destroy_super() might be called
in a row with alloc_super(), e.g. in sget(), if !test and err when set()
the fs private info. 

By the way, there is memory allocated in register_shrinker() based on
nr_node_ids, so maybe we need to free it in unregister_shrinker()? Maybe
that's already covered in the deferred part.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
