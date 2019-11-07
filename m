From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0.5/5] bfq-iosched: relocate bfqg_*rwstat*() helpers
Date: Thu, 7 Nov 2019 12:08:15 -0700
Message-ID: <4d34b6a3-b141-f0fe-c7e1-e68e0fa52cfb@kernel.dk>
References: <20191106215838.3973497-1-tj@kernel.org>
 <20191107190459.GA3622521@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6tc+3dFnObbCsZTOmcaVyw6tfhQMQsGco5do8dKeQEQ=;
        b=LgVB184nuWNpFfGTtXqtzbPQCgBsxaiS3I2ido28o3uv6Be63L007ZEgJmeI4p0/bU
         gZ6XCsGvaUXpCS9kQrcCCvJGsC6gBbU5UgGuwiQXUL2Yq7wIEFglIILOgZw8P9sQ59j7
         DVtDRA39e/w+eVu+5Fh80AmOIS+cIts7L5UOC6aEPlA7E1tDZ3rxeD/TiAUidkN3wOUr
         1nHZaIYFTXT5S+tb7PTGosHYi4WLU/P4nMLLf2YXPVRMFdaZd4mZ8LM0dz/v2xb6ZclM
         3VZLjZEqUWsplJQaLrY2K2NJQ4QLwMKeezr3/t5BIKT6nsMzzJ4vjASSNPhTr64cZv0u
         0dSg==
In-Reply-To: <20191107190459.GA3622521@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com

On 11/7/19 12:04 PM, Tejun Heo wrote:
> Jens, this is an extra patch to help fixing the build bug when
> !CONFIG_BFQ_CGROUP_DEBUG.  The git tree has been updated accordingly.
> Please let me know if you want the whole series reposted.

I seem to run into issues applying the series with the 0.5 added first
and with the updated patch 1. So maybe a resend isn't a bad idea :-)

-- 
Jens Axboe

