From: Li Zhong <lizhongfs@gmail.com>
Subject: Re: [PATCH v11 25/25] list_lru: dynamically adjust node arrays
Date: Thu, 20 Jun 2013 08:50:23 +0800
Message-ID: <1371689423.2555.1.camel@ThinkPad-T5421>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
	 <1370550898-26711-26-git-send-email-glommer@openvz.org>
	 <1371548521.2984.6.camel@ThinkPad-T5421>
	 <20130619073154.GA1990@localhost.localdomain>
	 <1371633148.2984.18.camel@ThinkPad-T5421>
	 <20130619132904.GA4031@localhost.localdomain>
	 <20130619101414.49da3bfb.akpm@linux-foundation.org>
Reply-To: lizhongfs@gmail.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=BVDGfluM56Je27AQzW+9bohXuY5yTpGvSeGcVIVmmbw=;
        b=QqBVmP9/zf+/LKTL5q6WPkFstP/XOLAJur9FKVhZZs67MKlIOkuQy2pCX00BboHL9a
         w2/MHb7GB83tZVcnsRBhbWCKkYScwrOHtFl40vpWvPl9rQofVZ6YfbwKnDHTDT5psRkG
         YsVwUEXMEUrFcpB4sm9gl4jhmNC6OSGV4t9P+5l6/j2QhV4cZvvCV467vuaLtMp1bPTk
         QiKsIfo2jAwyxztfMIekEXsKGFdEd+V8bLyj0ePefpIFIkA5TKVq7CnRO87J3z47pf0F
         w1D2Qv+QXUTfcvtruUo17ZbgzCVIo3FnZzMuy8rRJXKUTBzEa9oDfrM4nXQDu1aeo3fm
         Xg2Q==
In-Reply-To: <20130619101414.49da3bfb.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@gmail.com>, Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, Dave Chinner <dchinner@redhat.com>

On Wed, 2013-06-19 at 10:14 -0700, Andrew Morton wrote:
> On Wed, 19 Jun 2013 17:29:06 +0400 Glauber Costa <glommer@gmail.com> wrote:
> 
> > > > Thanks for taking a look at this.
> > > > 
> > > > list_lru_destroy is called by deactivate_lock_super, so we should be fine already.
> > > 
> > > Sorry, I'm a little confused...
> > > 
> > > I didn't see list_lru_destroy() called in deactivate_locked_super().
> > > Maybe I missed something? 
> > 
> > Err... the code in my tree reads:
> > 
> >         unregister_shrinker(&s->s_shrink);
> >         list_lru_destroy(&s->s_dentry_lru);
> >         list_lru_destroy(&s->s_inode_lru);
> >         put_filesystem(fs);
> >         put_super(s);
> > 
> > But then I have just checked Andrew's, and it is not there - thank you.
> 
> That is added by "super: targeted memcg reclaim", which is in the part
> of the series which we decided to defer.

Oh, yes, there it is. Sorry for the noise ...

> 
> > Andrew, should I send a patch for you to fold it ?
> 
> Sure.  Perhaps you could check for any other things which should be
> brought over from the not-merged-yet patches?
> 


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
