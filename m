From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Date: Mon, 14 Oct 2019 09:33:07 -0700
Message-ID: <20191014163307.GG18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4e/+dg0NVCCBrtHyCNhp9Ya4wF37EwRkEK+NeEl5+VU=;
        b=A31njF9Kt8jL9DxYdqt+AFERZ4GXgyF70roSgACytG3oPAM4SAiEfGJA0thhHyQsRE
         LDJwdWYGEuIpGGkNJedBJR9j2bImNS5IFxRfVCKSyf0ecjmUBeGfXkQhqHu0Q0/J9Z3S
         6WvQvuglHPm37Ceukii41k6PvelrK0oe30D2phoqsH1fIzkYqooz65ZizMGS2Ae21r4u
         NQwH94TUGi4i8G9syVddwuPF4XeoBEdQbqtIcjw26FBbZcP0aibSAUHvEZE7EsZQDlcN
         rwgH1ijPQlLfswIvNQnaBq6wZuH+iOrUri5/E4uHH/RxDQQI8TCzgHFtRKVT9V2KgZL7
         MY6A==
Content-Disposition: inline
In-Reply-To: <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello, Aleksa.

On Tue, Oct 15, 2019 at 02:59:31AM +1100, Aleksa Sarai wrote:
> On 2019-10-14, Tejun Heo <tj@kernel.org> wrote:
> > On Sat, Oct 12, 2019 at 12:05:39PM +1100, Aleksa Sarai wrote:
> > > Because pids->limit can be changed concurrently (but we don't want to
> > > take a lock because it would be needlessly expensive), use the
> > > appropriate memory barriers.
> > 
> > I can't quite tell what problem it's fixing.  Can you elaborate a
> > scenario where the current code would break that your patch fixes?
> 
> As far as I can tell, not using *_ONCE() here means that if you had a
> process changing pids->limit from A to B, a process might be able to
> temporarily exceed pids->limit -- because pids->limit accesses are not
> protected by mutexes and the C compiler can produce confusing
> intermediate values for pids->limit[1].
>
> But this is more of a correctness fix than one fixing an actually
> exploitable bug -- given the kernel memory model work, it seems like a
> good idea to just use READ_ONCE() and WRITE_ONCE() for shared memory
> access.

READ/WRITE_ONCE provides protection against compiler generating
multiple accesses for a single operation.  It won't prevent split
writes / reads of 64bit variables on 32bit machines.  For that, you'd
have to switch them to atomic64_t's.

Thanks.

-- 
tejun
