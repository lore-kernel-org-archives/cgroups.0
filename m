From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: [PATCH v5 0/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Thu, 27 Jun 2019 14:49:29 -0500
Message-ID: <1561664970-1555-1-git-send-email-chiluk+linux@indeed.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=AesOW3EmeuBjZTWgdRCKfU4DW0QAsRu61r3/LGTQTg8=;
        b=NCZODYSjpvpfxj59czkgru2M6MbuOf355ojoS6qv35oesf0ZPEKewPbzf8Q6hUTwNZ
         63GC9qzntLhV3BXxzsA1wfMonAydRnckvGu7+Ty6+pC2zHJpo0wDteG4b3WNGiac6WEN
         get4j9BzPfJbNVLnEdYRJcAD/bpv4qOuVvgK4=
In-Reply-To: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Segall <bsegall@google.com>, Pqhil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

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
