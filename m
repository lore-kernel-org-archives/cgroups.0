From: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Subject: RE: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Wed, 16 Mar 2022 16:49:29 +0000
Message-ID: <e9cac4aba6384c5c91125a9f7d61a4e8@saabgroup.com>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <YjIShE3mwRyNbO53@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 weald.air.saab.se 22GGnVUb005751
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=saabgroup.com;
        s=weald; t=1647449371;
        bh=5QHUREPdKS0RYEDaBp+97Eck0DLnpYJfMdi/oyeVGbU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=utkEsq3p/XJygC/rsIc9PMZ3MEF4Lo/f2mQLLC1YfAZcb4cNrdJ++SzeOFTU0W7+W
         l/7+RWoywfQLpyY89k46SDKHv/eDM27NPI/WkIptQ8dtqXdHlDWCCVpgf9B70ZF9rP
         xiLWtoSRbNZBRsbU3hCS5LqTsnytGaC1yYkvDNSQ=
In-Reply-To: <YjIShE3mwRyNbO53-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> I have a basic question. cgroup provides new capabilities through
> its ability to hierarchically organize workloads on the system and
> distributes resources across the hierarchy. If all one wants to do
> is affining specific threads to specific CPUs or changing some other
> attributes of them, there's nothing extra that cgroup provides
> compared to using plain per-task interface. Is there some other
> eason why cgroup is the preferred way here?

Very good question! And yes, there actually are some reasons. :)

By using cgroup you can delegate the authority to configure a subset
of the hierarchy via rwx and user, group, others. By using the
per-task interface you have to be root, right?

Also, we want to separate the configuration of the threads from the
application as it need to be deployed in different hardware scenarios.

And we need to be able to easily replicate a configuration from one
machine to another machine.

We also need to configure other aspects that cgroup allows us to do
for the set of processes.

Since cgroup solves all of the above problems for us, why using
something else? :)

