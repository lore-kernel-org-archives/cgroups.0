From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Mon, 4 Jan 2016 13:59:36 -0500
Message-ID: <20160104185936.GA3807@mtj.duckdns.org>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
 <20160104175836.GA11668@mtj.duckdns.org>
 <568ABFC3.3010803@cumulusnetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ImyqQx/eLyhAiTnryz43hWX7N/UksuxBebd7GNjCTf8=;
        b=ioNlv8TzmzndfpTlYLnwe/wjU/gO5geMeKuulrs+SEGtW8U6bNNaChTbQNqRBfnFph
         jcQYLcD6BRdHoRQcqUB+2G+jJW/Ciq2RifT9JPGkd8etk40xEdpCTY4144VnN5c1FO73
         xBFxI+mNPnXd7w8Hps9nMRbViiq7kLcalektN/qnj2R71O8QCMH/mC8g56eH/tjODBoK
         j+ZaCsb+nvIpwFOdQ5sMTrZvLfKD+GM0GbNs1dwE9ua7WNhddRJEk3WBqd2D2vcO8lAI
         H0VvccDcAeor23rsFbcaWpG3Zdtgxnms9Isbl+GTBTGoPqmbRioVHSNYKrMkXOau1Wp5
         fIQQ==
Content-Disposition: inline
In-Reply-To: <568ABFC3.3010803-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shm-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org, roopa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org

Hello, David.

On Mon, Jan 04, 2016 at 11:53:55AM -0700, David Ahern wrote:
> On 1/4/16 10:58 AM, Tejun Heo wrote:
> >Please don't create any new controller whose sole purpose is
> >identifying group membership.  Please take a look at how libxt_cgroup
> >handles identification w/o creating a new controller.
> >
> >  http://lkml.kernel.org/g/1449527935-27056-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> >
> 
> This controller applies a cgroup specific setting to tasks associated with
> an instance (similar to cpuset restricting tasks to specifics CPUs), so it
> is more than just identifying membership.

Any identification can be mapped back and forth to setting configs to
a set of tasks.  That doesn't change the fact that all the controller
is doing is identifying cgroup membership and the proposed controller
shares exatly the same problems as netprio or netcls controllers.

> I looked at the commits referenced above and net/netfilter/xt_cgroup.c code
> in particular and I don't see how it applies to this use case. Can you
> elaborate?

Match cgroup membership in whatever subsystem that cares about it and
apply the policy there.

Thanks.

-- 
tejun
