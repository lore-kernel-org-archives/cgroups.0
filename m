From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 0/2] mm: memcg: fix tracking of pending stats updates values
Date: Fri, 22 Sep 2023 10:59:13 -0700
Message-ID: <CAJD7tkbHcJ59XLk1VqhkLtuZOqqw=VQyCqB1eooy6hR7eb3RSQ@mail.gmail.com>
References: <20230922082542.466579-1-yosryahmed@google.com> <20230922100310.102aa12ac2bdf0568e6e7432@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695405593; x=1696010393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neFKDss4Eoz4zqBDkZFgiJEWmdfT57VEWXtM0Jgtcu8=;
        b=NO2GxxrARKtVZOSuIAMt9Ix6EPjYW5hGkY5KMhlhPvlklZuBBhdfW3kQzC5UIS0Gcu
         noUJVp1dkiwSLCuovsS6cydQnDXH5XO0oIM8TJa8aHmqSkWc0U4djBl2EYpwmbdTenLW
         vcxon6A//JrFRuM567ICtp58sVYzH8TcEqvFnfhqISxB/TlRsu+WI0S2TS8QM2H8sJzG
         daE25I68Iq6ByjiVUOX/McVVxqTLPVx+wNqyzVrYjk3mtwbMlk7VZtjfSvuX6jdrEtlv
         jaNpj23Rwq3D197kfypZs0chiG70X45KWoPd8usq1ljHbZxU6qyxmR9Fp46Kd0XMX9Vs
         ToCg==
In-Reply-To: <20230922100310.102aa12ac2bdf0568e6e7432@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 22, 2023 at 10:03=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 22 Sep 2023 08:25:40 +0000 Yosry Ahmed <yosryahmed@google.com> wr=
ote:
>
> > While working on adjacent code [1], I realized that the values passed
> > into memcg_rstat_updated() to keep track of the magnitude of pending
> > updates is consistent. It is mostly in pages, but sometimes it can be i=
n
> > bytes or KBs. Fix that.
>
> Clashes with "memcg: remove unused do_memsw_account in
> memcg1_stat_format", and maybe other things.  Can you please redo
> against mm-unsstable or linux-next?

Done, sent v2:
https://lore.kernel.org/linux-mm/20230922175741.635002-1-yosryahmed@google.=
com/

Thanks!
