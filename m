From: Shakeel Butt <shakeelb@google.com>
Subject: Re: BUG at mm/vmalloc.c:3089! - invalid opcode: 0000 [#1] SMP KASAN PTI
Date: Wed, 22 Jul 2020 09:16:57 -0700
Message-ID: <CALvZod5cBTsytQz5=EbqT_s1_ZJ8YpkBe+CLEAU+25FP4kHSAg@mail.gmail.com>
References: <CA+G9fYuj3bHUMz8XQztbmTgF0c5+rZ5-FkUjFyvEftej2jLT+Q@mail.gmail.com>
 <CAK8P3a3br1bDc8C6UjRWzdmwzVV26YYe3ixHV7LH5Z0-OiqPQQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tcL+fVRHFbwjcT2YoeEyW0ovDsmOpco9f4REaf4pOLw=;
        b=Yubxcjwtpc7YJGf0Tziz+sT7J49N0W4XOpcuP6qz+/oiMJmZWQU/Kd8bRbKoKhkvRZ
         RnULiCwqMICOqU1HdOr0DGkfNUWsljA27n+XJ+U5D4l98CuiRYbkSXMPr4+W0DyFNtb+
         AY+GHqK5P2TwUgTqNVgFJTxJoi0sTaFqqe+6N0p/LenOodA1YiaVIgE+e2BMkKkM402X
         R4n2L8/Xi3rrf4jYh3bII4QM3zJZ2tIZWJ5l8SbQpLT5zkqRCfn06WbbJYUNLuUFZK79
         2WjQU9hbziDqo4arXlFdwyZ0UC8MY80G8CFPHzWB/TsG+e4NxODiBVUvc4xDIlT2n9fa
         B76A==
In-Reply-To: <CAK8P3a3br1bDc8C6UjRWzdmwzVV26YYe3ixHV7LH5Z0-OiqPQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, lkft-triage@lists.linaro.org, LTP List <ltp@lists.linux.it>, Cgroups <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, Joel Fernandes <joel@joelfernandes.org>, "Uladzislau Rezki (Sony)" <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>, Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>, Steven Rostedt <rostedt@goodmis.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Mike Rapoport <rppt@linux.ibm.com>, David Hildenbrand <david@redhat.com>, Joerg Roedel <jroedel@suse.de>, Roman

On Wed, Jul 22, 2020 at 1:55 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Adding Roman Gushchin to Cc, he touched that code recently.
>
> Naresh, if nobody has any immediate ideas, you could double-check by
> reverting these commits:
>
> e0b8d00b7561 mm: memcg/percpu: per-memcg percpu memory statistics
> 99411af13595 mm/percpu: fix 'defined but not used' warning
> 9398ce6306b6 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix
> 54116d471779 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix
> ec518e090843 mm: memcg/percpu: account percpu memory to memory cgroups
> 9bc897d18dc3 percpu: return number of released bytes from pcpu_free_area()
>
>        Arnd
>

I think syzbot has bisected this issue to the suspect patch.

https://lore.kernel.org/lkml/00000000000043f09405ab01b0b8@google.com/
