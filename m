From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: memcg: softlimit on internal nodes
Date: Fri, 19 Apr 2013 17:26:20 -0700
Message-ID: <20130420002620.GA17179@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:mime-version
         :content-type:content-disposition:user-agent;
        bh=XzIzz1goVOuKk7zdh5EOADF0MzbAQSZlkzrZCpPtoco=;
        b=Q0CFi8TZXaPMAUoOIx7WfgFBRVJiOtLnr6nW3RzdpNlcWZcWRN8/QQvt38l0a6ckuO
         UwAdvMqdx5QVQ/TjqZtTc1VCN0lrhPjAxxtZkd4E6EWB908ijTQtNBf17eo+ee4cdn4R
         D8dMK6vyvNnWkDZelvKfZD+De8/1TORpInlgtJ/mEbDkTQBByfjxySaRElYPN86JKqjp
         gQzBptWCbkAjGsxEfn8jATmUEa1wkoJEI0Rm/Z6S2cHDN83hyAqF/gqNZFiMN1tK6lxk
         0rNiARLaIE8QoEcrruAKdrxNIOywkEUjA7wKquR+TfF+bMTfgtXCGqFqny++sgjjWJ6a
         O/gg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Michal and all.

Sorry about asking silly questions and leaving in the middle.  I had a
plane to catch which I just barely made.  I thought about it on the
way here and your proposal seems confused.

I think the crux of the confusion comes from the fact that you're
essentially proposing flipping the meaning of the knob for internal
nodes - it means minmum guaranteed allocation - that is, the shrinker
won't bother the cgroup if the memory consumption is under the
softlimit - and your proposal is to reverse that for cgroups with
children so that it actually means "soft" limit - creating pressure if
above the limit (IIUC, it isn't entirely that either as the pressure
is created iff the whole system is under memory pressure, right?).

Regardless of the direction of a configuration, a parent cgroup should
gate that configuration in the same direction.  ie. If it's a limit
for a leaf node when reached, it also is an limit for the whole
subtree for an internal cgroup.  If it's a configuration which
guarantees allocation (in the sense that it'll be excluded in memory
reclaim if under limit), the same, if the subtree is under limit,
reclaim shouldn't trigger.

For example, please consider the following hierarchy where s denotes
the "softlimit" and h hardlimit.

      A (h:8G s:4G)
     /            \
    /              \
 B (h:5G s:1G)    C (h:5G s:1G)

For hard limit, nobody seems confused how the internal limit should
apply - If either B or C goes over 5G, the one going over that limit
will be on the receiving end of OOM killer.  Also, even if both B and
C are individually under 5G, if the sum of the two goes over A's limit
- 8G, OOM killer will be activated on the subtree.  It'd be a policy
decision whether to kill tasks from A, B or C, but the no matter what
the parent's limit will be enforced in the subtree.  Note that this is
a perfectly valid configuration.  It is *not* an invalid
configuration.  It is exactly what the hierarchical configuration is
supposed to do.

It must not be any different for "softlimit".  If B or C are
individually under 1G, they won't be targeted by the reclaimer and
even if B and C are over 1G, let's say 2G, as long as the sum is under
A's "softlimit" - 4G, reclaimer won't look at them.  It is exactly the
same as hardlimit, just the opposite direction.

Now, let's consider the following hierarchy just to be sure.  Let's
assume that A itself doesn't have any tasks for simplicity.

      A (h:16G s:4G)
     /            \
    /              \
 B (h:7G s:5G)    C (h:7G s:5G)

For hardlimit, it is clear that A's limit won't do anything.  No
matter what B and C do.  In exactly the same way, A's "softlimit"
doesn't do anything regardless of what B and C do.  Just like A's
hardlimit doesn't impose any further restrictions on B and C, A's
softlimit doesn't give any further guarantee to B and C.  There's no
difference at all.

Now, it's completely silly that "softlimit" is actually allocation
guarantee rather than an actual limit.  I guess it's born out of
similar confusion?  Maybe originally the operation was a confused mix
of the two and it moved closer to guaranteeing behavior over time?

Anyways, it's apparent why actual soft limit - that is something which
creates reclaim pressure even when the system as whole isn't under
memory pressure - would be useful, and I'm actually kinda surprised
that it doesn't already exist.  It isn't difficult to imagine use
cases where the user doesn't want certain services/applications (say
backup, torrent or static http server serving large files) to not
consume huge amount of memory without triggering OOM killer.  It is
something which is fundamentally useful and I think is why people are
confused and pulling the current "softlimit" towards something like
that.

If such actual soft limit is desired (I don't know, it just seems like
a very fundamental / logical feature to me), please don't try to
somehow overload "softlimit".  They are two fundamentally different
knobs, both make sense in their own ways, and when you stop confusing
the two, there's nothing ambiguous about what what each knob means in
hierarchical situations.  This goes the same for the "untrusted" flag
Ying told me, which seems like another confused way to overload two
meanings onto "softlimit".  Don't overload!

Now let's see if this gogo thing actually works.

Thanks.

--
tejun
