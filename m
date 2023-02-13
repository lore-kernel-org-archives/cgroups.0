From: Victor Stewart <v@nametag.social>
Subject: Re: [BUG ?]: hugetlb.xxx[.rsvd].max implicit write failure
Date: Mon, 13 Feb 2023 12:47:29 +0000
Message-ID: <CAM1kxwgh1expSb_zfLy-CDDcH_mNgJEmwNLxmF_YTEcDGgCSmw@mail.gmail.com>
References: <CAM1kxwgN40r3tqdUFXPNgSAB3djMTDpDAXOACsS2zOF=LXxeyw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rh4Kqn4+7KWXS3H/aKAK51ihf1ygtrczxgKWhB+Qs0w=;
        b=gJug4aVhXfibqFqH+coTt2+jvlis6+zE4jh3tnVRcFv3JobKmeOWVwP+1qi3fjjwHv
         Z1j+2C4QNPL+UvWdqn8XOcspI48GXcQeaxq+oNHa6AOdfroIdAO3X87RiazVQcIl+eBX
         3U4I7rdQ8ctXeKx9xqHJUhmPYvW4SGL5+WIkXBlmaAjIbEAu59JeVqb8sKTKMsbdC+P7
         p/skYrVgy7tXy65wjtM+V2bx2NehZYokREtay8Daqe/TtVz1xgFuL8hB06aJ/Fpzo1ke
         nrV75IT90nEb73KWIDOOB+pObyhF3USY7HMZfVDxKhRbSBBZhysCIyZZ9jTRzg55k1Ip
         nZFg==
In-Reply-To: <CAM1kxwgN40r3tqdUFXPNgSAB3djMTDpDAXOACsS2zOF=LXxeyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 13, 2023 at 12:34 AM Victor Stewart <v@nametag.social> wrote:
>
> attempted to use hugetlb resource control for the first time. running 6.1.9
>
> create the subdirectory, then enable the hugetlb controller. reading the
> initial value of hugetlb.2MB.rsvd.max returns "max". i write 128 and receive a
> return value of 3. but then read hugetlb.2MB.rsvd.max and it now returns 0.
> same exact thing happens for hugetlb.2MB.max

ahh, it takes reads/writes with bytes as units, not 2MB pages.

kind of confusing and unexpected, even though memory works the same.

>
> so clearly the write is secretly failing somewhere even though the write
> operation return success?
>
> there are plenty of pages available:
>
> HugePages_Total:    4096
> HugePages_Free:     4096
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> Hugetlb:        13631488 kB
>
> none of the scarce documentation on this controller leads me to believe there's
> any required configuration beyond the above. so completely bewildered as to
> what's going wrong?
