From: Roberto Sassu <roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
Date: Wed, 07 Sep 2022 10:02:30 +0200
Message-ID: <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
         <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
         <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mykola Lysenko <mykolal-b10kYP2dOMg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jakub Sitnicki <jakub-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kself>

On Tue, 2022-09-06 at 11:21 -0700, Alexei Starovoitov wrote:
> On Tue, Sep 6, 2022 at 10:04 AM Roberto Sassu
> <roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
> > From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Commit 6e71b04a82248 ("bpf: Add file mode configuration into bpf
> > maps")
> > added the BPF_F_RDONLY and BPF_F_WRONLY flags, to let user space
> > specify
> > whether it will just read or modify a map.
> > 
> > Map access control is done in two steps. First, when user space
> > wants to
> > obtain a map fd, it provides to the kernel the eBPF-defined flags,
> > which
> > are converted into open flags and passed to the security_bpf_map()
> > security
> > hook for evaluation by LSMs.
> > 
> > Second, if user space successfully obtained an fd, it passes that
> > fd to the
> > kernel when it requests a map operation (e.g. lookup or update).
> > The kernel
> > first checks if the fd has the modes required to perform the
> > requested
> > operation and, if yes, continues the execution and returns the
> > result to
> > user space.
> > 
> > While the fd modes check was added for map_*_elem() functions, it
> > is
> > currently missing for map iterators, added more recently with
> > commit
> > a5cbe05a6673 ("bpf: Implement bpf iterator for map elements"). A
> > map
> > iterator executes a chosen eBPF program for each key/value pair of
> > a map
> > and allows that program to read and/or modify them.
> > 
> > Whether a map iterator allows only read or also write depends on
> > whether
> > the MEM_RDONLY flag in the ctx_arg_info member of the bpf_iter_reg
> > structure is set. Also, write needs to be supported at verifier
> > level (for
> > example, it is currently not supported for sock maps).
> > 
> > Since map iterators obtain a map from a user space fd with
> > bpf_map_get_with_uref(), add the new req_modes parameter to that
> > function,
> > so that map iterators can provide the required fd modes to access a
> > map. If
> > the user space fd doesn't include the required modes,
> > bpf_map_get_with_uref() returns with an error, and the map iterator
> > will
> > not be created.
> > 
> > If a map iterator marks both the key and value as read-only, it
> > calls
> > bpf_map_get_with_uref() with FMODE_CAN_READ as value for req_modes.
> > If it
> > also allows write access to either the key or the value, it calls
> > that
> > function with FMODE_CAN_READ | FMODE_CAN_WRITE as value for
> > req_modes,
> > regardless of whether or not the write is supported by the verifier
> > (the
> > write is intentionally allowed).
> > 
> > bpf_fd_probe_obj() does not require any fd mode, as the fd is only
> > used for
> > the purpose of finding the eBPF object type, for pinning the object
> > to the
> > bpffs filesystem.
> > 
> > Finally, it is worth to mention that the fd modes check was not
> > added for
> > the cgroup iterator, although it registers an attach_target method
> > like the
> > other iterators. The reason is that the fd is not the only way for
> > user
> > space to reference a cgroup object (also by ID and by path). For
> > the
> > protection to be effective, all reference methods need to be
> > evaluated
> > consistently. This work is deferred to a separate patch.
> 
> I think the current behavior is fine.
> File permissions don't apply at iterator level or prog level.

+ Chenbo, linux-security-module

Well, if you write a security module to prevent writes on a map, and
user space is able to do it anyway with an iterator, what is the
purpose of the security module then?

> fmode_can_read/write are for syscall commands only.
> To be fair we've added them to lookup/delete commands
> and it was more of a pain to maintain and no confirmed good use.

I think a good use would be requesting the right permission for the
type of operation that needs to be performed, e.g. read-only permission
when you have a read-like operation like a lookup or dump.

By always requesting read-write permission, for all operations,
security modules won't be able to distinguish which operation has to be
denied to satisfy the policy.

One example of that is that, when there is a security module preventing
writes on maps (will be that uncommon?), bpftool is not able to show
the full list of maps because it asks for read-write permission for
getting the map info.

Freezing the map is not a solution, if you want to allow certain
subjects to continuously update the protected map at run-time.

Roberto

