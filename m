From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Thu, 28 Jul 2022 07:35:14 -1000
Message-ID: <YuLI0jh8Csq0mErM@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
 <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
 <CA+khW7gfzoeHVd5coTSWXuYVfqiVMwoSjXkWsP-CeVdmOm0FqA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=QspELtFwrGd992ER4IywagKhOwPAd04XFlDr4WU6NiI=;
        b=mr2y8Nixp9iQYiaPkk1ld3aAvfXUbpKTeQ15WW56UqOrHJT7F6ygOyrLj1DDaCkTiT
         Btb3DBlO0KaSYzChaNk/QE5FisTCujb6TIsaKo4sDfHWGqDOXRI4z6wzpsc71giBkXAE
         UhjaXLzeSQ2FYrOgzCYkyCnkLpH0GqfV6Nyk/MXzhQHa6peGkiIqaB74rxQlVlC4CRMH
         0m98YNTpKu9tGdkZ38JBZ7DKi8bs2oCmbjDgzVxUBHk1Hvy75bihPcG4YlLTiseIQnl8
         KKQA0QK0h3Dm+kDcrY67cJ6p/LBOkjXG3TRzWjzbNxxOvxuxKDD6/OsYCaLaW7q16zWD
         FPqg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+khW7gfzoeHVd5coTSWXuYVfqiVMwoSjXkWsP-CeVdmOm0FqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Jul 28, 2022 at 10:20:46AM -0700, Hao Luo wrote:
...
> is a good feature of this convention. My thoughts: It seems that ID
> may be better, for two reasons. First, because ID is stateless, the
> userspace doesn't have to remember closing the FD. Second, using
> different identifications in two directions (userspace specifies
> cgroup using FD, while kernel reports cgroup using ID) introduces a
> little complexity when connecting them together.

Yeah, you can pass the IDs around different processes, print and log them in
meaningful ways and so on because they're actual IDs, so my preference is
towards using them for anything new.

Thanks.

-- 
tejun
