From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Date: Wed, 7 Sep 2022 06:18:09 -1000
Message-ID: <YxjEQabWR/BQOzk5@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
 <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=uhG7u+w7VyCcpyqgRvdj5juA1UtJgIUngIaiJnQjnlg=;
        b=fLpa63LacDyjcE/vOT2FJdnhbj72Sx8714QLP6Qn/d9p6+I87lcQWgOvbCBbSsukSH
         mH12lh3sQ1gujRjvOcEfh94G9ku2t9m8Mb9vOyK6pPhM1vwODGEcCESbxd6uCu0W7HFn
         7tHmH+luQvssLOTPgS2yHi/9wDhCFwGJUBcQpk29GxG7/GSThV5wNh+85ZC15/l1Oh3U
         cUg0t+i5EIyHSimnTaevPPoNAic7cxVG723kdP19q3TQOf0ZSa8twTUsQaAsYk2euSoO
         NLkrw9UCDqG5UlJL/R5d6PRHXT5URnD5nC3OgOwKhBDQLw4Na20v+/qa3fSpRYjCreS3
         u/aQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netwo

Hello,

On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> Hmm. We discussed this option already. We definitely don't want
> to introduce an uapi knob that will allow anyone to skip memcg
> accounting today and in the future.

cgroup.memory boot parameter is how memcg provides last-resort workarounds
for this sort of problems / regressions while they're being addressed. It's
not a dynamically changeable or programmable thing. Just a boot time
opt-out. That said, if you don't want it, you don't want it.

Thanks.

-- 
tejun
