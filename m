From: Chuhong Yuan <hslester96@gmail.com>
Subject: Re: [PATCH 01/12] rdmacg: Replace strncmp with str_has_prefix
Date: Mon, 2 Sep 2019 14:48:05 +0800
Message-ID: <CANhBUQ1NvLc7vxMJsFpCN2X502d8TwZSVNTJPfg35Y_ocUpYPA@mail.gmail.com>
References: <20190729151346.9280-1-hslester96@gmail.com> <201907292117.DA40CA7D@keescook>
 <CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com> <201908291652.46E2D65@keescook>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMzxmnkxNJ25Ubbbpj3fmyVSXQrVBstVeDl3+hULd4I=;
        b=ALTtMzFn01urPW1oTRJx8B8KaMUkx5MsYciorahuYhsXjqCHHMYHNTyPmOlvxbP8H/
         7y34YPgWOWXKI6kZgpy/CbydTQFA6W6oEtPvXdi670yMBN8T59o9xYDh4yrC/jx5wmsq
         SS20Qct5zUK4wP0LTYZohQqqcZOSgg/aD2qkVkSvaPVAe5s7otwTtVWomLlmjIyLxwL7
         ia9wKVWkXkd7b0IWIB3MUucyEN2xttcLijQZsmMl9XOGA9dhKvo2oZIclli1IUkvJAMA
         GFWhSM3pluYyrWl1n2qUWnt10pZ0F+2uQIrQzM/mZpYz5HkbWfCdU2pKKNajItqKcnhK
         iUmg==
In-Reply-To: <201908291652.46E2D65@keescook>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>, Laura Abbott <labbott@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Steven Rostedt <rostedt@goodmis.org>

On Fri, Aug 30, 2019 at 7:52 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Jul 30, 2019 at 02:39:40PM +0800, Chuhong Yuan wrote:
> > I think with the help of Coccinelle script, all strncmp(str, const, len)
> > can be replaced and these problems will be eliminated. :)
>
> Hi! Just pinging this thread again. Any progress on this conversion?
>

I didn't work further on this conversion since it seems that developers
are not very interested in this problem (only half of my sent patches have
been responded till now) and I am working on other projects recently.

If the Coccinelle script is needed, I can try to implement it next week.

Regards,
Chuhong

> Thanks!
>
> --
> Kees Cook
