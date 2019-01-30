From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 14:30:26 -0500
Message-ID: <20190130193026.GA21410@cmpxchg.org>
References: <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz>
 <20190129145240.GX50184@devbig004.ftw2.facebook.com>
 <20190130165058.GA18811@dhcp22.suse.cz>
 <20190130170658.GY50184@devbig004.ftw2.facebook.com>
 <CALvZod5ma62fRKqrAhMcuNT3GYT3FpRX+DCmeVr2nDg1u=9T8w@mail.gmail.com>
 <20190130192712.GA21279@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u4lGJa1eqm311IjOZIxyEEk5pH4RS2fwSIKRlT/c2bc=;
        b=MBC71ieoROyzpJYMm/RoM48yebOSHThzuo7d3oPiagXJfjLAD5AOCg12b0GXqJMHgo
         byQdg6fKygYXahH3gh70/beX8rcnd9A2w876UhzSUZRp1EC54kTTM02cUEIHzQF34GZP
         9/ViuRdoaByPgSw4yx6n4p8Dlns+T5Pw4L87bee6Hw8nuxjJXB+l8mHHb+lYM9bSEsYh
         p5FehOxBq3izQVdqa3zLxdA2sCUSafZvMUY7D91qtNGspuKGT1tm/XhwTSyKShEMwbNq
         n0dQ3h57xSEY0s45uLv7teLyVuciOaDK0y8LFHR9WeANLuoFKihiVwRYKw4TT3+TpzQm
         g2Mg==
Content-Disposition: inline
In-Reply-To: <20190130192712.GA21279@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, kernel-team@fb.com

On Wed, Jan 30, 2019 at 02:27:12PM -0500, Johannes Weiner wrote:
> On Wed, Jan 30, 2019 at 11:11:44AM -0800, Shakeel Butt wrote:
> > Hi Tejun,
> > 
> > On Wed, Jan 30, 2019 at 9:07 AM Tejun Heo <tj@kernel.org> wrote:
> > >
> > > Hello, Michal.
> > >
> > > On Wed, Jan 30, 2019 at 05:50:58PM +0100, Michal Hocko wrote:
> > > > > Yeah, cgroup.events and .stat files as some of the local stats would
> > > > > be useful too, so if we don't flip memory.events we'll end up with sth
> > > > > like cgroup.events.local, memory.events.tree and memory.stats.local,
> > > > > which is gonna be hilarious.
> > > >
> > > > Why cannot we simply have memory.events_tree and be done with it? Sure
> > > > the file names are not goin to be consistent which is a minus but that
> > > > ship has already sailed some time ago.
> > >
> > > Because the overall cost of shitty interface will be way higher in the
> > > longer term.  cgroup2 interface is far from perfect but is way better
> > > than cgroup1 especially for the memory controller.  Why do you think
> > > that is?
> > >
> > 
> > I thought you are fine with the separate interface for the hierarchical events.
> 
> Every other file in cgroup2 is hierarchical, but for recursive
> memory.events you'd need to read memory.events_tree?
> 
> Do we hate our users that much? :(

FTR, I would be okay with adding .local versions to existing files
where such a behavior could be useful. But that seems to be a separate
discussion from fixing memory.events here.
