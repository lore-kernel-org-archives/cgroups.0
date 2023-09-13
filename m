From: Dmitry Yakunin <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] cgroup: list all subsystem states in debugfs
 files
Date: Wed, 13 Sep 2023 12:35:15 +0200
Message-ID: <870aa2af-62b7-48ba-b1a0-77b651352211@nebius.com>
References: <20230911075437.74027-1-zeil@nebius.com>
 <20230911075437.74027-2-zeil@nebius.com>
 <CAJD7tkYM0JBukPMWCWtx-nrzGgPw4Y6m1p2_Ynb9fzSgsS0igg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nebius.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/tUvI0rO/fZsEmr+L76aouRqGSfQ9Vy9Ur+y7I0tJI=;
 b=HBFjKf+lqbgZahi4GtYOmIJAhbgsmlroTn/BhlyfoKVYpahgfUrvnoxCpHzHY/6clGw1BibC0lKl3/OLNc3kj4xgC7wrhp5bnNYSXiZLv1aspGL2zKfurX9NDlImM0mJXa+tH3T+wlQK6VkEuJ49+Q/tplyGwiv6mbIbnfSL9cJDBxfEBI8WTE0P3Z+DiKeSu9Duc9Rk9Ui8HQTZ4D/E7keeGmZsfp81YOYP3nXSCdk3eitLzcSRWWBlPIc9uojNCy5XrrGcUTLgGyyCquakjOrS8ZUp8xewAS81nTFQKoueiclOkhnbhaqZ2ySdxSuVn95etkJTx0gRAJK6vzMQ+w==
Content-Language: ru
In-Reply-To: <CAJD7tkYM0JBukPMWCWtx-nrzGgPw4Y6m1p2_Ynb9fzSgsS0igg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, NB-Core Team <NB-CoreTeam-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

Sure, if you can share you work it would be nice. Thank you.

