From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: Throttle allocators when failing reclaim over
 memory.high
Date: Fri, 1 Feb 2019 14:16:36 -0500
Message-ID: <20190201191636.GA17391@chrisdown.name>
References: <20190201011352.GA14370@chrisdown.name>
 <20190201071757.GE11599@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ik+nUeP1/vzq94Z7ZicHjBf1u7i2w1Mxdx/p4Q0QLSE=;
        b=W0Wn44AOStTYe+dttllNOONJ0kwMX4EYLQZLRFhf29Z90hnoImF1lG8nSdMLxA0Qvx
         sKvki9e7iBsjP3b+VFMOseTyDlPyfjw7+rS04bf+5SjjcbF/W5qqz2jWs6AhKtXbfKiy
         eLeelp1K2HK81/hAXExiivV4njdyB6k3k+HJ0=
Content-Disposition: inline
In-Reply-To: <20190201071757.GE11599@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Michal Hocko writes:
>How does this play wit the actual OOM when the user expects oom to
>resolve the situation because the reclaim is futile and there is nothing
>reclaimable except for killing a process?

In addition to what Johannes said, this doesn't impede OOM in the case of 
global system starvation (eg. in the case that all major consumers of memory 
are allocator throttling). In that case nothing unusual will happen, since the 
task's state is TASK_KILLABLE rather than TASK_UNINTERRUPTIBLE, and we will 
exit out of mem_cgroup_handle_over_high as quickly as possible.
