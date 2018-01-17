From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 0/4] mm, memcg: introduce oom policies
Date: Wed, 17 Jan 2018 14:31:57 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801171420330.86895@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com> <20180117114554.GA10523@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=v1OMpfyd6ig+oV9abpCwzGg5UfpnthQS44uBBpZmCDQ=;
        b=objYMY12q2YA36S5JAwvbRplj7nE2N2GUI43+7dG3EtjNk7I7NYvcTls7oblCz84C/
         9f+0HSOZzL3zh1MQssCVj77Grr8QFHCxfb2Svvlu/godhBCZKpuCYk9C+N5yDiNOCuxc
         sr8EuHryxzRNDaQ46V7r26BE11AoH0GOAQimNn1Tl/nrx5DdUqDpILslBCeI+xhZ736r
         2CBWK2lxSHPPkldZRs8aKjhei30Fyy2ymx6bvP/h9UmTncG8PV0qD25RI0dHDv1cDokp
         OG+lWpmVsDW3uqIwce+ab//mVysQ1MoLVk28y2pQ4nS6a5VxuegFbzo92zCJ62ehxync
         gM6A==
In-Reply-To: <20180117114554.GA10523@castle.DHCP.thefacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 17 Jan 2018, Roman Gushchin wrote:

> You're introducing a new oom_policy knob, which has two separate sets
> of possible values for the root and non-root cgroups. I don't think
> it aligns with the existing cgroup v2 design.
> 

The root mem cgroup can use "none" or "cgroup" to either disable or 
enable, respectively, the cgroup aware oom killer.  These are available to 
non root mem cgroups as well, with the addition of hierarchical usage 
comparison to prevent the ability to completely evade the oom killer by 
the user by creating sub cgroups.  Just as we have files that are made 
available on the root cgroup and not others, I think it's fine to allow 
only certain policies on the root mem cgroup.  As I wrote to Tejun, I'm 
fine with the policy being separated from the mechanism.  That can be 
resolved in that email thread, but the overall point of this patchset is 
to allow hierarchical comparison on some subtrees and not on others.  We 
can avoid the mount option in the same manner.

> For the root cgroup it works exactly as mount option, and both "none"
> and "cgroup" values have no meaning outside of the root cgroup. We can
> discuss if a knob on root cgroup is better than a mount option, or not
> (I don't think so), but it has nothing to do with oom policy as you
> define it for non-root cgroups.
> 

It certainly does have value outside of the root cgroup: for system oom 
conditions it is possible to choose the largest process, largest single 
cgroup, or largest subtree to kill from.  For memcg oom conditions it's 
possible for a consumer in a subtree to define whether it wants the 
largest memory hogging process to be oom killed or the largest of its 
child sub cgroups.  This would be needed for a job scheduler in its own 
subtree, for example, that creates its own subtrees to limit jobs 
scheduled by individual users who have the power over their subtree but 
not their limit.  This is a real-world example.  Michal also provided his 
own example concerning top-level /admins and /students.  They want to use 
"cgroup" themselves and then /students/roman would be forced to "tree".

Keep in mind that this patchset alone makes the interface extensible and 
addresses one of my big three concerns, but the comparison of the root mem 
cgroup compared to other individual cgroups and cgroups maintaining a 
subtree needs to be fixed separately so that we don't completely evade all 
of these oom policies by using /proc/pid/oom_score_adj in the root mem 
cgroup.  That's a separate issue that needs to be addressed.  My last 
concern, about userspace influence, can probably be addressed after this 
is merged by yet another tunable since it's vital that important cgroups 
can be protected.  It does make sense for an important cgroup to be able 
to use 50% of memory without being oom killed, and that's impossible if 
cgroup v2 has been mounted with your mount option.
