From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Date: Thu, 18 Oct 2012 14:14:34 -0700
Message-ID: <20121018211434.GI13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2xh9RUbJfuqRDj58gBzDPcDRgzcStUYblBSADkz/2hQ=;
        b=Mw15TM3bnOynYznm8FvTprPcJL28hIKg3DJu8wgTC1SgWA82asfz8bH1p5cv4wzsa4
         TddBZUZrWChCYcqVQYHbBIfD01qVVmsiKyjc7bSXJaJEocFY4vrnLQWaBn6M6gD1os0m
         bgUa/ZVYEuvB4o7lkYZIlbZm9W5UXk68PoZJ0iiXdmDQu01vBM3cxtAU0rM0BcJ729G9
         JaxicjqVPVL3/MZlHvs4+L7dG2vrt9NPgBAyTiSujw8m7acBfUeZc/Vtbo0CHryAUmrs
         8VqLSdZFOfV+GWrW6XOwnu6mPcNXpbr8bkqBeYP2VyJGyJjkxX7sTLVax9ylhbdK92P+
         lKAQ==
Content-Disposition: inline
In-Reply-To: <20121017191606.GA6223-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Helsley <matthltc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Matt.

On Wed, Oct 17, 2012 at 12:16:06PM -0700, Matt Helsley wrote:
> > * Unfreezable kernel tasks don't prevent a cgroup from transitioning
> >   into FROZEN from FREEZING.  There's nothing userland can do with or
> >   about such tasks.
> 
> Seems like a non-problem. Do you have a testcase showing how kernel
> threads prevent cgroups that should be freezable from being frozen?
> It used to be that you couldn't move kernel threads out of the root
> cgroup and the root cgroup was not freezable. So this was never a
> problem before. Is there some change here that I'm unaware of?

Hmmm?  Nothing prevents kthreads from being moved around.  We only
recently added the restriction to prevent migration of the kthreadd
(the one which creates other kthreads).  You can reproduce it with
khungtask or any other !freezable kthreads.

> > * Tasks can be moved in and out of a frozen cgroup.  Tasks are made to
> >   conform to the state of the new cgroup during migration.  This
> >   behavior makes a lot more sense and removes the use of
> >   ->can_attach() which makes co-mounting difficult.
> 
> One nice aspect of freezing the set of tasks in the cgroup as well as the
> tasks themselves was you had a fixed set of tasks to work with (from
> userspace or otherwise). With this change that will no longer be true.
> This is a userspace-visible behavior change and userspace code may
> have relied on this feature.
>
> Will this work for the CRIU folks? With this patch one of the tasks being
> checkpointed could become thawed simply by some other process writing
> the pid into a different cgroup's tasks file. In contrast, with the
> current code they'd have to explicitly thaw its cgroup first.

Yeap, this is a userland visible behavior change.  Don't see any other
way around it tho and if you can't prevent someone else moving things
in/out of your cgroup, what prevents someone else echoing THAWED to
freezer.state?

As for CRIU, it isn't using cgroup freezer at the moment because
frozen tasks can't be ptraced currently.  Something I'm hoping to
change but not sure when it can be done.

Thanks.

-- 
tejun
