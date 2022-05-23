From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Mon, 23 May 2022 15:50:34 -0700
Message-ID: <CAJD7tkYwv2LDZeV2F5pxuniw7LCNjBapDCm3WuRhzwTH-jN3PA@mail.gmail.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz> <87zgjcg4xs.fsf@vajain21.in.ibm.com> <YodDaFVeU33bu7yQ@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNZwUkKZtlmZ14jNWylohEgLi2zUCj6Z0VWU+7uDZNM=;
        b=r+jnJOIBusH635WqI8fbwufkzACI9oCjiSIfKUDvHLseBJPHh9vUSZlWtwSH8Sydl+
         p0/3xnIcp17otnrYR/qZYEtr6fCmmo/gji7kOUYPP6UyvM1lhwAZhAh+PfEezkRw1I+b
         0l+aqABzU+E1xxYyggSXp2yt3nt7hQt8aIVYsfT0XMAZIcoUsbXMGNq3dYHqcSyQidme
         Y+uNXLp/WE5SR/6z9aJrefZIBRRQrknYRS8H+rvGVbIqlCI6X3PKndf5zmU9QieV6U0v
         r4hmfFl33JKtb0OxMQi2LHy5P1cGQYOlOTDCinO58dnFAPIIEWMTyKmgebufRzp65StN
         2U6g==
In-Reply-To: <YodDaFVeU33bu7yQ@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>

On Fri, May 20, 2022 at 12:29 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Fri 20-05-22 10:45:43, Vaibhav Jain wrote:
> >
> > Thanks for looking into this patch Michal,
> >
> > Michal Hocko <mhocko@suse.com> writes:
> >
> > > On Thu 19-05-22 04:08:15, Vaibhav Jain wrote:
> > >> [1] Provides a way for user-space to trigger proactive reclaim by introducing
> > >> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
> > >> of pages scanned and reclaimed is still not directly available to the
> > >> user-space.
> > >>
> > >> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
> > >> readable which returns the number of pages scanned / reclaimed during the
> > >> reclaim process from 'struct vmpressure' associated with each memcg. This should
> > >> let user-space asses how successful proactive reclaim triggered from memcg
> > >> 'memory.reclaim' was ?
> > >>
> > >> With the patch following command flow is expected:
> > >>
> > >>  # echo "1M" > memory.reclaim
> > >>
> > >>  # cat memory.reclaim
> > >>    scanned 76
> > >>    reclaimed 32
> > >
> > > Why cannot you use memory.stat? Sure it would require to iterate over
> > > the reclaimed hierarchy but the information about scanned and reclaimed
> > > pages as well as other potentially useful stats is there.
> >
> > Agree that "memory.stat" is more suitable for scanned/reclaimed stats as
> > it already is exposing bunch of other stats.
> >
> > The discussion on this patch however seems to have split into two parts:
> >
> > 1. Is it a good idea to expose nr_scanned/nr_reclaimed to users-space
> > and if yes how ?
> >
> > IMHO, I think it will be better to expose this info via 'memory.stat' as it
> > can be useful insight into the reclaim efficiency  and vmpressure.
>
> We already do that with some more metrics
> pgrefill 9801926
> pgscan 27329762
> pgsteal 22715987
> pgactivate 250691267
> pgdeactivate 9521843
> pglazyfree 0
> pglazyfreed 0
>
> > 2. Will it be useful to provide feedback to userspace when it writes to
> > 'memory.reclaim' on how much memory has been reclaimed ?
> >
> > IMHO, this will be a useful feeback to userspace to better adjust future
> > proactive reclaim requests via 'memory.reclaim'
>
> How precise this information should be? A very simplistic approach would
> be
> cp memory.stat stats.before
> echo $WHATEVER > memory.reclaim
> cp memory.stat stats.after
>
> This will obviously contain also activity outside of the explicitly
> triggered reclaim (racing background/direct reclaim) but isn't that what
> actually matters? Are there any cases where the only metric you care
> about is the triggered reclaim in isolation?

I think it might be useful to have a dedicated entry in memory.stat
for proactively reclaimed memory. A case where this would be useful is
tuning and evaluating userspace proactive reclaimers. For instance, if
a userspace agent is asking the kernel to reclaim 100M, but it could
only reclaim 10M, then most probably the proactive reclaimer is not
using a good methodology to figure out how much memory do we need to
reclaim.

IMO this is more useful, and a superset of just reading the last
reclaim request status through memory.reclaim (read stat before and
after).

Additionally, things get complicated if the userspace agent is
multi-threaded. For a cumulative entry in memory.stat, it shouldn't
matter by a lot as we are looking at the total for all threads
cumulatively anyway. If we are only reading the memory reclaimed in
the last request (through memory.reclaim), then we can easily get the
results of a request that happened on a different thread.

>
> --
> Michal Hocko
> SUSE Labs
