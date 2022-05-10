From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 11:01:32 -1000
Message-ID: <YnrSrKFTBn3IyUfa@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
 <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org>
 <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3rcz6qVNZi20/uUbB9766ZMC6kcEWw22DciqK9/zDQ=;
        b=M5ccWIy7d+bh8DqBj2aI3HFZZKskE0cwfDgQq3SKLrVgdAEFxXFPBkEBMgJ4qngmA2
         6H8woKrDHM1reouusOvd4aPscHfCRI6hEodeZJsd4D6vPzWpj+/ESYcRIaKuxdIo+A+Q
         REO2UUrR8BzAZBYQDBIpzFkYPdqzj+joI8K38ONynFtD+rXLjCemnJJiB6b4CFMkjshY
         CYR1R/+q+MdBzjd4wFuiVS17ecBinIwmowmWql+VGUH65xm+Uu8/uHde/uKwZ03XLtU1
         905SUSDqeXRgRwg7ZHM6aBsoRSIR0O+RAeQn1ZgTa7JGGDNCVlqjo9fhIzsr4tSQQYUz
         Sx6A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, May 10, 2022 at 01:43:46PM -0700, Yosry Ahmed wrote:
> I assume if we do this optimization, and have separate updated lists
> for controllers, we will still have a "core" updated list that is not
> tied to any controller. Is this correct?

Or we can create a dedicated updated list for the bpf progs, or even
multiple for groups of them and so on.

> If yes, then we can make the interface controller-agnostic (a global
> list of BPF flushers). If we do the optimization later, we tie BPF
> stats to the "core" updated list. We can even extend the userland
> interface then to allow for controller-specific BPF stats if found
> useful.

We'll need that anyway as cpustats are tied to the cgroup themselves rather
than the cpu controller.

> If not, and there will only be controller-specific updated lists then,
> then we might need to maintain a "core" updated list just for the sake
> of BPF programs, which I don't think would be favorable.

If needed, that's fine actually.

> What do you think? Either-way, I will try to document our discussion
> outcome in the commit message (and maybe the code), so that
> if-and-when this optimization is made, we can come back to it.

So, the main focus is keeping the userspace interface as simple as possible
and solving performance issues on the rstat side. If we need however many
updated lists to do that, that's all fine. FWIW, the experience up until now
has been consistent with the assumptions that the current implementation
makes and I haven't seen real any world cases where the shared updated list
are problematic.

Thanks.

-- 
tejun
