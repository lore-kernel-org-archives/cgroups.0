From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
	leader is moved
Date: Thu, 21 May 2015 21:27:16 +0200
Message-ID: <20150521192716.GA21304@redhat.com>
References: <1431978595-12176-1-git-send-email-tj@kernel.org> <1431978595-12176-4-git-send-email-tj@kernel.org> <20150519121321.GB6203@dhcp22.suse.cz> <20150519212754.GO24861@htj.duckdns.org> <20150520131044.GA28678@dhcp22.suse.cz> <20150520132158.GB28678@dhcp22.suse.cz> <20150520175302.GA7287@redhat.com> <20150520202221.GD14256@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520202221.GD14256-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 05/20, Michal Hocko wrote:
>
> On Wed 20-05-15 19:53:02, Oleg Nesterov wrote:
> >
> > Yes, yes, the group leader can't go away until the whole thread-group dies.
>
> OK, then we should have a guarantee that mm->owner is always thread
> group leader, right?

No, please note that the exiting leader does exit_mm()->mm_update_next_owner()
and this changes mm->owner.

Btw, this connects to other potential cleanups... task_struct->mm looks
a bit strange, we probably want to move it into signal_struct->mm and
make exit_mm/etc per-process. But this is not trivial, and off-topic.

Offtopic, because the exiting leader has to call mm_update_next_owner()
in any case. Simply because it does cgroup_exit() after that, so
get_mem_cgroup_from_mm() can't work if mm->owner is zombie.

This also means that get_mem_cgroup_from_mm() can race with the exiting
mm->owner unless I missed something.

> > But can't we kill mm->owner somehow?
>
> I would be happy about that. But it is not that simple.

Yes, yes, I understand.

Oleg.
