From: "Daniel Xu" <dxu@dxuuu.xyz>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Tue, 10 Mar 2020 13:40:08 -0700
Message-ID: <C17G1V88F2XD.EQFO8E8QX1YO@dlxu-fedora-R90QNFJV>
References: <CALvZod62gypsxCYOpGsR6SWwp7roh8eEEKvZ8WNFtjB0bH=okg@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm2; bh=8WvbRILYPoYcT8dxosBEiC8oW
        xw+zHTO76bbxckt8n8=; b=ZTdTsBQqnGlN82GljZ7ESrmeyYE+fTjgey4UhMzpJ
        3N4fMDtH9kyzIGOx7nzUYnSKc7bXucBB8PkuCIq/jwR/fFicp7c1o20WDkFIcL9O
        qax6PFx9BpgRnJgmLcC8T9bfhHyanrIqjCaHZAExqUaNRYiWoM1YLg7Fytzh+FHT
        Y6rUSTgvbrsCTnuGM/vOM5f+6Jh3xYQ4l5fgxQ2ce1bA5XdPxMStWzD+/zZmv/UK
        JHOd23JYCyC3yqwNz+MOXJczPOceZyk93e+7MhjWeQgKmGa1GgwmPVUvO8/54BES
        dhXMJPlxelF1uvg4t1fYU2ypuDHhXw8HTQhoLXEf377Hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8WvbRI
        LYPoYcT8dxosBEiC8oWxw+zHTO76bbxckt8n8=; b=QyL8Hee7vDR49szK/qplbo
        DJgRHYUR7BLgBMCqGnNi/yEhTbWK1F/Vxm27DH6xOSTGZ9qBEYoxCcjOJBJaUTVg
        IzNoXjRmOi2WsGj3pKFybI4t6AVpxuCwTA85KAhFFKkCjPn8FR7m6RJmz6swNKJd
        mZgUS1XKDKNK5osuEmg/WeawvyjNGbZqYw0g5qvhMTJxVf0ueop8qfBJn0R6SQTw
        bg8QbkSCePE+YAZx2Vwa+EGoz0OGTG3XFVhgh+t+czA922S9NdxdeJUdnJ5HLRBS
        V0EPPoRtMjQSK1DhY2HRuRwCvbPtjdLtdJ6mVYZzbVwpnGz2lSsu0i8pnxw8JthQ
        ==
In-Reply-To: <CALvZod62gypsxCYOpGsR6SWwp7roh8eEEKvZ8WNFtjB0bH=okg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel Team <kernel-team@fb.com>

Hi Shakeel,

On Tue Mar 10, 2020 at 12:40 PM, Shakeel Butt wrote:
> Hi Daniel,
>
>=20
> On Thu, Mar 5, 2020 at 1:16 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > It's not really necessary to have contiguous physical memory for xattr
> > values. We no longer need to worry about higher order allocations
> > failing with kvmalloc, especially because the xattr size limit is at
> > 64K.
> >
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>
>=20
> The patch looks fine to me. However the commit message is too cryptic
> i.e. hard to get the motivation behind the change.
>

Thanks for taking a look. The real reason I did it was because Tejun
said so :).

Tejun, is there a larger reason?


Thanks,
Daniel
