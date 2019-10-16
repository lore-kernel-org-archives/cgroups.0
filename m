From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Date: Wed, 16 Oct 2019 07:27:56 -0700
Message-ID: <20191016142756.GN18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
 <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pWLBPoWyBcOr16gWtiZJvZNkZ+CpdbY6LbEquS4WgGs=;
        b=SWezzmlqWZweUFaF4bfjHi2Tkkw8IwVCxK4pMU0MbQZvbR2h4E82Y8SaKq2ezH2umM
         WfPRhFIQakPbA8Otm9Wuc/6yBmHY4iHer+p4UI/OZl4/gWanrHa4EIwbFby9zsvbYmst
         sWi85/Xa/YV9FyaWVkBgxd8vgS0+SgZgr1wypsV68+Tu6PJ9AimgXsQ0fRyR3xx73Q7/
         VQ/IVepjPClxC2g2duudYJbd/4GD7ExOPqSKzsrX/nP38Q/ZBh6/JL0z+o5sg5Qz/npy
         zyNO86sjKko2KZdlxldTUeds1q9AfwACNfH60szRWGnZJwbBwXGDTDGCU2n/HhUGYXR/
         zDTQ==
Content-Disposition: inline
In-Reply-To: <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello, Aleksa.

On Wed, Oct 16, 2019 at 07:32:19PM +1100, Aleksa Sarai wrote:
> Maybe I'm misunderstanding Documentation/atomic_t.txt, but it looks to
> me like it's explicitly saying that I shouldn't use atomic64_t if I'm
> just using it for fetching and assignment.

Hah, where is it saying that?  The alternative would be seqlock or
u64_stats or straight-up locking but idk for this atomic64_t should be
fine.

> > The non-RMW ops are (typically) regular LOADs and STOREs and are
> > canonically implemented using READ_ONCE(), WRITE_ONCE(),
> > smp_load_acquire() and smp_store_release() respectively. Therefore, if
> > you find yourself only using the Non-RMW operations of atomic_t, you
> > do not in fact need atomic_t at all and are doing it wrong.
> 
> As for 64-bit on 32-bit machines -- that is a separate issue, but from
> [1] it seems to me like there are more problems that *_ONCE() fixes than
> just split reads and writes.

Your explanations are too wishy washy.  If you wanna fix it, please do
it correctly.  R/W ONCE isn't the right solution here.

Thanks.

-- 
tejun
