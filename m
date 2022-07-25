From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/9] sched/psi: fix periodic aggregation shut off
Date: Mon, 25 Jul 2022 11:34:28 -0400
Message-ID: <Yt64BKsrUbD0xxYI@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-2-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67je02j6uPzSAKV5fALusQHcJaLZtd8UN7xVwkpfhMI=;
        b=cqYIXD8d4R3afensKf+99266lB8CnpoCR0cvyQJleALFFxfA893nPv3nDzZXt3p9za
         s8ObwE74BOHxU+40bwlVdDr3a0JISs43bgIQOwzuJcNzM0xST3u+iLxR8hwv1zNTXHS6
         Grd3BJJSVOsa4373326OgtzSlvStT0S1VDd14qQS8J0boaE438X2O4r5roAtieEZRa6h
         SNNVP2akwjO8VpRxcok8o5upBwDLt09kWP3F6AcTwTqmdW5Me+jybiLbG/C3AXfnQHXy
         6oThJosmja+RHL1pI0goIfSDiDz5HrJwrK5df6TJlo/cSxTG7pIONBV6cRi62GYTHyug
         bsxA==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-2-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On Thu, Jul 21, 2022 at 12:04:31PM +0800, Chengming Zhou wrote:
> We don't want to wake periodic aggregation work back up if the
> task change is the aggregation worker itself going to sleep, or
> we'll ping-pong forever.
> 
> Previously, we would use psi_task_change() in psi_dequeue() when
> task going to sleep, so this check was put in psi_task_change().
> 
> But commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
> defer task sleep handling to psi_task_switch(), won't go through
> psi_task_change() anymore.
> 
> So this patch move this check to psi_task_switch(). Note for defer sleep
> case, we should wake periodic avgs work for common ancestors groups,
> since those groups have next task sched_in.
> 
> Fixes: 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Good catch!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
