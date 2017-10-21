From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct
 cgroup_root
Date: Sat, 21 Oct 2017 08:32:53 -0700
Message-ID: <20171021153253.GG1302522@devbig577.frc2.facebook.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
 <20171018133010.GD1302522@devbig577.frc2.facebook.com>
 <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BfFfPt8KuhOdKW1s4OU/URnjGDCe2CzbaF/zjhwjWzo=;
        b=ZjGSWhTEXfKBIMXdO1TQu2yGLN8seydnSqxVfgXdWgOpW3GQq6JlF3aNEsXtMLUKKC
         0AuCg6FDzqeVrKM/5PnaxvTh1cOgvYXyogR9BQzTWH+Y4UMDHRjRtDxMFoBVE6UigCdq
         iO3+AA6UJMcverOEbXdrZPDxCyEecyTS2AmQy+SblOqtFtrrnDmB8NXXwBDOBd/qsPSz
         0lhp2Lfh5LTssF+AVPNZJ8OV93+76m6EhhYHTQooT8uYFu3GcC3Cw+BrXLvbBVXgServ
         XTaBSHiFzGjjE9TAQDc6O2jtLiNFpM3y8ofspWlTUlJuIj+br2B7ZXrRD0vVfkXtmT2I
         p++w==
Content-Disposition: inline
In-Reply-To: <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, android-llvm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello, Nick.

On Fri, Oct 20, 2017 at 12:15:55AM -0700, Nick Desaulniers wrote:
> > This is silly tho.  We know the the root group embedded there won't
> > have any ancestor_ids.
> 
> Sure, but struct cgroup_root is still declared as having a struct
> cgroup not declared as the final member.

Why is that a problem tho?  We know that it doesn't have any flexible
array member so there's no storage allocated to it.

> > Also, in general, nothing prevents us from
> > doing something like the following.
> >
> >         struct outer_struct {
> >                 blah blah;
> >                 struct inner_struct_with_flexible_array_member inner;
> >                 unsigned long storage_for_flexible_array[NR_ENTRIES];
> >                 blah blah;
> >         };
> 
> At that point, then why have the struct with flexible array member in
> the first place?

Because there are different ways to use the struct?

> >> or specific location of the member cgrp within struct cgroup_root AFAICT.
> > I think we should just silence the bogus warning.
> 
> Is the order of the members actually important?  Otherwise it seems
> that we're taking advantage of a GNU C extension for no real reason,
> which is what I'm trying to avoid.  Please reconsider.

Here, not necessarily but I don't want to move it for a bogus reason.
Why would we disallow embedding structs with flexible members in the
middle when it can be done and is useful?  If we want to discuss
whether we want to avoid such usages in the kernel (but why?), sure,
let's have that discussion but we can't decide that on "clang warns on
it by default".

Thanks.

-- 
tejun
