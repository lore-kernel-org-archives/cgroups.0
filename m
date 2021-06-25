From: Ronny Meeus <ronny.meeus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Short process stall after assigning it to a cgroup
Date: Fri, 25 Jun 2021 09:32:59 +0200
Message-ID: <CAMJ=MEfMSX06-mcKuv54T7_VCCrv8uZsN-e-QiHe8-sx-sXVoA@mail.gmail.com>
References: <CAMJ=MEegYBi_G=_nk1jaJh-dtJj59EFs6ehCwP5qSBqEKseQ-Q@mail.gmail.com>
 <YNNvK0koEdkuD/z3@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bRwf8isjvoYl83x2OClryu7P0IJp28cVtw0kzUaoiqE=;
        b=J5TXfJKrChnx0Kw8UzbBdOYLoeBRXpK0qQg/BlZzemDnd7n7Atjv8ZFVzG0luzgVDN
         RV5SpCPBHXnJa7nB+vzotBodPhwU7XAV7rG4RppTJnbhnVMdHSbWOMKr99FLasoEOHxh
         j/lsD3IyuhjRU/oM/cuHScn+4wOceam19hQVGGRhB64YSaAozksVUz1Y/wIwqW0M5VH8
         fRdL0HbAr9ioXLnesQYMPlSM3gk2VvemM8m5J6YXvgfvBq9LuUAd8r1Em/eVytdUFEQU
         e2hJvtPjeUqiNTFprcaBDI0wnPrZaUiHiP5mPlGtll9xFtX3j0LxLwDuUvS3FbXjSdXr
         tpRw==
In-Reply-To: <YNNvK0koEdkuD/z3@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Op wo 23 jun. 2021 om 19:28 schreef Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>:
>
> Hello Ronny.
>
> On Mon, Jun 14, 2021 at 05:29:35PM +0200, Ronny Meeus <ronny.meeus@gmail.=
com> wrote:
> > All apps are running in the realtime domain and I'm using kernel 4.9
> > and cgroup v1. [...]  when it enters a full load condition [...]
> > I start to gradually reduce the budget of the cgroup until the system
> > is idle enough.
>
> Has your application some RT requirements or is there other reason why
> you use group RT allocations? (When your app seems to require all CPU
> time, you decide to curb it. And it still fullfills RT requirements?)
>

The application does not have strict RT requirements.
The main reason for using cgroups is to reduce the load of the high
consumer applications when the system is under high load so that also
lower prio apps can have a portion of the CPU.
We were working with fixed croups initially but this has the big
disadvantage that the unused budget configured in one group cannot be
used by another group and as such the processing power is basically
lost.

>
> > But sometimes, immediately after the process assignment, it stops for
> > a short period (something like 1 or 2s) and then starts to consume 40%
> > again.
>
> What if you reduce cpu.rt_period_us (and cpu.rt_runtime_us
> proportionally)? (Are the pauses shorter?) Is there any useful info in
> /proc/$PID/stack during these periods?
>

I tried to use shorter periods like 100ms instead of 1s but the
problem is still observed.
Using a proportionally reducing algo is more complex to implement and
I think would not solve the issue either.

About the stack: it is difficult to know from the SW when the issue
happens so dumping the stack is not easy I think but it is a good
idea.
I will certainly think about it.
To observe the system I use a spirent traffic generator which shows me
the number of processed packets in a nice graph. In this way it is
easy to see that there are short peaks when the system is not
returning any packets.

> > Is that expected behavior?
>
> Someone with RT group schedulling knowledge may tell :-)
>
> HTH,
> Michal
