From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 0/2] memcg: OOM log improvements
Date: Wed, 26 Apr 2023 07:20:15 -0700
Message-ID: <CAJD7tkZ1fM4h_PYD+6XiSEiJFKU0B91anV7xEEoLgLdtpMTHRQ@mail.gmail.com>
References: <20230426133919.1342942-1-yosryahmed@google.com> <20230426101922.49a66ee6@gandalf.local.home>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682518852; x=1685110852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HgpJhfslW9AJxpWh6L39g4b9zrGjSQZYS/g5Jt+Nqj8=;
        b=Eyg15XOqfRojyNHkgX+U5vM5JVy3wnEtjmADA5EpeYfP8poMCa7IW3j8xjCyBiO8+K
         BC/aygNk7B0kYFA5L0cq71ZO7wX6JZQnU9xAH/f1t9DDYXQb0JMvAs5rNGA9zu1GC2bF
         xW1uCY0lVr81LtB15Tku27roz5XoVg0EuUz7xgpRQcCeg1+0DQqVi4gUg84LGJh2Bm29
         9pBOcABPgS3XiF6+CH1cOIMmIAVe42GEQ9/zUcRqKVpwdnDOUX2Qo3FvAV/vniRy460u
         JHKl8UYLf2Bjvfk7rz31Lr1PyQ0EyxajN8Se3AbY+wuiVI0GnevbWPlAwZCuqq2lE9R/
         CWOA==
In-Reply-To: <20230426101922.49a66ee6@gandalf.local.home>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, Petr Mladek <pmladek@suse.com>, Chris Li <chrisl@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Apr 26, 2023 at 7:19=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Wed, 26 Apr 2023 13:39:17 +0000
> Yosry Ahmed <yosryahmed@google.com> wrote:
>
> > The series uses seq_buf_do_printk() which was only recently introduced
> > [1]. It did not land in Linus's tree yet, but ideally it will land this
> > merge window. I thought I would share the patches meanwhile for
> > feedback.
> >
> > [1]https://lore.kernel.org/lkml/20230415100110.1419872-1-senozhatsky@ch=
romium.org/
>
> FYI, it's running through my tests right now (with several other patches)=
.
>
> If everything passes, I'll let it sit in linux-next for a day or two than
> push to Linus at the end of the week.
>
> -- Steve

Great! Thanks for the update!
