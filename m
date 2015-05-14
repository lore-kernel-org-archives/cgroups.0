From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 13:56:41 +0200
Message-ID: <20150514115641.GE6799@dhcp22.suse.cz>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514103148.GA5066@rei.suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514103148.GA5066-J5syqNJeCN4b1SvskN2V4Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 14-05-15 12:31:49, Cyril Hrubis wrote:
[...]
> Looking at the code, it does two more things here:
> 
> echo $pid > tasks
> kill -s USR1 $pid 2> /dev/null
> 
> Sending SIGUSR1 to the memcg_process causes it to repeat the allocation
> that has been passed to it by the command line parameters.
> 
> So my guess is that it expect the force_empty to fail if the process has
> allocated some memory after it has been moved to the current cgroup.

force_empty fails if the memcg cannot be reclaimed down to 0. The memory
charged after the task has moved to the group is easily reclaimable so
I do not see any reason why we would fail here.

> The previous testcases does exactly this but moves the process to the
> parent with:
> 
> echo $pid > ../tasks
> 
> Before it tries the force_empty and expects it to succeed.
> 
> Was this some old implementation limitation that has been lifted
> meanwhile?

OK, now I remember... f61c42a7d911 ("memcg: remove tasks/children test
from mem_cgroup_force_empty()") which goes back to 3.16. So the test
case is invalid.

-- 
Michal Hocko
SUSE Labs
