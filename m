From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/4] cgroup: Allow bypass mode in subtree_control
Date: Tue, 25 Jul 2017 13:13:44 -0400
Message-ID: <20170725171343.GB3216015@devbig577.frc2.facebook.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-3-git-send-email-longman@redhat.com>
 <20170722135030.GC3329631@devbig577.frc2.facebook.com>
 <3cf09046-7eac-82fe-8bd2-6aef1125b10c@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cf29bDclH3IOXV64L9jZJbX3iMBxzJXGBoGYU4VXQX4=;
        b=Eav0sfO8ExyF3CUj5HnbGWlpqmupo3KI25RiK+ufZSnuiZirOP5haL6TDk5B/qqWDj
         4iFv8VJhgEAo2ERIH8Xt2JmmqgXaodBB2k2mKOdvwKzqQE8a2OXG9VHYnbdk+M6efIus
         h2HgzuW9KZE+rF4SVs7mhf5vMQFuLBPOzLV7g/jWdX9ax0z9I9IMx2hAYzo9oHpKiCg8
         4+OTkKotxbFo9xpQOALAJNNOucbIO0o06jYsUUp0J+vDNtUo8c3d76PKxL/u8LE5hS/W
         FFvWJ/ggUdvU1AGQVzihxsXQbWDZS2DrYAWZr1SUCln7wjn97FkLXXqeuWsgqIUG3iPv
         DATg==
Content-Disposition: inline
In-Reply-To: <3cf09046-7eac-82fe-8bd2-6aef1125b10c@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Waiman.

On Mon, Jul 24, 2017 at 02:20:59PM -0400, Waiman Long wrote:
> As said in patch 3, enabling bypass mode at subtree_control delegate the
> authority of enabling controllers to the children. The children own the
> resource control files directly. It will be more straight forward to

But that doesn't work at all because such child would end up
controlling the distribution of an ancestor's resources.  It breaks a
fundamental property of the hierarchy.

> explain if bypass mode can only be used consistently from the root down.
> Having a mix of regular enable and bypass down the tree will be more
> tricky to talk about.

Hmmm... it isn't just being tricky.  As proposed, it is in direct
conflict with the basic semantics of the resource hierarchy.

> > * While the idea is interesting, I think we need more concrete
> >   usecases to justify the addition and make sure that we aren't doing
> >   something misguided.  Can you please illustrate / give examples of
> >   how this would be useful?
> 
> Bypass mode targets mainly non-domain controllers and controllers that
> have cost associated with each additional level of hierarchy (e.g. cpu).
> I believe the end goal of cgroup v2 is to have all controllers migrated
> to it eventually. Consider the following:
> 
>     A
>    / \
>   B   C
>  / \ / \
> D  E F G
> 
> Controller X may want (A, B, C) to be controlled as one group with one
> set of control files whereas D, E, F, G will have their own control
> files. Controller Y may want all of them have their own control files.
> Bypass mode allows us to do that. With more and more controllers enabled
> in v2, the chance of this kind of configuration conflicts is going up.

I think I understand what it wants to do but I think it's still
lacking justfications given how invasive the change is to the basic
operation and usage.  We need more than one can think of this and it
can help with certain hypothetical use cases.  ie. along the line of
what the actual use cases are, what our overhead looks like and why,
and why the problem can't be solved in a different, hopefully less
intrusive, way.

Thanks.

-- 
tejun
