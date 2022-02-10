From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/4] memcg: unify force charging conditions
Date: Thu, 10 Feb 2022 15:15:26 -0800
Message-ID: <YgWcjv/D7wy4dxXR@carbon.dhcp.thefacebook.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
 <20220210081437.1884008-3-shakeelb@google.com>
 <YgVvgCbbTrDPb5tT@carbon.dhcp.thefacebook.com>
 <CALvZod5FBEHzNcXD-Wo5BPmMxu+Kf-ZA8s6N9EmD6TeFocs3_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dRAJShx2hNO0nyEkkCJ86DsNPM8DCyUoDPBpOJEvCrE=;
 b=XrB//CH81dyKQsDU1oGkGeFcUVezb2Pppcu+KajuL2ZNnkTsfopf8yn+tXir7wvfn6p7
 MjULMJ8mCCql3Rf7pqNUEpCfp9PIbr3E7xsIlmIaiha59q4v87VhTlmNz5v1slO+VKJ8
 yFyIlItRpyah9AlCgeoMZ88kFs5gZZ+4Ygs= 
Content-Disposition: inline
In-Reply-To: <CALvZod5FBEHzNcXD-Wo5BPmMxu+Kf-ZA8s6N9EmD6TeFocs3_w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Feb 10, 2022 at 02:25:01PM -0800, Shakeel Butt wrote:
> On Thu, Feb 10, 2022 at 12:03 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Feb 10, 2022 at 12:14:35AM -0800, Shakeel Butt wrote:
> > > Currently the kernel force charges the allocations which have __GFP_HIGH
> > > flag without triggering the memory reclaim. __GFP_HIGH indicates that
> > > the caller is high priority and since commit 869712fd3de5 ("mm:
> > > memcontrol: fix network errors from failing __GFP_ATOMIC charges") the
> > > kernel let such allocations do force charging. Please note that
> > > __GFP_ATOMIC has been replaced by __GFP_HIGH.
> > >
> > > __GFP_HIGH does not tell if the caller can block or can trigger reclaim.
> > > There are separate checks to determine that. So, there is no need to
> > > skip reclaim for __GFP_HIGH allocations. So, handle __GFP_HIGH together
> > > with __GFP_NOFAIL which also does force charging.
> >
> > This sounds very reasonable. But shouldn't we check if __GFP_DIRECT_RECLAIM
> > is set and bail out otherwise?
> >
> 
> We already have a gfpflags_allow_blocking() check which checks for
> __GFP_DIRECT_RECLAIM.

Indeed. Please, feel free to add
Reviewed-by: Roman Gushchin <guro@fb.com> to the patch.

Thank you!
