From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup/task_lock] INFO: suspicious RCU usage.
Date: Tue, 25 Feb 2014 10:06:36 -0500
Message-ID: <20140225150636.GF26788@htj.dyndns.org>
References: <20140221021622.GB13515@localhost>
 <20140221154025.GB460@htj.dyndns.org>
 <530C5977.4090402@huawei.com>
 <530C8615.4020004@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BLurnx+3mpwq58Qv2JOKCC/32+QN+dB4E1LJ0ycCAU0=;
        b=f03ZplCYRoO+wqtEsBV5d9K3Tr55WzJU6onzzhhcpsVg6DNnNtSEGIGB5rPUnl/v+K
         VUXc/hUhJ914xlyTotPj6bis+Mx7C/7qN6y8MpAVmwUuPkwC2QsqfYTJYuPLF5qEtc0V
         +8bKOKF4NH3VxFeVbNEV+wBJMCKB+ctVuEZXLFlNl0GRPMKct68egurBsGB/bC1U2t2T
         3UzTqpPQec+JV9SPr1fkiDq47MWQzlFmXaKlQ/2imkZ4jEn9iAYyxrG6WMyWfqJtvKhi
         RixPAIftCkHe76lxmjSP10a77h1XFw0XNtdKzIp/9fcLSEHiNqwBg+S0QnGN9+fofnf4
         gsMQ==
Content-Disposition: inline
In-Reply-To: <530C8615.4020004-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Li.

On Tue, Feb 25, 2014 at 08:01:25PM +0800, Li Zefan wrote:
...
> >> So, this is from removing task_lock from task_css_set_check() and
> >> adding rcu_read_lock() in cpuset_cpus_allowed() should fix it.
> > 
> > Yeah, rcu_read_lock() should be sufficient.
> > 
> >> I'm
> >> not sure how much of task_lock() locking we currently have in cpuset
> >> is actually necessary tho.  Shouldn't we be able to do most with just
> >> callback_mutex, if not cpuset_mutex?  Li, any ideas?
> >>
> > 
> > task_lock() is also used to protect task->mems_allowed. I'll see if we
> > can get rid of most (if not all) task_lock() lockings in cpuset.
> > 
> 
> After a quick lock, I think except the one in cpuset_change_task_nodemask(), all
> other task_lock() lockings can be replace by rcu_readlock().

I committed the original series as-is.  Can you please post follow-up
patches to update cpuset locking?

Thanks.

-- 
tejun
