From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/5] cgroup/cpuset: Don't call validate_change() for some
 flag changes
Date: Wed, 16 Jun 2021 16:39:32 -0400
Message-ID: <YMphhLAzmRRyD+cm@slm.duckdns.org>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w2FBfLaBcwWiXuuQkiw+TKxNhLLyk0+UoFjg+2c9KWs=;
        b=BqBhOjMwogf4k3blz8IAL4WznI6LikA5MM6wtvdt54OjlMTQ/hGLAM476ovh8+O353
         rcDqAUKKfNsblRHU2SVTlhQwfloN8u0hu+w0LiTH+Tia01Gkw4fSBkLWyNLyJfM+n4oL
         fXL0blwAjsHNAx6D/kmfSebvzy5pTvr1zwUiheCDJmbSiGGiavFdxKJDZQb2GMcmyVEc
         h8SWGqakfPRb8QUBkKTK0rTCq6vaXPkrjWvudCqX3OWKPJI6qJuX/Rxo093xzbXye5yS
         RKxsZlzvsABLEIvIVTqJl2q95sY12+mQpCfVtM2pTFJww7wQiU6JQYLFu8KjPFsnsSjE
         L2bA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210603212416.25934-2-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

Hello,

On Thu, Jun 03, 2021 at 05:24:12PM -0400, Waiman Long wrote:
> The update_flag() is called with one flag bit change and without change
> in the various cpumasks in the cpuset. Moreover, not all changes in the
> flag bits are validated in validate_change().  In particular, the load
> balance flag and the two spread flags are not checked there. So there
> is no point in calling validate_change() if those flag bits change.

The fact that it's escaping validation conditionally from caller side is
bothersome given that the idea is to have self-contained verifier to ensure
correctness. I'd prefer to make the validation more complete and optimized
(ie. detect or keep track of what changed) if really necessary rather than
escaping partially because certain conditions aren't checked.

Thanks.

-- 
tejun
