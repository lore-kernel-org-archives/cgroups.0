From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 0/6] rdma controller support
Date: Fri, 8 Jan 2016 01:31:06 +0530
Message-ID: <CAG53R5WwdRwb0XyAMGMey4JaDGUntJ9=m_ZToFkygboZxfMQ6A@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<20160105215623.GH5995@mtj.duckdns.org>
	<CAG53R5XQaUz=vJCEqLwGt93CC1YMnVQ=k4DuRU0nspcb_-+_6g@mail.gmail.com>
	<20160107150718.GC29797@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=AE7NuurVM7voDM6WKMcTRcq31kss8zSq0rL96+tYXGE=;
        b=NZaUC0ySMJsN6g682GTkmnO7rLCAeo622ZIFLWXv84Ola5lLMqS9HAw/KCoZGSjGw0
         577PHn04DiHgB/beXf4Y+vOSB8V69YM+rkW8mkvojyMsbVL/8UJs5nXMvTnBR0BCWiR6
         7Ao1CEtHT4ap+YAaIfzBOEhLBblVQhi5MmCKJAgkiXs6QurKa9RvqyNGZTP1O/v/YlhN
         5nGwsClpSnELRPiHjUg0KJUHbdswR+3CQgsepyyZxZTHdZ39O3L4NQDzg/YG63HXxBmH
         4EIxJ9h+hpxRD0CvE6IU/WzhUYEQFl7Skq2UPksigfFNyM7C+IfC7JlDbnShVbOcH39H
         akFg==
In-Reply-To: <20160107150718.GC29797-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 7, 2016 at 8:37 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Thu, Jan 07, 2016 at 04:43:20AM +0530, Parav Pandit wrote:
>> > If different controllers can't agree upon the
>> > same set of resources, which probably is a pretty good sign that this
>> > isn't too well thought out to begin with,
>>
>> When you said "different controller" you meant "different hw vendors", right?
>> Or you meant, rdma, mem, cpu as controller here?
>
> Different hw vendors.
>
>> > at least make all resource
>> > types defined by the controller itself and let the controllers enable
>> > them selectively.
>> >
>> In this V1 patch, resource is defined by the IB stack and rdma cgroup
>> is facilitator for same.
>> By doing so, IB stack modules can define new resource without really
>> making changes to cgroup.
>> This design also allows hw vendors to define their own resources which
>> will be reviewed in rdma mailing list anway.
>> The idea is different hw versions can have different resource support,
>> so the whole intention is not about defining different resource but
>> rather enabling it.
>> But yes, I equally agree that by doing so, different hw controller
>> vendors can define different hw resources.
>
> How many vendors and resources are we talking about?
To my knowledge Intel HFI driver is the only one.

>  What I was
> trying to say was that unless the number is extremely high, it'd be
> far simpler to hard code them in the rdma controller and let drivers
> enable the ones which apply to them.

Instead of in rdma controller, its hard coded in IB stack.
I see this as an advantage where resource definition ownership remains
with IB stack maintainers, rather than rdma cgroup maintainer.
rdma cgroup maintainer doesn't have to understand what SRQ vs QP or
ODP type MR or multicast group is.
IB stack maintainer is better placed to judge and define it.

I would like to hear from Jason, Doug, Liran and other RDMA experts
about their thoughts.

> It would require updating the
> rdma cgroup controller to add new resource types but I think that'd
> actually be an upside, not down.  There needs to be some checks and
> balances against adding new resource types; otherwise, it'll soon
> become a mess.

I think this checks for new resource type can be ensured by IB stack
maintainer to avoid the mess.

My preference is IB stack to define resource, but I am ok to let go
this feature if consensus is RDMA cgroup.

>
> Thanks.
>
> --
> tejun
