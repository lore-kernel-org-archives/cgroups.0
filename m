From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v15 12/12] cpuset: Expose cpuset.cpus.subpartitions with
 cgroup_debug
Date: Thu, 8 Nov 2018 16:46:17 +0100
Message-ID: <20181108154617.GX9761@hirez.programming.kicks-ass.net>
References: <1541689726-20088-1-git-send-email-longman@redhat.com>
 <1541689726-20088-13-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zRIBLWsw80zYbxzgs3jgsZeBfHdU+bZkwp0KRbzrlWU=; b=vuIC7TsB1/mdZF2zuBxuSbC60
        kLh7CERmaQnIb9yqgVlwa5V7CypLACpvgBQDgRxRVeSUhIrXjL8ToG9CkR9RBPUi9prQag4gJ0Dkw
        M8KeUG/xNBGsb+vZ5Q98UGB+aJ7QtaNDVobHS2EnKLSMEUngDSwrlg5zFJUcmOqtVqeS7SfwP8sRG
        WK0GR3DwoDq5ZPxxurG8kNpRQH/JsBwecQ8Z0meZtpriC6MSRkFwIoCsuHvJLa6OS/hrMa8vdq9VF
        49LvCBIvbWf99fA8EBDXi8sEsG7pov1JF0PmKbAYveJdtbY735u/OyQ/8hL/vkN9A1928mT5r+LNk
      
Content-Disposition: inline
In-Reply-To: <1541689726-20088-13-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Thu, Nov 08, 2018 at 10:08:46AM -0500, Waiman Long wrote:
> For debugging purpose, it will be useful to expose the content of the
> subparts_cpus as a read-only file to see if the code work correctly.
> However, subparts_cpus will not be used at all in most use cases. So
> adding a new cpuset file that clutters the cgroup directory may not be
> desirable.  This is now being done by using the hidden "cgroup_debug"
> kernel command line option to expose a new "cpuset.cpus.subpartitions"
> file.

One thought I had; would it make sense to make these debug files hidden
("." prefix) ?
