From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Thu, 7 Jan 2016 04:43:20 +0530
Message-ID: <CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<20160105215623.GH5995@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=pwj59T/wsPPMjIe8vMmiY/m+uHk6U1z035d3YOnMw7Y=;
        b=ZZiZSZRXEDC+X/rWF7cHX1La722MvgLYfTautE9TDwjWJvEwP5YTMR95TNDHJ8Ad/R
         V7TIP8Pl7ByTEphWnbgZ6DY9H6eWyNi9jz02Zgq61yIrHCc9Ty/2A7CyMq4xhQTxmYg+
         CZ1D6v4Xzbe5o93vB+AHC0zJMTUo4ffiVLJlt3FqG6lB0PXL0ZhyaLdIeeT+CJt5Pt4R
         zps3miY5top8j7Z+ztoqtMsJ1JoRpWZ2wAITCCwPyloF2iaXmD1gclgGYLInBnpOwDZt
         aLQl5zam4SRVYYyDQ57BEajVd9vzRgCPDFXnQSqgPuWMA/IWFYWzHZTg3PpW5K0wtUKO
         P0Sg==
In-Reply-To: <20160105215623.GH5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On Wed, Jan 6, 2016 at 3:26 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Jan 06, 2016 at 12:28:00AM +0530, Parav Pandit wrote:
>> Resources are not defined by the RDMA cgroup. Resources are defined
>> by RDMA/IB stack & optionally by HCA vendor device drivers.
>
> As I wrote before, I don't think this is a good idea.  Drivers will
> inevitably add non-sensical "resources" which don't make any sense
> without much scrutiny.

In our last discussion on v0 patch,
http://lkml.iu.edu/hypermail/linux/kernel/1509.1/04331.html

The direction was, that vendor should be able to define their own resources.
> If different controllers can't agree upon the
> same set of resources, which probably is a pretty good sign that this
> isn't too well thought out to begin with,

When you said "different controller" you meant "different hw vendors", right?
Or you meant, rdma, mem, cpu as controller here?

> at least make all resource
> types defined by the controller itself and let the controllers enable
> them selectively.
>
In this V1 patch, resource is defined by the IB stack and rdma cgroup
is facilitator for same.
By doing so, IB stack modules can define new resource without really
making changes to cgroup.
This design also allows hw vendors to define their own resources which
will be reviewed in rdma mailing list anway.
The idea is different hw versions can have different resource support,
so the whole intention is not about defining different resource but
rather enabling it.
But yes, I equally agree that by doing so, different hw controller
vendors can define different hw resources.


> Thanks.
>
> --
> tejun
