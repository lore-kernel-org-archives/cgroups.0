From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 11 Sep 2023 10:21:24 -1000
Message-ID: <ZP92xP5rdKdeps7Z@mtj.duckdns.org>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com>
 <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
 <ZP8SDdjut9VEVpps@dhcp22.suse.cz>
 <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
 <ZP9rtiRwRv2bQvde@dhcp22.suse.cz>
 <CAAPL-u9XwMcrqVRu871tGNKa3LKmJSy9pZQ7A98uDbG6ACzMxQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694463687; x=1695068487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=djFVbSPSCUqIznFcytjoMNrEsFpZVt4WCJe34ZTsb1w=;
        b=RSwAmzG8v/RqCT8e5xiIlSED1U2WtlkcohA8oOCPRcBgqo0YpBwFqq+LiCxbbofVqE
         x58Z7l/ELwkOhe5hNLVkTFD8NFeUplhHtv0/DzKf/WfSxj4tEZrPR9T+mRVUsnOjqSkw
         +sAfCCfuOPvMmXyGlcolRxuvyVJh0pGrmw5MlsooghFxVcMmZW/rnl6WeQVoGwPx3scG
         xae3habIc8WRwHw3tyqyaEToqY4cJ3Bzo3u6zb9f+jROIu7yvZOtORAZCck8/1NTB5O9
         h8WH64IFfMrdjZ1f16Kr1fDRZ81PtKksGft/ARURIAaRPbbw3pD+DVwSvFq6GS3Ks982
         gsrg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAAPL-u9XwMcrqVRu871tGNKa3LKmJSy9pZQ7A98uDbG6ACzMxQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>

Hello,

On Mon, Sep 11, 2023 at 01:01:25PM -0700, Wei Xu wrote:
> Yes, it is the same test (10K contending readers). The kernel change
> is to remove stats_user_flush_mutex from mem_cgroup_user_flush_stats()
> so that the concurrent mem_cgroup_user_flush_stats() requests directly
> contend on cgroup_rstat_lock in cgroup_rstat_flush().

I don't think it'd be a good idea to twist rstat and other kernel internal
code to accommodate 10k parallel readers. If we want to support that, let's
explicitly support that by implementing better batching in the read path.
The only guarantee you need is that there has been at least one flush since
the read attempt started, so we can do sth like the following in the read
path:

1. Grab a waiter lock. Remember the current timestamp.

2. Try lock flush mutex. If obtained, drop the waiter lock, flush. Regrab
   the waiter lock, update the latest flush time to my start time, wake up
   waiters on the waitqueue (maybe do custom wakeups based on start time?).

3. Release the waiter lock and sleep on the waitqueue.

4. When woken up, regarb the waiter lock, compare whether the latest flush
   timestamp is later than my start time, if so, return the latest result.
   If not go back to #2.

Maybe the above isn't the best way to do it but you get the general idea.
When you have that many concurrent readers, most of them won't need to
actually flush.

Thanks.

-- 
tejun
