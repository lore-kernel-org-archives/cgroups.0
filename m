From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 3/4] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Mon, 11 Sep 2017 13:48:39 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709111345320.102819@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <20170911131742.16482-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=f0f+PDDaqEeZblYw5F4pAs+gvB5vXbW9yHDkaJZzYTw=;
        b=WlTxZ3sgMdQW4qdHoiOc3Q9qcEFKBkcgjpAC8fqE5HVtjdaoYFAqxkhMu/u9XDwatX
         WXfp6qSmpAmi4SenBAsBFz2eKrHb6kbnf892YoLP6QI8AGk/j4EJ2mfm/jUgp9cnK86C
         xVWzlfzQeHFvY2/+Y/YqppM7R5iNW8tP3GobrB8zvnv2W7dFpyp3LXYB1yMryjN1NgdU
         SHKBizRBvibaZd1Nn1MhLiB+n5n3bYCS/YrBwNfBekluLstCw2OpF+H9Z8VjBo7sNWFY
         WrinYIm/ljZV7M3OlsDOakXmeQXQjatSUP9qn3xif6THPRAZ9ghQ1ICqnssyz00AHsbC
         YC9w==
In-Reply-To: <20170911131742.16482-4-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 11 Sep 2017, Roman Gushchin wrote:

> Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
> OOM killer. If not set, the OOM selection is performed in
> a "traditional" per-process way.
> 
> The behavior can be changed dynamically by remounting the cgroupfs.

I can't imagine that Tejun would be happy with a new mount option, 
especially when it's not required.

OOM behavior does not need to be defined at mount time and for the entire 
hierarchy.  It's possible to very easily implement a tunable as part of 
mem cgroup that is propagated to descendants and controls the oom scoring 
behavior for that hierarchy.  It does not need to be system wide and 
affect scoring of all processes based on which mem cgroup they are 
attached to at any given time.
