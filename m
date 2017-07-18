From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 19:28:01 +0200
Message-ID: <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6x8BF3x7ZUtpdadnDcXZhEBsHy3itFBE4fLUnIf40gQ=; b=H25bTidgeMdkYdBBZn3L1Ko+l
        D1cIXQmW477G+OVuZ5/Nq5VYxMu4AF+rc4jv0Ui1vfnfRJUWXrSGvfKfRWGNMVp+8XR1swxypOXsL
        ZwKbm9lVQXk5C4KIlnqCFP3JugasOKNhlf0XUFvWjjI+lt6/+gbvH4Eeut4Qj293CY7jJqfmJpV8s
        y3S/TEKQGh3DPFjFY2mGkTEdunvUNSkVC+Jn4HavF0NaFX6R/lYgtsWvKZ+WTg4ifoxLvxsN8LoaP
        55FwxVRLR2IfGQEtKEMvYzBDl3zb4WET/6QNDDr0kE48DwcKvySI2ZSoli275ua00K2Qk50Ny83v5
    
Content-Disposition: inline
In-Reply-To: <20170717142609.GC3519177@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Mon, Jul 17, 2017 at 10:26:09AM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Mon, Jul 17, 2017 at 04:14:09PM +0200, Peter Zijlstra wrote:
> > AFAICT this is not in fact what I suggested... :/
> 
> Heh, sorry about misattributing that.  I was mostly referring to the
> overall idea of marking each cgroup domain or threaded rather than
> subtree.
> 
> > My proposal did not have that invalid state. It would simply refuse to
> > change the type from thread to domain in the case where the parent is
> > not a domain.
> > 
> > Also, my proposal maintained the normal property inheritance rules. A
> > child cgroup's creation 'type' would be that of its parent and not
> > always be 'domain'.
> 
> But aren't both of the above get weird when the parent can host both
> domain and threaded children?
> 
> 	  R
>        /
>       A(D)
> 
> If you create another child B under R, it's naturally gonna be a
> domain.  Let's say you turn that to threaded.
> 
> 	   R
>        /   \
>      A(D) B(T)
> 
> And now try to create another child C, should that be a domain or
> threaded?

Domain of course, as R must be a domain, and hence all its children
start out as such.

> If we only inherit from the second level on, which is in itself
> already confusing, that still leads to invalid configs for non-root
> thread roots.

I don't see how. I don't get the example Waiman gave, what is wrong
with:

	R (D)
	|
	A (D)
       / \
     C(D) B(T) 

? Afaict that's a perfectly valid configuration.



