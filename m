From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
Date: Wed, 9 Jan 2013 15:47:58 +0100
Message-ID: <20130109144758.GC5095@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
 <1356456367-14660-1-git-send-email-handai.szj@taobao.com>
 <20130102104421.GC22160@dhcp22.suse.cz>
 <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com>
 <alpine.LNX.2.00.1301061135400.29149@eggly.anvils>
 <CAFj3OHVUx0bZyEGQU_CApVbgz7SrX3BQ+0U5fRV=En800wv+cQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHVUx0bZyEGQU_CApVbgz7SrX3BQ+0U5fRV=En800wv+cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Wed 09-01-13 22:35:12, Sha Zhengju wrote:
[...]
> To my knowledge, each task is forked in root memcg, and there's a
> moving while attaching it to a cgroup. So move_account is also a
> frequent behavior to some extent.

Not really. Every fork/exec is copies the current group (see
cgroup_fork) so there is no moving on that path.
[...]
-- 
Michal Hocko
SUSE Labs
