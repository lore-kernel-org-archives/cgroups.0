From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for
 cgroup hierarchical stats collection
Date: Wed, 24 Aug 2022 19:09:14 -0700
Message-ID: <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=00m4IEZE5ymczAS2BUKtiJ+vi+Xy5c2+SWdERk9o0Uk=;
        b=XUIvvDE9rb07vRHUIuRXdPojnd2u+LRkrd7NUXqdJbASQ4pc6DJzy1xL27y/fUIJUu
         DFYkYSy6vJBh0vjTngR/JYHMFgUYkz5ovrKbIfQ8ti/UNB5X0bAuLknVM3I8dqTySI8v
         aNC6NnXT/bwq7HVDnRjWcviT4NyxzbZ5SyY+msV1T/13fvAiJ/4o5WPyIoHrVBf2AzT+
         VUj1v3TLgjGH9VKySxCO5hYoVGQ1RgGzPDgWUzMh7irERe68LMD3qrFdvxKsjOfCAyzp
         YYjSL2ZzkeY/7L/XxhzTJEopLxiUfMRZNunwMvNXZ/v63LwTj8PXPJm/1aESeSwdrVHp
         LJzg==
In-Reply-To: <20220824233117.1312810-6-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.>

On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> +
> +       for (i = 0; i < N_CGROUPS; i++) {
> +               fd = create_and_get_cgroup(cgroups[i].path);
> +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> +                       return fd;
> +
> +               cgroups[i].fd = fd;
> +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> +
> +               /*
> +                * Enable memcg controller for the entire hierarchy.
> +                * Note that stats are collected for all cgroups in a hierarchy
> +                * with memcg enabled anyway, but are only exposed for cgroups
> +                * that have memcg enabled.
> +                */
> +               if (i < N_NON_LEAF_CGROUPS) {
> +                       err = enable_controllers(cgroups[i].path, "memory");
> +                       if (!ASSERT_OK(err, "enable_controllers"))
> +                               return err;
> +               }
> +       }

It passes BPF CI, but fails in my setup with:

# ./test_progs -t cgroup_hier -vv
bpf_testmod.ko is already unloaded.
Loading bpf_testmod.ko...
Successfully loaded bpf_testmod.ko.
setup_bpffs:PASS:mount 0 nsec
setup_cgroups:PASS:setup_cgroup_environment 0 nsec
setup_cgroups:PASS:get_root_cgroup 0 nsec
setup_cgroups:PASS:create_and_get_cgroup 0 nsec
(cgroup_helpers.c:92: errno: No such file or directory) Enabling
controller memory:
/mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
#36      cgroup_hierarchical_stats:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

How do I debug it?
