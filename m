From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Fri, 2 Jul 2021 16:19:20 -0400
Message-ID: <20210702201920.i4pacu2x76e6crbf@oracle.com>
References: <60decdb6.1c69fb81.6130e.7642@mx.google.com>
 <20210702200742.wuhdg4dhpolher3t@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=TRgInt7NXvWcv4AjlAp0yqi8aGSlE0iQsPoM2X812HU=;
 b=G5xs11ZLllfc9YgvNGcSAvRou4DWErLSO5pKcr8ElOpwptkOgDkwjSxLc6dHyWQlBdr/
 UNfDwJuTA9WbkeGh9vJMJH+KzIjuI1hw0zbKD2OZBZ7k/++mHXRNhggESH7c7e9H4UIu
 7l50reOioiCwtuRztEMP4EP49/5mOeaj7WRX4ytgW+92B3l7bnLnTUlooc8KkmgcdH24
 6fR25eQu9vsHQNwFvZangBL+v3vsc6h0vxsJIF3iKIfBfkSC80NWL5gd9tLDZrQtc5mc
 QcMcdIU4DY+cy5rlttRQGtBbASwPtf36D+4mpz2y/Z4w3R8Wp75Z8X+hOlnCus8/yOcB 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRgInt7NXvWcv4AjlAp0yqi8aGSlE0iQsPoM2X812HU=;
 b=s3vyYnG2meo9LEsypgjwVAH5Bkjdd7F7znXZvfgWk+Xqx/lMwwuX+NRrLmf7gqoMvVMH4leSvjtz2lK30N2ozX6XSBLKVQqITaa61Y9ZhFxrswkH8lTJGOePpZKYHdmbkHwjEQ5HWXLvDq+yfT1SjoJwQBazPk205h04ztN8a6A=
Content-Disposition: inline
In-Reply-To: <20210702200742.wuhdg4dhpolher3t-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavan Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

+ Android folks

On Fri, Jul 02, 2021 at 04:07:42PM -0400, Daniel Jordan wrote:
> Hello,
> 
> On Fri, Jul 02, 2021 at 08:26:27AM -0000, Hao Lee wrote:
> > memcg currently has a remote charging mechanism that can charge usage to other
> > memcg instead of the one the task belongs to.
> > 
> > In our environment, we need to account the cpu usage consumed by some kworkers
> > to a specific cgroup. Thus, we want to introduce a remote-charging mechanism to
> > cpu and cpuacct subsys in our kernel.
> 
> I also want to see this upstream, and am actually working on it right
> now, have been for some time.
> 
> So far, this is needed to properly account multithreaded padata jobs,
> memory reclaim, and net rx.  Android folks have raised this issue in the
> past too, though I'm not aware of the specific kthreads that are giving
> them problems.

Pavan, Wei, do you have any details about this?

> So naturally, I'm curious about your use case and how it may be
> different from these others.  What kworkers would you like to account?
> 
> > I want to know if the community has a plan to do this?
> > What will the community approach look like?
> 
> There has been discussion about this here,
> 
>    https://lore.kernel.org/lkml/20200219214112.4kt573kyzbvmbvn3-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/
> 
> more recently here,
> 
>    https://lore.kernel.org/lkml/YGxjwKbec68sCcqo-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/
> 
> and we may talk about it at LPC:
> 
>    https://www.linuxplumbersconf.org/event/11/page/104-accepted-microconferences#cont-perform
> 
> > I think we need to move the active_memcg to a separated active_cgroup struct,
> > and the latter will contain active_memcg, active_tg, and active_cpuacct.
> 
> I'm not seeing how that could work for cases that don't know the cgroup
> when the remote charging period begins.  The only one I'm aware of
> that's like that is net rx, where the work to process packets has to
> start before their ultimate destination, and therefore cgroup, is known.
> 
> thanks,
> Daniel
