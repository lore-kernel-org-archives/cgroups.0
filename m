From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 10/10] bpf, memcg: Add new item bpf into
 memory.stat
Date: Fri, 23 Sep 2022 17:20:18 -1000
Message-ID: <Yy53cgcwx+hTll4R@slm.duckdns.org>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
 <20220921170002.29557-11-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=zdaZUg3/Ml2ij6XPZD2qg9IOy8atuUvae1lDmHhGEaU=;
        b=UnG1HqbKS/mgMg2dkwoqyo9cxa/2p7p+q8MDbzDOgljy0JmBKN0AWL+/mahBJ/oE4b
         /9QD89ZRZ9yccoJzfPy1SQYt46FZAHzGDAXYLKiMDDVay1UH7uAAzk0Pnp4PMrM/DYFA
         qct+9CeD/c4KcYv4qvhJlG7CUUdSyifL0o4iXE3JixbsRu10MtIcZU1pnh/dg3IaJDGW
         l/o4f/rGLnfGtadyK68xaOvEpWZxNrSqawqgdBi7N/MUUR7Q7HiQSxZMg6C29UfLCrcf
         Cc6YLDBbmkNwdTZc1eALtudTSBzGRjfP7tPAUl52zchsEqh82XFo68pJm7Ob1HOBZZ7b
         +ttA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220921170002.29557-11-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, lizefan.x@bytedance.com, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org

Hello,

On Wed, Sep 21, 2022 at 05:00:02PM +0000, Yafang Shao wrote:
> A new item 'bpf' is introduced into memory.stat, then we can get the memory
> consumed by bpf. Currently only the memory of bpf-map is accounted.
> The accouting of this new item is implemented with scope-based accouting,
> which is similar to set_active_memcg(). In this scope, the memory allocated
> will be accounted or unaccounted to a specific item, which is specified by
> set_active_memcg_item().

Imma let memcg folks comment on the implementation. Hmm... I wonder how this
would tie in with the BPF memory allocator Alexei is working on.

> The result in cgroup v1 as follows,
> 	$ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
> 	bpf 109056000
> 	total_bpf 109056000
> After the map is removed, the counter will become zero again.
>         $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
>         bpf 0
>         total_bpf 0
> 
> The 'bpf' may not be 0 after the bpf-map is destroyed, because there may be
> cached objects.

What's the difference between bpf and total_bpf? Where's total_bpf
implemented? It doesn't seem to be anywhere. Please also update
Documentation/admin-guide/cgroup-v2.rst.

> Note that there's no kmemcg in root memory cgroup, so the item 'bpf' will
> be always 0 in root memory cgroup. If a bpf-map is charged into root memcg
> directly, its memory size will not be accounted, so the 'total_bpf' can't
> be used to monitor system-wide bpf memory consumption yet.

So, system-level accounting is usually handled separately as it's most
likely that we'd want the same stat at the system level even when cgroup is
not implemented. Here, too, it'd make sense to first implement system level
bpf memory usage accounting, expose that through /proc/meminfo and then use
the same source for root level cgroup stat.

Thanks.

-- 
tejun
