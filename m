From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] cgroup: Fix typo in comments and documents
Date: Fri, 30 Jul 2021 07:53:07 -0700
Message-ID: <CALvZod6sUh0XQGVb4wEfzGNDcrLabgmjEdu+wh0g1c=cvvci4Q@mail.gmail.com>
References: <20210730051605.2626-1-caihuoqing@baidu.com> <0516372e-0120-ff52-bf9a-cf1cda9a633f@email.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WwILEX7NR1VzEi/uBdrHjZ2rhekLFtKl+IjEJ6PsRbo=;
        b=eSRscB5LQZ42d/wJxzzYPB1M2Ev+d8TH1pk1kq7FZs6bBPalAKZ3cFxeJSuSpu3dN0
         Em59MuepSMmpBso4Ynu1+27CaFcZ/iVxU8JvxIa1juSCTwjR6YMwx9wll3fjX5aCGryx
         45DqbbN+Vkr/RNTQXWcM1pYi75BmOfzzVzQXBH9/jduPm+5mKvBVTvWDtNNS2TWuLZA7
         SjJ+vWgQYQe8cUdVUakQ72OAzF+V4E0mXkB/PO+kFm4hQvjmJr/4XUmQZIE0UtBv6/no
         Cz6pNjN2L+umPZr0BsmaHwqvuBPvKfnA6X6V143fY0lGA+TJgx0m3RbMz7Vh66AHtjOK
         lPuQ==
In-Reply-To: <0516372e-0120-ff52-bf9a-cf1cda9a633f@email.cn>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hu Haowen <src.res@email.cn>
Cc: Cai Huoqing <caihuoqing@baidu.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Jul 30, 2021 at 6:44 AM Hu Haowen <src.res@email.cn> wrote:
>
>
> =E5=9C=A8 2021/7/30 =E4=B8=8B=E5=8D=881:16, Cai Huoqing =E5=86=99=E9=81=
=93:
> > Fix typo: iff  =3D=3D> if

This is not a typo. 'iff' means 'if and only if'. For details see
https://en.wikipedia.org/wiki/If_and_only_if.
