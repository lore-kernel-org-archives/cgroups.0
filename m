From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 0/2] Android style loosening of cgroup attach
 permissions
Date: Fri, 5 Jun 2015 03:52:04 +0900
Message-ID: <20150604185204.GQ20091@mtj.duckdns.org>
References: <1432179674-19154-1-git-send-email-john.stultz@linaro.org>
 <CALAqxLUXVaf0vzS=Hx+vZK5VqJoWHQ4iA8jG6+sWmiU6O3wbKw@mail.gmail.com>
 <20150603055057.GE20091@mtj.duckdns.org>
 <CALAqxLWkXTgKzq68H6TvPc6Wgbn5_jwVoW5Q9onnHnvQ0bTNiA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I04HfetHXQzmWhVLxHdmBqy0X02aHqxemvdirlcYZ30=;
        b=JQUr7K6E0ZMkcWlsPxHFwDBccZVquGI+kt42NtQG09aVUEeY3JjtbpQKEDcT9QglLd
         DoLBOVEhU1em51Q4TsRp6eUFi+SK94AikGI7YeIZLdw30tFyyy1q8U2KAWyCbIZO3yk4
         Jaxoq6L3yAYSkdFQy+2zNesG1aRRe7A/KthhyzD9Tm5pJe3YUqyK1Ys+U0KAoNTwX1se
         PLdqEioJZmD/I+VbGth0nFmplwUXxSkRX5cewsiplG782Ocxf2Qj5giLFXgFAMmuNNiC
         +vRtHOH4sba5C9VVt8G7QsXAovgphwHOy0lbVzn6EC5N9p8j8jHld12Nl7FiODVD90PY
         +7yQ==
Content-Disposition: inline
In-Reply-To: <CALAqxLWkXTgKzq68H6TvPc6Wgbn5_jwVoW5Q9onnHnvQ0bTNiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello, John.

On Thu, Jun 04, 2015 at 10:11:17AM -0700, John Stultz wrote:
> And at least in the current android-3.18 kernel, I don't see any rcu
> sync modifications. But maybe I'm missing what you mean?

It was from years ago so maybe it's no longer needed anymore and
removed but there was a patch in the android kernel to remove
synchronize_rcu() somewhere to make things go faster, which was fine
for android's use case at the time but would lead to oops in other
cases.  Hmmm... the upstream kernel dropped synchronize_rcu() quite a
while ago so maybe that's why it's no longer there.

> > Given that, I'm not sure this patchset makes sense for upstream.
> 
> Right, I'm not suggesting the patch go in "as-is".  I just wanted to
> show what Android is currently using, and start a discussion of what
> would be a better approach for Android to use, or what the kernel
> might need to be able to support Android's use case.

Sure, it'd be great if android's cgroup usage converges with other use
cases.  The main problem I see is that for controllers with persistent
state (memcg), migration is either gonna be extremely expensive or
won't update existing charge state and this is a lot more of a
fundamental property rather than an incidental technical detail.

Each page requires tracking info and access to that tracking info must
be optimized for hot path memory operations - some of them get really
hot, so we can't pay much overhead there both in terms of locking and
indirection, which pretty much implies that updating the association
of each object is gonna be extremely expensive and likely fragile with
weird corner cases where things don't quite work as expected and so
on.

While currently this primarily matters only to memcg, I think it's
reasonable to assume that for any resource tracking regarding
persistent objects similar attributes are likely to be in play and as
such the general direction of cgroup development is towards mostly
static organizational structure with dynamic config update happening
through per-controller knobs.

Thanks.

-- 
tejun
