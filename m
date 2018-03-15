From: Roman Gushchin <guro@fb.com>
Subject: Re: [patch -mm v3 1/3] mm, memcg: introduce per-memcg oom policy
 tunable
Date: Thu, 15 Mar 2018 17:10:41 +0000
Message-ID: <20180315171039.GB1853@castle.DHCP.thefacebook.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803121757080.192200@chino.kir.corp.google.com>
 <20180314123851.GB20850@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.20.1803141341180.163553@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=TuYyzSs4QI7LDJ4b+yc7ZikBkG8ry3Wq6XbQHnZ/eW0=;
 b=fQlg87fSxbd41xZnALIpYiOxF7h0uccj34WgTC/DmyZQGwsmSRMUgM3n+InZIK0Mo+N4
 4tJpy+7NR6xzbvXAijzIk886gpzI5HGIxxeQ7VpPxhW7TFAQrgPpJjiHBq7U9ZspWkzz
 Fz70Y3+a3F15cx+3svayuUfmiPO2I9UgU8M= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TuYyzSs4QI7LDJ4b+yc7ZikBkG8ry3Wq6XbQHnZ/eW0=;
 b=a+yL8Teswijd89ZfMXUAuco8exdyTBqBjCmGAAmYeCPwyRqSj1XSVtPu8d0b9e6O3XrH+1J9Kr6LlARUDNoNQ09F8k932HUaK/orkYAeKlFc9VO3HKqFZAda3vJ+kZW9zrbHa8eZs99Mu3KVk/JgEyd5AekPbl5f7SqORjvSrkQ=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1803141341180.163553@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello, David!

On Wed, Mar 14, 2018 at 01:58:59PM -0700, David Rientjes wrote:
> On Wed, 14 Mar 2018, Roman Gushchin wrote:
>  - Does not lock the entire system into a single methodology.  Users
>    working in a subtree can default to what they are used to: per-process
>    oom selection even though their subtree might be targeted by a system
>    policy level decision at the root.  This allow them flexibility to
>    organize their subtree intuitively for use with other controllers in a
>    single hierarchy.
> 
>    The real-world example is a user who currently organizes their subtree
>    for this purpose and has defined oom_score_adj appropriately and now
>    regresses if the admin mounts with the needless "groupoom" option.

I find this extremely confusing.

The problem is that OOM policy defines independently how the OOM
of the corresponding scope is handled, not like how it prefers
to handle OOMs from above.

As I've said, if you're inside a container, you can have OOMs
of different types, depending on settings, which you don't even know about.
Sometimes oom_score_adj works, sometimes not.
Sometimes all processes are killed, sometimes not.
IMO, this adds nothing but mess.

The mount option (which I'm not a big fan of too) was added only
to provide a 100% backward compatibility, what was forced by Michal.
But I doubt that mixing per-process and per-cgroup approach
makes any sense.

> 
>  - Allows changing the oom policy at runtime without remounting the entire
>    cgroup fs.  Depending on how cgroups are going to be used, per-process 
>    vs cgroup-aware may be mandated separately.  This is a trait only of
>    the mem cgroup controller, the root level oom policy is no different
>    from the subtree and depends directly on how the subtree is organized.
>    If other controllers are already being used, requiring a remount to
>    change the system-wide oom policy is an unnecessary burden.
> 
>    The real-world example is systems software that either supports user
>    subtrees or strictly subtrees that it maintains itself.  While other
>    controllers are used, the mem cgroup oom policy can be changed at
>    runtime rather than requiring a remount and reorganizing other
>    controllers exactly as before.

Btw, what the problem with remounting? You don't have to re-create cgroups,
or something like this; the operation is as trivial as adding a flag.

> 
>  - Can be extended to cgroup v1 if necessary.  There is no need for a
>    new cgroup v1 mount option and mem cgroup oom selection is not
>    dependant on any functionality provided by cgroup v2.  The policies
>    introduced here work exactly the same if used with cgroup v1.
> 
>    The real-world example is a cgroup configuration that hasn't had
>    the ability to move to cgroup v2 yet and still would like to use
>    cgroup-aware oom selection with a very trivial change to add the
>    memory.oom_policy file to the cgroup v1 filesystem.

I assume that v1 interface is frozen.

Thanks!
