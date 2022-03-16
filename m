From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Wed, 16 Mar 2022 06:31:21 -1000
Message-ID: <YjIQ2c8CoMDDaUeT@slm.duckdns.org>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <CAPhsuW5qHSZNSEh8CQK3wYqtJ4XB+EwFEJWKA9SkA+wGFbvNCg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0li51S2j9zx6touwa3lalaBuNLB+ApBmTIWJmdTR4CI=;
        b=CMYlilISkpmT9u93kuzE80ilYUmxO8tZDHP6kRvGqaeCD3IgCfRgtxtt4ui3m8C8N3
         9QtIz4konuRNXrXD0iyToy2A4HfrIhnctNOUmpZYxsjwupqLpl7K0F3OdK7bv76ZfG3S
         d7I15BTZRPEIinQ3m0FkfvWkUcwSGR1Kc3/jiio7PtNWUUHFlqir/2VM7IQD1imzBbID
         DSr03q7fwGP/+dxbERzS+cdO5t1v3YENg18f8jVBEZpwv4qnrRc58kP/y7mbEgt4vj+L
         LHrdRCBMigiHY3BFJ70y/qpNf8P39NsI9ElYBYDeI1G4SH0cV9bcMzQpwjbmUyBVJ7Ta
         M/lQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPhsuW5qHSZNSEh8CQK3wYqtJ4XB+EwFEJWKA9SkA+wGFbvNCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Mar 15, 2022 at 11:04:56PM -0700, Song Liu wrote:
> Lookups invoke a rstat flush, so we still walk every node of a subtree for
> each lookup, no? So the actual cost should be similar than walking the
> subtree with some BPF program? Did I miss something?

rstat only walks cgroups / cpus which have been active since the flush.

Thanks.

-- 
tejun
