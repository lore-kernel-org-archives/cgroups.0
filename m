From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 12:16:30 -0400
Message-ID: <20161004161630.GC4205@htj.duckdns.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ezfVzU+AoOwLCSvv7JHexZi1qL5OmRa4ptha+SeQSnM=;
        b=hlh84P9583ZPF+cwtbuFxK3I7jItOWLFwYlL3ULHGaLwkC0WXtL8+pPHYRuPgq/I9Y
         aTNYoiEWz2ZbhwFcl/dxGwOFdqiRzA3Hbh9lwXVgKAROB2OT+ey3IB353tF+oiRcuDr0
         pKirPc1sSVe4VPPpScExAV40XHnO0zpumuDi17G8BfCzWvo0BvCBGZ6JPjgFiaw2+eoX
         Fa+RsqGYmaThyz9En+W32rPsDpGHehIKUP/ruRvyUDlJNr+Ig+dzsX1by0VqHMuB8D94
         uP4LGFItBaxzeXr+mMzuQZaf8Z7pbapT7efw954VXcmt9PK+FpuSlUIselOxpgwYd/Zx
         1+lA==
Content-Disposition: inline
In-Reply-To: <1475556090-6278-1-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Hello, John.

On Mon, Oct 03, 2016 at 09:41:28PM -0700, John Stultz wrote:
> The migration of a task from the foreground to background, or to
> elevate a task to audio priority, may be done by system service that
> does not run as root. So this patch allows processes with CAP_SYS_NICE
> to be able to migrate tasks between cgroups.  I suspect if there was a
> specific cap (CAP_SYS_CHANGE_CGROUP) for this, it would be usable here,
> but in its absence, they've overloaded CAP_SYS_NICE for this use.

CAP_SYS_RESOURCE won't do?

> At first glance, overloading CAP_SYS_NICE seems a bit hackish, but this
> shows that there is a active and widely deployed use for different cgroup
> attachment rules then what is currently available.

I'm curious who issues these migrations.  Is that restricted to
certain uids?  If so, would it work for android if cgroupfs supports
ACL so that those uids can be approved via setfacl?  That'd be an a
lot more generic approach.

Thanks.

-- 
tejun
