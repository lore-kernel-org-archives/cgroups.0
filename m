From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Date: Thu, 21 Apr 2022 13:43:17 -1000
Message-ID: <YmHsFWy7Wa4HNZXl@slm.duckdns.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
 <584183e2-2473-6185-e07d-f478da118b87@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/eAIscwqrdOmVK8JO+DB8Q4/nTvq74/yqQoE6DPm+YE=;
        b=BuOn9jZFa0z5WyxQu4hiLUdJAi/zwUHm1r5eQfF7B2DC/9QVs/N7Mp7ZrccbIIYZNo
         JsuVB84ni+bT89l44FR+k4nl0uSUmLdPjndEgpc7uQjvsH7k7fC8x6jdaCnPmXGAj72B
         RD3E5PqhesJS6VUic1lN4Y1goCu1XOftLSnezxcJKa4c8uYsIR2rXQJvctMKpqafnXgI
         X8fYyAgjhj0wzO9ejjFn/X4JrqEEwzeOGAaPglJsO0KPU1g1t/Xlv7qycSpvTjiS/OEW
         aQD80Xii/k6tttIIf28RUlUjmahDWuo5Gvo5TzlOb23eBJLCNKOeV4/LWcBQRJ59T7gZ
         yvFQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <584183e2-2473-6185-e07d-f478da118b87-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+e42ae441c3b10acf9e9d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

Hello,

On Thu, Apr 14, 2022 at 10:51:18AM -0700, Tadeusz Struk wrote:
> What happened was, the write triggered:
> cgroup_subtree_control_write()->cgroup_apply_control()->cgroup_apply_control_enable()->css_create()
> 
> which, allocates and initializes the css, then fails in cgroup_idr_alloc(),
> bails out and calls queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);

Yes, but this css hasn't been installed yet.

> then cgroup_subtree_control_write() bails out to out_unlock:, which then goes:
> 
> cgroup_kn_unlock()->cgroup_put()->css_put()->percpu_ref_put(&css->refcnt)->percpu_ref_put_many(ref)

And this is a different css. cgroup->self which isn't connected to the half
built css which got destroyed in css_create().

So, I have a bit of difficulty following this scenario. The way that the
current code uses destroy_work is definitely nasty and it'd probably be a
good idea to separate out the different use cases, but let's first
understand what's failing.

Thanks.

-- 
tejun
