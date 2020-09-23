From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [Phishing Risk] [External] Re: [PATCH] cgroup: Add cgroupstats
 numbers to cgroup.stat file
Date: Wed, 23 Sep 2020 17:57:16 +0800
Message-ID: <b2fda7f4-e7d1-9e2c-6de6-c1a8ead23568@bytedance.com>
References: <20200915155349.15181-1-zhouchengming@bytedance.com>
 <20200921145009.GD4268@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ewCx0XKQ1ju6wfyj3Pz3K+HET98S+3k20JpX1ePN7aQ=;
        b=MD1ytn3xzFQiWdnsMkQCBk2hz87iEDkmmNejgl1t5v6oTcnCs3th4hp/TnrsiKBqmR
         9NDXScVlMBTL6o7guiemcfft7wumzcfUV1pppS+K/eAQnVb7mn7ffvhkJvU9TLdFlCEU
         ZpUYlgHJPiw4VLODvjkMA6m9IFhAD2KHrgxTlPqVTxSC6ud2gm6c4K+VjdnPgfZSARPx
         h4XY+rRc7UB05Jiixoj0yiTh6z51VIEtzxfCkFGQm6mp8tgdd3o9hOCoOGhwanyYXnSi
         DL3ACAV+TXF3FKUzSlkoXu/vJ5SKuoPlg911HSRmnKPQALxl/uAJbocVIP8lmu1Fo9EQ
         xJmw==
In-Reply-To: <20200921145009.GD4268@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, luodaowen.backend@bytedance.com, songmuchun@bytedance.com


在 2020/9/21 下午10:50, Tejun Heo 写道:
> Hello,
>
> On Tue, Sep 15, 2020 at 11:53:49PM +0800, Chengming Zhou wrote:
>> In the cgroup v1, we can use netlink interface to get cgroupstats for
>> a cgroup. But it has been excluded from cgroup v2 interface intentionally
>> due to the duplication and inconsistencies with other statistics.
>> To make container monitor tool like "cadvisor" continue to work, we add
>> these cgroupstats numbers to the cgroup.stat file, and change the
>> admin-guide doc accordingly.
> So, we can't add O(nr_threads) operations to cgroup.stat reads. There are
> two ways forward that I can see.
>
> * Investigate how these counters are being used. If it's used for congestion
>   detection, pressure metrics are likely better indicators to use anyway. If
>   the usage frequency is low enough, maybe querying from userspace should
>   work?
>
> * If the need for these per-cgroup task state counters is really
>   justifiable, the counters should be maintained from scheduling event
>   directly and summed up using rstat like other statistics.
>
> Thanks.
>
Well, I see. These counters are being used for load monitor and debug,
pressure metrics

is good for congestion detection, but more details needed for debug when
problem happened.

And I noticed PSI has maintained these taskstats from scheduler event
already. I think we can

just export these counters gracefully.

Thanks.

