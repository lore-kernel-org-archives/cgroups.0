From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v14 12/12] cpuset: Show descriptive text when reading
 cpuset.sched.partition
Date: Wed, 17 Oct 2018 08:08:36 -0700
Message-ID: <20181017150836.GS270328@devbig004.ftw2.facebook.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-13-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e5bqOghSzvUOk7rsXSilVyYGwatXjhM7u+odjRAkfi4=;
        b=vJ8dM3grDlZ/NMU8EDubc1RbZoT/h53R+wjWcyG2YRo7rbpJQLNqNHqZkD9YyP4Flg
         isJSP7maA8mWbxFsfSvVssgFBGG5i+sAce1/MmGafci+LOXXIwvrMuhkvhKHHQsn8Uqz
         V5PKPYfmJDdOyHQm0vWDIc/A6eq9q3GIS6U2g6xRY0wqGFzPaGDD9FrBLe+d4RxCPY5V
         eUu7zOb8l50kgUzJVaI/f9X9UIPsBXsjG5o0x+WW4YicXaMmmSD/9YMJCqHHmWxPj3q+
         Cx/ZVyaEDrHJX+P74HNajLHb4flPy10SE11pPm5oUMCo0b2Gx/BFfGH4TUqyDz6kxBmt
         FDxQ==
Content-Disposition: inline
In-Reply-To: <1539635377-22335-13-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Oct 15, 2018 at 04:29:37PM -0400, Waiman Long wrote:
> Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
> read. A person who is not familiar with the partition code may not
> understand what they mean.
> 
> In order to make cpuset.sched.partition more user-friendly, it will
> now display the following descriptive text on read:
> 
>   "normal" - A normal cpuset, not a partition root
>   "partition" - A partition root
>   "partition invalid" - An invalid partition root
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Waiman Long <longman@redhat.com>

Can you also make this consistent when writing to the file?

Thanks.

-- 
tejun
