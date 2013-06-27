From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups statistics
Date: Thu, 27 Jun 2013 10:21:45 -0700
Message-ID: <CAOMFOmUNkb2q_FL_ceJC_GerTiUYrwN0r8WO1fQ7ZhmwKra2dQ@mail.gmail.com>
References: <20130627012304.GG4536@htj.dyndns.org>
	<1372351046-11976-1-git-send-email-anatol.pomozov@gmail.com>
	<20130627165943.GA5599@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=SNLDeK/BTJ7CvcXlgq8+tLJVxe/a3UL6SBXGgtMYFdk=;
        b=AlaftGRZxYs51Sf4P/GmOWSM0KfDl2ypTZBBw8pCsSjwvxAUqvBbhkoONAciHUsyJE
         6xVvmq+7sYeSFEgXuM5NGEM8NQRe5CFo1ymHGQLVuq7NkCk9y/INr5iLGS+muLhctx3z
         TqpB+X17OK8lVBjxLDHei9Dy+GQ44D1jMIalKkLiVTiBmQeJrXHagpBIq7CNbFV99Mah
         rpyPh/6NqSa3k4IWwM/8EMVc59R/eGVY7JooAYve96O3dDg+MC/q1xOttqCDjCAJ5IDb
         6J1S8M+njPIMWry1fNVbZdnGPlGB/bOYOLteKFsNQiGwhXCy4x1Fh3EkT+tgDzZmyiHU
         ljGg==
In-Reply-To: <20130627165943.GA5599-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hi

On Thu, Jun 27, 2013 at 9:59 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> (cc'ing Jens)
>
> Hello,
>
> This one probably needs -stable cc'd.  Jens, do you wanna take this?
> If not, I'll be happy to take it through cgroup tree.

Personally I think it should not go to -stable. The stats was changed
in 3.5 kernel and nobody complained about it, so I guess nobody
(except us) cares about the file format.

> On Thu, Jun 27, 2013 at 09:37:26AM -0700, Anatol Pomozov wrote:
>> Before 3.5 CFQ cgroups stats was lazy initialized - the stat object was created
>> only if the device had any I/O in that cgroup.
>>
>> Around 3.5 time CFQ stat structure became part of device structure. And
>> zero stat is created when device is initialized. Initialization can happen
>> e.g. when we configure it via 'weight_device' file. It calls
>> cfqg_set_weight_device() and it creates cfq_group structure.
>>
>> But even if device is initialized the stats is still zero.
>> If we configure all devices in all in all cgroups it generates a lot of
>> useless stat info that takes more resources to process and store. Imagine
>> servers with handreds cgroups and handreds iSCSI block devices.
>>
>> Do not print stats for inactive devices - it restores functionality
>> that was before 3.5
>>
>> Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
>> ---
>>  block/blk-cgroup.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index e8918ff..4e07e73 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -560,6 +560,7 @@ EXPORT_SYMBOL_GPL(__blkg_prfill_u64);
>>   * @rwstat: rwstat to print
>>   *
>>   * Print @rwstat to @sf for the device assocaited with @pd.
>> + * Devices with zero activity will not be printed.
>>   */
>>  u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
>>                        const struct blkg_rwstat *rwstat)
>> @@ -571,19 +572,23 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
>>               [BLKG_RWSTAT_ASYNC]     = "Async",
>>       };
>>       const char *dname = blkg_dev_name(pd->blkg);
>> -     u64 v;
>> +     u64 total;
>>       int i;
>>
>>       if (!dname)
>>               return 0;
>>
>> +     total = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
>> +     /* skip devices with no activity */
>> +     if (!total)
>> +             return 0;
>> +
>>       for (i = 0; i < BLKG_RWSTAT_NR; i++)
>>               seq_printf(sf, "%s %s %llu\n", dname, rwstr[i],
>>                          (unsigned long long)rwstat->cnt[i]);
>>
>> -     v = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
>> -     seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
>> -     return v;
>> +     seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)total);
>> +     return total;
>>  }
>>  EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
>>
>> --
>> 1.8.3
>>
>
> --
> tejun
