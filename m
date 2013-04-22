From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Mon, 22 Apr 2013 11:30:20 -0700
Message-ID: <20130422183020.GF12543@htj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
 <20130421022321.GE19097@mtj.dyndns.org>
 <20130421124554.GA8473@dhcp22.suse.cz>
 <20130422043939.GB25089@mtj.dyndns.org>
 <20130422151908.GF18286@dhcp22.suse.cz>
 <20130422155703.GC12543@htj.dyndns.org>
 <20130422162012.GI18286@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=fpDnU2e/x3gB4QRz8WoingerIQ9ObrbhQi7mteiCszE=;
        b=ocMO12mU2WG2B/w6Y2YF/mh+JDs2B2emqhbUWzPyBbpIIrNtd5QCBDCsIEb2OywXyJ
         bNVEOu5wONGGUcPp6NpYx+2XoL0UZcv7nFeq1PbXbMQgdNmVoegOtfO0Rx56dn0vYud5
         4VFnkQHNcWxc3YDpKWL8Nw7MfzDs+KYQIknZyKiiS21wBPAUA4kAeOJv99EsEYJtEgpk
         WZO4mFohNSF/L7/5LFDmQUTNShrE1AbYbPlasbg07QVEwTlksQfCQWEdaM5s2VtlMyZp
         WcAsfMT0gUkpLBPsXe4n/HlMqV3MU5qmRT05P75jYRrpiQcL41QW4KlxyCkwUwP+Qzxj
         EiBA==
Content-Disposition: inline
In-Reply-To: <20130422162012.GI18286-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hey,

On Mon, Apr 22, 2013 at 06:20:12PM +0200, Michal Hocko wrote:
> Although the default limit is correct it is impractical for use
> because it doesn't allow for "I behave do not reclaim me if you can"
> cases. And we can implement such a behavior really easily with backward
> compatibility and new interfaces (aka reuse the soft limit for that).

Okay, now we're back to square one and I'm reinstating all the mean
things I said in this thread. :P No wonder everyone is so confused
about this.  Michal, you can't overload two controls which exert
pressure on the opposite direction onto a single knob and define a
sane hierarchical behavior for it.  You're making it a point control
rather than range one.  Maybe you can define some twisted rules
serving certain specific use case, but it's gonna be confusing /
broken for different use cases.

You're so confused that you don't even know you're confused.

> I am approaching this from a simple perspective. Reclaim from everybody

No, you're just thinking about two immediate problems you're given and
trying to jam them into something you already have not realizing those
two can't be expressed with a single knob.

> who doesn't care about the soft limit (it hasn't been set for that
> group) or who is above the soft limit. If that is sufficient to meet the
> reclaim target then there is no reason to touch groups that _do_ care
> about soft limit and they are under. Although this doesn't give you
> any guarantee it can give a certain prioritization for groups in the
> overcommit situations and that is what soft limit was intended for from
> the very beginning.

For $DEITY's sake, soft limit should exert reclaim pressure.  That's
it.  If a group is over limit, it'll feel *extra* pressure until it's
back to the limit.  Once under the limit, it should be treated equally
to any other tasks which are under the limit including the ones
without any softlimit configured.  It is not different from hardlimit.
There's nothing "interesting" about it.

Even for flat hierarchy, with your interpretation of the knob, it is
impossible to say "I don't really care about this thing, if it goes
over 30M, hammer on it", which is a completely reasonable thing to
want.

> > And, if people want a mechanism for isolation / lessening of pressure,
> > which looks like a valid use case to me, add another knob for that
> > which is prioritized under both hard and soft limits.  That is the
> > only sensible way to do it.
> 
> No, please no yet another knob. We have too many of them already. And
> even those that are here for a long time can be confusing as one can
> see.

Yes, sure, knobs are hard, let's combine two controls in the opposite
directions into one.

That is the crux of the confusion - trying to combine two things which
can't and shouldn't be combined.  Just forget about the other thing or
separate it out.  Please take a step back and look at it again.
You're really epitomizing the confusion on this subject.

Thanks.

-- 
tejun
