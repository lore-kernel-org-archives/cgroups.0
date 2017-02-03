From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 3 Feb 2017 15:59:55 -0500
Message-ID: <20170203205955.GA9886@mtj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CgVtg+HW+jlycZwcNN3ikKC4FamuFJHStZ8y6VSLb/c=;
        b=ett5/tck4RKcYgf2YOZs15Ixnp7mddE7jBJf30PuhsiWxnncrmGNCUeKP1QdYZ7byC
         4PYa8Hwc5DSPF1S1Dmfrjh/Fu62UefOMKTVah9nM8sSxv8tvzWsNo5apDE/NzOPJskcC
         +G6CxQ2wPzvfXmmt6o0PNwRedTjpoG3mxaj5KunLENIIfSJg0j5wH4NBpwNLZ83eY3to
         CD9vNXciGpZIZZNdqQ51QELMhabrvFLHUheT+GS4vp2BXoG26g6U4P5856PCtNQin8Oa
         YhgOAjdDLncN+Cexq7oINSEjcAjrivz4HeRR3kc5wEq4aQIwFr0cuzLpWB9fwjMUsu9X
         tB/A==
Content-Disposition: inline
In-Reply-To: <20170203202048.GD6515-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello, Peter.

On Fri, Feb 03, 2017 at 09:20:48PM +0100, Peter Zijlstra wrote:
> So my proposal was to do the inverse of what you propose here. Instead
> of marking special 'thread' subtrees, explicitly mark resource domains
> in the tree.
> 
> So always allow arbitrary hierarchies and allow threads to be assigned
> to cgroups, as long as they're all in the same resource domain.
> 
> Controllers that do not support things, fallback to mapping everything
> to the nearest resource domain.

That sounds counter-intuitive as all controllers can do resource
domains and only a subset of them can do thread mode.  Also, thread
subtrees are necessarily a sub-hierarchy of a resource domain.  Also,
expanding resource domains from the root after the trees are populated
would make the behaviors surprising as the resource domains that these
subtrees belong to would change dynamically.

In practice, how would this work?  To enable memcg, the user has to
first create the subtree and then explicitly have to make that a
domain and then enable memcg?  If so, that would be a completely
unnecessary deviation from the current behavior while not achieving
any more functionalities, right?  It's just flipping the default value
the other way around and the default wouldn't be supported by many of
the controllers.  I can't see how that is a better option.

Thanks.

-- 
tejun
