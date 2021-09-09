From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and misc_events.local
Date: Thu, 9 Sep 2021 09:56:17 -0700
Message-ID: <CAHVum0cGkzLg_5fZNFNTG=RRqGYW-8YG2V3gst1TevjtQ4YdBA@mail.gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZVjhQf4Wc5qDwKc6Wxkb4xPFLHy4YamVgNh/i3e/aqg=;
        b=sV1HzMzIqQ847QSIIUoHp201jmkdi8+7JMKKQdM8EinRPUqW6MxoJPuy/M2sRh2YX8
         xGwcv5MvtoepmTeQz63R00ZU3mkodxx8Vtuf7cefIh7JiddrNc0Yd+HLcMnE0u5OAfR/
         fweeDgDPOYX5WlQZwmnM8z7OYcNcHK5+OUWA6PU/YOo3Ef1EPu2B782teb163N0EMh5v
         mjd6zGLdXtWdZIVYySo5svms0Bzb+9s5hNCnj2sj2n75/Y3AjSmdyyKIMNTBPT1kXSVH
         /V0DIbMAyvMrgOFxygJGca5bv4qaGEU//VC0F8i/MejvgsFhmMA+lFU74x5dSN7tsYCr
         da0Q==
In-Reply-To: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 7, 2021 at 10:24 PM brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>
> Introduce misc.events and misc.events.local to make it easier for
> us to understand the pressure of resources. The main idea comes
> from mem_cgroup.
>
> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> ---
>  include/linux/misc_cgroup.h |  9 +++++++
>  kernel/cgroup/misc.c        | 50 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 58 insertions(+), 1 deletion(-)

Thanks for the changes. Please also update the documentation at
Documentation/admin-guide/cgroup-v2.rst for the new changes in the
misc cgroup.
