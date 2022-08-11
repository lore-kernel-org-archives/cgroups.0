From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Thu, 11 Aug 2022 10:09:28 +0800
Message-ID: <cd4983dd-8432-7f79-1066-61b6f02e99c3@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
 <YvPN07UlaPFAdlet@cmpxchg.org> <YvPqcJh5Ffv4Yga9@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=oSA+Jof75BuedTVbt4lBoiMeV523r3pp7Ny1EC5oo3o=;
        b=w0LbbLx22MfQERbKFdETrb3ybAIxu4PakWhNX0JhVR2NfpBhq7Yqripn1YP+hcGg1G
         NHY8+4Rr6yTKcDEvaGbHrUCApwsNJdhMdkRsTVYxZXLCqcgx+obRDTd/0VoA/KsyYkgM
         xH9Y6GqYr8VN+x4u/U0KUA9lBlMnHdXIWFeh5HvCHJAjtbs/dhQ9C3BiKrDuXjx9U1nb
         Bk0ohofkrChxG8d7tGGKbx2K0azQCe1H0MYPxRZTEfFLG2WGP0lilMgvtFYTnjho35Mo
         +AEvUT3AQhyadp5mfRNM58gAtRcMxqcI1P2jRVMQ96L2Kmxs15ulMY1H9dapgPZoyLZk
         pAsQ==
Content-Language: en-US
In-Reply-To: <YvPqcJh5Ffv4Yga9@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 2022/8/11 01:27, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 10, 2022 at 11:25:07AM -0400, Johannes Weiner wrote:
>> How about just cgroup.pressure? Too ambiguous?
>>
>> cgroup.pressure.enable sounds good to me too. Or, because it's
>> default-enabled and that likely won't change, cgroup.pressure.disable.
> 
> .disable sounds more logical but I like .enable better for some reason. As
> for just cgroup.pressure, yeah, maybe? The conundrum is that the prettiness
> order is the exact reverse of the logical order. So, I'm okay with any of
> the three.

Ok, so I would like to pick the prettiest "cgroup.pressure", it also looks more
consistent with {cpu|memory|io}.pressure.

Thanks!

