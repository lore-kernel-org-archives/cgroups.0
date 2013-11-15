From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.10.16 cgroup css_set_lock deadlock
Date: Fri, 15 Nov 2013 17:19:29 +0900
Message-ID: <20131115081929.GA11530@mtj.dyndns.org>
References: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kTpQxgkASN22ihmw1gdc/5aLJYM5ErC6apszznyjDsY=;
        b=hRdStLFiJh9LHkQOp12rRdWm3PWqyZdT45hdhRX5yGUgv+2ZG/8mW244W3nbcUimxA
         5lfEMh5fgu+Wcmi/jQiDBBbK8N6ITY42iENrTG/N9Y0ihk0sVb5EV5y7xK2OaSbcbO49
         gV3BMtri5gAq6vjjgxQLQE4oCJbIZh0Xn5EOIpkdiwA+5bP+4TYGxScouUgm+yvQ/Ad3
         M0h+Q5iJxW4nUoI6mjQa375LFbsIH0t/kEw+BH9uIpr9Ivt2Jg5IFeQtWEievK6Qeh9J
         FXIUZHIbQVRyVwd5c02eRR3H1nFGvxK4aFqdtrKOhmbNsdYwfhkv2wi5A6fFjXxwV7n1
         mFFQ==
Content-Disposition: inline
In-Reply-To: <20131114232529.GB16725-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Nov 14, 2013 at 05:25:29PM -0600, Shawn Bohrer wrote:
> In trying to reproduce the cgroup_mutex deadlock I reported earlier
> in https://lkml.org/lkml/2013/11/11/574 I believe I encountered a
> different issue that I'm also unable to understand. This machine
> started out reporting some soft lockups that look to me like they are
> on a read_lock(css_set_lock):
> 
...
> RIP: 0010:[<ffffffff8109253c>]  [<ffffffff8109253c>] cgroup_attach_task+0xdc/0x7a0
...
>  [<ffffffff81092e87>] attach_task_by_pid+0x167/0x1a0
>  [<ffffffff81092ef3>] cgroup_tasks_write+0x13/0x20

Most likely the bug fixed by ea84753c98a7 ("cgroup: fix to break the
while loop in cgroup_attach_task() correctly").  3.10.19 contains the
backported fix.

Thanks.

-- 
tejun
