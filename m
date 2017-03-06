From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Mon, 6 Mar 2017 13:58:20 -0500
Message-ID: <20170306185820.GA19696@htj.duckdns.org>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ej82faQH4mmwoZlkiJErnOrhHYu5eTmm5ow8ViJMzNo=;
        b=K1v6bG7uBqh/i+OMdlAfIn067IAzv0RjOTymZZyKTgoWHE3k8qWqGMDdVsazh1uAQy
         RxgCxMR85YWrMDR6EsksVjr+usSIHJMkCzSdSCPWD9nsOWTgZpI28/qfYcV4qGgm7WSh
         WuAlisfV93qoK2erWS4IdOQFByZP3CdF9dZS2QO4L2/xcEEnpSQrAipIz0ASdR2XU0Cs
         e2/bBFCYAaqqtNVtUgzYgbpyMzT41BmQV+nwEvsnNTmftaYMQ/EemkUT+3X8G37n3t/i
         bH5bHRbpISq5EEkNi23qR15JUN08BqqwDpOwIzstYvvDlAZ778XdATioF1XucSd29LHX
         6RFw==
Content-Disposition: inline
In-Reply-To: <9a57890c-d9e9-5719-e155-ce1161795a02-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Feb 17, 2017 at 12:37:11PM +0100, Krzysztof Opasiak wrote:
> > We need to limit and monitor the number of file descriptors processes
> > keep open. If a process exceeds certain limit we'd like to terminate it
> > and restart it or reboot the whole system. Currently the RLIMIT API
> > allows limiting the number of file descriptors but to achieve our goals
> > we'd need to make sure all programmes we run handle EMFILE errno
> > properly. That is why we consider developing a cgroup controller that
> > limits the number of open file descriptors of its members (similar to
> >  memory controler).
> > 
> > Any comments? Is there any alternative that:
> > 
> > + does not require modifications of user-land code,
> > + enables other process (e.g. init) to be notified and apply policy.

Hmm... I'm not quite sure fds qualify as an independent system-wide
resource.  We did that for pids because pids are globally limited and
can run out way earlier than memory backing it.  I don't think we have
similar restructions for fds, do we?

Thanks.

-- 
tejun