On 12.09.2023 00:16, Yosry Ahmed wrote:
> On Mon, Sep 11, 2023 at 12:55=E2=80=AFAM Yakunin, Dmitry (Nebius)
> <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org> wrote:
>> After removing cgroup subsystem state could leak or live in background
>> forever because it is pinned by some reference. For example memory cgroup
>> could be pinned by pages in cache or tmpfs.
>>
>> This patch adds common debugfs interface for listing basic state for each
>> controller. Controller could define callback for dumping own attributes.
>>
>> In file /sys/kernel/debug/cgroup/<controller> each line shows state in
>> format: <common_attr>=3D<value>... [-- <controller_attr>=3D<value>... ]
>>
>> Common attributes:
>>
>> css - css pointer
>> cgroup - cgroup pointer
>> id - css id
>> ino - cgroup inode
>> flags - css flags
>> refcnt - css atomic refcount, for online shows huge bias
>> path - cgroup path
>>
>> This patch adds memcg attributes:
>>
>> mem_id - 16-bit memory cgroup id
>> memory - charged pages
>> memsw - charged memory+swap for v1 and swap for v2
>> kmem - charged kernel pages
>> tcpmem - charged tcp pages
>> shmem - shmem/tmpfs pages
>>
>> Link: https://lore.kernel.org/lkml/153414348591.737150.14229960913953276=
515.stgit@buzz
>> Suggested-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@p=
ublic.gmane.org>
>> Reviewed-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.o=
rg>
>> Signed-off-by: Dmitry Yakunin <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.=
org>
> FWIW, I was just recently working on a debugfs directly that exposes a
> list of all zombie memcgs as well as the "memory.stat" output for all
> of them.
>
> This entails a file at /sys/kernel/debug/zombie_memcgs/all that
> contains a list of zombie memcgs (with indentation to reflect the
> hierarchy) and an id for each of them.
>
> This id can be used to index per-memcg directories at
> /sys/kernel/debug/zombie_memcgs/<id>/, which include debug files. The
> only one we have so far is
> /sys/kernel/debug/zombie_memcgs/<id>/memory.stat.
>
> If there is interest in this, I can share more information.
>
>> ---
>>   include/linux/cgroup-defs.h |   1 +
>>   kernel/cgroup/cgroup.c      | 101 ++++++++++++++++++++++++++++++++++++
>>   mm/memcontrol.c             |  14 +++++
>>   3 files changed, 116 insertions(+)
>>
>> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
>> index 8a0d5466c7be..810bd300cbee 100644
>> --- a/include/linux/cgroup-defs.h
>> +++ b/include/linux/cgroup-defs.h
>> @@ -673,6 +673,7 @@ struct cgroup_subsys {
>>          void (*exit)(struct task_struct *task);
>>          void (*release)(struct task_struct *task);
>>          void (*bind)(struct cgroup_subsys_state *root_css);
>> +       void (*css_dump)(struct cgroup_subsys_state *css, struct seq_fil=
e *m);
>>
>>          bool early_init:1;
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 625d7483951c..fb9931ff7570 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -40,6 +40,7 @@
>>   #include <linux/mount.h>
>>   #include <linux/pagemap.h>
>>   #include <linux/proc_fs.h>
>> +#include <linux/debugfs.h>
>>   #include <linux/rcupdate.h>
>>   #include <linux/sched.h>
>>   #include <linux/sched/task.h>
>> @@ -7068,3 +7069,103 @@ static int __init cgroup_sysfs_init(void)
>>   subsys_initcall(cgroup_sysfs_init);
>>
>>   #endif /* CONFIG_SYSFS */
>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +void *css_debugfs_seqfile_start(struct seq_file *m, loff_t *pos)
>> +{
>> +       struct cgroup_subsys *ss =3D m->private;
>> +       struct cgroup_subsys_state *css;
>> +       int id =3D *pos;
>> +
>> +       rcu_read_lock();
>> +       css =3D idr_get_next(&ss->css_idr, &id);
>> +       *pos =3D id;
>> +       return css;
>> +}
>> +
>> +void *css_debugfs_seqfile_next(struct seq_file *m, void *v, loff_t *pos)
>> +{
>> +       struct cgroup_subsys *ss =3D m->private;
>> +       struct cgroup_subsys_state *css;
>> +       int id =3D *pos + 1;
>> +
>> +       css =3D idr_get_next(&ss->css_idr, &id);
>> +       *pos =3D id;
>> +       return css;
>> +}
>> +
>> +void css_debugfs_seqfile_stop(struct seq_file *m, void *v)
>> +{
>> +       rcu_read_unlock();
>> +}
>> +
>> +int css_debugfs_seqfile_show(struct seq_file *m, void *v)
>> +{
>> +       struct cgroup_subsys *ss =3D m->private;
>> +       struct cgroup_subsys_state *css =3D v;
>> +       /* data is NULL for root cgroup_subsys_state */
>> +       struct percpu_ref_data *data =3D css->refcnt.data;
>> +       size_t buflen;
>> +       char *buf;
>> +       int len;
>> +
>> +       seq_printf(m, "css=3D%pK cgroup=3D%pK id=3D%d ino=3D%lu flags=3D=
%#x refcnt=3D%lu path=3D",
>> +                  css, css->cgroup, css->id, cgroup_ino(css->cgroup),
>> +                  css->flags, data ? atomic_long_read(&data->count) : 0=
);
>> +
>> +       buflen =3D seq_get_buf(m, &buf);
>> +       if (buf) {
>> +               len =3D cgroup_path(css->cgroup, buf, buflen);
>> +               seq_commit(m, len < buflen ? len : -1);
>> +       }
>> +
>> +       if (ss->css_dump) {
>> +               seq_puts(m, " -- ");
>> +               ss->css_dump(css, m);
>> +       }
>> +
>> +       seq_putc(m, '\n');
>> +       return 0;
>> +}
>> +
>> +static const struct seq_operations css_debug_seq_ops =3D {
>> +       .start =3D css_debugfs_seqfile_start,
>> +       .next =3D css_debugfs_seqfile_next,
>> +       .stop =3D css_debugfs_seqfile_stop,
>> +       .show =3D css_debugfs_seqfile_show,
>> +};
>> +
>> +static int css_debugfs_open(struct inode *inode, struct file *file)
>> +{
>> +       int ret =3D seq_open(file, &css_debug_seq_ops);
>> +       struct seq_file *m =3D file->private_data;
>> +
>> +       if (!ret)
>> +               m->private =3D inode->i_private;
>> +       return ret;
>> +}
>> +
>> +static const struct file_operations css_debugfs_fops =3D {
>> +       .open =3D css_debugfs_open,
>> +       .read =3D seq_read,
>> +       .llseek =3D seq_lseek,
>> +       .release =3D seq_release,
>> +};
>> +
>> +static int __init css_debugfs_init(void)
>> +{
>> +       struct cgroup_subsys *ss;
>> +       struct dentry *dir;
>> +       int ssid;
>> +
>> +       dir =3D debugfs_create_dir("cgroup", NULL);
>> +       if (dir) {
>> +               for_each_subsys(ss, ssid)
>> +                       debugfs_create_file(ss->name, 0644, dir, ss,
>> +                                           &css_debugfs_fops);
>> +       }
>> +
>> +       return 0;
>> +}
>> +late_initcall(css_debugfs_init);
>> +#endif /* CONFIG_DEBUG_FS */
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4b27e245a055..7b3d4a10ac63 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5654,6 +5654,20 @@ static void mem_cgroup_css_rstat_flush(struct cgr=
oup_subsys_state *css, int cpu)
>>          }
>>   }
>>
>> +static void mem_cgroup_css_dump(struct cgroup_subsys_state *css,
>> +                               struct seq_file *m)
>> +{
>> +       struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);
>> +
>> +       seq_printf(m, "mem_id=3D%u memory=3D%lu memsw=3D%lu kmem=3D%lu t=
cpmem=3D%lu shmem=3D%lu",
>> +                  mem_cgroup_id(memcg),
>> +                  page_counter_read(&memcg->memory),
>> +                  page_counter_read(&memcg->memsw),
>> +                  page_counter_read(&memcg->kmem),
>> +                  page_counter_read(&memcg->tcpmem),
>> +                  memcg_page_state(memcg, NR_SHMEM));
>> +}
>> +
>>   #ifdef CONFIG_MMU
>>   /* Handlers for move charge at task migration. */
>>   static int mem_cgroup_do_precharge(unsigned long count)
>> --
>> 2.25.1
>>
>>
