From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v2] mm/memcontrol: use kstrtobool for swapaccount param
 parsing
Date: Tue, 13 Sep 2022 18:34:40 +0800
Message-ID: <128547F8-DABA-4548-82F5-0707A3614084@linux.dev>
References: <20220909084647.3598299-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663065294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oac3nih64E0pi5snDdXMh4iMt6lvJM63V217jemxOhc=;
        b=dhPTSi3G/hlnCI2RbLxXw/uXLx+5gnjunhauhgmpG3H3TXa2adVMGUgVjhp8+NV35PezOS
        ZthAY2vp1IUzGtcU4o7gF3Dt+JwNU20LbBQsGnkUkiIVZH5u/mugUZjMjXGWSX4iZo3w3q
        6dWKZU9ap4GYETodLLRP5gHlRPbP/kk=
In-Reply-To: <20220909084647.3598299-1-liushixin2@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Liu Shixin <liushixin2@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Kefeng Wang <wangkefeng.wang@huawei.com>



> On Sep 9, 2022, at 16:46, Liu Shixin <liushixin2@huawei.com> wrote:
>=20
> Use kstrtobool which is more powerful to handle all kinds of =
parameters
> like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".
>=20
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>

With Andrew and Michal=E2=80=99s suggestion.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.=
