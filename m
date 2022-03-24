From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: memcg: Do not count memory.low reclaim if it does not happen
Date: Thu, 24 Mar 2022 11:17:14 -0700
Message-ID: <5049EBC3-5BAE-4509-BA63-1F4A7D913517@linux.dev>
References: <20220324095157.GA16685@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648145837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Xdg6AguU1tCjET4IpuuuOj6DcGbMJAnyZKDx5p9X6o=;
        b=CaznleEkIgnUPwdpezvS7Q1Z4Lx0QM+qd453HpZhRxWImtUouqJZERSIMyPP1D2gE8ZEgK
        hunDJ2I4gzVQNoBZ4dAQD8M976MYphFJnDpz5hcIVyr8TlmscQS2WpsWbWgfK1i5SJvIAc
        0p6Mq5sqgguQ1ED1eaSfq88c1oCQ5Go=
In-Reply-To: <20220324095157.GA16685@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Richard Palethorpe <rpalethorpe@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Muchun Song <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>


> On Mar 24, 2022, at 2:52 AM, Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>=20
> =EF=BB=BFOn Wed, Mar 23, 2022 at 02:44:24PM -0700, Roman Gushchin <roman.g=
ushchin@linux.dev> wrote:
>> Does it mean that in the following configuration:
>>    `parent .low=3D50M
>>      ` s1    .low=3D0M   .current=3D50M
>>      ` s2  .low=3D0M   .current=3D50M
>> there will be no memory.events::low at all? (assuming the recursive thing=
 is on)
>=20
> True, no memory.events:low among siblings.
> Number of memory.events:low in the parent depends on how much has to be
> reclaimed (>50M means carving into parent's protection, hence it'll be
> counted).

Ok, so it=E2=80=99s not really about the implementation details of the recla=
im mechanism (I mean rounding up to the batch size etc), it=E2=80=99s a more=
 generic change: do not generate low events for cgroups not explicitly prote=
cted by a non-zero memory.low value.

Idk, I don=E2=80=99t have a strong argument against this change (except that=
 it changes the existing behavior), but I also don=E2=80=99t see why such ev=
ents are harmful. Do you mind elaborating a bit more?

Thank you!=
