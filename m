From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Date: Wed, 16 Oct 2019 08:32:34 -0700
Message-ID: <20191016153234.GO18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
 <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
 <20191016142756.GN18794@devbig004.ftw2.facebook.com>
 <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T9N8Qt/Q4T/fLDKFrE/yGjdsJz9c4IKV5iMQVuzGrps=;
        b=uR+B/8KpPRzIhOBAr5vomaF58ezGmJX/eSypGMHunaNAhefJay3pXHyQMlfeT33DY2
         E7CYU5KMl9Bvj6oHq9PBQ/vQ4QhvoLaD8r9wy3Id7EKa6ZnUkh9C8r0M1g82ZyAAcRsA
         F8+Xxp3LqG/0rsTC+TCAaLPer+M4sVHPnYCFLSQ8AgEKp+5dkJ5KUf5oSjb4BDsB9VnN
         LTdQU3BkzHyE+SgCrKzT8ogPqp79w2Z45xmDJ2QbmKgqdd1vmbWHGQW5kdpch5QSKCt5
         9LN25GRra8d834gUX5t4Z/INq89v6v7FkHZNuYvqadr1h9sT7s7zYSlvpz+zY8zONofD
         hXIg==
Content-Disposition: inline
In-Reply-To: <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello,

On Thu, Oct 17, 2019 at 02:29:46AM +1100, Aleksa Sarai wrote:
> > Hah, where is it saying that?
> 
> Isn't that what this says:
> 
> > Therefore, if you find yourself only using the Non-RMW operations of
> > atomic_t, you do not in fact need atomic_t at all and are doing it
> > wrong.
> 
> Doesn't using just atomic64_read() and atomic64_set() fall under "only
> using the non-RMW operations of atomic_t"? But yes, I agree that any
> locking is overkill.

Yeah, I mean, it's an overkill.  We can use seqlock or u64_stat here
but it doesn't matter that much.

> > > As for 64-bit on 32-bit machines -- that is a separate issue, but from
> > > [1] it seems to me like there are more problems that *_ONCE() fixes than
> > > just split reads and writes.
> > 
> > Your explanations are too wishy washy.  If you wanna fix it, please do
> > it correctly.  R/W ONCE isn't the right solution here.
> 
> Sure, I will switch it to use atomic64_read() and atomic64_set() instead
> if that's what you'd prefer. Though I will mention that on quite a few
> architectures atomic64_read() is defined as:
> 
>   #define atomic64_read(v)        READ_ONCE((v)->counter)

Yeah, on archs which don't have split access on 64bits.  On the ones
which do, it does something else.  The generic implementation is
straight-up locking, I think.

Thanks.

-- 
tejun
