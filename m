From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/4] cgroup: Child cgroup creation not allowed on
 invalid domain
Date: Sat, 22 Jul 2017 09:43:58 -0400
Message-ID: <20170722134358.GB3329631@devbig577.frc2.facebook.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
 <1500669293-21792-2-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SXBPRyhAMzttkWZzB73H4xoqrFvBDh/wVXZ0V8QmgY8=;
        b=MW7hLXBfCfTULoxtPrATihnponaAvcQbviHj+orv0UTfvQbY0kwuzvY4/raores2KY
         flLUmHDhX1BmrE36QG9ybQo2SrewLBhm6MekFEs5W/XBgop/6b7GDSbMECm5xKozk3MP
         3HxUNkUcEpBbELeaWSNAG/aVHXF+gfI+GrMlB9h8E9gvnNYW+22/80pobUuslDdzuOPe
         OA7nxJXZNBiGKjF58TzKkaoU7wR+X7sInLgKHj3qiNvmUYeJxyJx1AxqCoLDPDO4554g
         61cQ8w5ChTiPypyIBCmZ70Dn7wqmsMuFFDE04WEBh3qEx95w72vYIhHZvJb/0PNDp9/U
         ghLg==
Content-Disposition: inline
In-Reply-To: <1500669293-21792-2-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Waiman.

On Fri, Jul 21, 2017 at 04:34:50PM -0400, Waiman Long wrote:
> When thread mode is used, it is possible that some cgroups may be
> in an invalid state. Currently users may not be aware that they are
> invalid until they try to migrate tasks over. This patch disallows
> child cgroup creation on invalid domain. This adds one more failure
> point in reminding users that they are dealing with invalid domains.
> It also minimizes the number of invalid domains outstanding as much
> as possible.

It's a bit inconsistent because we can reach the same forbidden state
by turning a sibling cgroup threaded.  Please consider the following.

     A
    / \
   B   C
        \
	 D

Let's say all are domains and we make B threaded.  A becomes the
threaded domain, C and D become invalid, which is the configuration
you're trying to prevent.  We can either enabling threaded on B too or
relax type modifications further so that people can make C threaded
which makes sense given that that would lead to a topology which has
to supported anyway (if C were threaded before D was created, it'd
look the same).

So, I'm leaning more towards relaxing restrictions and tightening it,
and given that we have to expose invalid state anyway, I think there's
actual benefit in doing so as it gives more flexibility while building
the hierarchy.

Thanks.

-- 
tejun
