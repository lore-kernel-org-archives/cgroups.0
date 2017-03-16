From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
 kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 13:03:21 -0400
Message-ID: <20170316170321.GF15810@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
 <20170315231920.GB13656@htj.duckdns.org>
 <20170316150233.GB24478@redhat.com>
 <20170316160544.GC15810@htj.duckdns.org>
 <20170316161756.GA27613@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8fTaYgupoocr2wNE6TQwmWVKvMlf2xi3T+a118FwNjQ=;
        b=kBaUhewQZPEH2oTA4RhZfWPXl7CVZKPoGVA+5X45O075FlXSfoGkaV4SgvPw6bVApS
         OvGHlNmBAArENTqlUQY70BmKWw6xe9FxVeXdZmvSY+0lLwtE7j5FbS4pasvvu4Q/0sE8
         auspNVf2Q+9ncydTs84SvFq6fCXrq344rtQ3TSGnoEaJ0iEjkDkjClFjwNlvGZh00HR4
         7kEZnGzWxC0zZYwniHMAJabOsVPrUg1fUtZOR6QEhjDUvWbixVJR0VsBlTrXVNuxZOxf
         dAKFH/tR+nAVvViFVg0DGIlWonaSBhKJX0paDr0CqWLcjA+qyAPHHBpl23bqWnH9Z5fk
         9AwQ==
Content-Disposition: inline
In-Reply-To: <20170316161756.GA27613@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello,

On Thu, Mar 16, 2017 at 05:17:57PM +0100, Oleg Nesterov wrote:
> But this also means that __cgroup_procs_write() will always fail if
> this task is a kernel thread which was not created by kthread_create().
> 
> Currently you can use kernel_thread() (although you shouldn't) and it
> can be migrated, this won't work after your patch.

I see what you mean now.  The only users seem to be init/main.c and
kernel/kmod.c.  I'll see if there's a way we can do this only for
kthread_create() users.

Thanks.

-- 
tejun
