From: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Mon, 22 Apr 2013 00:14:53 -0700
Message-ID: <CANN689F7X1X4i1M=nteGan0POdVbBMu0xviuWN70f_BTv==3eA@mail.gmail.com>
References: <20130420002620.GA17179@mtj.dyndns.org>
	<20130420031611.GA4695@dhcp22.suse.cz>
	<20130421022321.GE19097@mtj.dyndns.org>
	<CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
	<20130422042445.GA25089@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=tDwcg/1ekR43tNbAa+wY6dxaQ/aeyjoLhZ2EGUuyqqo=;
        b=pX9EPdEsP3/n+mui1OlRqTL0L6q+JJQ43LDqU+Dpil7JSsqzFjqgkkTuzZW9JSzXVY
         J8yTB5J+Oc9nEHl1kk+VNLV0hCJ5WFRk5SROgZVTFot1VCtREjeSPcB3sjrR3qkdx/cg
         +R8TrPFP31t0U5aM7x815XPHp8EZsg7R7najTprImZLPhlpk3FWdwLdQr60nEDsrtnig
         WSFXIJXna3nSKybiSTD7XN+aBCvxHXFlRQHUkBrGMWvfmIgRJTASb6tCeeG4+eMJ/ScB
         9gByTUNEoo0TY2DlEEvsFUDpcB4jqePaEMglGoeDzJi2M5jyYBsLAV0vhdaEXSfTk7mj
         FMCQ==
In-Reply-To: <20130422042445.GA25089-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Sun, Apr 21, 2013 at 9:24 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hey, Michel.
>
>> I don't remember exactly when you left - during the session I
>> expressed to Michal that while I think his proposal is an improvement
>> over the current situation, I think his handling of internal nodes is
>> confus(ed/ing).
>
> I think I stayed until near the end of the hierarchy discussion and
> yeap I heard you saying that.

All right. Too bad you had to leave - I think this is a discussion we
really need to have, so it would have been the perfect occasion.

>>> > Now, let's consider the following hierarchy just to be sure.  Let's
>>> > assume that A itself doesn't have any tasks for simplicity.
>>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> >
>>> >       A (h:16G s:4G)
>>> >      /            \
>>> >     /              \
>>> >  B (h:7G s:5G)    C (h:7G s:5G)
>>> >
>>> > For hardlimit, it is clear that A's limit won't do anything.
>>
>> One thing some people worry about is that B and C's configuration
>> might be under a different administrator's control than A's. That is,
>> we could have a situation where the machine's sysadmin set up A for
>> someone else to play with, and that other person set up B and C within
>> his cgroup. In this scenario, one of the issues has to be how do we
>> prevent B and C's configuration settings from reserving (or protecting
>> from reclaim) more memory than the machine's admin intended when he
>> configured A.
>
> Cgroup doesn't and will not support delegation of subtrees to
> different security domains.  Please refer to the following thread.
>
>   http://thread.gmane.org/gmane.linux.kernel.cgroups/6638

Ah, good. This is news to me. To be clear, I don't care much for the
delegation scenario myself, but it's always been mentioned as the
reason I couldn't get what I want when we've talked about hierarchical
soft limit behavior in the past. If the decision not to have subtree
delegation sticks, I am perfectly happy with your proposal.

> And I don't even get the delegation argument.  Isn't that already
> covered by hardlimit?  Sure, reclaimer won't look at it but if you
> don't trust a cgroup it of course will be put under certain hardlimit
> from parent and smacked when it misbehaves.  Hardlimit of course
> should have priority over allocation guarantee and the system wouldn't
> be in jeopardy due to a delegated cgroup misbehaving.  If each knob is
> given a clear meaning, these things should come naturally.  You just
> need a sane pecking order among the controls.  It almost feels surreal
> that this is suggested as a rationale for creating this chimera of a
> knob.  What the hell is going on here?

People often overcommit the cgroup hard limits so that one cgroup can
make use of a larger share of the machine when the other cgroups are
idle.
This works well only if you can depend on soft limits to steer reclaim
when the other cgroups get active again.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
