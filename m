From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Tue, 10 Mar 2020 12:40:00 -0700
Message-ID: <CALvZod62gypsxCYOpGsR6SWwp7roh8eEEKvZ8WNFtjB0bH=okg@mail.gmail.com>
References: <20200305211632.15369-1-dxu@dxuuu.xyz> <20200305211632.15369-2-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N85h88yMkj8nihjHQm5ShxaRV163FX/geAkJs+oMDoE=;
        b=mUx0pRt/ifhXaLLeig29B1PZojnEWlfUQmKs76Nv0uFBrXGkEImVFyRuM2RtPAKYrz
         uPUV4AhgKlcGGM7ci4cny3Acn0RSgANJXvKZITpusUovp8NJpyby6fv/3pgN944NKPq6
         pJjTuD4ANLUt7oKFFpCa08kjySsiLipzgsaqgw7opqvek6pA9YKQnGP7YkUhsVPUIiSX
         o7LWuk7IzswFmykdgtRgW7/wO6m7C46+nxa4JsJelT9+sTJsO1RctClvfYZPGwnaiTnJ
         pq/+MnDJRWsufhQ6WmqOk76NLBvNv6ock80strcOjO9LaH6gs9P9EpEJ2+2zwW5q/c5T
         4fLQ==
In-Reply-To: <20200305211632.15369-2-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

Hi Daniel,

On Thu, Mar 5, 2020 at 1:16 PM Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org> wrote:
>
> It's not really necessary to have contiguous physical memory for xattr
> values. We no longer need to worry about higher order allocations
> failing with kvmalloc, especially because the xattr size limit is at
> 64K.
>
> Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>

The patch looks fine to me. However the commit message is too cryptic
i.e. hard to get the motivation behind the change.
