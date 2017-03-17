From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] cgroup, kthread: close race window where new
        kthreads can be migrated to non-root cgroups
Date: Fri, 17 Mar 2017 14:50:21 +0100
Message-ID: <20170317135021.GB32763@redhat.com>
References: <20170315231827.GA13656@htj.duckdns.org> <20170315231920.GB13656@htj.duckdns.org> <20170316205424.GH15810@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com F1948342C60
Content-Disposition: inline
In-Reply-To: <20170316205424.GH15810@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 03/16, Tejun Heo wrote:
>
> Oleg,
> if you're okay with the patch, I can route this through
> cgroup/for-4.11-fixes.

Thanks, looks good to me.

Oleg.

