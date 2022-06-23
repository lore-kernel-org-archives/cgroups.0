From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [External] Re: [PATCH v2] sched: RT bandwidth interface for
 cgroup unified hierarchy
Date: Thu, 23 Jun 2022 10:23:26 +0800
Message-ID: <888b6885-5380-e21f-260f-eb1bb89679c3@bytedance.com>
References: <20220622015557.7497-1-zhouchengming@bytedance.com>
 <20220622173929.GA669@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=csCXiXt7nFq4+h4WD6heVCXixZoWRVAJL1Lssrp4las=;
        b=WA6u/LptxC6hvIktNHSr3CpHwaPyPUZckJ++HrZ8zmkycEVEbijkXaMLEyDey8F+Lt
         +g9qR64kyl7wYpz43zDjaGpxgpfUYBvM2MdhkLXKLiNBAox4WxuLcd38TMk7diCM5eOL
         tC9IYkjtiUnlLb0jH4nTwNbo1PbJKCHFNfMv2BUZLagEOhrTkFeGlPLJXXFHXNifaD81
         rS/gmlxZpPouMX1g7QzQbznGjyvAn1lNo0P9Oa/y0XRQ/pvZstMIW9Mc0r+zv5BrjsGH
         h8iGUiTl3PWQxbL7LmjM13/+bsHsPrxA+jWjulwftKo/3WMMHrO0Le7Wf11NO9X04NEA
         L3rw==
Content-Language: en-US
In-Reply-To: <20220622173929.GA669@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: rdunlap@infradead.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Michal,

On 2022/6/23 01:39, Michal Koutn=C3=BD wrote:
> Hello Chengming.
>=20
> On Wed, Jun 22, 2022 at 09:55:57AM +0800, Chengming Zhou <zhouchengming@b=
ytedance.com> wrote:
>> We need to run RT threads in cgroup unified hierarchy, but we can't
>> since the default rt_bandwidth.rt_runtime of non-root task_group is 0
>> and we haven't interface to update it.
>=20
> Do you really want to make use of group RT schedulling
> (CONFIG_RT_GROUP_SCHED) or just be able to run RT threads in the unified
> hieararchy with cpu controller enabled?
>=20

The latter could meet our current needs I think, but it would be better that
we can put a max limit on the task_group in case multiple groups need to
run RT processes.

> Those are two different use cases, the former is more complex and it's a
> reason why v2 doesn't expose the RT attributes (yet).
> The latter is typically achieved by unsetting CONFIG_RT_GROUP_SCHED (and
> relying on the global rt_runtime limit).
>=20

I don't know why v2 differ from v1 in the RT bandwidth control.. Is there
some links of explanation? (CFS bandwidth control can work on v2 now.)

If the problem can't be solved, we have to unset CONFIG_RT_GROUP_SCHED.

Thanks.

> Thanks,
> Michal
