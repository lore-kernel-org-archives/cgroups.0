From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] alternative mechanism to skip memcg kmem allocations
Date: Tue, 8 May 2012 13:47:02 -0700
Message-ID: <CABCjUKAo=guO5GBEiLSyOKbp3tRTpmwWWF0H+FoVqWF=S-JyZQ@mail.gmail.com>
References: <1336448238-3728-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=s6i+b2m0ot1C1VrwdSBP3hFC+f7Lq1QIDj+ANTxtpNQ=;
        b=Ry56QdlQdTGUbyDFVxKxcy3vql9ZqeZWBoGN8EknYLYh+QPjtLJ8dl7kMf2DOrbz9O
         49n+VlpvxsVF/6yHPZVfZLeHvOAxmmk7zEmVcZiG72jaAgTs5egFMHmhxFyfMAvCbGba
         cdr3ggAEiRJgY8H+jShItPGyTUqMkQZ6OTgFp/I5nBXV3zZy3uftCznEPvGm7Bll2yJa
         bYslxz8Cn7bZgEcsWSiLseqIoSnFYO4hd7R+zckEiCIp3tdJWlvpY7GOdwfLm8K4d0uM
         XXivZ9BC/wLp0kZvdunZrpV82R+MIEOJzVJKb2Wf0x6fmMjitic1K8VCwYEnt6T7TuaT
         TJaw==
In-Reply-To: <1336448238-3728-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, May 7, 2012 at 8:37 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> w=
rote:
> Since Kame expressed the wish to see a context-based method to skip
> accounting for caches, I came up with the following proposal for
> your appreciation.
>
> It basically works in the same way as preempt_disable()/preempt_enabl=
e():
> By marking a region under which all allocations will be accounted
> to the root memcg.
>
> I basically see two main advantages of it:
>
> =A0* No need to clutter the code with *_noaccount functions; they cou=
ld
> =A0 become specially widespread if we needed to skip accounting for
> =A0 kmalloc variants like track, zalloc, etc.
> =A0* Works with other caches, not only kmalloc; specially interesting
> =A0 since during cache creation we touch things like cache_cache,
> =A0 that could very well we wrapped inside a noaccount region.
>
> However:
>
> =A0* It touches task_struct
> =A0* It is harder to keep drivers away from using it. With
> =A0 kmalloc_no_account we could simply not export it. Here, one can
> =A0 always set this in the task_struct...
>
> Let me know what you think of it.

I like this idea a lot.

>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> =A0include/linux/sched.h | =A0 =A01 +
> =A0mm/memcontrol.c =A0 =A0 =A0 | =A0 34 +++++++++++++++++++++++++++++=
+++++
> =A02 files changed, 35 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 81a173c..516a9fe 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1613,6 +1613,7 @@ struct task_struct {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_pages; /* uncharged u=
sage */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long memsw_nr_pages; /* uncha=
rged mem+swap usage */
> =A0 =A0 =A0 =A0} memcg_batch;
> + =A0 =A0 =A0 int memcg_kmem_skip_account;
> =A0#endif
> =A0#ifdef CONFIG_HAVE_HW_BREAKPOINT
> =A0 =A0 =A0 =A0atomic_t ptrace_bp_refcnt;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8c7c404..833f4cd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -479,6 +479,33 @@ struct cg_proto *tcp_proto_cgroup(struct mem_cgr=
oup *memcg)
> =A0EXPORT_SYMBOL(tcp_proto_cgroup);
> =A0#endif /* CONFIG_INET */
>
> +static void memcg_stop_kmem_account(void)
> +{
> + =A0 =A0 =A0 struct task_struct *p;
> +
> + =A0 =A0 =A0 if (!current->mm)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 p =3D rcu_dereference(current->mm->owner);
> + =A0 =A0 =A0 if (p) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_lock(p);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p->memcg_kmem_skip_account =3D true;
> + =A0 =A0 =A0 }

This doesn't seem right. The flag has to be set on current, not on
another task, or weird things will happen (like the flag getting
lost).

Also, we might want to make it a count instead of a boolean, so that
it's possible to nest it.

-- Suleiman
