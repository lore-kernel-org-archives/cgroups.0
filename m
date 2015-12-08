From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Thread page cache getting accounted in the process cgroup
 instead of cgroup assigned to the thread.
Date: Tue, 8 Dec 2015 17:08:17 +0100
Message-ID: <20151208160817.GA8042@dhcp22.suse.cz>
References: <CAKpF0T6+N1TimuKePhXKN4Z+Zmz=NKuOURP3bi0GPC7EZMJurg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKpF0T6+N1TimuKePhXKN4Z+Zmz=NKuOURP3bi0GPC7EZMJurg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ankur Khurana <ankur.kkhurana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 07-12-15 16:06:18, Ankur Khurana wrote:
> Hi,
> 
> Recently, I got to know about the control groups on linux and found it
> interesting and started experimenting with it. I tried cgroups for
> various subsystems and it worked as I would expect it to work. Feeling
> empowered with the use of control groups, I went one step further and
> tried to get resource isolation on thread level. I used java as a
> choice of programming language and tried to do resource allocation to
> different threads. It worked really fine for cpu and blkio but results
> for memory were somewhat interesting.

Memory controller accounting is per process (resp. per mm_struct which
is shared between threads in the same process or between processes
created by clone(CLONE_VM) in general). The memory is accounted to
the owner of the mm_struct which is usually the group leader of
the process but this might get more muddy when the mm_struct is
shared between processes which are not in the same thread group (see
mm_update_next_owner).

The reason is that the memory is inherently shared between threads.
The implementation is also much simpler and straightforward because
the charging operates on the mm_struct rather than a task same as other
operations which are specific to user address space.

HTH
-- 
Michal Hocko
SUSE Labs
