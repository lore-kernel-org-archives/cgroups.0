From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 3/7] Make TestSetPageDirty and dirty page accounting in
 one func
Date: Mon, 02 Jul 2012 20:14:02 +0900
Message-ID: <4FF1827A.7060806@jp.fujitsu.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881275-5651-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340881275-5651-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2012/06/28 20:01), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Commit a8e7d49a(Fix race in create_empty_buffers() vs __set_page_dirty_buffers())
> extracts TestSetPageDirty from __set_page_dirty and is far away from
> account_page_dirtied.But it's better to make the two operations in one single
> function to keep modular.So in order to avoid the potential race mentioned in
> commit a8e7d49a, we can hold private_lock until __set_page_dirty completes.
> I guess there's no deadlock between ->private_lock and ->tree_lock by quick look.
> 
> It's a prepare patch for following memcg dirty page accounting patches.
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

I think there is no problem with the lock order.

My small concern is the impact on the performance. IIUC, lock contention here can be
seen if multiple threads write to the same file in parallel.
Do you have any numbers before/after the patch ?


Thanks,
-Kmae
