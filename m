From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: [PATCH v6 0/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Tue, 23 Jul 2019 11:44:25 -0500
Message-ID: <1563900266-19734-1-git-send-email-chiluk+linux@indeed.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ADevYrTtujyVPlK2tuwzFrUbRUoPbF6rtrn0E36CPHM=;
        b=Jh6y+i7ilzxWsEyzWSh5ajwKZ3FeaRcz5c8xrmJ1BaE6ye4FKc3bYOK0/IPng058dI
         vaXiuqO3ZWMsCAKZ07n/iVLG3THw1XMi89oOPXPxBeLWjs+0Ny3RFcpdve25jPP0+Gdb
         hvd/8UiFnj7jNfmaaswaFUfXxGn4mHrGa6QpY=
In-Reply-To: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

Changelog v6
- Added back missing call to lsub_positive(&cfs_b->runtime, runtime);
- Added Reviewed-by: Ben Segall <bsegall@google.com>
- Fix some grammar in the Documentation, and change some wording.
- Updated documentation due to the .rst change

Changelog v5
- Based on this comment from Ben Segall's comment on v4
> If the cost of taking this global lock across all cpus without a
> ratelimit was somehow not a problem, I'd much prefer to just set
> min_cfs_rq_runtime = 0. (Assuming it is, I definitely prefer the "lie
> and sorta have 2x period 2x runtime" solution of removing expiration)
I'm resubmitting my v3 patchset, with the requested changes.
- Updated Commit log given review comments
- Update sched-bwc.txt give my new understanding of the slack timer.

Changelog v4
- Rewrote patchset around the concept of returning all of runtime_remaining
when cfs_b nears the end of available quota.

Changelog v3
- Reworked documentation to better describe behavior of slice expiration per
feedback from Peter Oskolkov

Changelog v2
- Fixed some checkpatch errors in the commit message.
