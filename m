From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Date: Tue, 10 May 2022 12:07:44 -1000
Message-ID: <YnriMPYyOP9ibskc@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-9-yosryahmed@google.com>
 <Ynq04gC1l7C2tx6o@slm.duckdns.org>
 <CA+khW7girnNwap1ABN1a4XuvkEEnmkztTV+fsuC3MsxNeB08Yg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/D0OGw2on3AvUmlzv6/hmtVTR0FwAvCOjEZGHeN3148=;
        b=D+gxb7yJZ8m9WsThtL1BuBBOK9yZLCBXHYCPmiuC3APueeYrvaQ54LuI6lVJ9KDkGH
         bq8GCDiooCm7ohQyIPpk/Kemojg6ouW6d3J42fNcrTqpgF5QKN4NAP95JpFbeuv6tpy8
         eydzSFu4lyZgZrhRoHv/IdwFTGtzmVWzOiM/azxGTFxwwaR8UBZ8EFSiEh9bdNBHdb0B
         pxZ0jZeBQbGHGF+LgD5PRcmJm4mDJ/Ajquo0bduwqzhPfvj2IYFI0EwegKDL3MFvKjDU
         4Hi5BLDA2H/KhFY4EuEhj+wqb2D5jVc74T94LZr/+9gDTT4iItLQjiB9E6fH5zaQNaPy
         bEeg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+khW7girnNwap1ABN1a4XuvkEEnmkztTV+fsuC3MsxNeB08Yg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, May 10, 2022 at 02:12:16PM -0700, Hao Luo wrote:
> > Is there a reason why this can't be a proper iterator which supports
> > lseek64() to locate a specific cgroup?
> >
> 
> There are two reasons:
> 
> - Bpf_iter assumes no_llseek. I haven't looked closely on why this is
> so and whether we can add its support.
> 
> - Second, the name 'iter' in this patch is misleading. What this patch
> really does is reusing the functionality of dumping in bpf_iter.
> 'Dumper' is a better name. We want to create one file in bpffs for
> each cgroup. We are essentially just iterating a set of one single
> element.

I see. I'm just shooting in the dark without context but at least in
principle there's no reason why cgroups wouldn't be iterable, so it might be
something worth at least thinking about before baking in the interface.

Thanks.

-- 
tejun
