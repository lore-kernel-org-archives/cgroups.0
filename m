From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: reorder flexible array members of struct
 cgroup_root
Date: Thu, 26 Oct 2017 07:32:22 -0700
Message-ID: <20171026143222.GC59538@devbig577.frc2.facebook.com>
References: <20171017063322.11455-1-nick.desaulniers@gmail.com>
 <20171018133010.GD1302522@devbig577.frc2.facebook.com>
 <CAH7mPvjksNSDo4o=z51YkH4yX+gDnGXU-g59gTkOUS-pEva8sA@mail.gmail.com>
 <20171021153253.GG1302522@devbig577.frc2.facebook.com>
 <20171025215423.GD96615@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ao7zjrFIb05LN2KpYmW4A8M+sXjp68pkB6o5fTh80L4=;
        b=ND3pmhYchSbSIfgTM1yA4GFV5UHGm9aueG4VVFUOy0oZBomDFQH8Vh5kfRUt1TqvSa
         UceLMZU0EYUA0C62xjPjb4JXRNIVqD5epfN7hSJYES/ms+udo6dRuvb0ex7Ptvs268Eb
         Mn6aYzEGf2Tn/QWLuPPLerdIVh3xNMqGhA/o54Sc6Vb0lwtvkNkrKMDpcYzWmFb+x62/
         5EYqcEYMgw7S8dZD9XOr9wRwUaMsUZmb4cPNcEMC2/W1Ul854vdPAfXJN8F1hVflYs3y
         CBmg49112NV+zspg3mxAEkXyCORdjrl/7H30lyX9XoXtUgRV+AFARf7IVUFLTvR8PEig
         NLiw==
Content-Disposition: inline
In-Reply-To: <20171025215423.GD96615-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Nick Desaulniers <nick.desaulniers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, android-llvm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

On Wed, Oct 25, 2017 at 02:54:23PM -0700, Matthias Kaehlcke wrote:
> From your earlier comment I understand that there is no problem in
> this case because we know that cgroup_root->cgrp will always be
> empty.
> 
> However in other instances the warning could point out actual errors
> in the code, so I think it is good to have this warning generally
> enabled. If cgroup_root was defined in a .c file we could consider to
> disable the warning locally, but since the definition is in a header
> that is widely included (indirectly through linux/cgroup.h and
> net/sock.h) this doesn't seem to be an option.
> 
> Is there a good reason for the current position of cgrp within
> cgroup_root? If there are no drawbacks in moving it to the end of
> the struct I think Nick's patch is a reasonable solution.

This all sounds really bogus to me.  Let's say we have something like
the following.

  struct flex_struct {
  	int array[];
  };

And the following two usages.

1.

  struct flex_struct *fs =
	kmalloc(sizeof(struct flex_struct) + N * sizeof(int));

2.

  struct enclosing_struct es {
	struct flex_struct fs;
	int fs_array_storage[N];
  };

  struct enclosing_struct *es =
	kmalloc(sizeof(struct enclosing_struct));

So, you're saying #1 is okay but #2 is not, which is just silly.  The
compiler can't warn correctly about flex array members whether they're
embedded or not.  Nothing prevents somebody accessing beyond N in #1
either.

This effort seems really pointless to me.  Let's please not waste any
more bandwidth on this.

Thanks.

-- 
tejun
