From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 00/10] per lruvec lru_lock for memcg
Date: Mon, 13 Jan 2020 00:48:12 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2001130032170.1103@eggly.anvils>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com> <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org> <944f0f6a-466a-7ce3-524c-f6db86fd0891@linux.alibaba.com> <d2efad94-750b-3298-8859-84bccc6ecf06@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-817818044-1578905305=:1103"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=WZ/Vp5J75l/Z0Fz+dAhAJFvPAQAZ19P0lPgX+P8DE2c=;
        b=kEhY48/M0ggWwX4MEp67wWDacjjM2wtpVF6VdfR+QTa89pYS1Ttsf2zhsO8+rAUU6z
         nbOC/tzJ7vvPxgnf9hcmvu4/CpYXaqm+jest6X7tewjKCfUhoIsPnKpvMaAYphzImzb3
         QMSQYIkrXk95BmJ1me8KmozT7h4bu25C/qD6qjVtdBIz3J8fCDJMnquBwx0dPFkEUi49
         LAkoO8wjIPqvgDTcDa6SCty/lMoV7Z9BZ64d/h8EexOUrv9unhFGEg8rxKLv3T+CUoIl
         Lxa/6cd0OwlV5Cqciuy5rYZXpeQu45NJicfJBAplLaiYsZL97KT4EWcZOdy52FmI2ydI
         rMKA==
In-Reply-To: <d2efad94-750b-3298-8859-84bccc6ecf06-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-817818044-1578905305=:1103
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 10 Jan 2020, Alex Shi wrote:
> =E5=9C=A8 2020/1/2 =E4=B8=8B=E5=8D=886:21, Alex Shi =E5=86=99=E9=81=93:
> > =E5=9C=A8 2020/1/1 =E4=B8=8A=E5=8D=887:05, Andrew Morton =E5=86=99=E9=
=81=93:
> >> On Wed, 25 Dec 2019 17:04:16 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAg@public.gmane.org=
m> wrote:
> >>
> >>> This patchset move lru_lock into lruvec, give a lru_lock for each of
> >>> lruvec, thus bring a lru_lock for each of memcg per node.
> >>
> >> I see that there has been plenty of feedback on previous versions, but
> >> no acked/reviewed tags as yet.
> >>
> >> I think I'll take a pass for now, see what the audience feedback looks
> >> like ;)
> >>
> >=20
>=20
> Hi Johannes,
>=20
> Any comments of this version? :)

I (Hugh) tried to test it on v5.5-rc5, but did not get very far at all -
perhaps because my particular interest tends towards tmpfs and swap,
and swap always made trouble for lruvec lock - one of the reasons why
our patches were more complicated than you thought necessary.

Booted a smallish kernel in mem=3D700M with 1.5G of swap, with intention
of running small kernel builds in tmpfs and in ext4-on-loop-on-tmpfs
(losetup was the last command started but I doubt it played much part):

mount -t tmpfs -o size=3D470M tmpfs /tst
cp /dev/zero /tst
losetup /dev/loop0 /tst/zero

and kernel crashed on the

VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D page->mem_cgroup, page);
kernel BUG at mm/memcontrol.c:1268!
lock_page_lruvec_irqsave
relock_page_lruvec_irqsave
pagevec_lru_move_fn
__pagevec_lru_add
lru_add_drain_cpu
lru_add_drain
swap_cluster_readahead
shmem_swapin
shmem_swapin_page
shmem_getpage_gfp
shmem_getpage
shmem_write_begin
generic_perform_write
__generic_file_write_iter
generic_file_write_iter
new_sync_write
__vfs_write
vfs_write
ksys_write
__x86_sys_write
do_syscall_64

Hugh
--0-817818044-1578905305=:1103--
