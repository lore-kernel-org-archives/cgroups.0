From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v12 05/18] fs: do not use destroy_super() in alloc_super()
 fail path
Date: Tue, 3 Dec 2013 13:23:01 +0400
Message-ID: <529DA2F5.1040602@parallels.com>
References: <cover.1385974612.git.vdavydov@parallels.com> <af90b79aebe9cd9f6e1d35513f2618f4e9888e9b.1385974612.git.vdavydov@parallels.com> <20131203090041.GB8803@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131203090041.GB8803@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On 12/03/2013 01:00 PM, Dave Chinner wrote:
> On Mon, Dec 02, 2013 at 03:19:40PM +0400, Vladimir Davydov wrote:
>> Using destroy_super() in alloc_super() fail path is bad, because:
>>
>> * It will trigger WARN_ON(!list_empty(&s->s_mounts)) since s_mounts is
>>   initialized after several 'goto fail's.
> So let's fix that.
>
>> * It will call kfree_rcu() to free the super block although kfree() is
>>   obviously enough there.
>> * The list_lru structure was initially implemented without the ability
>>   to destroy an uninitialized object in mind.
>>
>> I'm going to replace the conventional list_lru with per-memcg lru to
>> implement per-memcg slab reclaim. This new structure will fail
>> destruction of objects that haven't been properly initialized so let's
>> inline appropriate snippets from destroy_super() to alloc_super() fail
>> path instead of using the whole function there.
> You're basically undoing the change made in commit 7eb5e88 ("uninline
> destroy_super(), consolidate alloc_super()") which was done less
> than a month ago. :/
>
> The code as it stands works just fine - the list-lru structures in
> the superblock are actually initialised (to zeros) - and so calling
> list_lru_destroy() on it works just fine in that state as the
> pointers that are freed are NULL. Yes, unexpected, but perfectly
> valid code.
>
> I haven't looked at the internals of the list_lru changes you've
> made yet, but it surprises me that we can't handle this case
> internally to list_lru_destroy().

Actually, I'm not going to modify the list_lru structure, because I
think it's good as it is. I'd like to substitute it with a new
structure, memcg_list_lru, only in those places where this functionality
(per-memcg scanning) is really needed. This new structure would look
like this:

struct memcg_list_lru {
    struct list_lru global_lru;
    struct list_lru **memcg_lrus;
    struct list_head list;
    void *old_lrus;
}

Since old_lrus and memcg_lrus can be NULL under normal operation, in
memcg_list_lru_destroy() I'd have to check either the list or the
global_lru field, i.e. it would look like:

if (!list.next)
    /* has not been initialized */
    return;

or

if (!global_lru.node)
    /* has not been initialized */
    return;

I find both of these checks ugly :-(

Personally, I think that's calling destroy() w/o init() is OK only for
simple structures where destroy/init are inline functions or macros,
otherwise one can forget to "fix" destroy() after it extends a structure.

Thanks.
