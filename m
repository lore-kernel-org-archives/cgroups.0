From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/8] cgroup: net_prio: Do not define
 task_netpioidx() when not selected
Date: Tue, 11 Sep 2012 13:37:28 -0700
Message-ID: <20120911203728.GX7677@google.com>
References: <1347380774-9546-1-git-send-email-wagi@monom.org>
 <1347380774-9546-4-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/EMLiexb4clZPCckmYdEOJBjaGMGvDOA+gGyizxdk8Q=;
        b=CjNynDVamvjgfNY2baeLF+hZGn21khI5aKDMsKuBmIf1N64/+w7GHRkky6dDQcIrKt
         vj0Fpn94gF6oCel2ZKz3UQFvZkyjy17LV6NZHXBcV+QqhrfWTTdITvG3zotEAmdTcpYk
         FSTqEdPU5kXjwLuG8A/dsZFLSOweOLqAa/s34VOWBlh+0jtp6B7CVBAvmo7brNbRYLvx
         vjgWcKgICk58kZGwbY0uq7LkM7BXEQ2KfI/azCMXQC6DPE1nX2VCWp3uvEo2FUV7iUrs
         sxA5hA7BX7D5L7MbXsxOdz+x2lPUGl7hxKGwU7BdY/9Xq/K+DyYMprQ8YkMrdqAYMTve
         AZXA==
Content-Disposition: inline
In-Reply-To: <1347380774-9546-4-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Tue, Sep 11, 2012 at 06:26:09PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> task_netprioidx() should not be defined in case the configuration is
> CONFIG_NETPRIO_CGROUP=n. The reason is that in a following patch the
> net_prio_subsys_id will only be defined if CONFIG_NETPRIO_CGROUP!=n.
> When net_prio is not built at all any callee should only get an empty
> task_netprioidx() without any references to net_prio_subsys_id.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> Cc: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>
> Cc: John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

For 1-3.

  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
