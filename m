From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm: Fix dropped memcg from mem cgroup soft limit
 tree
Date: Thu, 18 Feb 2021 10:30:20 -0800
Message-ID: <c3ffa2cb-cb2c-20b7-d722-c875934992e9@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen@linux.intel.com>
 <YC4kV7dkJpxjW+df@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YC4kV7dkJpxjW+df-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/18/21 12:24 AM, Michal Hocko wrote:

> 
> I have already acked this patch in the previous version along with Fixes
> tag. It seems that my review feedback has been completely ignored also
> for other patches in this series.

Michal,

My apology.  Our mail system screwed up and there are some mail missing
from our mail system that I completely missed your mail.  
Only saw them now after I looked into the lore.kernel.org.

Responding to your comment:

>Have you observed this happening in the real life? I do agree that the
>threshold based updates of the tree is not ideal but the whole soft
>reclaim code is far from optimal. So why do we care only now? The
>feature is essentially dead and fine tuning it sounds like a step back
>to me.

Yes, I did see the issue mentioned in patch 2 breaking soft limit
reclaim for cgroup v1.  There are still some of our customers using
cgroup v1 so we will like to fix this if possible.

For patch 3 regarding the uncharge_batch, it
is more of an observation that we should uncharge in batch of same node
and not prompted by actual workload.
Thinking more about this, the worst that could happen
is we could have some entries in the soft limit tree that overestimate
the memory used.  The worst that could happen is a soft page reclaim
on that cgroup.  The overhead from extra memcg event update could
be more than a soft page reclaim pass.  So let's drop patch 3
for now.

Let me know if you will like me to resend patch 1 with the fixes tag
for commit 4e41695356fb ("memory controller: soft limit reclaim on contention")
and if there are any changes I should make for patch 2.

Thanks.

Tim

