From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: avoid attaching a cgroup root to two different
 superblocks, take 2
Date: Fri, 28 Apr 2017 18:07:20 -0400
Message-ID: <20170428220720.GJ22354@htj.duckdns.org>
References: <58F6C85F.10706@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b1nhqtFuCf8mNIcpVYQhjqLBfstsvUfILPMQhjG/A8A=;
        b=LMRCtDpk4ABIvPuAdtnzU3mzhbiiHgckzqIK4l8ypXd062+Q8sK8eGCb4Ys7YQYmpa
         SZCdHe2ld8obe/J7PBjPbhElRotPznTN+BcQpTi0ftzHCOv/MRBf7MfyUlplsE3Mx4+e
         4/EQMBkF3DU02tIQnhIVBO4C87EH5jKENx8OGtQwPktiMxSiwzdz1RtzfZ18XbPRRrQq
         dNIQ10L416tSDvYeujdoZw4hgbabIJ05MsZWjk1S+clZQI0etSh0Ib+i81X5/Nsn56yY
         TqeQb5YqnTo49QQvEyMcIZX7frhyDW0yJTHrHsMgbea7nLyokLYNzztc87G654CatUi/
         bqhQ==
Content-Disposition: inline
In-Reply-To: <58F6C85F.10706@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: avagin@virtuozzo.com, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 19, 2017 at 10:15:59AM +0800, Zefan Li wrote:
> Commit bfb0b80db5f9 is broken. Now we try to fix the race by delaying
> the initialization of cgroup root refcnt until a superblock has been
> allocated.
>
> Cc: stable@vger.kernel.org # 3.16+
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Reported-by: Andrei Vagin <avagin@virtuozzo.com>
> Tested-by: Andrei Vagin <avagin@virtuozzo.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-4.12 w/o the stable tag.  Let's wait this one
out.  It's unlikely to trigger in real use cases and if we decide that
this needs to be in -stable, we can ask Greg later.

> Again I didn't receive your reply. I believe the problem is in my side.
> I'll see if there's some network administrator who can look into this
> issue, but I don't have much hope...

Bummer.  Is there another address I can cc? :(

Thanks.

-- 
tejun
