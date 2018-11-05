From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Mon, 5 Nov 2018 08:36:56 -0800
Message-ID: <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5D6B8SZiDJWloZJTLfl8O4vQl7ln5NDRmJQc+XqseP4=;
        b=Kv6QzhDDiGVwesKpr09Smj12ROI23t+yHETDN2mC/n5VCP1cxi5lkMfplmQRjJ9RFk
         7yWiOAG4kVquv49U/n+3BUWenNmRx7lx5H+h733vYQ5kbRTzR7uZu9R17qu4WC5PfvZS
         M7wSvinTc0zBvoQLGhMucOV3HWyhY7wHpwfv4PjEcSPAj/bpiQvLUkoaJkags8XK1080
         gAtIw11DHCU6+DtzNAnlXbTJDD0WLvgt+56Aph9EqhTqDgbiIQdIvgh8W1AxxwhKIs8X
         vPTz4DPH/Ej4gxH/D3iGNpyECrjWMYDbKk9P7B01yUhgrA8j106UMBkVNw9v7fZmDvm7
         FL9Q==
Content-Disposition: inline
In-Reply-To: <1539635377-22335-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

Hello,

So, this looks good to me.  Peter, I'm gonna roll the series into
cgroup/for-4.21-cpuset.  Please holler if you have any objections /
comments.

Thanks.

-- 
tejun
