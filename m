From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH mm-unstable RFC 4/5] memcg: remove mem_cgroup_flush_stats_atomic()
Date: Thu, 20 Apr 2023 12:38:16 -0700
Message-ID: <CALvZod6wiCzpbCOtR06vGXy+gb6adC8RCkXfsRjC-N8yJorGWg@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com> <20230403220337.443510-5-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682019507; x=1684611507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbkXWBpwVxhf9T5z1cj4mwmJl7+Xdft765BvQGmNJoc=;
        b=Ciz/t1cEtCUCOm5soArFZ936T3/SUb8VLB6c5P8LGdbu6vVDAjL9VlEeJbi2ziuhxy
         C3vmNugZAc+x8atgpej6AYWTbg/CH71jBJ0GUVSsktziCLpabOw7/zqEc+skmTFrOO+i
         ZotbQR6QLIGThfZYmTQOsHIcM4IBzEj1DPNrJDhEruo8QA3xEDRWU0solT/rU2BAY/yV
         85SiFvDILk1jQ3JOtF5iesWxvT/b7C3s8OyqovZ33BteZR/RTUJDUejNm5BY5J1b+QCh
         LqVHQd2X9sSBfcuCGaWZZ5VX5RmRRr6etLFaH8HToHo6sDWVSQ8xu7PDiyXLRdFEokvw
         TciA==
In-Reply-To: <20230403220337.443510-5-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com> =
wrote:
>
> Previous patches removed all callers of mem_cgroup_flush_stats_atomic().
> Remove the function and simplify the code.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
