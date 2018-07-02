From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Mon, 2 Jul 2018 09:53:22 -0700
Message-ID: <20180702165322.GI533219@devbig577.frc2.facebook.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0Jg384EXlL606hr7KDYmXTRZefett+h7ct6FErCR4KM=;
        b=vTF0KCkjDxod1McirjGM++UnOdf+UcWoBW/8oUucmewwqecKbdt7WSYmldW4vaG5oi
         6hLyF3FnVo9BLcbHnRpQw5GYkThh6rbYlo9hA6KhL9F1XQ0Qw/eMecwBZiEni1nigOkC
         2ug5+0NodhNdWJ2y6/0RigvZIqHBEl5AhYTl2XIpwZtapo1w4mCM3QxJT1BwCa4DMhhd
         Ek2BNz+thz+9AR8ym7mH1felvuD/hUd4qpsgg80RtDQr+Vz/pfQ38Q4JQMeY7OeLghxx
         thKh03zSSeoiTvHOCMmlUe5GxUjVOIccEIS/nKjDkwME3uIupnfOjAtrORkpMFyYsi4v
         L02w==
Content-Disposition: inline
In-Reply-To: <1529825440-9574-8-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello, Waiman.

On Sun, Jun 24, 2018 at 03:30:38PM +0800, Waiman Long wrote:
> Because of the fact that setting the "cpuset.sched.partition" in
> a direct child of root can remove CPUs from the root's effective CPU
> list, it makes sense to know what CPUs are left in the root cgroup for
> scheduling purpose. So the "cpuset.cpus.effective" control file is now
> exposed in the v2 cgroup root.

So, effective changing when enabling partition on a child feels wrong
to me.  It's supposed to contain what's actually allowed to the cgroup
from its parent and that shouldn't change regardless of how those
resources are used.  It's still given to the cgroup from its parent.

It's a bit different because the way partition behaves is different
from other resource konbs in that it locks away those cpus so that
they can't be taken back.

What do people think about restricting partition to the first level
children for now at least?  That way we aren't locked into the special
semantics and we can figure out how to this down the hierarchy later.
Given that we ignore the regular cpuset settings when the set goes
empty (which also is a special condition which only exists for cpuset)
and inherits the parent's, I think the consistent thing to do is doing
the same for partition - if it can't be satisfied, ignore it, but
maybe there is a better way.

Thanks.

-- 
tejun
