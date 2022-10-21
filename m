From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Fri, 21 Oct 2022 11:53:34 -0700
Message-ID: <CALvZod6TXxp9nXuPcWD1Vhi6jvxyWeAOrwXvDfTTxYC9RviWhQ@mail.gmail.com>
References: <20221021160304.1362511-1-kuba@kernel.org> <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
 <CANn89iKTi5TYyFOOpgw3P0eTi1Gqn4k-eX+xRTX78Q4sAunm2Q@mail.gmail.com>
 <CALvZod5di3saFdDJ1cwFDgvLPmnEJ7XB9P8YBTJ3uzfBKAFi3Q@mail.gmail.com> <20221021104016.407cbda9@kernel.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WpUHQ3H2dxiw8WYhyzGCQZNfs2uYsqjIQqTj/d0xOKY=;
        b=SkfJyFOI7pZcn7NohaH2rj/ApDcBFOQehX8ecSSnjNf8Hcr0k4n8t5c4dzlyLHXpV7
         4PefvFXYx1//rzTI2zoUgnJDy1gnXEn6F7kUCPo2bcltE3X8XJGJRD1aiJOWWqBQbPJ+
         xg6UkWLIBGVWS4tIzYyWjwaWa9engwXfyWGW0NDwRn7zGwip8AKNMeultGWoNh6JSRpQ
         S0xOZ7x/dgXUHlNeU6qPE2mONVpA6UaGVXuQmMjZ/+tLX6k/UV0QvRTL25F5dKdt97il
         EWI1fIEH+nScZtX9TmbCoNUeFMG5LFi1w92hgi/CYzyUONJx3lSv2COzTTW6hwTL6BuS
         ekpQ==
In-Reply-To: <20221021104016.407cbda9@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com, cgroups@vger.kernel.org, roman.gushchin@linux.dev, weiwan@google.com, ncardwell@google.com, ycheng@google.com

On Fri, Oct 21, 2022 at 10:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 21 Oct 2022 09:34:20 -0700 Shakeel Butt wrote:
> > > > How about just using gfp_any() and we can remove gfp_memcg_charge()?
> > >
> > > How about keeping gfp_memcg_charge() and adding a comment on its intent ?
> > >
> > > gfp_any() is very generic :/
>
> That was my thinking, and I'm not sure what I could put in a comment.
> Wouldn't it be some mix of words 'flags', 'memory', 'cgroup' and
> 'charge'... which is just spelling out the name of the function?
>
> I mean:
>
>         /* Alloc flags for passing to cgroup socket memory charging */
>
> does not add much value, right?

Yeah I agree. Let's just go with the original patch.

You can add:

Acked-by: Shakeel Butt <shakeelb@google.com>
