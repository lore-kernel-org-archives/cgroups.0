From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] cgroup: revise how we re-populate root directory
Date: Fri, 02 Mar 2012 13:49:06 +0800
Message-ID: <4F505F52.9000509@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com>	<4F4F148F.6040808@cn.fujitsu.com> <CAJd=RBAh-GzsfMiViGzKMeDV+G01K_OHZQHJ=amnp0trVhMABQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJd=RBAh-GzsfMiViGzKMeDV+G01K_OHZQHJ=amnp0trVhMABQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

20:48, Hillf Danton wrote:
> On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
>>
>> -static void cgroup_clear_directory(struct dentry *dentry)
>> +static void cgroup_clear_directory(struct dentry *dentry, bool remove_all,
>> +                                  unsigned long removed_bits)
>>  {
>> -       struct list_head *node;
>> +       LIST_HEAD(head);
>> +       struct dentry *d, *node;
>>
>>        BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
>> +
>>        spin_lock(&dentry->d_lock);
>> -       node = dentry->d_subdirs.next;
>> -       while (node != &dentry->d_subdirs) {
>> -               struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
>> +       list_for_each_entry_safe(d, node, &dentry->d_subdirs, d_u.d_child) {
>> +               struct cftype *cft = d->d_fsdata;
>> +
>> +               if (!remove_all && cft->subsys &&
>> +                   !test_bit(cft->subsys->subsys_id, &removed_bits))
>> +                       continue;
>>
>>                spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
>> -               list_del_init(node);
>> +               list_move(&d->d_u.d_child, &head);
>>                if (d->d_inode) {
>>                        /* This should never be called on a cgroup
>>                         * directory with child cgroups */
>>                        BUG_ON(d->d_inode->i_mode & S_IFDIR);
>>                        dget_dlock(d);
>> -                       spin_unlock(&d->d_lock);
>> -                       spin_unlock(&dentry->d_lock);
>> +               }
>> +               spin_unlock(&d->d_lock);
>> +       }
>> +       spin_unlock(&dentry->d_lock);
>> +
> 
> Safe to process isolated entries without dentry->d_lock held?
> 

no vfs expert, I need to check into the vfs code.

> -hd
> 
>> +       list_for_each_entry_safe(d, node, &head, d_u.d_child) {
>> +               spin_lock(&d->d_lock);
>> +               list_del_init(&d->d_u.d_child);
>> +               spin_unlock(&d->d_lock);
>> +               if (d->d_inode) {
>>                        d_delete(d);
>>                        simple_unlink(dentry->d_inode, d);
>>                        dput(d);
>> -                       spin_lock(&dentry->d_lock);
>> -               } else
>> -                       spin_unlock(&d->d_lock);
>> -               node = dentry->d_subdirs.next;
>> +               }
>>        }
>> -       spin_unlock(&dentry->d_lock);
>>  }
>>
