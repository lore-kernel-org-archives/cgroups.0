From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 11:11:44 -0800
Message-ID: <CALvZod5ma62fRKqrAhMcuNT3GYT3FpRX+DCmeVr2nDg1u=9T8w@mail.gmail.com>
References: <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz> <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz> <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz> <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz> <20190129145240.GX50184@devbig004.ftw2.facebook.com>
 <20190130165058.GA18811@dhcp22.suse.cz> <20190130170658.GY50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M4j223sTiX4eMGkNGmN1WWkhqrWqcQOSV+aX1N0vGfU=;
        b=azkJLUZ8/StL/5E53v70C5unuQk4f6Ciqs5ZgN9hYqf0WgprVCpGmJfw35DSNFFigH
         JVmOK/jHtzt8P/JqqIEwed/TX1ZFf0ud6XffSASmHI6C8ghY79KgnZYb6Isd5RNkClua
         FQaIW69ilbPoeutkgd0gm95mrYy1COvWQrd88dpMGnxQ/PkebF5X5yUvjgS2yoSNBlUN
         OM0upjn5ctZEGvNWDVcPkYrC2dDtFHVzqK69UsO8y+FvOF106czYSuDNEtf1vGESZlVM
         koBSwBSPYR2tcLjlCvJxtcRP7SRjAYCkyAf0Ruy8coYoG1kClerdGq0mQntTghNaeEoZ
         /Hsg==
In-Reply-To: <20190130170658.GY50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, kernel-team@fb.com

Hi Tejun,

On Wed, Jan 30, 2019 at 9:07 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Michal.
>
> On Wed, Jan 30, 2019 at 05:50:58PM +0100, Michal Hocko wrote:
> > > Yeah, cgroup.events and .stat files as some of the local stats would
> > > be useful too, so if we don't flip memory.events we'll end up with sth
> > > like cgroup.events.local, memory.events.tree and memory.stats.local,
> > > which is gonna be hilarious.
> >
> > Why cannot we simply have memory.events_tree and be done with it? Sure
> > the file names are not goin to be consistent which is a minus but that
> > ship has already sailed some time ago.
>
> Because the overall cost of shitty interface will be way higher in the
> longer term.  cgroup2 interface is far from perfect but is way better
> than cgroup1 especially for the memory controller.  Why do you think
> that is?
>

I thought you are fine with the separate interface for the hierarchical events.

https://lkml.kernel.org/r/20190128161201.GS50184@devbig004.ftw2.facebook.com

Is that not the case?

Shakeel
