From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v2 00/10] sched/psi: some optimization and extension
Date: Tue, 16 Aug 2022 22:01:30 +0800
Message-ID: <08ec9c4f-80b2-f731-aa8b-fb4e852ece25@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220815132514.GB22640@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=erk4QjfKLI1wqXEF6e5iSvx1UiCDlKAdjqB4/lN4Erk=;
        b=Y0g/2vtkm1HDsEQno8ZsLNKBwZANZXHmx08W3wcN28MC03rqN8MuI64iRs+rHEj/xM
         Mhgh3CWWqwIHvp1zbpwHD9c7qXg8eE0IRMI8lE/Bs7Oc8V/33m9VXiuhskmTBfgxD9NZ
         Mq62JekBPMAcUxs3Ilcqg2rqG1qAlFVad2zD270PHvYGPCENWlJsVUgAAgaml9ycj8+R
         a3jNEi3vDV1kpIpykK09HTqW8zI8WIjy7FGbgBfUo8YJAns9J0U7Fg6u4PI2mpVSLveW
         3onWPrEs8plVxEpuEm8C8LSAqbQuxfh0aI9mUsW5fx9yeIMqQ/EHbVhAWxDUX3eJSAq/
         eMZg==
Content-Language: en-US
In-Reply-To: <20220815132514.GB22640@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 2022/8/15 21:25, Michal Koutn=C3=BD wrote:
> On Mon, Aug 08, 2022 at 07:03:31PM +0800, Chengming Zhou <zhouchengming@b=
ytedance.com> wrote:
>> This patch series are some optimization and extension for PSI,
>=20
> BTW do you have some numbers/example how much these modifications save
> when aggregated together?
>=20

I lost my test data last time, I will use mmtests/config-scheduler-perfpipe
to get some performance numbers right now.

Thanks.
