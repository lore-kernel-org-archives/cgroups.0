From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v14 12/12] cpuset: Show descriptive text when reading
 cpuset.sched.partition
Date: Fri, 19 Oct 2018 12:24:44 -0700
Message-ID: <20181019192444.GV270328@devbig004.ftw2.facebook.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-13-git-send-email-longman@redhat.com>
 <20181017150836.GS270328@devbig004.ftw2.facebook.com>
 <b797288a-6088-f7b0-c881-81633c071754@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jHydDG8+60wpJW/CzjZHlAATZ1UOTmTYFr6noyYndLY=;
        b=Gbp2uC8rJfrn6zjV3mVIIh+M6Z5vFHBiIkE6Hhac3yxx2vHU4dyWUsne6aB214PVCf
         hY8C61E7xp/DO0F9kIYg55EteS7MlW3WNDgRgQ9aFRj+7+tyVyYSWkokCisKA4jG9JPp
         YvKh7vsKkiJs6jrU3PTCw/lkuF0BhDQ/ax9iku0hP4lSNM0i4E8c88z/1MPmpvJ/lAZt
         mK+oCQscWinWN0UdhxNj+N2H5OO0G+tJu4UeO4yhulBlFxKZ3VBgaVDcSsNx49lFdflq
         p95PYi4LbbAaT32eGIkc4AAzlywgOslneVrM6pglGBO9ignvhNa4sAi9vEtfpicXRPnw
         MDsA==
Content-Disposition: inline
In-Reply-To: <b797288a-6088-f7b0-c881-81633c071754@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Fri, Oct 19, 2018 at 02:56:13PM -0400, Waiman Long wrote:
> On 10/17/2018 11:08 AM, Tejun Heo wrote:
> > On Mon, Oct 15, 2018 at 04:29:37PM -0400, Waiman Long wrote:
> >> Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
> >> read. A person who is not familiar with the partition code may not
> >> understand what they mean.
> >>
> >> In order to make cpuset.sched.partition more user-friendly, it will
> >> now display the following descriptive text on read:
> >>
> >>   "normal" - A normal cpuset, not a partition root
> >>   "partition" - A partition root
> >>   "partition invalid" - An invalid partition root
> >>
> >> Suggested-by: Tejun Heo <tj@kernel.org>
> >> Signed-off-by: Waiman Long <longman@redhat.com>
> > Can you also make this consistent when writing to the file?
> >
> > Thanks.
> >
> How about the attached patch instead?

Looks good to me.  Once Peter is okay with it, I'll roll it into
cgroup devel branch.  As v4.19 is almost done, I think it makes more
sense to target the next merge window (v4.21).

Thanks.

-- 
tejun
