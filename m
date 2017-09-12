From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 3/4] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Tue, 12 Sep 2017 21:01:15 +0100
Message-ID: <20170912200115.GA25218@castle>
References: <20170911131742.16482-1-guro@fb.com>
 <20170911131742.16482-4-guro@fb.com>
 <alpine.DEB.2.10.1709111345320.102819@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=4olCSAhuVPp/EQQ1Hubp5zkPt8X24UhryZShzUotFF8=;
 b=kvDRlhIfHe24KNJT9RSfu/lBgYjMspfcVuTiRb8Y4MeJBTczTyG/fu/vEzyy0D9ciLXj
 +yZx1dwjBYWuXHzQmADiKVGlESlSrSn8YbvlK+3D9wwmaNgdWjrMHs9XIS8iylkxNI+B
 z9ypFJBgfOvBLOZ/x0yOdYXxePJwlpQUZdM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4olCSAhuVPp/EQQ1Hubp5zkPt8X24UhryZShzUotFF8=;
 b=Gy5uRJr/jVryrbEpQJdul+u+HmqQjuuMG/SAZzKrNG0bGcFN+ns+eAqmfmtVj/RqoX5NTOimHHbkSYOYFmC3+B/jlrSIQlExQBBWE+OTqmZRTuvdpggKLmrjaMaU89CdARc8BePMPoekH4rdKWO1CYtE6r9yF8BiO625lEhdbCw=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709111345320.102819@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 11, 2017 at 01:48:39PM -0700, David Rientjes wrote:
> On Mon, 11 Sep 2017, Roman Gushchin wrote:
> 
> > Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
> > OOM killer. If not set, the OOM selection is performed in
> > a "traditional" per-process way.
> > 
> > The behavior can be changed dynamically by remounting the cgroupfs.
> 
> I can't imagine that Tejun would be happy with a new mount option, 
> especially when it's not required.
> 
> OOM behavior does not need to be defined at mount time and for the entire 
> hierarchy.  It's possible to very easily implement a tunable as part of 
> mem cgroup that is propagated to descendants and controls the oom scoring 
> behavior for that hierarchy.  It does not need to be system wide and 
> affect scoring of all processes based on which mem cgroup they are 
> attached to at any given time.

No, I don't think that mixing per-cgroup and per-process OOM selection
algorithms is a good idea.

So, there are 3 reasonable options:
1) boot option
2) sysctl
3) cgroup mount option

I believe, 3) is better, because it allows changing the behavior dynamically,
and explicitly depends on v2 (what sysctl lacks).

So, the only question is should it be opt-in or opt-out option.
Personally, I would prefer opt-out, but Michal has a very strong opinion here.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
