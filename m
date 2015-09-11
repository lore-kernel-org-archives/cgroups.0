From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 22:17:42 +0530
Message-ID: <CAG53R5X5o8hJX1VJ00j5Bxuaps3FGCPNss4ey-07Dq+XP8xoBg@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
	<55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=6srOrQ3g34cPvinJmQ10jfiVtHR9M3HN1FuQYvq3FeY=;
        b=yCpDP5yIClY3Vx8kwU0lEl8EE2qInpscll3wp4R88iWIyb1rilJpTHxXK5Qy4h13Vs
         +P5ZCtDvrMgJXp3QF8GX8rMsS9qn/QyLa5K+v148Fv8oMXZYhiGZRXBSwYdGI1e7Xuao
         V+xpj3Le+e0gu3xShwjloXJM2PEu2M6IUVz+MYPJi/2RwFnby/FdRviIlDeaOJBrppLe
         8R35Sub2YdZL2rG9POM+F+1oTUX6xVoE1nJl4wyEaIztNQC+n9fwum41rWHi40E+5nHT
         xy5pMIIPPDtgAljItjbtTCX7OD/qKtQydJAdURJUZLZLdCvCy8DONTRpsrW74F92AUTK
         Fivg==
In-Reply-To: <20150911145213.GQ8114-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> cpuset is a special case but think of cpu, memory or io controllers.
> Their resource distribution schemes are a lot more developed than
> what's proposed in this patchset and that's a necessity because nobody
> wants to cripple their machines for resource control.

IO controller and applications are mature in nature.
When IO controller throttles the IO, applications are pretty mature
where if IO takes longer to complete, there is possibly almost no way
to cancel the system call or rather application might not want to
cancel the IO at least the non asynchronous one.
So application just notice lower performance than throttled way.
Its really not possible at RDMA level with RDMA resource to hold up
resource creation call for longer time, because reusing existing
resource with failed status can likely to give better performance.
As Doug explained in his example, many RDMA resources as its been used
by applications are relatively long lived. So holding ups resource
creation while its taken by other process will certainly will look bad
on application performance front compare to returning failure and
reusing existing one once its available or once new one is available.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
