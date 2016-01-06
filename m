From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Thu, 7 Jan 2016 04:14:26 +0530
Message-ID: <CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
	<20160105215309.GG5995@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=5Is+mphAveMsIZFOXKn7oEoFc8cQ0NNYcShxV8Ef8I0=;
        b=WAPZ/VcLW7KN56u268iDjg2E7527fJv8FeBdkVFG3I6oUKQoe+K9uT0F0o3/bCIxio
         wLq2yRWAmG4YiIVKnJ5tN3/jvMepMxco5OiHezYdLujBnof6W+rDFQPdNayVS7RnPJJv
         JK+gNqAm+gCcnMjOqPxSxc5TV6JoGAEJ3EQXz6xfoOfSsHbfwRpztusYvU9jiIykyJ8C
         loJg5b/BJmRSFepYniB5Wq/EgJyZHxjFQusFnVkV3cZCoLGD1InqO4hv6jF+HKqMQq02
         Hx+mAXN1GeI206lOicjxyw8lKhK+v4O5Cr2VtQZhW7V6BYt9aIO/CPJnBCy7D1vjBnKM
         rGOQ==
In-Reply-To: <20160105215309.GG5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 6, 2016 at 3:23 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Jan 06, 2016 at 12:28:06AM +0530, Parav Pandit wrote:
>> +5-4-1. RDMA Interface Files
>> +
>> +  rdma.resource.verb.list
>> +  rdma.resource.verb.limit
>> +  rdma.resource.verb.usage
>> +  rdma.resource.verb.failcnt
>> +  rdma.resource.hw.list
>> +  rdma.resource.hw.limit
>> +  rdma.resource.hw.usage
>> +  rdma.resource.hw.failcnt
>
> Can you please read the rest of cgroup.txt and put the interface in
> line with the common conventions followed by other controllers?
>

Yes. I read through. I can see two changes to be made in V2 version of
this patch.
1. rdma.resource.verb.usage and rdma.resource.verb.limit to change
respectively to,
2. rdma.resource.verb.stat and rdma.resource.verb.max.
3. rdma.resource.verb.failcnt indicate failure events, which I think
should go to events.
I roll out new patch for events post this patch as additional feature
and remove this feature in V2.

rdma.resource.verb.list file is unique to rdma cgroup, so I believe
this is fine.

We will conclude whether to have rdma.resource.hw.<files> or not in
other patches.
I am in opinion to keep "resource" and "verb" or "hw" tags around to
keep it verbose enough to know what are we trying to control.

Is that ok?

> Thanks.
>
> --
> tejun
