From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Tue, 23 Sep 2014 16:46:50 +0900
Message-ID: <5421256A.8080708@jp.fujitsu.com>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

(2014/09/19 22:22), Johannes Weiner wrote:
> Memory is internally accounted in bytes, using spinlock-protected
> 64-bit counters, even though the smallest accounting delta is a page.
> The counter interface is also convoluted and does too many things.
> 
> Introduce a new lockless word-sized page counter API, then change all
> memory accounting over to it and remove the old one.  The translation
> from and to bytes then only happens when interfacing with userspace.
> 
> Aside from the locking costs, this gets rid of the icky unsigned long
> long types in the very heart of memcg, which is great for 32 bit and
> also makes the code a lot more readable.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

I like this patch because I hate res_counter very much.

a few nitpick comments..

<snip>

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 19df5d857411..bf8fb1a05597 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -54,6 +54,38 @@ struct mem_cgroup_reclaim_cookie {
>   };
>   
>   #ifdef CONFIG_MEMCG
> +
> +struct page_counter {
> +	atomic_long_t count;
> +	unsigned long limit;
> +	struct page_counter *parent;
> +
> +	/* legacy */
> +	unsigned long watermark;
> +	unsigned long limited;
> +};

I guees all attributes should be on the same cache line. How about align this to cache ?
And legacy values are not very important to be atomic by design, right ?

> +
> +#if BITS_PER_LONG == 32
> +#define PAGE_COUNTER_MAX ULONG_MAX
> +#else
> +#define PAGE_COUNTER_MAX (ULONG_MAX / PAGE_SIZE)
> +#endif
> +
<snip>

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2def11f1ec1..dfd3b15a57e8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -25,7 +25,6 @@
>    * GNU General Public License for more details.
>    */
>   
> -#include <linux/res_counter.h>
>   #include <linux/memcontrol.h>
>   #include <linux/cgroup.h>
>   #include <linux/mm.h>
> @@ -66,6 +65,117 @@
>   
>   #include <trace/events/vmscan.h>
>   
> +int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
> +{
> +	long new;
> +
> +	new = atomic_long_sub_return(nr_pages, &counter->count);
> +
> +	if (WARN_ON(unlikely(new < 0)))
> +		atomic_long_set(&counter->count, 0);

 WARN_ON_ONCE() ?
 Or I prefer atomic_add(&counter->count, nr_pages) rather than set to 0
 because if a buggy call's "nr_pages" is enough big, following calls to
 page_counter_cacnel() will show more logs.

> +
> +	return new > 1;
> +}
> +
> +int page_counter_charge(struct page_counter *counter, unsigned long nr_pages,
> +			struct page_counter **fail)
> +{
> +	struct page_counter *c;
> +
> +	for (c = counter; c; c = c->parent) {
> +		for (;;) {
> +			unsigned long count;
> +			unsigned long new;
> +
> +			count = atomic_long_read(&c->count);
> +
> +			new = count + nr_pages;
> +			if (new > c->limit) {
> +				c->limited++;
> +				if (fail) {
> +					*fail = c;
> +					goto failed;
> +				}
  seeing res_counter(), c ret code for this case should be -ENOMEM.
> +			}
> +
> +			if (atomic_long_cmpxchg(&c->count, count, new) != count)
> +				continue;
> +
> +			if (new > c->watermark)
> +				c->watermark = new;
> +
> +			break;
> +		}
> +	}
> +	return 0;
> +
> +failed:
> +	for (c = counter; c != *fail; c = c->parent)
> +		page_counter_cancel(c, nr_pages);
> +
> +	return -ENOMEM;
> +}
> +
> +int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
> +{
> +	struct page_counter *c;
> +	int ret = 1;
> +
> +	for (c = counter; c; c = c->parent) {
> +		int remainder;
> +
> +		remainder = page_counter_cancel(c, nr_pages);
> +		if (c == counter && !remainder)
> +			ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +int page_counter_limit(struct page_counter *counter, unsigned long limit)
> +{
> +	for (;;) {
> +		unsigned long count;
> +		unsigned long old;
> +
> +		count = atomic_long_read(&counter->count);
> +
> +		old = xchg(&counter->limit, limit);
> +
> +		if (atomic_long_read(&counter->count) != count) {
> +			counter->limit = old;
> +			continue;
> +		}
> +
> +		if (count > limit) {
> +			counter->limit = old;
> +			return -EBUSY;
> +		}
> +
> +		return 0;
> +	}
> +}

I think the whole "updating limit"  ops should be mutual exclusive. It seems
there will be trouble if multiple updater comes at once.
So, "xchg" isn't required. calllers should have their own locks.

Thanks,
-Kame




--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
