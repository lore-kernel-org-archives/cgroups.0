From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Mon, 17 Jul 2017 10:26:09 -0400
Message-ID: <20170717142609.GC3519177@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BmCqRZh9H08raT8AFjfI63RjjWRJgFuc9J4VQIFqG9s=;
        b=vdkxR7PleCxtnYDBYdqnsWpl1KS+nI+6mDH6apWiaXTUoB97Oa5VdKFwHm3Au5OkCq
         wO/K2Xg1tEQKZBpljT1WDFQQxQpGEjkiKzT0ebio2kF8NqYZkBDUZS/sJGLYweg8bsZA
         ESmnggRJ419egAIrH3JEc8lSh7OL2X3d05wilCNF4KdLP65XfmAoSCUM0wl7qY7qNEcG
         C/ed9rL71OC5kSFZwQuSIjqNDbssQL0IpatL5zgHu+MqsiE3JoIUez54wcp+XfVxaJfN
         HCdJ+UtRXbKaMjN1FcC8+/QpdUpw0l1T1CRLWrmLHgvcpVAmOJ/WarRsWTODIGz77iBz
         SRyw==
Content-Disposition: inline
In-Reply-To: <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Peter.

On Mon, Jul 17, 2017 at 04:14:09PM +0200, Peter Zijlstra wrote:
> AFAICT this is not in fact what I suggested... :/

Heh, sorry about misattributing that.  I was mostly referring to the
overall idea of marking each cgroup domain or threaded rather than
subtree.

> My proposal did not have that invalid state. It would simply refuse to
> change the type from thread to domain in the case where the parent is
> not a domain.
> 
> Also, my proposal maintained the normal property inheritance rules. A
> child cgroup's creation 'type' would be that of its parent and not
> always be 'domain'.

But aren't both of the above get weird when the parent can host both
domain and threaded children?

	 R
       / 
      A(D)

If you create another child B under R, it's naturally gonna be a
domain.  Let's say you turn that to threaded.

	 R
       /   \
     A(D) B(T)

And now try to create another child C, should that be a domain or
threaded?

If we only inherit from the second level on, which is in itself
already confusing, that still leads to invalid configs for non-root
thread roots.

I don't think whether we fail the transition or put the cgroup in an
invalid state is all that material.  The simpler the better.

> Let me read more (and more careful) to see if there's other things.

Sure thing.

Thanks!

-- 
tejun
