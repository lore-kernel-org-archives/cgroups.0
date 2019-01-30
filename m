From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 14:23:45 -0500
Message-ID: <20190130192345.GA20957@cmpxchg.org>
References: <20190123223144.GA10798@chrisdown.name>
 <20190124082252.GD4087@dhcp22.suse.cz>
 <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6+s3m/wCiQicI56EM9O8sUfe7ZO8/YgchrGdD+iAv9I=;
        b=ccNxnvT224O+7fChZ7Efge3FO8zKw7BrWhwJ7vtYCw2pMhdgeAnuGSy0ooAgXBO//i
         RZodYsnJPpMtZAmiD6BTOM2ZmYll6e8Tx/HpFylbwTK5qpdK3HKp6c8tm3vGNFD5i3eG
         8JiePIfFf14/NPKu2oWsFcTO4Wmr0VywSvdt7lcrunvnDALgrasx6zXTVrEFmG2x+muA
         aIOTrYjcVAI1Zqden7mXBJepzBhvBMPxAagdov+uqKm15pG4iFf8eEdJtEwm3GOlHOKT
         pgPErx42/P7qtYmr8UalnjLRF0Ek8ydI72C2ok/il/IB0bsnSgpJg/sO8ZnlzCxjp1kE
         11Ow==
Content-Disposition: inline
In-Reply-To: <20190128125151.GI18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Mon, Jan 28, 2019 at 01:51:51PM +0100, Michal Hocko wrote:
> On Fri 25-01-19 10:28:08, Tejun Heo wrote:
> > On Fri, Jan 25, 2019 at 06:37:13PM +0100, Michal Hocko wrote:
> > > Please note that I understand that this might be confusing with the rest
> > > of the cgroup APIs but considering that this is the first time somebody
> > > is actually complaining and the interface is "production ready" for more
> > > than three years I am not really sure the situation is all that bad.
> > 
> > cgroup2 uptake hasn't progressed that fast.  None of the major distros
> > or container frameworks are currently shipping with it although many
> > are evaluating switching.  I don't think I'm too mistaken in that we
> > (FB) are at the bleeding edge in terms of adopting cgroup2 and its
> > various new features and are hitting these corner cases and oversights
> > in the process.  If there are noticeable breakages arising from this
> > change, we sure can backpaddle but I think the better course of action
> > is fixing them up while we can.
> 
> I do not really think you can go back. You cannot simply change semantic
> back and forth because you just break new users.
> 
> Really, I do not see the semantic changing after more than 3 years of
> production ready interface. If you really believe we need a hierarchical
> notification mechanism for the reclaim activity then add a new one.

This discussion needs to be more nuanced.

We change interfaces and user-visible behavior all the time when we
think nobody is likely to rely on it. Sometimes we change them after
decades of established behavior - for example the recent OOM killer
change to not kill children over parents.

The argument was made that it's very unlikely that we break any
existing user setups relying specifically on this behavior we are
trying to fix. I don't see a real dispute to this, other than a
repetition of "we can't change it after three years".

I also don't see a concrete description of a plausible scenario that
this change might break.

I would like to see a solid case for why this change is a notable risk
to actual users (interface age is not a criterium for other changes)
before discussing errata solutions.
