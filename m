From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
Date: Tue, 1 Dec 2020 15:44:50 +0800
Message-ID: <58f66f22-fd5f-685d-e608-99c35d89c1a3@linux.alibaba.com>
References: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>



在 2020/12/1 上午3:52, Naresh Kamboju 写道:
> Crash log:
> -----------
> ioctl_sg01.c:81: TINFO: Found SCSI device /dev/sg1
> [  285.862123] ==================================================================
> [  285.863025] BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
> [  285.863025] Read of size 4 at addr 00000000000000c8 by task kswapd0/245

Hi Naresh,

Good to know you again. :)

Would you like to use command to check whichh line cause the panic:

scripts/faddr2line vmlinux workingset_eviction+0xf2/0x1e0

I can't reproduce it. and my gcc version mismatch with yours.

Thanks
Alex
