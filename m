From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 22:04:21 +0200
Message-ID: <CAPAsAGxcCJai6PpTVOkqAB-vG+Q71hb1exsK79hJ7Kb2eKAtjA@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan> <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan> <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683144272; x=1685736272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHU5powRCH79ePrW9PLsNOR73hzLy7pF/AR2cVrEP7A=;
        b=X9cvzf7QfWfANWyiwaBoFAaHPlX2qeqZu2VCK9dHuW20oD3qDZADVWlb+BtBIBdSiO
         2RDzvFggR0cV7IyIeCqHDf9vzAIbh3l8EKnAha85GOqZ/85Z2kV5iHi0HZA5hxN3WCiL
         NDBgwTKeSBh1uBp9ZRn5IcKnZwjB9Xw2FNCu3VPxcgaMe8gKOK7zMR3TIQzUlk13qk0g
         Oy/vqaLM0dX473ikdNYh4d6O6S61SceyugQ5rTKI7IbtLax4XorLUr0QhjWGkIK6Mm8g
         jmi9mu20BH7ourolp1eZoSnL7KPbf6yac3FZz/qPtTH6UuXviA7A9ThzGyGaLUXBvIEp
         nt2Q==
In-Reply-To: <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@go

On Wed, May 3, 2023 at 6:35=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Kent.
>
> On Wed, May 03, 2023 at 04:05:08AM -0400, Kent Overstreet wrote:
> > No, we're still waiting on the tracing people to _demonstrate_, not
> > claim, that this is at all possible in a comparable way with tracing.
>
> So, we (meta) happen to do stuff like this all the time in the fleet to h=
unt
> down tricky persistent problems like memory leaks, ref leaks, what-have-y=
ou.
> In recent kernels, with kprobe and BPF, our ability to debug these sorts =
of
> problems has improved a great deal. Below, I'm attaching a bcc script I u=
sed
> to hunt down, IIRC, a double vfree. It's not exactly for a leak but leaks
> can follow the same pattern.
>

For leaks there is example bcc
https://github.com/iovisor/bcc/blob/master/tools/memleak.py
