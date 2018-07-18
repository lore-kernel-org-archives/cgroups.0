From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Wed, 18 Jul 2018 08:31:39 -0700
Message-ID: <20180718153139.GQ72677@devbig577.frc2.facebook.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <4cf9924e-7b97-187f-a1f5-853a45165abb@redhat.com>
 <151fc655-7e29-f060-789e-ee6c5c23d132@redhat.com>
 <a1eb4971-ff23-6fd8-d75b-112d63f0aee9@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hR+qD/rstAfQOlQkLYPzveTTy2nQYci9SLbQtsf9TfI=;
        b=sMZc31jhwq9tu4K/f0rBurhN0Hpa+rkT0/9jX9xSiSQF3nFbe87mIpEQY6aXK+t3k3
         SR3a5suk1TX1lgqqOJ9djyBEmB5Z+mSDOd8CGS1I6qq9w5oTNAAPyRzbA2rJoPbUP4hz
         DlC9f445y24coOLwjQyLpsVzs2JQJPS1AVY53zrWhVv0XZEN6tzOe9gATcQZYDCEErKT
         2D48L1LLAE4h23oQ6b6UahXV7IIjBK+n2uVBbvbwZpSCJZ1hc3jEdC6lLkb6uXGnXXZK
         jDiX9Ixul6z2OvIvpjA8wiPSf2QWv7S0fj9WuBGVNpebCaIHbRngkbKrY2W6TSdAteVP
         RPaw==
Content-Disposition: inline
In-Reply-To: <a1eb4971-ff23-6fd8-d75b-112d63f0aee9@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Wed, Jul 18, 2018 at 11:21:18AM -0400, Waiman Long wrote:
> What do you think about this patch?
> 
> Are there any other issues you have with this patchset?

Looks good to me.  If others are okay with it, I think we're all good.

Thanks.

-- 
tejun
