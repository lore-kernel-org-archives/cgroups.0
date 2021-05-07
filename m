From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Fri, 7 May 2021 16:59:13 -0400
Message-ID: <YJWqIVnX9giaKMTG@slm.duckdns.org>
References: <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
 <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local>
 <YJWWByISHSPqF+aN@slm.duckdns.org>
 <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WM3qTdeeeQvN9wqJqOAh1ks+lZ+P1gcdIZXNpOTonrc=;
        b=r+Rn1FuazZF3GatZUdqZ9l+FO+YTxA1D3YJlPcigoUO/F7/3KKxnkKe8ET7nEtAaih
         h6fBoqyszKYVFnDS+WIP+vKhSBconGErn5q6t57LNyLRSMcUsTeSRHebj6zjsqnU8x91
         x0LcaPNDgX8NgwJDE+oQh/NazmWbYdiuBHCUfHS5bzAcrnOI8eVAd750FcUke5aERvyk
         RyJfEPfKen91mYgLYXsAZnWv3MdAYzlzFwN7wIWnOJ841tOYm5RbkLFP9VKshPpvdoKI
         PnUzOkCTWO4flAD3dS69vOC0XZLegxH4D7oQ0YhZ3bJhNRecuxNpozapdS0JCFX0VV/K
         EdCg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Kenny Ho <y2kenny@gmail.com>, Song Liu <songliubraving@fb.com>, Andrii Nakryiko <andriin@fb.com>, DRI Development <dri-devel@lists.freedesktop.org>, Daniel Borkmann <daniel@iogearbox.net>, Kenny Ho <Kenny.Ho@amd.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Brian Welty <brian.welty@intel.com>, John Fastabend <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, Martin KaFai Lau <kafai@fb.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Network Development <netdev@vger.kernel.org>, KP Singh <kpsingh@chromium.org>, Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>, Dave Airlie <airlied@gmail.com>

Hello,

On Fri, May 07, 2021 at 03:55:39PM -0400, Alex Deucher wrote:
> The problem is temporal partitioning on GPUs is much harder to enforce
> unless you have a special case like SR-IOV.  Spatial partitioning, on
> AMD GPUs at least, is widely available and easily enforced.  What is
> the point of implementing temporal style cgroups if no one can enforce
> it effectively?

So, if generic fine-grained partitioning can't be implemented, the right
thing to do is stopping pushing for full-blown cgroup interface for it. The
hardware simply isn't capable of being managed in a way which allows generic
fine-grained hierarchical scheduling and there's no point in bloating the
interface with half baked hardware dependent features.

This isn't to say that there's no way to support them, but what have been
being proposed is way too generic and ambitious in terms of interface while
being poorly developed on the internal abstraction and mechanism front. If
the hardware can't do generic, either implement the barest minimum interface
(e.g. be a part of misc controller) or go driver-specific - the feature is
hardware specific anyway. I've repeated this multiple times in these
discussions now but it'd be really helpful to try to minimize the interace
while concentrating more on internal abstractions and actual control
mechanisms.

Thanks.

-- 
tejun
