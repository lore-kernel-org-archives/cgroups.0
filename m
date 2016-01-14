From: Martijn Coenen <maco@google.com>
Subject: Re: [PATCH] memcg: Only free spare array when readers are done
Date: Thu, 14 Jan 2016 16:33:38 +0100
Message-ID: <CA+_MTtwZ7Wo-9GsJEb6yH9j3qwL6DFShuUXhHr7whczZVywk_w@mail.gmail.com>
References: <001a113abaa499606605294b5b17@google.com>
	<20160114143847.GD5046@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=R14qbKartuwhjipKU9g3qIU+6vB23O5RMPXPDOXI6bY=;
        b=EpTLd4F1ujExGgzqmxcmhUw6ScQaCbx3fy3FoDRyMpiO8k+sA2gLv3/x3v9k55ZIMA
         uPB39VIMz4e9WmmDWeqVLp2pzrELVv882ULNdLShpNuAufiBHn7uaLM2AXLWPjukoabj
         HJ4uUhVd2k1mxWyPgAb1Mx0RRCJKnn0ui4VkcJUvW1OCG6R2yWOLR4oreBFZg8djA+d1
         vhK6SczJ0W6TKb4GKQr50z2iuBPuCK9PGlnIdL4w7CQ8efYSYanR85PIHX+9ii4DffvL
         +QWzQlSW+x/YNmelh/Yhyy0cZsA8NUHqrWbFuvVWWIz+pqpzb4oJ/yHh9x7rn/ZIW1Rf
         zDsQ==
In-Reply-To: <20160114143847.GD5046@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Jan 14, 2016 at 3:38 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Thu 14-01-16 14:33:52, Martijn Coenen wrote:
>> A spare array holding mem cgroup threshold events is kept around
>> to make sure we can always safely deregister an event and have an
>> array to store the new set of events in.
>>
>> In the scenario where we're going from 1 to 0 registered events, the
>> pointer to the primary array containing 1 event is copied to the spare
>> slot, and then the spare slot is freed because no events are left.
>> However, it is freed before calling synchronize_rcu(), which means
>> readers may still be accessing threshold->primary after it is freed.
>
> Have you seen this triggering in the real life?
(Sorry for the HTML mess).
It was pretty easy to reproduce in a stress test setup, where we spawn
a process, put it in a mem cgroup and setup the threshold, have it
allocate a lot of memory quickly (crossing the threshold), unregister
the event, kill and repeat. Usually within 30 mins.

>
>>
>> Fixed by only freeing after synchronize_rcu().
>>
>
> Fixes: 8c7577637ca3 ("memcg: free spare array to avoid memory leak")
>> Signed-off-by: Martijn Coenen <maco@google.com>
> Cc: stable
>
> Acked-by: Michal Hocko <mhocko@suse.com>
>
> Thanks!
>
>> ---
>>  mm/memcontrol.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 14cb1db..73228b6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3522,16 +3522,17 @@ static void
>> __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
>>  swap_buffers:
>>       /* Swap primary and spare array */
>>       thresholds->spare = thresholds->primary;
>> -     /* If all events are unregistered, free the spare array */
>> -     if (!new) {
>> -             kfree(thresholds->spare);
>> -             thresholds->spare = NULL;
>> -     }
>>
>>       rcu_assign_pointer(thresholds->primary, new);
>>
>>       /* To be sure that nobody uses thresholds */
>>       synchronize_rcu();
>> +
>> +     /* If all events are unregistered, free the spare array */
>> +     if (!new) {
>> +             kfree(thresholds->spare);
>> +             thresholds->spare = NULL;
>> +     }
>>  unlock:
>>       mutex_unlock(&memcg->thresholds_lock);
>>  }
>> --
>> 2.6.0.rc2.230.g3dd15c0
>
> --
> Michal Hocko
> SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
