From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 9 May 2018 12:26:46 +0200
Message-ID: <20180509102646.GO12217@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hiy5mCwn+X3GBy2fvC0qy7poT0adi7TtKudZmw9F1bI=; b=GYYBMCMeKF0n3FCnG9PngPBiM
        LZ4nHTdUB1Yn7zOfIu19KcQxBOxxXJ7tmUCykLES0ScNlja/YUZGEP3RbvBXIaJOpGOWesOlZz8UM
        aPsLAVl0pzOlZRt6Sl+3hblsKFBllDG+28cjhxnspVOuslIRm6593afpH9UYADShlzZImTjaFj6Mg
        hM+JZHIQgRCRBsBUacYt6OgaZgBphxbbembRj8xRGOAtY73EMvof6ugFTmN6Fu6B+IcfvWpB0ZPwU
        TekgVuz2f1g1lw1rc4Hr9fs68SPpPBwWJ2bYkA8YbQYpkuc4P+S2aXGMglE4WjUk1P7EQ261SW0Na
      
Content-Disposition: inline
In-Reply-To: <20180507210135.1823-7-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 07, 2018 at 05:01:34PM -0400, Johannes Weiner wrote:
> +static void psi_clock(struct work_struct *work)
> +{

> +	dwork = to_delayed_work(work);
> +	group = container_of(dwork, struct psi_group, clock_work);
> +

> +
> +	/* Keep the clock ticking only when there is action */
> +	if (nonidle_total)
> +		schedule_delayed_work(dwork, MY_LOAD_FREQ);
> +}

Note that this doesn't generate a stable frequency for the callback.
The (nondeterministic) time spend doing the actual work is added to each
period, this gives an unconditional downward bias to the frequency, but
also makes it very unstable.

You want explicit management of timer->expires, and add MY_LOAD_FREQ
(which is a misnomer) to it and not reset it based on jiffies.
