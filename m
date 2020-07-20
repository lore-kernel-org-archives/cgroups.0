From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Mon, 20 Jul 2020 23:27:57 +0200
Message-ID: <CAFLxGvyxtYnJ5UdD18uNA97zQaDB8-Wv8MHQn2g9GYD74v7cTg@mail.gmail.com>
References: <20200720075148.172156-1-hch@lst.de> <20200720075148.172156-5-hch@lst.de>
 <CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
 <20200720120734.GA29061@lst.de> <2827a5dbd94bc5c2c1706a6074d9a9a32a590feb.camel@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sh/KLSzQqnJr0/PMf2DmO5rUtVYfFwMH4ti+obo2a7s=;
        b=EulKUbZ0padoY58Gz7BUn19Q8Hk6KEJaTssCqM4lILM7IAI6zewfZh8oqNUoUyQoQB
         7NTznTeKJycRqCHBebiJHdUDc3dJuXT4oWkSqv7Nd8vAXT58D5mHAgRZrE/rlefmctXk
         iF0R314VBwwyPtZ5vQ9GjPl1jHRYIZxMQkWwbkCU5KpbxSiLWlT5Nqva2QiK7czML7c5
         URTZec+Vmlsd24zt83lXA6dlTzT6u6pS8nCtPCyLiAvWG+LFRFdZ5hizdC/H3ow8Mkn8
         0jt58w1ztanJnkcf9f7qnHKksF3N35HduNlT0BJ1Z5fBq2yUpp1KgYjnlkc1j3tOh7m6
         BfSQ==
In-Reply-To: <2827a5dbd94bc5c2c1706a6074d9a9a32a590feb.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Song Liu <song@kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-mtd@lists.infradead.org, linux-mm@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, drbd-dev@lists.linbit.com

On Mon, Jul 20, 2020 at 2:37 PM Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
> On Mon, 2020-07-20 at 14:07 +0200, Christoph Hellwig wrote:
> > What about jffs2 and blk2mtd raw block devices?

I don't worry much about blk2mtd.

> If my memory serves me correctly JFFS2 did not mind readahead.

This covers my knowledge too.
I fear enabling readahead on JFFS2 will cause performance issues, this
filesystem
is mostly used on small and slow NOR devices.

-- 
Thanks,
//richard
