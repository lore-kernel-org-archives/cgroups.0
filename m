From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
Date: Thu, 8 Sep 2022 08:17:19 -0700
Message-ID: <CAADnVQL7murY8G4SG5sF3855ETBpmrv0S-dueR8Rht4ucm6WwQ@mail.gmail.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
 <20220906170301.256206-2-roberto.sassu@huaweicloud.com> <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
 <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
 <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q@mail.gmail.com> <8d7a713e500b5e3fce93e4c5c7b8841eb6dd28e4.camel@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dvC/u7qJ5dN4X47tbsTGAuz++QpERj+4FDleSIpBEMg=;
        b=R0hVOMicuPDSnoQmcmYiJB3LFWFfOFwjBgRBuwuOEWI5JTxT51Lu0OjLr++Gxw/lzs
         Tvik3ezKxyKAnzDTCdQqFNmpHVznLaNacrF9ZuvJc9pBhz0lrAdZi1n+3xp/ijThvgp8
         VOwRWcRDrlK9c+JFS1o8ONZvPVH7bR5r3/0ESeh6jy2zLWd7yU9MbottgDeiLnCTWQUN
         tzuE0V5OqQhzozQQSsV16et/mkj7icGxA9KjWbtIM5r6eFzdxL2e+f9jqf4Nw1JWc8Gp
         zzjf6KnNbCgGJ8j2doSbs7qY9udYo9nEXzEMNqBxnxO5iPN9tehMBETqPTDu68UbIvgn
         qldw==
In-Reply-To: <8d7a713e500b5e3fce93e4c5c7b8841eb6dd28e4.camel@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kself>

On Thu, Sep 8, 2022 at 6:59 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> On Wed, 2022-09-07 at 09:02 -0700, Alexei Starovoitov wrote:
> >
>
> [...]
>
> > > Well, if you write a security module to prevent writes on a map,
> > > and
> > > user space is able to do it anyway with an iterator, what is the
> > > purpose of the security module then?
> >
> > sounds like a broken "security module" and nothing else.
>
> Ok, if a custom security module does not convince you, let me make a
> small example with SELinux.
>
> I created a small map iterator that sets every value of a map to 5:
>
> SEC("iter/bpf_map_elem")
> int write_bpf_hash_map(struct bpf_iter__bpf_map_elem *ctx)
> {
>         u32 *key = ctx->key;
>         u8 *val = ctx->value;
>
>         if (key == NULL || val == NULL)
>                 return 0;
>
>         *val = 5;
>         return 0;
> }
>
> I create and pin a map:
>
> # bpftool map create /sys/fs/bpf/map type array key 4 value 1 entries 1
> name test
>
> Initially, the content of the map looks like:
>
> # bpftool map dump pinned /sys/fs/bpf/map
> key: 00 00 00 00  value: 00
> Found 1 element
>
> I then created a new SELinux type bpftool_test_t, which has only read
> permission on maps:
>
> # sesearch -A -s bpftool_test_t -t unconfined_t -c bpf
> allow bpftool_test_t unconfined_t:bpf map_read;
>
> So, what I expect is that this type is not able to write to the map.
>
> Indeed, the current bpftool is not able to do it:
>
> # strace -f -etrace=bpf runcon -t bpftool_test_t bpftool iter pin
> writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
> bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0, file_flags=0},
> 144) = -1 EACCES (Permission denied)
> Error: bpf obj get (/sys/fs/bpf): Permission denied
>
> This happens because the current bpftool requests to access the map
> with read-write permission, and SELinux denies it:
>
> # cat /var/log/audit/audit.log|audit2allow
>
>
> #============= bpftool_test_t ==============
> allow bpftool_test_t unconfined_t:bpf map_write;
>
>
> The command failed, and the content of the map is still:
>
> # bpftool map dump pinned /sys/fs/bpf/map
> key: 00 00 00 00  value: 00
> Found 1 element
>
>
> Now, what I will do is to use a slightly modified version of bpftool
> which requests read-only access to the map instead:
>
> # strace -f -etrace=bpf runcon -t bpftool_test_t ./bpftool iter pin
> writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
> bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0,
> file_flags=BPF_F_RDONLY}, 16) = 3
> libbpf: elf: skipping unrecognized data section(5) .eh_frame
> libbpf: elf: skipping relo section(6) .rel.eh_frame for section(5)
> .eh_frame
>
> ...
>
> bpf(BPF_LINK_CREATE, {link_create={prog_fd=4, target_fd=0,
> attach_type=BPF_TRACE_ITER, flags=0}, ...}, 48) = 5
> bpf(BPF_OBJ_PIN, {pathname="/sys/fs/bpf/iter", bpf_fd=5, file_flags=0},
> 16) = 0
>
> That worked, because SELinux grants read-only permission to
> bpftool_test_t. However, the map iterator does not check how the fd was
> obtained, and thus allows the iterator to be created.
>
> At this point, we have write access, despite not having the right to do
> it:

That is a wrong assumption to begin with.
Having an fd to a bpf object (map, link, prog) allows access.
read/write sort-of applicable to maps, but not so much
to progs, links.
That file based read/write flag is only for user processes.
bpf progs always had separate flags for that.
See BPF_F_RDONLY vs BPF_F_RDONLY_PROG.
One doesn't imply the other.
