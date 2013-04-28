From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix compile warning when CONFIG_SMP=n
Date: Sat, 27 Apr 2013 19:55:35 -0700
Message-ID: <20130428025535.GA6569@htj.dyndns.org>
References: <517C7F91.2030705@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=vGwh2Tnqb3wR2GRDYwvAYeOlhJe0ZkKnVF45eZV7jvU=;
        b=h+OL2kFhTR0CP1KSVCUQCq2wUs+DKrLV/NWyVq0Oarr+xxxnzlPyv4Bc0C6hIvvG+g
         MX+O+s11b5fy45t3jY/dTCagTFzzaNjfu4XgBSKjXCDDEGj5lA0coC0ipWtNx/ITxRau
         eVykbKVaON6+y+VJ/NdueDOHpcOU8c8P/K3A/CPVZRCTTf7bSHJFsClTa0LmsdNET1Yd
         z1YegNdqMk8//NOczOOH9UTTczZZ6LxxyFnSyDI7kJSl2CaoIvfzdUEQpcb+WkZSc8lw
         LEIxcZzsrlzQm/kAvBYrv/XTRdKKQbShFhENLyTHnoW5Q1LBKnd3ERElu/U1ppEyeUvJ
         EDTw==
Content-Disposition: inline
In-Reply-To: <517C7F91.2030705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sun, Apr 28, 2013 at 09:46:57AM +0800, Li Zefan wrote:
> Reported by Fengguang's kbuild test robot:
> 
> kernel/cpuset.c:787: warning: 'generate_sched_domains' defined but not used
> 
> Introduced by commit e0e80a02e5701c8790bd348ab59edb154fbda60b
> ("cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()),
> which removed generate_sched_domains() from cpuset_hotplug_workfn().
> 
> Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.  Thanks.

-- 
tejun
