From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Date: Wed, 16 Oct 2019 08:54:07 -0700
Message-ID: <20191016155407.GP18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
 <20191014154136.GF18794@devbig004.ftw2.facebook.com>
 <20191014155931.jl7idjebhqxb3ck3@yavin.dot.cyphar.com>
 <20191014163307.GG18794@devbig004.ftw2.facebook.com>
 <20191016083218.ttsaqnxpjh5i5bgv@yavin.dot.cyphar.com>
 <20191016142756.GN18794@devbig004.ftw2.facebook.com>
 <20191016152946.34j5x45ko5auhv3g@yavin.dot.cyphar.com>
 <20191016153520.zet5mn5xsygig4xc@yavin.dot.cyphar.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0WPO79DQDmX9K5UUvDG9NIvgYir9s6WI5TJKIJkxgcM=;
        b=KCKGbCnnZALErjaIOXUYlE+dIZkF5JwVP/bpZ27+TuqqGH9oF0ds351xGOTB7cX87c
         c4943D0f6UUJc5cY4nDXJIhYnPI8ba57pzg6LD+UtawPccJUsKjuyd0K8Y6vM2/hJm5I
         RflHR2EyV1blt1g8DVrTRsNn+6EwcKLXhSqsK6OznGPFaYfeKCajl+kZriwEBFPPtDIC
         LGwjAz89030aFNhbBaWQtFZnJTGGXoLm4aPpNSC1rj5FOBJXVMSkAZGyhvXwt8cU8Ppo
         1pTL4woX4HN5aiZXh64itUXu4jap71Aba4sJGmNQlXnuRmfaDnNtUd8f4WP9tHxpEf67
         KKXg==
Content-Disposition: inline
In-Reply-To: <20191016153520.zet5mn5xsygig4xc@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Thu, Oct 17, 2019 at 02:35:20AM +1100, Aleksa Sarai wrote:
> > Sure, I will switch it to use atomic64_read() and atomic64_set() instead
> > if that's what you'd prefer. Though I will mention that on quite a few
> > architectures atomic64_read() is defined as:
> > 
> >   #define atomic64_read(v)        READ_ONCE((v)->counter)
> 
> Though I guess that's because on those architectures it turns out that
> READ_ONCE is properly atomic?

Oh yeah, on archs where 64bit accesses are atomic, READ_ONCE() /
WRITE_ONCE() would work here.  If the limit variable were ulong
instead of an explicit 64bit variable, RW ONCE would work too as ulong
accesses are atomic on all archs IIRC.

Thanks.

-- 
tejun
