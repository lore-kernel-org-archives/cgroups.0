From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: cgroup-v2: fix path to example BPF program
Date: Thu, 25 Feb 2021 13:09:34 -0700
Message-ID: <87zgzrc3k1.fsf@meer.lwn.net>
References: <20210224131631.349287-1-antonio.terceiro@linaro.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3EFDC2C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1614283775; bh=eamGHQqfFKFIt3F2dJcpYXGTGQYPLSSArF/d6nsrqBI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=q+8lFvoxPuQgBWLF7iC/BJjOOrr3jc1kYz2wxI0csNbg7zAs2stlHxtSR681ir+HD
         ZzMFNW2KOGcczgTqvvw/5SQHfs2INL0lSjD8x5XD8ED/9dViIwz3eUMR96dnWCdmMJ
         3DuwiLtPCy2CpL9Wrjupc2k/+VV2mAjHh7S9tG9LCOodaviQmiuN6zdO/G3HduqjDA
         1rUNtHm/DsKxAoeeaHkGc09WMGpKQ8lFuJQIrtkQIpi2WFWpIvNcbPSjgkKeX5QA4E
         HpeWqk9ZCZ4G+XlAWOvXPqJynx9OuLkkNGr22iAVt7foh8cr9y6RZQMMet2WBrs7A+
         jG+yZKR1XQEgA==
In-Reply-To: <20210224131631.349287-1-antonio.terceiro@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Antonio Terceiro <antonio.terceiro@linaro.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jiong Wang <jiong.wang@netronome.com>

Antonio Terceiro <antonio.terceiro@linaro.org> writes:

> This file has been moved into the "progs" subdirectory in
> bd4aed0ee73ca873bef3cb3ec746dd796f03df28, together with all test BPF
> programs.
>
> Signed-off-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Jiong Wang <jiong.wang@netronome.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.  I did fix the changelog to include a Fixes: tag with
the commit listed in the proper format.

Thanks,

jon
