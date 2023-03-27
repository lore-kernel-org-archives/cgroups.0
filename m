From: Cai Xinchen <caixinchen1@huawei.com>
Subject: Re: [PATCH 1/1] mm: memcontrol: fix vmstats_percpu state incorrect
 subtraction after reparent
Date: Mon, 27 Mar 2023 09:29:37 +0800
Message-ID: <f183b995-9ed1-db80-5f0a-493e77946886@huawei.com>
References: <20230320030648.50663-1-caixinchen1@huawei.com>
 <20230320030648.50663-2-caixinchen1@huawei.com>
 <20230324171114.32oru5sdubfsfvgi@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20230324171114.32oru5sdubfsfvgi@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: mkoutny@suse.com
Cc: songmuchun@bytedance.com, akpm@linux-foundation.org, hannes@cmpxchg.org, longman@redhat.com, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, cgroups@vger.kernel.org, duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, yosryahmed@google.com, mpenttil@redhat.com

Yes, only cgroup v1.

On 2023/3/25 1:11, Michal Koutn=C3=BD wrote:
> Hello.
>
> On Mon, Mar 20, 2023 at 03:06:48AM +0000, Cai Xinchen <caixinchen1@huawei=
.com> wrote:
>> When memcg C is offllined, its pages are reparented to memcg P,
>> so far P->vmstats (hierarchical) have those pages, and
>> P->vmstats_percpu (non-hierarchical) don't. When those pages get
>> uncharged, P->vmstats (hierachical) decreases, which is correct,
>> but P->vmstats_percpu (non-hierarchical) also decreases, which
>> is wrong, as those stats were never added to P->vmstats_percpu to
>> begin with.
> I was wondering why ->vmstats_percpu matters (in the end all is summed
> in ->vmstats) -- do you mean this is a cgroup v1 only issue? As only
> that exposes the non-hieararchical stats.
>
> Thanks,
> Michal
