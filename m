From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 7/8] cgroup: Assign subsystem IDs during compile time
Date: Tue, 11 Sep 2012 14:08:21 -0700
Message-ID: <20120911210821.GB7677@google.com>
References: <1347380774-9546-1-git-send-email-wagi@monom.org>
 <1347380774-9546-8-git-send-email-wagi@monom.org>
 <20120911210109.GZ7677@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rXEA2ZdEovsHrx9grlPZCuS0ReyBdS9lep47W23p1PA=;
        b=Xe4AxWTkhYGRoX2XzhGPVKUEDtT87oNk7rMmVoZz/blgGc3FvTNSFWTXctliffVvP1
         qBzHY+X319C2yRtKhdKJUbH4RgBZneXX9tLF05RedwKHev+8PgES9ZrlyI62lSe2NI9t
         4Vqg4ycQwS5GVu5/3ztrfrx2fCLVObio3YDpCQ6zSfZ5UnA/rLr4KsEGcvmsGVRChnjW
         mXUcpjjvgdyK9DsTW64YBa7JFZ1GbzcF4UZyWq+YdTns/pPl4xOwiUD1tXnsCSfqM2pK
         XthN2MEzmSmYrY7gnYeqnp0vcRbeRArGIl7QgRn66RSmIpwKn/8VzhfYIukvGgHiRRoj
         pRjA==
Content-Disposition: inline
In-Reply-To: <20120911210109.GZ7677-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Tue, Sep 11, 2012 at 02:01:09PM -0700, Tejun Heo wrote:
> For example, it's not evident the above is correct and it's burried
> with all other changes.  Can't we just assign the fixed subsys ID to
> net_prio_subsys_id in this patch?  This patch would be correct without
> any netprio changes, no?

Oops, that was wrong.  net_prio_subsys_id itself becomes constant.
Let's please better explain why the RCU trick removal is safe then.

Thanks.

-- 
tejun
