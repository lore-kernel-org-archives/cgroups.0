From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Fri, 7 May 2021 15:33:27 -0400
Message-ID: <YJWWByISHSPqF+aN@slm.duckdns.org>
References: <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
 <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DQeWsUe4sdL5lwcQgjwlYsUvqoVq4rgrGbWAxTRdzK0=;
        b=nGfiv21ZL8q5oVm8kipMoDb98KQPA4A9rngwmvXuqZnlY2cy9b/IbHGzKHuZ9/55Wg
         5rUH8L/Fu3n0B4hrJZ4B93X2HYBnLD/Lgrm+C58moHKKCT11Xw3AzGWg6CLYIhGjw2Lb
         sxBYCIrVWBFMASbtLYqc786mHo8oNlZnIRDVF7rJuoTPbfyqlnOLZqZwAyqypSouggs0
         yp2jIiV6O9MndUS/Sv9UxT6tVTL3ZezUAQZha9GS2GhAs+s2h+T3kfrqksj93rZHFqQj
         XaLXEGcaw6eFzEOZzgOS8jX+XQ3V8bvJnHAMEhXK/akANXg9UkdyK8Suaox+MyCAwzH0
         cAKQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YJVwtS9XJlogZRqv@phenom.ffwll.local>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Alex Deucher <alexdeucher@gmail.com>, Kenny Ho <y2kenny@gmail.com>, Song Liu <songliubraving@fb.com>, Andrii Nakryiko <andriin@fb.com>, DRI Development <dri-devel@lists.freedesktop.org>, Daniel Borkmann <daniel@iogearbox.net>, Kenny Ho <Kenny.Ho@amd.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Brian Welty <brian.welty@intel.com>, John Fastabend <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, Martin KaFai Lau <kafai@fb.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Network Development <netdev@vger.kernel.org>, KP Singh <kpsingh@chromium.org>, Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>, Dave Airlie <airlied@gmail.com>

Hello,

On Fri, May 07, 2021 at 06:54:13PM +0200, Daniel Vetter wrote:
> All I meant is that for the container/cgroups world starting out with
> time-sharing feels like the best fit, least because your SRIOV designers
> also seem to think that's the best first cut for cloud-y computing.
> Whether it's virtualized or containerized is a distinction that's getting
> ever more blurry, with virtualization become a lot more dynamic and
> container runtimes als possibly using hw virtualization underneath.

FWIW, I'm completely on the same boat. There are two fundamental issues with
hardware-mask based control - control granularity and work conservation.
Combined, they make it a significantly more difficult interface to use which
requires hardware-specific tuning rather than simply being able to say "I
wanna prioritize this job twice over that one".

My knoweldge of gpus is really limited but my understanding is also that the
gpu cores and threads aren't as homogeneous as the CPU counterparts across
the vendors, product generations and possibly even within a single chip,
which makes the problem even worse.

Given that GPUs are time-shareable to begin with, the most universal
solution seems pretty clear.

Thanks.

-- 
tejun
