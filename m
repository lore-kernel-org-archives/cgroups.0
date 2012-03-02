From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] xattr: extract kmem_xattr code from tmpfs
Date: Fri, 02 Mar 2012 13:23:03 +0800
Message-ID: <4F505937.9080904@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com>	<4F4F146C.9090300@cn.fujitsu.com> <CAJd=RBB+2r-Q8K1FQqPh90EdtAdmz3R8FWU48M_ePqyziNfcLw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJd=RBB+2r-Q8K1FQqPh90EdtAdmz3R8FWU48M_ePqyziNfcLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hillf Danton wrote:
> On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
>> +/*
>> + * free all the xattrs
>> + */
>> +void kmem_xattrs_free(struct kmem_xattrs *xattrs)
>> +{
>> +       struct kmem_xattr *xattr, *node;
>> +
>> +       spin_lock(&xattrs->lock);
>> +       list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
>> +               kfree(xattr->name);
>> +               kfree(xattr);
>> +       }
>> +       spin_unlock(&xattrs->lock);
> 
> In your work it is a library function, operations on &xattrs->head
> are no longer allowed, say list_empty(), after it called, though I
> dunno if such operations exist.
> 

I'd prefer to make it safer to use, so I'll re-init the list head
after freeing all the list items.

> And kmem_xattrs is too close to kmem_xattr, kmem_xattr_list
> is not pron of typo.
> 

Then you won't pass compile. ;)

kmem_xattr_list exposed the data structure we used internally.
We might change to use an rbtree.
