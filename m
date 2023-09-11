From: Wei Xu <weixugc@google.com>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 11 Sep 2023 12:15:24 -0700
Message-ID: <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com> <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com> <ZP8SDdjut9VEVpps@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694459737; x=1695064537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/sdkzsmQxQA0VmUOWu2qcGx46dyeNaTu7jP8u1Dy9E=;
        b=ukkIBmS919vl27KhRiuDqnNzkQ+5uAuOQR5w+ahaQlk7iF7L9jXvBM3zIipxykVlvD
         nBbFiMaHyjG8Ccyi9hKcSyaaf+5uYp8g/9E5odZ0r1QjiSBMDE5JFVGXGOZGMeYTRKut
         BQ4+H2sRMT8WldIzcH7qmvllFF1h+GBwKeWkz7qiteQ9Sl9UpTdscFclG1qXgvwGnJM8
         xh4Li8xwkqSzymkY6DIFtpU1oITAGbHkg2yzY5foeRXI0O4lzHnNZJmUBAOr2/vhUFrV
         18HjmeF4WzGjtRKQC4LFs7YSagXTEEAN8pKmd1JnpTVs+jf7/DT/faZxpcPbQNBAaluR
         YVSw==
In-Reply-To: <ZP8SDdjut9VEVpps@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>

On Mon, Sep 11, 2023 at 6:11=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 07-09-23 17:52:12, Wei Xu wrote:
> [...]
> > I tested this patch on a machine with 384 CPUs using a microbenchmark
> > that spawns 10K threads, each reading its memory.stat every 100
> > milliseconds.
>
> This is rather extreme case but I wouldn't call it utterly insane
> though.
>
> > Most of memory.stat reads take 5ms-10ms in kernel, with
> > ~5% reads even exceeding 1 second.
>
> Just curious, what would numbers look like if the mutex is removed and
> those threads would be condending on the existing spinlock with lock
> dropping in place and removed. Would you be willing to give it a shot?

Without the mutex and with the spinlock only, the common read latency
of memory.stat is still 5ms-10ms in kernel. There are very few reads
(<0.003%) going above 10ms and none more than 1 second.

> --
> Michal Hocko
> SUSE Labs
