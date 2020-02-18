From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Tue, 18 Feb 2020 13:41:11 -0800
Message-ID: <9d6690e9-0dd4-f779-89b2-e02ff9a517e4@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
 <1582035660.7365.90.camel@lca.pw>
 <CAHS8izO5=vKs-v9v=Di3hQXBD41+_YpYarXn1yZu9YE6SR-i6Q@mail.gmail.com>
 <d498012a-ec87-ca48-ed78-5fcdaf372888@oracle.com>
 <CAHS8izPbMizJMNB-y9y2OViXYLStA6VT-HkWRd2hCS-5JSMwSA@mail.gmail.com>
 <CAHS8izODfKaLqWAehhR_XuN=FRgmWBE7+eCJMD2HGig8s+zvwg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z6ygooUUXhz1hWqQYcQAJibC6Prp+WjFAbn5QtklRpQ=;
 b=a/6pOGctOeiz0VWq1GZU7ZfLtgCuJcMaDVZaLjz+RqXCYbfveMvQeSyaMINDAT0EHEaU
 qhrR4bD4f7fE98UGs8SMdYP+36Yl+GhQzcVLZF+2iztpbFQi9U1+VRfYcIkRM3SZlEQq
 A5EuTuKmO/+DbUB+MntQ6fkD/YzkGkZ/jotVM4qmIQnfBxkUMWb31KVAcvsWC4x2eSeV
 LFLMkV2t6YRMBivdQxuvhLFEcboKbCR2EhQ+KWjCVm5WmC3PXgdZq+U8Q9+UwYL6bCjo
 gde8v2a4reLHvUF9WkMOwpJpnZhhR12QJBPp4ZJXa98UEuPJn6RZxK3w0WIaKjRDUqB7 Jg== 
In-Reply-To: <CAHS8izODfKaLqWAehhR_XuN=FRgmWBE7+eCJMD2HGig8s+zvwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/18/20 1:36 PM, Mina Almasry wrote:
> On Tue, Feb 18, 2020 at 11:25 AM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Tue, Feb 18, 2020 at 11:14 AM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>> On 2/18/20 10:35 AM, Mina Almasry wrote:
>>>> On Tue, Feb 18, 2020 at 6:21 AM Qian Cai <cai-J5quhbR+WMc@public.gmane.org> wrote:
>>>>>
>>>>> On Tue, 2020-02-11 at 15:19 -0800, Andrew Morton wrote:
>>>>>> On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>>
>>>>> [ 7933.806377][T14355] ------------[ cut here ]------------
>>>>> [ 7933.806541][T14355] kernel BUG at mm/hugetlb.c:490!
>>>>> VM_BUG_ON(t - f <= 1);
>>>>> [ 7933.806562][T14355] Oops: Exception in kernel mode, sig: 5 [#1]
>>> <snip>
>>>> Hi Qian,
>>>>
>>>> Yes this VM_BUG_ON was added by a patch in the series ("hugetlb:
>>>> disable region_add file_region coalescing") so it's definitely related
>>>> to the series. I'm taking a look at why this VM_BUG_ON fires. Can you
>>>> confirm you reproduce this by running hugemmap06 from the ltp on a
>>>> powerpc machine? Can I maybe have your config?
>>>>
>>>> Thanks!
>>>
>>> Hi Mina,
>>>
>>> Looking at the region_chg code again, we do a
>>>
>>>         resv->adds_in_progress += *out_regions_needed;
>>>
>>> and then potentially drop the lock to allocate the needed entries.  Could
>>> anopther thread (only adding reservation for a single page) then come in
>>> and notice that there are not enough entries in the cache and hit the
>>> VM_BUG_ON()?
>>
>> Maybe. Also I'm thinking the code thinks actual_regions_needed >=
>> in_regions_needed, but that doesn't seem like a guarantee. I think
>> this call sequence with the same t->f range would violate that:
>>
>> region_chg (regions_needed=1)
>> region_chg (regions_needed=1)
>> region_add (fills in the range)
>> region_add (in_regions_needed = 1, actual_regions_needed = 0, so
>> assumptions in the code break).
>>
>> Luckily it seems the ltp readily reproduces this, so I'm working on
>> reproducing it. I should have a fix soon, at least if I can reproduce
>> it as well.
> 
> I had a bit of trouble reproducing this but I got it just now.
> 
> Makes sense I've never run into this even though others can readily
> reproduce it. I happen to run my kernels on a pretty beefy 36 core
> machine and in that setup things seem to execute fast and there is
> never a queue of pending file_region inserts into the resv_map. Once I
> limited qemu to only use 2 cores I ran into the issue right away.
> Looking into a fix now.

This may not be optimal, but it resolves the issue for me.  I just put it
together to test the theory that the region_chg code was at fault.
-- 
Mike Kravetz

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 45219cb58ac7..f750f95ed37a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -549,6 +549,7 @@ static long region_chg(struct resv_map *resv, long f, long t,
 	struct file_region *trg = NULL, *rg = NULL;
 	long chg = 0, i = 0, to_allocate = 0;
 	struct list_head allocated_regions;
+	long calc_adds_in_progress = 0;
 
 	INIT_LIST_HEAD(&allocated_regions);
 
@@ -561,14 +562,14 @@ static long region_chg(struct resv_map *resv, long f, long t,
 	if (*out_regions_needed == 0)
 		*out_regions_needed = 1;
 
-	resv->adds_in_progress += *out_regions_needed;
+	calc_adds_in_progress = resv->adds_in_progress + *out_regions_needed;
 
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
 	 * the number of in progress add operations.
 	 */
-	while (resv->region_cache_count < resv->adds_in_progress) {
-		to_allocate = resv->adds_in_progress - resv->region_cache_count;
+	while (resv->region_cache_count < calc_adds_in_progress) {
+		to_allocate = calc_adds_in_progress - resv->region_cache_count;
 
 		/* Must drop lock to allocate a new descriptor. Note that even
 		 * though we drop the lock here, we do not make another call to
@@ -593,8 +594,20 @@ static long region_chg(struct resv_map *resv, long f, long t,
 			list_add(&rg->link, &resv->region_cache);
 			resv->region_cache_count++;
 		}
+
+		chg = add_reservation_in_range(resv, f, t, NULL, NULL,
+				       out_regions_needed, true);
+
+		if (*out_regions_needed == 0)
+			*out_regions_needed = 1;
+
+		calc_adds_in_progress = resv->adds_in_progress +
+					*out_regions_needed;
+
 	}
 
+	resv->adds_in_progress += *out_regions_needed;
+
 	spin_unlock(&resv->lock);
 	return chg;
