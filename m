From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 2/3] mm: Charge active memcg when no mm is set
Date: Thu, 20 Feb 2020 16:03:44 -0500
Message-ID: <20200220210344.GK54486@cmpxchg.org>
References: <cover.1582216294.git.schatzberg.dan@gmail.com>
 <0a27b6fcbd1f7af104d7f4cf0adc6a31e0e7dd19.1582216294.git.schatzberg.dan@gmail.com>
 <CALvZod5bDQvYHTMCHoWbhiEbcBs4KATv=QLdjjivJ33kb6ZY+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6QH645NYVKdQbEm2dIlQdYX121ucp0jcY5IFqd2iTAM=;
        b=m1KDQ49IVlT6YDlcrR6kEHfCL5+o2vBShdjFVu+ROsFCINUdPBhVp7ZfyQt8YkI4V1
         ApmRefafOkHmPeBqAw+aOBORpbSSPQvei4ZebQKB6lbePikwbuyMsGeJXjPGkKyhKF37
         9o1/9zImGJswylC3buBORrbYwImOCEp6dvqkw7OsG2kKvjpLcZYbIMBWEEJBGIfSfePm
         lGuJBobkL/67AGpQYKeKwnKNQ1SI7SGZF6n4xEHA6Fr1dU2rHcyXW6iOC4YReVB3nvXP
         1eTMKYwJmvRR0MRNpnHb4fLXuhiRnQktysIIIW6duWgeu98O/ehaOE4y54nOMfsUxX8A
         5c/w==
Content-Disposition: inline
In-Reply-To: <CALvZod5bDQvYHTMCHoWbhiEbcBs4KATv=QLdjjivJ33kb6ZY+w@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

Hey Shakeel!

On Thu, Feb 20, 2020 at 10:14:45AM -0800, Shakeel Butt wrote:
> On Thu, Feb 20, 2020 at 8:52 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
> >
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
> >    a current->active_memcg, use that.
> 
> What if css_tryget_online(current->active_memcg) in
> get_mem_cgroup_from_current() fails? Do we want to change this to
> css_tryget() and even if that fails should we fallback to
> root_mem_cgroup or current->mm->memcg?

Good questions.

I think we can switch to css_tryget(). If a cgroup goes offline
between issuing the IO and the loop layer executing that IO, the
resources used could end up in the root instead of the closest
ancestor of the offlined group. However, the risk of that actually
happening and causing problems is probably pretty small, and the
behavior isn't really worse than before Dan's patches.

Would you mind sending a separate patch for this? AFAICS similar
concerns apply to all users of foreign charging.

As for tryget failing: can that actually happen? AFAICS, all current
users acquire a reference first (get_memcg_from_somewhere()) that they
assign to current->active_memcg. We should probably codify this rule
and do WARN_ON(!css_tryget()) /* current->active_memcg must hold a ref */
