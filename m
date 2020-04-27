From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memleak in cgroup
Date: Mon, 27 Apr 2020 13:13:04 -0400
Message-ID: <20200427171304.GC29022@cmpxchg.org>
References: <6e4d5208-ba26-93ed-c600-4776fc620456@huawei.com>
 <34dfdb52-6efd-7b11-07c8-9461a13b3aa4@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gq/hVuTwOmQSMneMygkOLzC97YbR5RTxhmWsHHCtD2U=;
        b=YX8ypOO5b3tqqWT49nZ/opdp0TWXhSm4SpC9rLf3j2MuHZVTVu9xpLe/99HQIdUHVr
         +MFb16vHQE26XQKzi/a5aJfpBDkiG1X5aUcKedCgu6D/P/XhHUyijIVppLxLc6owMgnf
         cV7xqZcYntn+8iNsFBDtMCcE10OkYNEYcUJGECO7UzgY54qfKODT5wLfRyvq7hnYcQHL
         Sk6Srv+koNou2ywjtFQyPVANIj3QNBhgftnawQ7doap3zL7+6OVhNd1cJ1tLrFGEDP+0
         Nqlp8ZsKOChhhmdP8KLTWIQUgp+Z/kEkcnqfJgiY0AItXA50NYRbNE+tcQEX9UHFdETd
         5nSw==
Content-Disposition: inline
In-Reply-To: <34dfdb52-6efd-7b11-07c8-9461a13b3aa4@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, linux-mm@kvack.org, guro@cmpxchg.org

+cc Roman who has been looking the most at this area

On Mon, Apr 27, 2020 at 03:48:13PM +0800, Yang Yingliang wrote:
> +cc linux-mm@kvack.org <mailto:linux-mm@kvack.org>
>=20
> On 2020/4/26 19:21, Yang Yingliang wrote:
> > Hi,
> >=20
> > When I doing the follow test in kernel-5.7-rc2, I found mem-free is
> > decreased
> >=20
> > #!/bin/sh
> > cd /sys/fs/cgroup/memory/
> >=20
> > for((i=3D0;i<45;i++))
> > do
> > =A0=A0=A0=A0=A0=A0=A0 for((j=3D0;j<60000;j++))
> > =A0=A0=A0=A0=A0=A0=A0 do
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mkdir /sys/fs/cgroup/memo=
ry/yyl-cg$j
> > =A0=A0=A0=A0=A0=A0=A0 done
> > =A0=A0=A0=A0=A0=A0=A0 sleep 1
> > =A0=A0=A0=A0=A0=A0=A0 ls /sys/fs/cgroup/memory/ | grep yyl | xargs rmdir
> > done

Should be easy enough to reproduce, thanks for the report. I'll try to
take a look later this week, unless Roman beats me to it.

Is this a new observation in 5.7-rc2?

Can you provide /sys/fs/cgroup/unified/cgroup.stat after the test?
