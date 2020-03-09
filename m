From: "Daniel Xu" <dxu@dxuuu.xyz>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Mon, 09 Mar 2020 11:21:33 -0700
Message-ID: <C16IH7NEXW4J.440OGTNY7CWX@dlxu-fedora-R90QNFJV>
References: <58c6e6dafabea52e5b030d18b83c13e4f43ab8e3.camel@perches.com>
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm2; bh=Dj8K1Y9A/sg8En4uAWfo+rhEO
        VoMBMW9TFciIFvXrkE=; b=bZuCeSSWq8fdUjsWIYiXViPPtFUijVzJJqyfWz8RD
        j2/DY/zLoVyKzJoIBj9Nx6EcdQY9qnVeWyQXPurcNir6/dV6HhcXESlOKquWL+oV
        fkrlFouUR5dexW/dFMzJRxEh2jN7kSqIBSC2evA0hlKfWn7YGJ4jmsvjmMkd0eOg
        JMixXV0tw6bKBLwQxAEsq3JpxdniJBeIYQkKIYwnpsiECzKbhqp3x3tppviJv/F7
        2VBbikfuB/obg++ywvEAf/6g9dRpn7wvdKaUf5d+zdJTTSH2JwLACpVEo+tb/Pru
        NywFXqw9X6DXUNRAqnATJWqa4HkvxYbuV/nKjPrABWy5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Dj8K1Y
        9A/sg8En4uAWfo+rhEOVoMBMW9TFciIFvXrkE=; b=22A3LS72KSpNWbka0RGeLW
        vfHJrUbDsKroCmTxe1wyBSoPYA+NgvED+pCnW6ue8y1/9huYTCxp7p6fNrGFUOr4
        yd9OdRI7Jo66M4EChIlDKrsg9nDBhVwtk2UDVB7I7R/EdwUB7JILB2qXxhJrfDgE
        WMBEEXQLzwxrqgLTMHjyUAmaHUUKZxRKTDzz6BaWvF09eOeYoQKRKKwiGyW9bQXD
        QC4KZcV8Culz97nevi5ZHVAlNQeFs0y2xDXni87lVuH2cwyCi99gvXR8OWUl6Knm
        HAEQwVEl4RDt0oyHC0/bjYA6HA5EgkzLOv/64evH9vfX4UWRiiKJRcvBiGoTN9lA
        ==
In-Reply-To: <58c6e6dafabea52e5b030d18b83c13e4f43ab8e3.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Joe Perches <joe@perches.com>, cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: shakeelb@google.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

Hi Joe,

On Fri Mar 6, 2020 at 12:49 AM, Joe Perches wrote:
> On Thu, 2020-03-05 at 13:16 -0800, Daniel Xu wrote:
> > It's not really necessary to have contiguous physical memory for xattr
> > values. We no longer need to worry about higher order allocations
> > failing with kvmalloc, especially because the xattr size limit is at
> > 64K.
>
>=20
> So why use vmalloc memory at all?
>
>=20
> > diff --git a/fs/xattr.c b/fs/xattr.c
> ']
> > @@ -817,7 +817,7 @@ struct simple_xattr *simple_xattr_alloc(const void =
*value, size_t size)
> >  	if (len < sizeof(*new_xattr))
> >  		return NULL;
> > =20
> > -	new_xattr =3D kmalloc(len, GFP_KERNEL);
> > +	new_xattr =3D kvmalloc(len, GFP_KERNEL);
>
>=20
> Why is this sensible?
> vmalloc memory is a much more limited resource.

What would be the alternative? As Greg said, contiguous memory should be
more scarce.

> Also, it seems as if the function should set
> new_xattr->name to NULL before the return.
>

Will add and send in a different patch.


Thanks,
Daniel
