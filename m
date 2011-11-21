From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Date: Mon, 21 Nov 2011 16:30:11 +0530
Message-ID: <CAKTCnzk81UiqVHGcTcN_0iyG8dw=-wC6jo8ME7g303PQFKDM3w@mail.gmail.com>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=FF7xRICxEE/vKC1DXDiK7dPG2xaSxGBFZ2i/I8AO8zE=;
        b=jKsh9VjI8kxb+IzsHp5CAw0nCrz9apjqhW//h+9UAWYE2uKQ2QdrBg2aqbFPt/+Zl6
         4a4P+8j6Ticv/fwUMs9rcUEvIr4IiYvvNW2tA2I2eXd9yCZ37lA6lJOxCJ8DQ24Q/lIz
         fr2B7OKQ4W+GJHio8kylURPXboendvCVWAaOs=
In-Reply-To: <20111117103308.063f78df.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Nov 17, 2011 at 7:03 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>
> I'll send this again when mm is shipped.
> I sometimes see mem_cgroup_split_huge_fixup() in perf report and noti=
ced
> it's very slow. This fixes it. Any comments are welcome.
>

How do you see this - what tests?

> =3D=3D
> Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
>
> at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> and modify page_cgroup and LRU accounting jobs and called
> HPAGE_PMD_SIZE - 1 times.
>
> But thinking again,
> =A0- compound_lock() is held at move_accout...then, it's not necessar=
y
> =A0 =A0to take move_lock_page_cgroup().
> =A0- LRU is locked and all tail pages will go into the same LRU as
> =A0 =A0head is now on.
> =A0- page_cgroup is contiguous in huge page range.
>
> This patch fixes mem_cgroup_split_huge_fixup() as to be called once p=
er
> hugepage and reduce costs for spliting.

The change seems reasonable, I am working on a test setup and hope to
test it soon

Balbir
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
