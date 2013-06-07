From: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11 1/3] cgroup: mark "tasks" cgroup file as insane
Date: Fri, 7 Jun 2013 12:21:19 +0200
Message-ID: <CAPXgP12RxuRfvZEuga95Gn04De3ds=apZP94jG9Ws5VqkSht=g@mail.gmail.com>
References: <20130604021302.GH29989@mtj.dyndns.org> <20130604111556.GA4963@redhat.com>
 <20130604201947.GE14916@htj.dyndns.org> <20130606092055.GF30217@redhat.com>
 <20130606211410.GF5045@htj.dyndns.org> <20130607101220.GE10742@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=JEF8l8IItjy9m7pmFy+v5rJYIk5+mXxGNDklVrMbEPQ=;
        b=hD3vxw8tmKgNISXu9zK1AJnTlKnVMcC1hKAP275YWhACdpJhNlwk0mzsfvPLIzYq/W
         GMus8hazNE9wGgmhdc1rYdMoS4iNPIeeZDFcPsstAdeXmoiKNNJys3tmaIE7Xip/LP5b
         R8nn6fL754DKNq2iaAGpTLRizAqjXZO72Bs6g=
In-Reply-To: <20130607101220.GE10742-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 7, 2013 at 12:12 PM, Daniel P. Berrange <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Well we pretty much needs the tunables available in the cpu, cpuset
> and cpuacct controllers to be available for the set of non-vCPU threads
> as a group. eg, cpu_shares, cfs_period_us, cfs_quota_us, cpuacct.usage,
> cpuacct.usage_percpu, cpuset.cpus, cpuset.mems.

The cpu, cpuset, cpuacct controllers need different configuration per
controller, or do you refer them as one entity?

Kay
