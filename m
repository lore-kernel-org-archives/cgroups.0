From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: dump memory.stat during cgroup OOM
Date: Wed, 5 Jun 2019 12:11:33 -0400
Message-ID: <20190605161133.GA12453@cmpxchg.org>
References: <20190604210509.9744-1-hannes@cmpxchg.org>
 <20190605120837.GE15685@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KwGTPhlO4F01V7ggP/cBc9JouzklE/A9aHOmDIgUHBk=;
        b=zjoAxtmU+7WyTYQ00sJFDH6OJqtCjZpplgs9SVN+RWNg6guyKEzFqHxWvkeWD5xfQx
         3viyeJVCAPj+8k0LO4Z+bc2QpTkfCW9m8xZE9z6fUdeDh7YFKe1UZZyi0rL238e8zESs
         MYs+yNFzM+DRnW6HrIeF6FbVmC7ddiFnlLH2M9Lor+6Q+h9+zxEHT4bocMkRdEW4SE1O
         tCd8Z2lNM9FmEhZvR0Aq+vQRXZxxJ1ZRDemdOvmtML38bbyLZbowaKM5F0TdIWZ+tBA3
         yyUMzaBENQiqhfUXhFhSk3/uadr0bUA4xkuQeThSRBjkw90iT+SCdxg/HHsZwmrIAtTf
         UMfQ==
Content-Disposition: inline
In-Reply-To: <20190605120837.GE15685@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Jun 05, 2019 at 02:08:37PM +0200, Michal Hocko wrote:
> On Tue 04-06-19 17:05:09, Johannes Weiner wrote:
> > The current cgroup OOM memory info dump doesn't include all the memory
> > we are tracking, nor does it give insight into what the VM tried to do
> > leading up to the OOM. All that useful info is in memory.stat.
> 
> I agree that other memcg counters can provide a useful insight for the OOM
> situation.
> 
> > Furthermore, the recursive printing for every child cgroup can
> > generate absurd amounts of data on the console for larger cgroup
> > trees, and it's not like we provide a per-cgroup breakdown during
> > global OOM kills.
> 
> The idea was that this information might help to identify which subgroup
> is the major contributor to the OOM at a higher level. I have to confess
> that I have never really used that information myself though.

Yeah, same. The thing is that sometimes we have tens or even hundreds
of subgroups, and when an OOM triggers at the top-level the console
will be printing for a while. But often when you have that big of a
shared domain it's because you just run a lot of parallel instances of
the same job, and when the oom triggers it's because you ran too many
jobs rather than one job acting up. In more hybrid setups, we tend to
also configure the limits more locally.

> > When an OOM kill is triggered, print one set of recursive memory.stat
> > items at the level whose limit triggered the OOM condition.
> > 
> > Example output:
> > 
> [...]
> > memory: usage 1024kB, limit 1024kB, failcnt 75131
> > swap: usage 0kB, limit 9007199254740988kB, failcnt 0
> > Memory cgroup stats for /foo:
> > anon 0
> > file 0
> > kernel_stack 36864
> > slab 274432
> > sock 0
> > shmem 0
> > file_mapped 0
> > file_dirty 0
> > file_writeback 0
> > anon_thp 0
> > inactive_anon 126976
> > active_anon 0
> > inactive_file 0
> > active_file 0
> > unevictable 0
> > slab_reclaimable 0
> > slab_unreclaimable 274432
> > pgfault 59466
> > pgmajfault 1617
> > workingset_refault 2145
> > workingset_activate 0
> > workingset_nodereclaim 0
> > pgrefill 98952
> > pgscan 200060
> > pgsteal 59340
> > pgactivate 40095
> > pgdeactivate 96787
> > pglazyfree 0
> > pglazyfreed 0
> > thp_fault_alloc 0
> > thp_collapse_alloc 0
> 
> I am not entirely happy with that many lines in the oom report though. I
> do see that you are trying to reduce code duplication which is fine but
> would it be possible to squeeze all of these counters on a single line?
> The same way we do for the global OOM report?

TBH I really hate those in the global reports because I always
struggle to find what I'm looking for. And smoking guns don't stand
out visually either. I'd rather have newlines there as well.

> > +	seq_buf_init(&s, kvmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
> 
> What is the reason to use kvmalloc here? It doesn't make much sense to
> me to use it for the page size allocation TBH.

Oh, good spot. I first did something similar to seq_file.c with an
auto-resizing buffer in case we print too much data. Then decided
that's silly since everything that will print into the buffer is right
there, and it's obvious that it'll fit, so I did the fixed allocation
and the WARN_ON instead.

How about a simple kmalloc?. I know it's a page sized buffer, but the
gfp interface seems a bit too low-level and has weird kinks that
kmalloc nicely abstracts into a sane memory allocation interface, with
kmemleak support and so forth...

Thanks for your review.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0907a96ceddf..b0e0e840705d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1371,7 +1371,7 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	struct seq_buf s;
 	int i;
 
-	seq_buf_init(&s, kvmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
+	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
 	if (!s.buffer)
 		return NULL;
 
@@ -1533,7 +1533,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 	if (!buf)
 		return;
 	pr_info("%s", buf);
-	kvfree(buf);
+	kfree(buf);
 }
 
 /*
@@ -5775,7 +5775,7 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	if (!buf)
 		return -ENOMEM;
 	seq_puts(m, buf);
-	kvfree(buf);
+	kfree(buf);
 	return 0;
 }
 
