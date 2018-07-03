From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Tue, 3 Jul 2018 08:58:23 -0700
Message-ID: <20180703155823.GS533219@devbig577.frc2.facebook.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nii9mXkoQMCWlubnGZW1vSGDl4mWcQn5io/dub3SdCo=;
        b=mMbjnSkb1YTbJVSZVMLSG2YYrNCxAdx1Th+DNOidqVgr8ZZITfQUxADeFDB7Sw/mNI
         Pr0b4XxNNSbnAtkVidmJhSvW5DFMA/BSXYaNJtCMU53e0B1+dter1johTak6nunifBmr
         /y+BZ6B7mmWKMb/EImvgLSYbYYMMmKIP52bqz6Mf9ZtX0Fial94ds9EjyhhDyMRY6IbN
         rAg8qTyF1Vl0az2qAFD8J3C3rVJJWpo1xO1Dwo8edpa535aWDf28loucOsoBeOGtb7Oc
         L3PwqTtwSTUc0Ax1T5QP4a56OVVsasRXJKFTQqv/lOkdvSbuzlsop6yssDW9IeoBNpIQ
         Op6A==
Content-Disposition: inline
In-Reply-To: <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello, Waiman.

On Tue, Jul 03, 2018 at 08:41:31AM +0800, Waiman Long wrote:
> > So, effective changing when enabling partition on a child feels wrong
> > to me.  It's supposed to contain what's actually allowed to the cgroup
> > from its parent and that shouldn't change regardless of how those
> > resources are used.  It's still given to the cgroup from its parent.
> 
> Another way to work around this issue is to expose the reserved_cpus in
> the parent for holding CPUs that can taken by a chid partition. That
> will require adding one more cpuset file for those cgroups that are
> partition roots.

Yeah, that should work.

> I don't mind restricting that to the first level children for now. That
> does restrict where we can put the container root if we want a separate
> partition for a container. Let's hear if others have any objection about
> that.

As currently implemented, partioning locks away the cpus which should
be a system level decision, not container level, so it makes sense to
me that it is only available to system root.

Thanks.

-- 
tejun
