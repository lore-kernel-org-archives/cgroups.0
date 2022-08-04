From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Thu, 4 Aug 2022 10:02:12 +0800
Message-ID: <94ddcd31-e168-06ed-c0f9-2ea25b802d60@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org> <YuAqWprKd6NsWs7C@slm.duckdns.org>
 <5a3410d6-428d-9ad1-3e5a-01ca805ceeeb@bytedance.com>
 <Yuq3Q6Y9dRnjjcPt@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=R8a2uTZpErjV8ZoEO/x1ZNaBxjx4vHWCt7mF0miAi5E=;
        b=zZ1UG92HUINfBQ0MPaLPPVMGISoqyJK/vD/6sOBUj8XoURNF1lfjGeUqvP9Fd0Q0n4
         S4tnowzf3rtmuMxZufeXmYMk6Idx/JgCkX3Plw150oX75qK9rOWR5ykDKz/sz3+WUMmV
         qoFAxG0rCEOoKhTUc12aJo6XYNciiUvXjIJdrE1WLpbsMhASFxIFg9i+mVCKLFfEdRf4
         79VgYyrQKQ1IuJT+owA5Geif2IltJJU2FgCCZb8FX9DuLUrLQiPPMA3fiLeIhVfrDhS6
         lgBpNEPmcHiEORwN/t+xhP9fHEMu5jG2DSGj5k1P7NT0ZHbum9gVw4Knz8LQVXLxleRM
         DJyg==
Content-Language: en-US
In-Reply-To: <Yuq3Q6Y9dRnjjcPt@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, surenb@google.com, mingo@redhat.com, peterz@infradead.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On 2022/8/4 01:58, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 03, 2022 at 08:17:22PM +0800, Chengming Zhou wrote:
>>> Assuming the above isn't wrong, if we can figure out how we can re-enable
>>> it, which is more difficult as the counters need to be resynchronized with
>>> the current state, that'd be ideal. Then, we can just allow each cgroup to
>>> enable / disable PSI reporting dynamically as they see fit.
>>
>> This method is more fine-grained but more difficult like you said above.
>> I think it may meet most needs to disable PSI stats in intermediate cgroups?
> 
> So, I'm not necessarily against implementing something easier but we at
> least wanna get the interface right, so that if we decide to do the full
> thing later we can easily expand on the existing interface. ie. let's please
> not be too hacky. I don't think it'd be that difficult to implement
> per-cgroup disable-only operation that we can later expand to allow
> re-enabling, right?

Agree, the interface is important, per-cgroup disable-only operation maybe easier
to implement. I will look into this more.

Thanks!

