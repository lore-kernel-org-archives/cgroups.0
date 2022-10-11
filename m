From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 2/3] cgroup: add cgroup_all_get_from_[fd/file]()
Date: Mon, 10 Oct 2022 14:18:25 -1000
Message-ID: <Y0S2UeE4reIRUdBH@slm.duckdns.org>
References: <20221010235845.3379019-1-yosryahmed@google.com>
 <20221010235845.3379019-3-yosryahmed@google.com>
 <Y0S0nFSyivpU4H0n@slm.duckdns.org>
 <CAJD7tkbDNqxE+bYQvo5YAbK01qz7UVd-s6bOf==Ao44bmNsk=Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xm8Uch19R6NmYEbBkjcqkxQLt/DtdpQviAbU+5kyHeg=;
        b=HBXnfJdLfLouo9iEPM66BHhv/PtDj/o/wxFo1cOhKl/R5e1EWC6xOAGDiaw0T1frh+
         QuCSxWZLMbBAtcHs2EZ+10XspyM7Vsi6Z2OnpUhJ2Y7m8RSSikhiqgQJ4lDMYZ425Yei
         bhO7e/Focu7uTT1h+Nx1QpZs4+BZ1Ze/bDoqcyY5Hav29eBAW8/8a9eNjtplJArxP8/x
         N/qDDfqGIiGI+SwaNDbzujkHfMOvd8T25luGAFsbVcgKx9FkDQqFSPhzZjHysqGag6Bu
         NWfJxrXndFcrX22F6bvnLh6q9rqZhP1FnjtBuhe7M46mjW95TnA0Bya8gFdyvjGQypH5
         I5oQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkbDNqxE+bYQvo5YAbK01qz7UVd-s6bOf==Ao44bmNsk=Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 10, 2022 at 05:14:24PM -0700, Yosry Ahmed wrote:
> On Mon, Oct 10, 2022 at 5:11 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, Oct 10, 2022 at 11:58:44PM +0000, Yosry Ahmed wrote:
> > > Add cgroup_all_get_from_fd() and cgroup_all_get_from_file() that
> > > support both cgroup1 and cgroup2.
> >
> > Looks generally good. How about cgroup_v1v2_ as the prefix?
> 
> Thanks for taking a look.
> 
> I don't have a strong opinion here. I picked cgroup_all_* vs
> cgroup12_* or cgroup_v1v2_* because it's easier on the eyes.

I'd rather have something which is really distinctive because the difference
is rather subtle.

> My preference would have been to rename the old versions to
> cgroup_dfl_* instead, but like you said this might confuse existing
> users.

Yeah, it's confusing to have parallel file / id lookup functions with
different behaviors and we've asssumed that all these from-userspace lookups
are cgroup2 only for a while now.

> Anyway, I am fine with whatever you choose. Let me know if you need me
> to send a v2 for changing the prefix.

Please send an updated version. I don't mind whether it's cgroup12_ or
cgroup_v1v2_.

Thanks.

-- 
tejun
