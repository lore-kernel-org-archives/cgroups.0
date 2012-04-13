From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: question about memsw of memory cgroup-subsystem
Date: Fri, 13 Apr 2012 16:49:54 +0200
Message-ID: <20120413144954.GA9227@tiehlicka.suse.cz>
References: <op.wco7ekvhn27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <op.wco7ekvhn27o5l-4p38iKlbJMyYoDLmhA0N64eABQC+30qQrE5yTffgRl4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gaoqiang <gaoqiangscut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

[CC linux-mm]

Hi,

On Fri 13-04-12 18:00:10, gaoqiang wrote:
> 
> 
> I put a single process into a cgroup and set memory.limit_in_bytes
> to 100M,and memory.memsw.limit_in_bytes to 1G.
> 
> howevery,the process was oom-killed before mem+swap hit 1G. I tried
> many times,and it was killed randomly when memory+swap
> 
> exceed 100M but less than 1G.  what is the matter ?

could you be more specific about your kernel version, workload and could
you provide us with GROUP/memory.stat snapshots taken during your test?

One reason for oom might be that you are hitting the hard limit (you
cannot get over even if memsw limit says more) and you cannot swap out
any pages (e.g. they are mlocked or under writeback).

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
