From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to break the while loop in
 cgroup_attach_task() correctly
Date: Sun, 13 Oct 2013 16:08:16 -0400
Message-ID: <20131013200816.GE18075@htj.dyndns.org>
References: <20131004130207.GA9338@redhat.com>
 <20131007184507.GD27396@htj.dyndns.org>
 <20131008145833.GA15600@redhat.com>
 <5254EB2A.7090803@huawei.com>
 <20131009133047.GA12414@redhat.com>
 <20131009140551.GA15849@redhat.com>
 <20131009165448.GA22437@redhat.com>
 <5257F9E3.5030708@huawei.com>
 <20131011160004.GA26416@redhat.com>
 <5258BB05.8030106@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=c5hk6SsOncH5koELa8PQaaeP7gg1uBCuOi3Dl4SGlvg=;
        b=IP7J1EarwKjNMNl7uYh9Zobt1nekSKF+YmaB8J9LB30Gor8bpsxkAH4QBXfx1tTlGw
         aSYXwvbouaAAKp6KMSgcjkoGDl11hP5fgPUHEdk6T0T+ihxs6ekv1n4by7nzy7WB+xkI
         uzJhHpwDGkWWd5wtT34HCkp2vPosSbyZuLdY6N6RyzBJWubUMfDTkC2bAnT/yGRqGCa6
         BEipOaLNpC1HjkYn24jHEjEdU1EMfsBGJlO+aqPL0VQduhdkGcSjx2xdGHN6SRes+8mZ
         M2nNishDnAvA8FYy29/x/0MdJ4LRdMmlYL61kEeR30o0dRBJwUuLHn4SAraaGaDzJRaN
         ya0g==
Content-Disposition: inline
In-Reply-To: <5258BB05.8030106-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On Sat, Oct 12, 2013 at 10:59:17AM +0800, Li Zefan wrote:
> From: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Both Anjana and Eunki reported a stall in the while_each_thread loop
> in cgroup_attach_task().
> 
> It's because, when we attach a single thread to a cgroup, if the cgroup
> is exiting or is already in that cgroup, we won't break the loop.
> 
> If the task is already in the cgroup, the bug can lead to another thread
> being attached to the cgroup unexpectedly:
> 
>   # echo 5207 > tasks
>   # cat tasks
>   5207
>   # echo 5207 > tasks
>   # cat tasks
>   5207
>   5215
> 
> What's worse, if the task to be attached isn't the leader of the thread
> group, we might never exit the loop, hence cpu stall. Thanks for Oleg's
> analysis.
> 
> This bug was introduced by commit 081aa458c38ba576bdd4265fc807fa95b48b9e79
> ("cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()")
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
> Reported-by: Eunki Kim <eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Reported-by: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> [ lizf: - fixed the first continue, pointed out by Oleg,
>         - rewrote changelog. ]
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12-fixes.

Thanks.

-- 
tejun
