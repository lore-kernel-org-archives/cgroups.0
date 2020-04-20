From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Mon, 20 Apr 2020 12:47:40 -0400
Message-ID: <20200420164740.GF43469@mtj.thefacebook.com>
References: <20200417010617.927266-1-kuba@kernel.org>
 <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
 <20200417162355.GA43469@mtj.thefacebook.com>
 <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TjZ2graq0CtbJ4vJTNn/oAWOw1/1F8FNfwmQNPt9wa0=;
        b=XZe8/pJP5Ci59jBCcI4vjJUBjJ/qqUnKCbvnrKJDBpcQnAhfg9sTYkWX9gcwIKjM9C
         d5Q+ermqNPUmdDFJFmJjsEQotzwMmRBj1XckNvwIl2igOcYtZHKlOFcSjsEZBfgdCM6k
         rJlWeEIrSJD5yAd0hUje27rl8Pvo+bOrYmGMg3267iRVFj7tIAyy8xM0J5b1E3tzSHWW
         3YrLLe7/r6VzLXf/wCS8/mFhxI3ZPF/cgjOhLUOTpWuE7zCKm5LFMfdgv9rHnrakNPFf
         WZ5QgXqAxjnEj6bvLR5moEpVc2iOhjHCEozH1S7gn6YK28SK/+6AM63miAUDUN3wL0XZ
         vdNA==
Content-Disposition: inline
In-Reply-To: <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Apr 20, 2020 at 09:12:54AM -0700, Shakeel Butt wrote:
> I got the high level vision but I am very skeptical that in terms of
> memory and performance isolation this can provide anything better than
> best effort QoS which might be good enough for desktop users. However,

I don't see that big a gap between desktop and server use cases. There sure
are some tolerance differences but for majority of use cases that is a
permeable boundary. I believe I can see where you're coming from and think
that it'd be difficult to convince you out of the skepticism without
concretely demonstrating the contrary, which we're actively working on.

A directional point I wanna emphasize tho is that siloing these solutions
into special "professional" only use is an easy pitfall which often obscures
bigger possibilities and leads to developmental dead-ends and obsolescence.
I believe it's a tendency which should be actively resisted and fought
against. Servers really aren't all that special.

> for a server environment where multiple latency sensitive interactive
> jobs are co-hosted with multiple batch jobs and the machine's memory
> may be over-committed, this is a recipe for disaster. The only
> scenario where I think it might work is if there is only one job
> running on the machine.

Obviously, you can't overcommit on any resources for critical latency
sensitive workloads whether one or multiple, but there also are other types
of workloads which can be flexible with resource availability.

> I do agree that finding the right upper limit is a challenge. For us,
> we have two types of users, first, who knows exactly how much
> resources they want and second ask us to set the limits appropriately.
> We have a ML/history based central system to dynamically set and
> adjust limits for jobs of such users.
> 
> Coming back to this path series, to me, it seems like the patch series
> is contrary to the vision you are presenting. Though the users are not
> setting memory.[high|max] but they are setting swap.max and this
> series is asking to set one more tunable i.e. swap.high. The approach
> more consistent with the presented vision is to throttle or slow down
> the allocators when the system swap is near full and there is no need
> to set swap.max or swap.high.

It's a piece of the puzzle to make memory protection work comprehensively.
You can argue that the fact swap isn't protection based is against the
direction but I find that argument rather facetious as swap is quite
different resource from memory and it's not like I'm saying limits shouldn't
be used at all. There sure still are missing pieces - ie. slowing down on
global depletion, but that doesn't mean swap.high isn't useful.

Thanks.

-- 
tejun
