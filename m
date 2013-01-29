From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 5/6] memcg: introduce
 swap_cgroup_init()/swap_cgroup_free()
Date: Tue, 29 Jan 2013 17:09:12 +0100
Message-ID: <20130129160912.GK29574@dhcp22.suse.cz>
References: <510658E3.1020306@oracle.com>
 <510658F7.6050806@oracle.com>
 <20130129145639.GG29574@dhcp22.suse.cz>
 <5107F00E.7070302@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5107F00E.7070302-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 29-01-13 23:51:42, Jeff Liu wrote:
> On 01/29/2013 10:56 PM, Michal Hocko wrote:
> > On Mon 28-01-13 18:54:47, Jeff Liu wrote:
> >> Introduce swap_cgroup_init()/swap_cgroup_free() to allocate buffers when creating the first
> >> non-root memcg and deallocate buffers on the last non-root memcg is gone.
> > 
> > I think this deserves more words ;) At least it would be good to
> > describe contexts from which init and free might be called. What are the
> > locking rules.
> > Also swap_cgroup_destroy sounds more in pair with swap_cgroup_init.
> Will improve the comments log as well as fix the naming.  Btw, I named
> it as swap_cgroup_free() because we have mem_cgroup_free() corresponding
> to mem_cgroup_init(). :)

I do see mem_cgroup_alloc and __mem_cgroup_free. Anyway this is not that
important. Consistent naming is not any rule. It is nice to have though.
So take these renaming suggestions as hints rather than you definitely
_have_ to do that.

[...]
-- 
Michal Hocko
SUSE Labs
