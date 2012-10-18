From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Thu, 18 Oct 2012 13:56:40 +0200
Message-ID: <20121018115640.GB24295@dhcp22.suse.cz>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
 <20121016133439.GI13991@dhcp22.suse.cz>
 <CAFj3OHVW-betpEnauzk-vQEfw_7bJxFneQb2oWpAZzOpZuMDiQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHVW-betpEnauzk-vQEfw_7bJxFneQb2oWpAZzOpZuMDiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed 17-10-12 01:14:48, Sha Zhengju wrote:
> On Tuesday, October 16, 2012, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
[...]
> > Could you be more specific about the motivation for this patch? Is it
> > "let's be consistent with the global oom" or you have a real use case
> > for this knob.
> >
> 
> In our environment(rhel6), we encounter a memcg oom 'deadlock'
> problem.  Simply speaking, suppose process A is selected to be killed
> by memcg oom killer, but A is uninterruptible sleeping on a page
> lock. What's worse, the exact page lock is holding by another memcg
> process B which is trapped in mem_croup_oom_lock(proves to be a
> livelock).

Hmm, this is strange. How can you get down that road with the page lock
held? Is it possible this is related to the issue fixed by: 1d65f86d
(mm: preallocate page before lock_page() at filemap COW)?

> Then A can not exit successfully to free the memory and both of them
> can not moving on.

> Indeed, we should dig into these locks to find the solution and
> in fact the 37b23e05 (x86, mm: make pagefault killable) and
> 7d9fdac(Memcg: make oom_lock 0 and 1 based other than counter) have
> already solved the problem, but if oom_killing_allocating_task is
> memcg aware, enabling this suicide oom behavior will be a simpler
> workaround. What's more, enabling the sysctl can avoid other potential
> oom problems to some extent.

As I said, I am not against this but I really want to see a valid use
case first. So far I haven't seen any because what you mention above is
a clear bug which should be fixed. I can imagine the huge number of
tasks in the group could be a problem as well but I would like to see
what are those problems first.

> > The primary motivation for oom_kill_allocating_tas AFAIU was to reduce
> > search over huge tasklists and reduce task_lock holding times. I am not
> > sure whether the original concern is still valid since 6b0c81b (mm,
> > oom: reduce dependency on tasklist_lock) as the tasklist_lock usage has
> > been reduced conciderably in favor of RCU read locks is taken but maybe
> > even that can be too disruptive?
> > David?
> 
> 
> On the other hand, from the semantic meaning of oom_kill_allocating_task,
> it implies to allow suicide-like oom, which has no obvious relationship
> with performance problems(such as huge task lists or task_lock holding
> time). 

I guess that suicide-like oom in fact means "kill the poor soul that
happened to charge the last". I do not see any use case for this from
top of my head (appart from the performance benefits of course).

> So make the sysctl be consistent with global oom will be better or set
> an individual option for memcg oom just as panic_on_oom does.

-- 
Michal Hocko
SUSE Labs
