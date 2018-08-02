From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/9] mm: workingset: tell cache transitions from
 workingset thrashing
Date: Thu, 2 Aug 2018 08:38:13 -0400
Message-ID: <20180802123813.GB17974@cmpxchg.org>
References: <20180801151308.32234-1-hannes@cmpxchg.org>
 <20180801151308.32234-3-hannes@cmpxchg.org>
 <c0480401-fb38-0b46-6dee-a20093dff065@sony.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ww2pzuKtFDKODo5ZENXYe4CkMdcQjkPC4MbTGXtAZ7M=;
        b=0PzBxk9k/YOO8ruxcsVMLaCTLjWlOZR7eAT3rBqCYvtO4hdI42yHj50FFE+dUt6R0K
         DlnyOIsdsnTYxViyPZ9pVGI032zWiXAK0h3c83rKOkQwxAWWSw+0n+XOgooAFriBF2zR
         u4mh978kjDsIb8Jb0xwH5FkEcny6Q/ARiYKLh56pFrtRA8tnUmV9FaUPJbOcYO++C7BR
         w03Kh95ZjTSe7G81X1aF9npuFl1eHfRMXuy+H7TM+Y9Kd5JEXb0aAGVfPleckX05+8Nj
         gqYNME6BKxphrKbBmq+hde8SWbuaiXx/Guo24FpNRaTgTVHvJXCix7Whq7HGAdPIZ5vs
         EzMg==
Content-Disposition: inline
In-Reply-To: <c0480401-fb38-0b46-6dee-a20093dff065@sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <peter.enderborg@sony.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Aug 02, 2018 at 08:57:31AM +0200, peter enderborg wrote:
> On 08/01/2018 05:13 PM, Johannes Weiner wrote:
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index e34a27727b9a..7af1c3c15d8e 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -69,13 +69,14 @@
> >   */
> >  enum pageflags {
> >  	PG_locked,		/* Page is locked. Don't touch. */
> > -	PG_error,
> >  	PG_referenced,
> >  	PG_uptodate,
> >  	PG_dirty,
> >  	PG_lru,
> >  	PG_active,
> > +	PG_workingset,
> >  	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
> > +	PG_error,
> >  	PG_slab,
> >  	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
> >  	PG_arch_1,
> > @@ -280,6 +281,8 @@ PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
> Any reason why the PG_error was moved? And dont you need to do some handling of this flag in proc/fs/page.c ?
> Some KFP_WORKINGSET ?

I wanted PG_workingset next to PG_active as they both describe how hot
the page is, but PG_waiters needs to remain with the same bit number.

As far as fs/proc/page.c and include/uapi/linux/kernel-page-flags.h
go, that's a good point and we'll probably want to make that available
to userspace eventually. But I'm not super eager to make a brandnew
page flag user ABI right away. Let's give the code that uses it some
wider exposure first and maybe publish it a few release cycles later.

Thanks
