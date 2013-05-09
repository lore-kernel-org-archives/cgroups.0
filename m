From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 08/31] list: add a new LRU list type
Date: Fri, 10 May 2013 01:02:07 +0400
Message-ID: <518C0ECF.8010302@parallels.com>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org> <1368079608-5611-9-git-send-email-glommer@openvz.org> <20130509133742.GW11497@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------030502060200010009090907"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130509133742.GW11497-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--------------030502060200010009090907
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On 05/09/2013 05:37 PM, Mel Gorman wrote:
> On Thu, May 09, 2013 at 10:06:25AM +0400, Glauber Costa wrote:
>> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Several subsystems use the same construct for LRU lists - a list
>> head, a spin lock and and item count. They also use exactly the same
>> code for adding and removing items from the LRU. Create a generic
>> type for these LRU lists.
>>
>> This is the beginning of generic, node aware LRUs for shrinkers to
>> work with.
>>
>> [ glommer: enum defined constants for lru. Suggested by gthelen,
>>   don't relock over retry ]
>> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>> Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>
>>> <SNIP>
>>>
>> +
>> +unsigned long
>> +list_lru_walk(
>> +	struct list_lru *lru,
>> +	list_lru_walk_cb isolate,
>> +	void		*cb_arg,
>> +	long		nr_to_walk)
>> +{
>> +	struct list_head *item, *n;
>> +	unsigned long removed = 0;
>> +
>> +	spin_lock(&lru->lock);
>> +restart:
>> +	list_for_each_safe(item, n, &lru->list) {
>> +		enum lru_status ret;
>> +
>> +		if (nr_to_walk-- < 0)
>> +			break;
>> +
>> +		ret = isolate(item, &lru->lock, cb_arg);
>> +		switch (ret) {
>> +		case LRU_REMOVED:
>> +			lru->nr_items--;
>> +			removed++;
>> +			break;
>> +		case LRU_ROTATE:
>> +			list_move_tail(item, &lru->list);
>> +			break;
>> +		case LRU_SKIP:
>> +			break;
>> +		case LRU_RETRY:
>> +			goto restart;
>> +		default:
>> +			BUG();
>> +		}
>> +	}
> 
> What happened your suggestion to only retry once for each object to
> avoid any possibility of infinite looping or stalling for prolonged
> periods of time waiting on XFS to do something?
> 
Sorry. It wasn't clear for me if you were just trying to make sure we
had a way out in case it proves to be a problem, or actually wanted a
change.

In any case, I cannot claim to be as knowledgeable as Dave in the
subtleties of such things in the final behavior of the shrinker. Dave,
can you give us your input here?

I also have another recent observation on this:

The main difference between LRU_SKIP and LRU_RETRY is that LRU_RETRY
will go back to the beginning of the list, and start scanning it again.

This is *not* the same behavior we had before, where we used to read:

        for (nr_scanned = nr_to_scan; nr_scanned >= 0; nr_scanned--) {
                struct inode *inode;
                [ ... ]

                if (inode_has_buffers(inode) || inode->i_data.nrpages) {
                        __iget(inode);
                        [ ... ]
                        iput(inode);
                        spin_lock(&sb->s_inode_lru_lock);

                        if (inode != list_entry(sb->s_inode_lru.next,
                                                struct inode, i_lru))
                                continue; <=====
                        /* avoid lock inversions with trylock */
                        if (!spin_trylock(&inode->i_lock))
                                continue; <=====
                        if (!can_unuse(inode)) {
                                spin_unlock(&inode->i_lock);
                                continue; <=====
                        }
                }

It is my interpretation that we in here, we won't really reset the
search, but just skip this inode.

Another problem is that by restarting the search the way we are doing
now, we actually decrement nr_to_walk twice in case of a retry. By doing
a retry-once test, we can actually move nr_to_walk to the end of the
switch statement, which has the good side effect of getting rid of the
reason we had to allow it to go negative.

How about we fold the following attached patch to this one? (I would
still have to give it a round of testing)


--------------030502060200010009090907
Content-Type: text/x-patch; name="lru.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="lru.patch"

diff --git a/lib/list_lru.c b/lib/list_lru.c
index da9b837..4aa069b 100644
--- a/lib/list_lru.c
+++ b/lib/list_lru.c
@@ -195,12 +195,10 @@ list_lru_walk_node(
 	unsigned long isolated = 0;
 
 	spin_lock(&nlru->lock);
-restart:
 	list_for_each_safe(item, n, &nlru->list) {
+		bool first_pass = true;
 		enum lru_status ret;
-
-		if ((*nr_to_walk)-- < 0)
-			break;
+restart:
 
 		ret = isolate(item, &nlru->lock, cb_arg);
 		switch (ret) {
@@ -217,10 +215,17 @@ restart:
 		case LRU_SKIP:
 			break;
 		case LRU_RETRY:
+			if (!first_pass)
+				break;
+			first_pass = true;
 			goto restart;
 		default:
 			BUG();
 		}
+
+		if ((*nr_to_walk)-- == 0)
+			break;
+
 	}
 	spin_unlock(&nlru->lock);
 	return isolated;

--------------030502060200010009090907--
