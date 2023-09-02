From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mainline build failure due to d1d4ff5d11a5 ("cgroup: put
 cgroup_tryget_css() inside CONFIG_CGROUP_SCHED")
Date: Sat, 2 Sep 2023 05:44:39 -1000
Message-ID: <ZPNYZ8quPOdJeVa2@slm.duckdns.org>
References: <ZPMdTJ7zwrCkdMTu@debian>
 <CAHk-=wgmvf9OjxeiO7ZzN2hsmDZ7-HViP9AjQkRN84fuDXNATQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693669481; x=1694274281; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5MqIon8Nabrk/UvYJeaLuN2bLyxr6GffPmpVBNQNzY=;
        b=kiLwbzmxJjaPyaP+zIeuBKcch+lT4I5zcV6AcLFOt8haFUU1QSm8vpV8jnhWLw+N75
         etueSPHbbEcA9+rM/Epy6pIh9Y0ltgLZHU9w6zi6SjPvbiMbobIWh3kNJQH/8sOPYfET
         0/dsdMe+7aqtA8dO0h0a0NTZyUsplhB4aj0UbDgrTi3wQn6jcyByeCLSLWLid+6Idang
         d9fug9sfOz26Bd74Bj7iTE2cqK82KvI6JUc6FfYwJOlmyrskGIJHFN1Y5pvNGGIuBftj
         Cqkax6SbL0J8ue3kmFOzVVrqw2hcI2J0iNmyRDYrsFbo5xa7zMFVxwGYy5xOzcY5tWum
         y8/Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgmvf9OjxeiO7ZzN2hsmDZ7-HViP9AjQkRN84fuDXNATQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, regressions-cunTk1MwBs/YUNznpcFYbw@public.gmane.org

On Sat, Sep 02, 2023 at 08:37:38AM -0700, Linus Torvalds wrote:
> On Sat, 2 Sept 2023 at 04:32, Sudip Mukherjee (Codethink)
> <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > git bisect pointed to d1d4ff5d11a5 ("cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED").
> 
> I pushed out a commit that should fix it (76be05d4fd6c: "cgroup: fix
> build when CGROUP_SCHED is not enabled")

Ah, you beat me to it. I'll drop my fix branch.

Thanks.

-- 
tejun
