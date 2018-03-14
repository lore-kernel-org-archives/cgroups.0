From: Roman Gushchin <guro@fb.com>
Subject: Re: [patch -mm v3 1/3] mm, memcg: introduce per-memcg oom policy
 tunable
Date: Wed, 14 Mar 2018 12:38:52 +0000
Message-ID: <20180314123851.GB20850@castle.DHCP.thefacebook.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803121757080.192200@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Dy6puvisM2mT62ReAIi2nSU52U2txJ2w1dbH9f40fEg=;
 b=DBbk0wmOCYBD2OR3DKdhyjHL2jFD8r2fqT0/pell33AmXWjS9gKsng4xUDrrVYKz6F1N
 ctiJ4MvyLFPZPpZcTZpxx3A2U/Fhg6y8Z03IJ3LPFqnLE9kaJILERBRXTcXSPF+XjEmR
 zhOPa+C2A7TJdO0XRRKLUX0Qwz15hmCcrVo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Dy6puvisM2mT62ReAIi2nSU52U2txJ2w1dbH9f40fEg=;
 b=jqUvSzIgRFSokSeO98iVpDiB5LC6YoNXGZnEcFJtczyG1/0+nFKQhP9At3U9r3GeprKiuf0n/p5Mg4HWciShp6m4RANSTlv5wZ07Ye6M9QDrgwQYJV2ilDnadqIylpeaH1KDvu26kPFNSPL9ha/IScqPBESsrVFLhP7MIcOUoSA=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1803121757080.192200@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, Mar 12, 2018 at 05:57:53PM -0700, David Rientjes wrote:
> The cgroup aware oom killer is needlessly enforced for the entire system
> by a mount option.  It's unnecessary to force the system into a single
> oom policy: either cgroup aware, or the traditional process aware.

Can you, please, provide a real-life example, when using per-process
and cgroup-aware OOM killer depending on OOM scope is beneficial?

It might be quite confusing, depending on configuration.
From inside a container you can have different types of OOMs,
depending on parent's cgroup configuration, which is not even
accessible for reading from inside.

Also, it's probably good to have an interface to show which policies
are available.

Thanks!
