From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
Date: Tue, 6 Sep 2022 11:21:50 -0700
Message-ID: <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com> <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PYs3Wuenq4cez94yZW8DSjj5pLfTjpJU6pDayqR/+9k=;
        b=PObnF9bQxkSs4fRurVZSSfRC5Xac9CJVZ7wh7zRfBoKnNdOWc4P7gB3qZpMaVSZvF2
         5H6xPT9EeiQ4b7T7rrJDHnmEvzPGckaKWmtqIc+glfZZqa43RP3xXZMlqP/Jlxm7MYcw
         e2i/ZqiU4MSv7eWCA2MN8xYaiZ32eK64DwbhpycZqHuhCE3ZW0S5BhOJrUFPPuO8B30p
         VUpFMo6kat6H3b3b0uHQXFi7nN9Gcj9IpXX1LIf7bTqw1NnECB0X5diBb79d89bi6UJ1
         0jyk9Q4vHJ0cnJSUbtFfbaPVqZl8/vY82CvFRrttXO92nleJsefEj1HqaSkGqkEyjJ1f
         STSA==
In-Reply-To: <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kself>

On Tue, Sep 6, 2022 at 10:04 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Commit 6e71b04a82248 ("bpf: Add file mode configuration into bpf maps")
> added the BPF_F_RDONLY and BPF_F_WRONLY flags, to let user space specify
> whether it will just read or modify a map.
>
> Map access control is done in two steps. First, when user space wants to
> obtain a map fd, it provides to the kernel the eBPF-defined flags, which
> are converted into open flags and passed to the security_bpf_map() security
> hook for evaluation by LSMs.
>
> Second, if user space successfully obtained an fd, it passes that fd to the
> kernel when it requests a map operation (e.g. lookup or update). The kernel
> first checks if the fd has the modes required to perform the requested
> operation and, if yes, continues the execution and returns the result to
> user space.
>
> While the fd modes check was added for map_*_elem() functions, it is
> currently missing for map iterators, added more recently with commit
> a5cbe05a6673 ("bpf: Implement bpf iterator for map elements"). A map
> iterator executes a chosen eBPF program for each key/value pair of a map
> and allows that program to read and/or modify them.
>
> Whether a map iterator allows only read or also write depends on whether
> the MEM_RDONLY flag in the ctx_arg_info member of the bpf_iter_reg
> structure is set. Also, write needs to be supported at verifier level (for
> example, it is currently not supported for sock maps).
>
> Since map iterators obtain a map from a user space fd with
> bpf_map_get_with_uref(), add the new req_modes parameter to that function,
> so that map iterators can provide the required fd modes to access a map. If
> the user space fd doesn't include the required modes,
> bpf_map_get_with_uref() returns with an error, and the map iterator will
> not be created.
>
> If a map iterator marks both the key and value as read-only, it calls
> bpf_map_get_with_uref() with FMODE_CAN_READ as value for req_modes. If it
> also allows write access to either the key or the value, it calls that
> function with FMODE_CAN_READ | FMODE_CAN_WRITE as value for req_modes,
> regardless of whether or not the write is supported by the verifier (the
> write is intentionally allowed).
>
> bpf_fd_probe_obj() does not require any fd mode, as the fd is only used for
> the purpose of finding the eBPF object type, for pinning the object to the
> bpffs filesystem.
>
> Finally, it is worth to mention that the fd modes check was not added for
> the cgroup iterator, although it registers an attach_target method like the
> other iterators. The reason is that the fd is not the only way for user
> space to reference a cgroup object (also by ID and by path). For the
> protection to be effective, all reference methods need to be evaluated
> consistently. This work is deferred to a separate patch.

I think the current behavior is fine.
File permissions don't apply at iterator level or prog level.
fmode_can_read/write are for syscall commands only.
To be fair we've added them to lookup/delete commands
and it was more of a pain to maintain and no confirmed good use.
