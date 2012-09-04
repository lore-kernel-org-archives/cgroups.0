From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Tue, 4 Sep 2012 15:09:06 +0200
Message-ID: <20120904130905.GA15683@dhcp22.suse.cz>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com>
 <20120903170806.GA21682@dhcp22.suse.cz>
 <5045BD25.10301@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5045BD25.10301-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue 04-09-12 12:34:45, Glauber Costa wrote:
> On 09/03/2012 09:08 PM, Michal Hocko wrote:
> > On Mon 03-09-12 19:46:51, Glauber Costa wrote:
> >> Here is a new attempt to lay down a path that will allow us to deprecate
> >> the non-hierarchical mode of operation from memcg.  Unlike what I posted
> >> before, I am making this behavior conditional on a Kconfig option.
> >> Vanilla users will see no change in behavior unless they don't
> >> explicitly set this option to on.
> > 
> > Which is the reason why I don't like this approach. Why would you enable
> > the option in the first place? If you know the default should be 1 then
> > you would already do that via cgconfig or directly, right?
> > I think we should either change the default (which I am planning to do
> > for the next OpenSUSE) or do it slow way suggested by Tejun.
> > We really want to have as big testing coverage as possible for the
> > default change and config option is IMHO not a way to accomplish this.
> > 
> 
> Not sure you realize, Michal, but you actually agree with me and my
> patch, given your reasoning.

I do agree with the default change, all right, but I really don't like
the config option because that one will not help us that much.

> If you plan to change it in OpenSUSE, you have two ways of doing so:
> You either carry a patch, which as simple as this is, is always
> undesirable, or you add one line to your distro config. Pick my patch,
> and do the later.

I would have to care the patch anyway until the distro kernel moves to
a kernel which has the patch which won't happen anytime soon (at least
from distro POV) and I guess we want the testing coverage as long as
possible.

> This patch does exactly the "do it slowly" thing, but without
> introducing more churn, like mount options.

Not really. Do it slowly means that somebody actually _notices_ that
something is about to change and they have a lot of time for that. This
will be really hard with the config option saying N by default.  People
will ignore that until it's too late.
We are interested in those users who would keep the config default N and
they are (ab)using use_hierarchy=0 in a way which is hard/impossible to
fix. This is where distributions might help and they should IMHO but why
to put an additional code into upstream? Isn't it sufficient that those
who would like to help (and take the risk) would just take the patch?

> Keep in mind that since
> there is the concern that direct upstream users won't see a sudden
> change in behavior, *every* way we choose to do it will raise the same
> question you posed: "Why would you enable this in the first place?" Be
> it a Kconfig, mount option, etc. The solution here is: Direct users of
> upstream kernels won't see a behavior change - as requested - but
> distributors will have a way to flip it without carrying a non-upstream
> patch.

The patch is so small that I do not care having it without being
upstream. Do others care that much?
The consequences of the semantic change is what matters much more to me.

[...]
-- 
Michal Hocko
SUSE Labs
