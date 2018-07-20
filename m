From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 05:04:16 -0700
Message-ID: <20180720120416.GA1934745@devbig577.frc2.facebook.com>
References: <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EE8DOX5ZIE3rtJp1zM5TJJep5oDH4cHuKZ9DE8KZmQI=;
        b=OoTcvBb9/Pxtz93qbOBRPREr0gTpQu+qg8l1NQieCQL7aoaa9AdGaResGWg/E8BD4+
         Ja8+/Q/uzzzh+hKvRb8C68OWXeYG6ymZjz+lx2IbcQqhgTrmJ7Nmo+f2QGYJbBrZTq5v
         0Cu6zJLbBbaz+/L+usDwGAqocoMS8UpEzp9MiZ6jzIYx4V9a1KvItwIwZh5HJwo2uQxg
         jysCdVepx29TMc8/03OrQDYKuG3RbiGfVumeZJ6MBrc21wZo39ajH+GUstd3mIn2CfV3
         PEx4wggSHlid2yxGhakfWrrbk6u9RpMUHWnp4xLlwcSpxhsAatsAC6Ll+Mom2KRCqTXr
         EJTA==
Content-Disposition: inline
In-Reply-To: <20180720114549.GY72677@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello,

On Fri, Jul 20, 2018 at 04:45:49AM -0700, Tejun Heo wrote:
> > > 2. take away any given cpu from ist subtree.
> > 
> > I really hate this obsession of yours and doubly so for partitions. But
> > why would this currently not be allowed?
> 
> Well, sorry that you hate it.  It's a fundamental architectural
> constraint.  If it can't satisfy that, it should't be in cgroup.

Just in case it wasn't clear from previous the exchanges, basic
architecture designs like this are what makes things like delegation
actually useful across all controllers.  If we allow a descendant in
the hierarchy to restrict waht its ancestors can do, it becomes really
painful operationally.

For now, I'd suggest just doing it at the first child level and move
on unless there are clear use cases where nested partitions are
useful, which I find unlikely given the nature of the operation -
partitions don't really have anything to do with one another.

Thanks.

-- 
tejun
