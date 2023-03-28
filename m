From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Tue, 28 Mar 2023 07:59:04 -0700
Message-ID: <CALvZod4zLhgjd3Tr5Qauz+OwF7Gj-NwDZPMpYAsxaMSUvu3F4g@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-5-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680015555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/Tr76xWiRdPhCzh2iAIz1ngMVJemqmUsrV57MPqNeE=;
        b=Tt1MpwBCckGfBRJPyJn7mnYIufUfVxu0osm9Xuq8gDBzp9Zl5SijHD6x4KQjbrMWEh
         cR4itExVYXUY8HTQuYCWuV5Rg6H125SdaHSCPAvUlKamplxStCH4rjE2/WcnHTjKhjrt
         038rfwwfndQ2ou7fJtK3qBflN/A1iDRlkq81JX+Z7insN5nb1uTL0Uo01n0XraIao7M2
         Fdp9ucU3Ljn6qpuDyKhjPEtSctWImYf+1VP6nPOE2U4SSXgKWYIn4QDlVxtNK1zY5mgr
         bLTFWCgmCGlE6IuJslMe1IS18hr0AuFjkuVwxblk3dP0+AkaQl8W95dVHmZXdHKaN7fx
         PZeg==
In-Reply-To: <20230328061638.203420-5-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> rstat flushing is too expensive to perform in irq context.
> The previous patch removed the only context that may invoke an rstat
> flush from irq context, add a WARN_ON_ONCE() to detect future
> violations, or those that we are not aware of.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
