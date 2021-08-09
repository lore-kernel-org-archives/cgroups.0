From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 0/9] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Mon, 9 Aug 2021 12:46:55 -1000
Message-ID: <YRGwXw3KW8eFhEa8@mtj.duckdns.org>
References: <20210720141834.10624-1-longman@redhat.com>
 <YP9ChFvrGrDMGzbe@slm.duckdns.org>
 <b2f49b2e-d5a4-1504-bd0c-0bd82943d855@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XNgzSBl2ViZgrzMacCsKUZKoLxV/azVHoL6Wpcoyx1o=;
        b=aEhH+GbMzUwYKoNDDFkuXlWKEVtNn+ncfDq/pdkGJJN4UnbE3CmPYayiSuTemIyIyr
         lZHcTi35GE2BjPN9IB00dF6+Ir6KSDgrQCmP3pcBi4w34uvF+JWOSVOnitMB59NUcNHn
         IolBa8d9/W36apIoy0H1KpO34GW9m7kGbkT4hpaH4/SwFT52bQk8bc/vpD4DYViw/8RM
         wR3xDD4TI4UESH3BPx9xBe1a5yt+1l/7X14ojMklyUd91+GtS+/TEBViIswe/IDwYXai
         tpMJsJJw8HlHXlt10zIKo2l+e889s0F8JMxguiNcQdSJYXN2M05+5urFXjP33WKrLDMc
         bH/A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <b2f49b2e-d5a4-1504-bd0c-0bd82943d855@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello, Waiman. Sorry about the delay. Was off for a while.

On Tue, Jul 27, 2021 at 05:14:27PM -0400, Waiman Long wrote:
> However, if we have a complicated partition setup with multiple child
> partitions. Invalid cpuset.cpus change in a parent partition will cause all
> the child partitions to become invalid too. That is the scenario that I
> don't want to happen inadvertently. Alternatively, we can restrict those

I don't think there's anything fundamentally wrong with it given the
requirement that userland has to monitor invalid state transitions.
The same mass transition can happen through cpu hotplug operations,
right?

> invalid changes if a child partition exist and let it pass through and make
> it invalid if it is a standalone partition.
> 
> Please let me know which approach do you want me to take.

I think it'd be best if we can stick to some principles rather than
trying to adjust it for specific scenarios. e.g.:

* If a given state can be reached through cpu hot [un]plug, any
  configuration attempt which reaches the same state should be allowed
  with the same end result as cpu hot [un]plug.

* If a given state can't ever be reached in whichever way, the
  configuration attempting to reach such state should be rejected.

Thanks.

-- 
tejun
