From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Mon, 29 May 2023 16:31:02 -0300
Message-ID: <ZHT9dqihVNWqccmY@nvidia.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
 <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com>
 <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com>
 <87ttwnkzap.fsf@nvidia.com>
 <ZFuvhP5qGPivokc0@google.com>
 <87jzxe9baj.fsf@nvidia.com>
 <ZGjntWoAfgyT0doo@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J5dDKR78diflsnAZsCnyCogLwszsrvEJfa7BwqUF0w=;
 b=iR9SYMQOX8VeMwvQq1H13x+rlkfXXniOGWkTplX/MaxBGAvvOkWegP4++Drvq2syehrwOcjY47E04ZiV9q7wDzfxfOh31guouIZKlHscDHU4RAhitVINPzBGP/w9ehXsthGjFg8aiTnXQvP6R1ngevIrDXgZs9AkqGBv8hfI37UD96WEHa7iVMPNT1vE3szAgzdWixm//enzTpFjnfq3D2kdA93vG3ltwDgKSwrW+clWgz4Jtt99s7jEmMMdWLngqEV608wveeEbE5kuAeXoiz2TbJETXw4TjelhXdc34YS4mWlVhx7WOoQEf4soN/eMBQcPBeUvZ2Qp9ttd65XRHg==
Content-Disposition: inline
In-Reply-To: <ZGjntWoAfgyT0doo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Sat, May 20, 2023 at 08:31:01AM -0700, Chris Li wrote:
> > This is basically where we need to get everyone aligned. The RLIMIT
> > approach currently implemented by my patch series does (2). For example:
> > 
> > 1. If a process in a pincg requests (eg. via driver ioctl) to pin a page
> >    it is charged against the pincg limit and will fail if going over
> >    limit.
> > 
> > 2. If the same process requests another pin (doesn't matter if it's the
> >    same page or not) it will be charged again and can't go over limit.
> > 
> > 3. If another process in the same pincg requests a page (again, doesn't
> >    matter if it's the same page or not) be pinned it will be charged
> >    against the limit.
> 
> I see. You want to track and punish the number of time process
> issue pin ioctl on the page.

Yes, because it is feasible to count that without a lot of overhead

In a perfect world each cgroup would be charged exactly once while any
pin is active regardless of how many times something in the cgroup
caused it to be pinned	.

Jason
