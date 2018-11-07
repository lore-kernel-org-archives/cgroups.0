From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Wed, 7 Nov 2018 13:32:29 -0800
Message-ID: <20181107213229.GB2509588@devbig004.ftw2.facebook.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
 <20181106115335.GQ22431@hirez.programming.kicks-ass.net>
 <20181106115558.GB22485@hirez.programming.kicks-ass.net>
 <8c386375-b801-8adb-602e-40c73a7efedc@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ocqIJI97jpN2dVlV1t1A/wPKjhZZa+9X2Rj+z/TPzm0=;
        b=QcliHLl8U0U/LckvbdwuWgns7Sys/Ajc/dyupghRVgVL9fjW4dMTC3mmCQ2jviMJXy
         aJzZA854k8CtKAhWxFBeBDLSjKtmmMUZIiARA6gl+JJc+EL68abLyU9MgZKHKdrbZoLb
         8Oj/U+soaqUllCN5k+4uBnKsfVx33Kc+7+pTOpLMtcvphgrQ7ney6QRxTo3unQD/BXBD
         v/PhHifrsNA2C3rP1iHKlFg1TMOhaIuKSSbDqvuihI/KMUcbMDvC84A+DAB4PP0bRl8y
         0UrF2pC290gBPuN5JyI3WTG1M3ncu9z8YaAlZnun57+HqdHtCbSvxu6s8Sri8Bdt3kzd
         crkA==
Content-Disposition: inline
In-Reply-To: <8c386375-b801-8adb-602e-40c73a7efedc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

Hello,

On Tue, Nov 06, 2018 at 09:06:01AM -0500, Waiman Long wrote:
> On 11/06/2018 06:55 AM, Peter Zijlstra wrote:
> > On Tue, Nov 06, 2018 at 12:53:35PM +0100, Peter Zijlstra wrote:
> >> On Mon, Nov 05, 2018 at 08:36:56AM -0800, Tejun Heo wrote:
> >>> Hello,
> >>>
> >>> So, this looks good to me.  Peter, I'm gonna roll the series into
> >>> cgroup/for-4.21-cpuset.  Please holler if you have any objections /
> >>> comments.
> >> Mostly nits, except I think the interface for cpuset.sched.partition
> >> needs to find another term for "not a parition", "normal" really doesn't
> >> work for me.
> > cpuset.sched.partition: "true", "false", "error"
> >
> > makes more sense to me.
> 
> The terms "true", "false", "error" look good to me. I can change the
> patchset to use those if Tejun has no objection. I will fix the other
> nits you have as well.

How about the following?

Interface file is named "cpuset.cpus.partition" as it's a partition of
cpus.  The writeable keys are "root" and "member" - a partition root
and a partition member.  When "root" is requested but can't be
satisfied it shows "root invalid".  This seems pretty consistent with
cgroup.type and other cpuset files.

Thanks.

-- 
tejun
