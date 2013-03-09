From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] do not abuse ->cred_guard_mutex in threadgroup_lock()
Date: Sat, 9 Mar 2013 12:15:50 -0800
Message-ID: <CAOS58YOT3yhmekrLPN30-bozrtNKrqEZEu7MR0se9Gv+DQ+CvA@mail.gmail.com>
References: <20130306223657.GA7392@redhat.com>
	<20130307172545.GA10353@redhat.com>
	<20130307180139.GD29601@htj.dyndns.org>
	<20130307180332.GE29601@htj.dyndns.org>
	<20130307191242.GA18265@redhat.com>
	<20130307193820.GB3209@htj.dyndns.org>
	<513A9A67.60909@huawei.com>
	<20130309032936.GT14556@mtj.dyndns.org>
	<513AE918.7020704@huawei.com>
	<20130309200046.GA8149@redhat.com>
	<20130309200106.GB8149@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=uGStnPQPeoRJzrLzSiKuDyFCugHCXMBY+RejRlUL0Lo=;
        b=SJQlvZw8Ri5gpUC0BdqM/4TaYt/54Q7I1BKORo+k7prO22vTAd9R17jbjVw0rod3QG
         dWrhDgWvNnjRBgjYI+fXAKyFiQqennBz9Hs8IoW44EoCJSq+2a6h92iPvKdoYBmeU1J+
         petVWe0uwI8MKcT3ZjglVAMliRCWl1vgimGGJkaDapnSJfTVlez4FRjsxOwmPEIKfzCn
         RfpHa0LwHEXiOwNeRSLMCMHJiEwSaP0dns7oYODCZiSdnTU9uk2NfM+7x7wHyIlOGqvW
         mW/4g/e/RxKRkU+nGY2Ef2uubnoTaocsd7PTcvbn6RoSK53yj9MKo+vD7kWbAhMvgwh9
         juLQ==
In-Reply-To: <20130309200106.GB8149-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 9, 2013 at 12:01 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> threadgroup_lock() takes signal->cred_guard_mutex to ensure that
> thread_group_leader() is stable. This doesn't look nice, the scope
> of this lock in do_execve() is huge.
>
> And as Dave pointed out this can lead to deadlock, we have the
> following dependencies:
>
>         do_execve:              cred_guard_mutex -> i_mutex
>         cgroup_mount:           i_mutex -> cgroup_mutex
>         attach_task_by_pid:     cgroup_mutex -> cred_guard_mutex
>
> Change de_thread() to take threadgroup_change_begin() around the
> switch-the-leader code and change threadgroup_lock() to avoid
> ->cred_guard_mutex.
>
> Note that de_thread() can't sleep with ->group_rwsem held, this
> can obviously deadlock with the exiting leader if the writer is
> active, so it does threadgroup_change_end() before schedule().
>
> Reported-by: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
