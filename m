From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Tue, 8 May 2018 10:05:33 -0400
Message-ID: <20180508140533.GA2900@cmpxchg.org>
References: <20180507210135.1823-7-hannes@cmpxchg.org>
 <201805080952.2yQWmzU2%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oyJQmBpzqh5ewuafcNHrhg6XsQdnMkilUl342uCnO24=; b=tZIJudIyDaghcK0DG591UAqXrv
        C2PJF1TDAS6RfcfpmAdFlky+bJO9rV4TAdAON/surU5tZ144pcZ11zsfpRtwFeX3RkoNYCoczsdHb
        95RVO/GNW8K9/+Hn7svn52/vgBh8Epj6mX1RPoDgbph/z7xyg3pR2nHcK82XFtFU3EPs=;
Content-Disposition: inline
In-Reply-To: <201805080952.2yQWmzU2%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Tue, May 08, 2018 at 11:04:09AM +0800, kbuild test robot wrote:
>    118	#else /* CONFIG_PSI */
>    119	static inline void psi_enqueue(struct task_struct *p, u64 now)
>    120	{
>    121	}
>    122	static inline void psi_dequeue(struct task_struct *p, u64 now)
>    123	{
>    124	}
>    125	static inline void psi_ttwu_dequeue(struct task_struct *p) {}
>  > 126	{
>    127	}

Stupid last-minute cleanup reshuffling. v2 will have:

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index cb4a68bcf37a..ff6256b3d216 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -122,7 +122,7 @@ static inline void psi_enqueue(struct task_struct *p, u64 now)
 static inline void psi_dequeue(struct task_struct *p, u64 now)
 {
 }
-static inline void psi_ttwu_dequeue(struct task_struct *p) {}
+static inline void psi_ttwu_dequeue(struct task_struct *p)
 {
 }
 #endif /* CONFIG_PSI */
