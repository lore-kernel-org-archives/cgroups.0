From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] slub: show dead memcg caches in a separate file
Date: Mon, 7 May 2012 15:04:39 -0700
Message-ID: <CABCjUKDuiN6bq6rbPjE7futyUwTPKsSFWHXCJ-OFf30tgq5WZg@mail.gmail.com>
References: <1336070841-1071-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=aZPjm3bOIeXtqXWpsPD1x1MlXA18N1PfszYxQZpuVkE=;
        b=aSuIn9Z+BUNH0w9+TRChch6wNsy8vPh1IGhgRZPvq+mMFn0VjsF/7XGNVqmm9q+bEx
         RbYxGz2GQ3ZWJv1JE1ExcxHCJEQFhz6TZ6mvYmf2KnmqYKahqn5wPgeCxX6y/lKoHDR2
         D7i/X7O/S1P02AbLHBykmba4vYo5Ni8zj2pyAV8PgkQz/Vqhb1kyzKGyX8P4xm6M1On6
         mc3TrEyHb1xIkr1uj09EEMHi0HnO4NuRMAfjaHBizK3qPTWY56avjSkcqzpeA5OVOe9j
         SYaYF7Xv/9Fk9qIOqKkS29S96ytr5VbN5MDMmM4RYc+Z4BCrwKY7LDxBkBkP/BCQ3TOI
         MOtg==
In-Reply-To: <1336070841-1071-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, May 3, 2012 at 11:47 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> One of the very few things that still unsettles me in the kmem
> controller for memcg, is how badly we mess up with the
> /proc/slabinfo file.
>
> It is alright to have the cgroup caches listed in slabinfo, but once
> they die, I think they should be removed right away. A box full
> of containers that come and go will rapidly turn that file into
> a supreme mess. However, we currently leave them there so we can
> determine where our used memory currently is.
>
> This patch attempts to clean this up by creating a separate proc file
> only to handle the dead slabs. Among other advantages, we need a lot
> less information in a dead cache: only its current size in memory
> matters to us.
>
> So besides avoiding polution of the slabinfo files, we can access
> dead cache information itself in a cleaner way.
>
> I implemented this as a proof of concept while finishing up
> my last round for submission. But I am sending this separately
> to collect opinions from all of you. I can either implement
> a version of this for the slab, or follow any other route.

I don't really understand why the "dead" slabs are considered as
polluting slabinfo.

They still have objects in them, and I think that hiding them would
not be the right thing to do (even if they are available in a separate
file): They will incorrectly not be seen by programs like slabtop.

-- Suleiman
