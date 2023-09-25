From: Kui-Feng Lee <sinquersw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup
 controller
Date: Mon, 25 Sep 2023 11:22:17 -0700
Message-ID: <9e83bda8-ea1b-75b9-c55f-61cf11b4cd83@gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695666140; x=1696270940; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dEdoLWk7hr93lYo85cFiSYxcDqCG5HY3UkZKa6gp7n8=;
        b=OAh6had7vUse9heF5fQAMHUa9ykBGce8/q0+EXNKvN6H/gm2FdblK8zBWfMnwYccyX
         AEy7/ztqv30wPjyRa1Q36hh7IXPS9Vug0IntxmtGXiCqF2n2aTSlZgteivBF2ytW5IVi
         FskV+eYRguiQ9wa8e4x5q6nSiNYuiSx0T9nK07BAhgL/ZJPoVxbX88yREeTkiJd7i9ys
         BW6m0gVEl2R3a4a5NXdzT8CtHg6mozOrQ3xEsOZkuFBbZIpf1aoMIQ813qajEHVaxeBb
         7EqFWzFHOBnNyLrj5inTfKWqxHGqH9WPD5pUIyV9g0EIqfDAj6yreiWgHawM264wZUNW
         MOWg==
Content-Language: en-US
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 9/22/23 04:28, Yafang Shao wrote:
> Currently, BPF is primarily confined to cgroup2, with the exception of
> cgroup_iter, which supports cgroup1 fds. Unfortunately, this limitation
> prevents us from harnessing the full potential of BPF within cgroup1
> environments.
> 
> In our endeavor to seamlessly integrate BPF within our Kubernetes
> environment, which relies on cgroup1, we have been exploring the
> possibility of transitioning to cgroup2. While this transition is
> forward-looking, it poses challenges due to the necessity for numerous
> applications to adapt.
> 
> While we acknowledge that cgroup2 represents the future, we also recognize
> that such transitions demand time and effort. As a result, we are
> considering an alternative approach. Instead of migrating to cgroup2, we
> are contemplating modifications to the BPF kernel code to ensure
> compatibility with cgroup1. These adjustments appear to be relatively
> minor, making this option more feasible.

Do you mean giving up moving to cgroup2? Or, is it just a tentative
solution?

