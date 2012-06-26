From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
Date: Mon, 25 Jun 2012 22:23:59 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206252212370.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-10-git-send-email-glommer@parallels.com> <20120625182907.GF3869@google.com> <4FE8E7EB.2020804@parallels.com> <20120625162158.cde295bf.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=htgvX5DBpwzJ4FcrCEEc5TP8UkAQZcznvfV28dQxEog=;
        b=QL8fbPHuhUKHeN8mOwO4rwn+zo94LyJ0uRDEiiYyREBLG1ztcLpzW+XMyxciGbwlGp
         vd/IyBCJyIfiZts6ARcHaBuRlkv4EHH+fNqkcIBKG2lpu4v9eM8mYH4zlx/KBAV/CAqy
         dfebLwOtb/f46X/r220taWRwx62lN43JHbFDpS2AHS7xqIv9TyZPihAnGxaF/9WrCgfz
         /WHTyu1/dRVW4FlJ8tEybNXSYuamBSfcQ7slDB4PI7E7eKb4/uG6V/yU/NhKcysXMf8U
         AuZlQlLsfUTS5mCnN6Z1n+FznnA/JpTCbYE2Lni7Quk2VI4TN0H9G2h3TUyufEBLS4c5
         ycjw==
In-Reply-To: <20120625162158.cde295bf.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Mon, 25 Jun 2012, Andrew Morton wrote:

> > >>   	 */
> > >>   	bool use_hierarchy;
> > >> -	bool kmem_accounted;
> > >> +	/*
> > >> +	 * bit0: accounted by this cgroup
> > >> +	 * bit1: accounted by a parent.
> > >> +	 */
> > >> +	volatile unsigned long kmem_accounted;
> > >
> > > Is the volatile declaration really necessary?  Why is it necessary?
> > > Why no comment explaining it?
> > 
> > Seems to be required by set_bit and friends. gcc will complain if it is 
> > not volatile (take a look at the bit function headers)
> 
> That would be a broken gcc.  We run test_bit()/set_bit() and friends
> against plain old `unsigned long' in thousands of places.  There's
> nothing special about this one!
> 

No version of gcc would complain about this, even with 4.6 and later with 
-fstrict-volatile-bitfields, it's a qualifier that determines whether or 
not the access to memory is the exact size of the bitfield and aligned to 
its natural boundary.  If the type isn't qualified as such then it's 
simply going to compile to access the native word size of the 
architecture.  No special consideration is needed for a member of 
struct mem_cgroup.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
