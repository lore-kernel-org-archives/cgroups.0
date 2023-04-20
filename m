From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 5/5] cgroup: remove
 cgroup_rstat_flush_atomic()
Date: Thu, 20 Apr 2023 09:48:46 -1000
Message-ID: <ZEGXHvEPsfORq36_@slm.duckdns.org>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-6-yosryahmed@google.com>
 <CALvZod79Au=Fw9MTW7fP0P7KwQQ_NUiKgRHsNUFnv9v61pKnZA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682020128; x=1684612128;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hSMRCReTvqtVhzznHuB7A9Sa7YpxOxqbCtc68BgIgE=;
        b=GoIwaWRNZp8R808HTRD2raT1Cv8BRnqejXttPEHtds1fb9h/AhpUl9OJJDZbZmKXs5
         ej/EgFXvWbW4w9LKCGU126TWEXFo2+e2QBkYSEiIkVYLkKp1Yq2F3zfrwPr0jqd9Gxuf
         nQBlNGqMhkaoKeGxlQQKNtnQKu8VM9dMoPNkjoNtq2Vl5kaG9YwMIhgPxXoCy36D5FRc
         kTUIUtcABjFyfsXA5LyCQQ3tIc/llbcBmRnzOByhC5xDRPIRsz2ZEK0WecgOzzFd/OBx
         kDyCdn5VDNCWI38ITAGu4oI1U/W4LwSmXRJIn63S/wewHbLIYoRGeaHxay6aEJrk9U+e
         dTKg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod79Au=Fw9MTW7fP0P7KwQQ_NUiKgRHsNUFnv9v61pKnZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 20, 2023 at 12:40:24PM -0700, Shakeel Butt wrote:
> +Tejun
>=20
>=20
> On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKl=
fQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Previous patches removed the only caller of cgroup_rstat_flush_atomic().
> > Remove the function and simplify the code.
>=20
>=20
> I would say let cgroup maintainers decide this and this patch can be
> decoupled from the series.

Looks fine to me but yeah please cc me on the whole series from the next
round.

Thanks.

--=20
tejun
