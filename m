From: Roberto Sassu <roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
Date: Thu, 08 Sep 2022 15:58:53 +0200
Message-ID: <8d7a713e500b5e3fce93e4c5c7b8841eb6dd28e4.camel@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
         <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
         <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
         <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
         <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mykola Lysenko <mykolal-b10kYP2dOMg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jakub Sitnicki <jakub-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kself>

On Wed, 2022-09-07 at 09:02 -0700, Alexei Starovoitov wrote:
> 

[...]

> > Well, if you write a security module to prevent writes on a map,
> > and
> > user space is able to do it anyway with an iterator, what is the
> > purpose of the security module then?
> 
> sounds like a broken "security module" and nothing else.

Ok, if a custom security module does not convince you, let me make a
small example with SELinux.

I created a small map iterator that sets every value of a map to 5:

SEC("iter/bpf_map_elem")
int write_bpf_hash_map(struct bpf_iter__bpf_map_elem *ctx)
{
	u32 *key = ctx->key;
	u8 *val = ctx->value;

	if (key == NULL || val == NULL)
		return 0;

	*val = 5;
	return 0;
}

I create and pin a map:

# bpftool map create /sys/fs/bpf/map type array key 4 value 1 entries 1
name test

Initially, the content of the map looks like:

# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 00
Found 1 element

I then created a new SELinux type bpftool_test_t, which has only read
permission on maps:

# sesearch -A -s bpftool_test_t -t unconfined_t -c bpf
allow bpftool_test_t unconfined_t:bpf map_read;

So, what I expect is that this type is not able to write to the map.

Indeed, the current bpftool is not able to do it:

# strace -f -etrace=bpf runcon -t bpftool_test_t bpftool iter pin
writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0, file_flags=0},
144) = -1 EACCES (Permission denied)
Error: bpf obj get (/sys/fs/bpf): Permission denied

This happens because the current bpftool requests to access the map
with read-write permission, and SELinux denies it:

# cat /var/log/audit/audit.log|audit2allow


#============= bpftool_test_t ==============
allow bpftool_test_t unconfined_t:bpf map_write;


The command failed, and the content of the map is still:

# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 00
Found 1 element


Now, what I will do is to use a slightly modified version of bpftool
which requests read-only access to the map instead:

# strace -f -etrace=bpf runcon -t bpftool_test_t ./bpftool iter pin
writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0,
file_flags=BPF_F_RDONLY}, 16) = 3
libbpf: elf: skipping unrecognized data section(5) .eh_frame
libbpf: elf: skipping relo section(6) .rel.eh_frame for section(5)
.eh_frame

...

bpf(BPF_LINK_CREATE, {link_create={prog_fd=4, target_fd=0,
attach_type=BPF_TRACE_ITER, flags=0}, ...}, 48) = 5
bpf(BPF_OBJ_PIN, {pathname="/sys/fs/bpf/iter", bpf_fd=5, file_flags=0},
16) = 0

That worked, because SELinux grants read-only permission to
bpftool_test_t. However, the map iterator does not check how the fd was
obtained, and thus allows the iterator to be created.

At this point, we have write access, despite not having the right to do
it:

# cat /sys/fs/bpf/iter
# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 05
Found 1 element

The iterator updated the map value.


The patch I'm proposing checks how the map fd was obtained, and if its
modes are compatible with the operations an attached program is allowed
to do. If the fd does not have the required modes, eBPF denies the
creation of the map iterator.

After patching the kernel, I try to run the modified bpftool again:

# strace -f -etrace=bpf runcon -t bpftool_test_t ./bpftool iter pin
writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0,
file_flags=BPF_F_RDONLY}, 16) = 3
libbpf: elf: skipping unrecognized data section(5) .eh_frame
libbpf: elf: skipping relo section(6) .rel.eh_frame for section(5)
.eh_frame

...

bpf(BPF_LINK_CREATE, {link_create={prog_fd=4, target_fd=0,
attach_type=BPF_TRACE_ITER, flags=0}, ...}, 48) = -1 EPERM (Operation
not permitted)
libbpf: prog 'write_bpf_hash_map': failed to attach to iterator:
Operation not permitted
Error: attach_iter failed for program write_bpf_hash_map

The map iterator cannot be created and the map is not updated:

# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 00
Found 1 element

Roberto

