From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Thu, 8 Nov 2012 13:44:26 +0100
Message-ID: <20121108124426.GF31821@dhcp22.suse.cz>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com>
 <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
 <alpine.DEB.2.00.1211070956540.27451@chino.kir.corp.google.com>
 <509BA799.505@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <509BA799.505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 08-11-12 20:37:45, Sha Zhengju wrote:
> On 11/08/2012 02:02 AM, David Rientjes wrote:
> >On Wed, 7 Nov 2012, Sha Zhengju wrote:
[..]
> >>+	else
> >>+		show_mem(SHOW_MEM_FILTER_NODES);
> >Well that's disappointing if memcg == root_mem_cgroup, we'd probably like
> >to know the global memory state to determine what the problem is.
> >
> 
> I really wondering if there is any case that can pass
> root_mem_cgroup down here.

No it cannot because the root cgroup doesn't have any limit so we cannot
trigger memcg oom killer.

-- 
Michal Hocko
SUSE Labs
