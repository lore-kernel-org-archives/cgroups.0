From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Sun, 23 Feb 2020 17:11:12 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2002231710420.7354@eggly.anvils>
References: <cover.1582216294.git.schatzberg.dan@gmail.com> <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com> <alpine.LSU.2.11.2002231058520.5735@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=HX1fJHLiNwnVKz7r+onFwX/niXbmKqUAA8UMhmaKQVk=;
        b=kvTvYofZbz9U3B5NUoEdMRddWJRK/T6OWfWosieMYrRCRmBG6eds6cFCmkYooinSxb
         8VPn/Y70cjNOolZdgXXxZbXrOgCEDWU+L7iglCMwW+DF/5BFvXKY0G0dPLuQ4lQmY5WP
         JNK5G2q80TrH67xVPlf3bovornkAJZFsIRARlH+qEnAVUsgB1s6isDKWXfcJA0FwjoBY
         nRdSBFeW6FTnlcgIbbxsM8b/CY2eBs+XAdfipDCubdL5u0kKxae5lEJ6Fy2NEr7PkG2O
         ATHNhSb++IjMLmUksnNBie+sd/AN3rJrbjO2Xqcd8JLvVZlsIYm7dt+uer/M20dGt1FP
         48pA==
In-Reply-To: <alpine.LSU.2.11.2002231058520.5735@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Sun, 23 Feb 2020, Hugh Dickins wrote:
> On Thu, 20 Feb 2020, Dan Schatzberg wrote:
> 
> > memalloc_use_memcg() worked for kernel allocations but was silently
> > ignored for user pages.
> > 
> > This patch establishes a precedence order for who gets charged:
> > 
> > 1. If there is a memcg associated with the page already, that memcg is
> >    charged. This happens during swapin.
> > 
> > 2. If an explicit mm is passed, mm->memcg is charged. This happens
> >    during page faults, which can be triggered in remote VMs (eg gup).
> > 
> > 3. Otherwise consult the current process context. If it has configured
> >    a current->active_memcg, use that. Otherwise, current->mm->memcg.
> > 
> > Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
> > would always charge the root cgroup. Now it looks up the current
> > active_memcg first (falling back to charging the root cgroup if not
> > set).
> > 
> > Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> Yes, internally we have some further not-yet-upstreamed complications
> here (mainly, the "memcg=" mount option for all charges on a tmpfs to
> be charged to that memcg); but what you're doing here does not obstruct
> adding that later, they fit in well with the hierarchy that you (and
> Johannes) mapped out above, and it's really an improvement for shmem
> not to be referring to current there - thanks.

I acked slightly too soon. There are two other uses of "try_charge" in
mm/shmem.c: we can be confident that the userfaultfd one knows what mm
it's dealing with, but the shmem_swapin_page() instance has a similar
use of current->mm, that you also want to adjust to NULL, don't you?

Hugh
