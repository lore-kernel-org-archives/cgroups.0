From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Thu, 25 Sep 2014 15:07:16 +0200
Message-ID: <20140925130716.GE12090@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144158.GC20398@esperanza>
 <20140922185736.GB6630@cmpxchg.org>
 <20140923110634.GH18526@esperanza>
 <20140923132801.GA14302@cmpxchg.org>
 <20140923152150.GL18526@esperanza>
 <20140923170525.GA28460@cmpxchg.org>
 <20140924141633.GB4558@dhcp22.suse.cz>
 <20140924170017.GB9968@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VwAveKYE6/kEjMm51QczSkm962a/TGy8SXv0O4HXiL4=;
        b=yZtGssROXaW+3gn9BrLj0amvCcrpAYU3MFxKtOJD2aS6iQ7da9NfbDv/VGtAsPPv8N
         9ZScmzvKNx9D40HTK2dAongzR1VJaqLdUZFECffpfBE6pFSo5ZI97xzaa96jm2YG6TXj
         S62wRm66YVXat5kEE5gxYmrIcpW39mUj+nSMavjxRC+rxJtGgeCFz11rV+iRdAlSmjCg
         A1cV7wkhMLs1CYOzhc1OefA2ldNU5ofV4h1NGQtvFAHS1pW/a4m0oO++Rs+va2m2Ojtr
         dhxzg1Mo2TX3iAn14B/LVSwcIxNDxvwPxoaUzDyQgvrHUtgv1U8uctnxuVrOGWcrpp3X
         5YzA==
Content-Disposition: inline
In-Reply-To: <20140924170017.GB9968@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 24-09-14 13:00:17, Johannes Weiner wrote:
> On Wed, Sep 24, 2014 at 04:16:33PM +0200, Michal Hocko wrote:
> > On Tue 23-09-14 13:05:25, Johannes Weiner wrote:
> > [...]
> > >  #include <trace/events/vmscan.h>
> > >  
> > > -int page_counter_sub(struct page_counter *counter, unsigned long nr_pages)
> > > +/**
> > > + * page_counter_cancel - take pages out of the local counter
> > > + * @counter: counter
> > > + * @nr_pages: number of pages to cancel
> > > + *
> > > + * Returns whether there are remaining pages in the counter.
> > > + */
> > > +int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
> > >  {
> > >  	long new;
> > >  
> > >  	new = atomic_long_sub_return(nr_pages, &counter->count);
> > >  
> > > -	if (WARN_ON(unlikely(new < 0)))
> > > -		atomic_long_set(&counter->count, 0);
> > > +	if (WARN_ON_ONCE(unlikely(new < 0)))
> > > +		atomic_long_add(nr_pages, &counter->count);
> > >  
> > >  	return new > 0;
> > >  }
> > 
> > I am not sure I understand this correctly.
> > 
> > The original res_counter code has protection against < 0 because it used
> > unsigned longs and wanted to protect from really disturbing effects of
> > underflow I guess (this wasn't documented anywhere). But you are using
> > long so even underflow shouldn't be a big problem so why do we need a
> > fixup?
> 
> Immediate issues might be bogus numbers showing up in userspace or
> endless looping during reparenting.  Negative values are just not
> defined for that counter, so I want to mitigate exposing them.
> 
> It's not completely leak-free, as you can see, but I don't think it'd
> be worth weighing down the hot path any more than this just to
> mitigate the unlikely consequences of kernel bug.
> 
> > The only way how we can end up < 0 would be a cancel without pairing
> > charge AFAICS. A charge should always appear before uncharge
> > because both of them are using atomics which imply memory barriers
> > (atomic_*_return). So do I understand correctly that your motivation
> > is to fix up those cancel-without-charge automatically? This would
> > definitely ask for a fat comment. Or am I missing something?
> 
> This function is also used by the uncharge path, so any imbalance in
> accounting, not just from spurious cancels, is caught that way.
> 
> As you said, these are all atomics, so it has nothing to do with
> memory ordering.  It's simply catching logical underflows.

OK, I think we should document this in the changelog and/or in the
comment. These things are easy to forget...

Thanks!

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
