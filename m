From: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1 1/4] cgroup quota: add disk space parse strategy
 to res_counter
Date: Sun, 11 Mar 2012 18:52:41 +0800
Message-ID: <4F5C83F9.7090201@oracle.com>
References: <4F59E799.6030409@oracle.com> <4F5C8A3A.7080601@parallels.com>
Reply-To: jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5C8A3A.7080601-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christopher Jones <christopher.jones-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, tytso-DPNOqEs/LNQ@public.gmane.org

On 03/11/2012 07:19 PM, Glauber Costa wrote:

> On 03/09/2012 03:20 PM, Jeff Liu wrote:
>> Introduce a new disk space parse strategy routine for cgroup quota
>> supports.
>> disk_space_parse() is simply copied from mmparse() with Petabytes and
>> Terabytes parse.
>>
>> Signed-off-by: Jie Liu<jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>   include/linux/res_counter.h |    3 ++
>>   kernel/res_counter.c        |   58
>> +++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 61 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
>> index c9d625c..f8ce315 100644
>> --- a/include/linux/res_counter.h
>> +++ b/include/linux/res_counter.h
>> @@ -79,6 +79,9 @@ typedef int (*write_strategy_fn)(const char *buf,
>> unsigned long long *val);
>>   int res_counter_memparse_write_strategy(const char *buf,
>>                       unsigned long long *res);
>>
>> +int res_counter_diskspace_parse_write_strategy(const char *buf,
>> +                           unsigned long long *res);
>> +
>>   int res_counter_write(struct res_counter *counter, int member,
>>                 const char *buffer, write_strategy_fn write_strategy);
>>
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index 34683ef..42c1623 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -145,6 +145,64 @@ u64 res_counter_read_u64(struct res_counter
>> *counter, int member)
>>   }
>>   #endif
>>
>> +/*
>> + * Copy from memparse(), add terabytes, petabytes parse support.
>> + */
> Don't see a reason for that. It is all bytes and such, just add the
> modifiers you want to the normal parse...

ok, I'll take care.

Thanks,
-Jeff

> 
>> +unsigned long long disk_space_parse(const char *ptr, char **retptr)
>> +{
>> +    char *endptr; /* local pointer to end of parsed string */
>> +    unsigned long long ret = kstrtoull(ptr,&endptr, 0);
>> +
>> +    switch (*endptr) {
>> +    case 'P':
>> +    case 'p':
>> +        ret<<= 10;
>> +    case 'T':
>> +    case 't':
>> +        ret<<= 10;
>> +    case 'G':
>> +    case 'g':
>> +        ret<<= 10;
>> +    case 'M':
>> +    case 'm':
>> +        ret<<= 10;
>> +    case 'K':
>> +    case 'k':
>> +        ret<<= 10;
>> +        endptr++;
>> +    default:
>> +        break;
>> +    }
>> +
>> +    if (retptr)
>> +        *retptr = endptr;
>> +
>> +    return ret;
>> +}
>> +
>> +int res_counter_diskspace_parse_write_strategy(const char *buf,
>> +                           unsigned long long *res)
>> +{
>> +    char *end;
>> +
>> +    /* return RESOURCE_MAX(unlimited) if "-1" is specified */
>> +    if (*buf == '-') {
>> +        *res = kstrtoull(buf + 1,&end, 10);
>> +        if (*res != 1 || *end != '\0')
>> +            return -EINVAL;
>> +        *res = RESOURCE_MAX;
>> +        return 0;
>> +    }
>> +
>> +    /* FIXME - make memparse() take const char* args */
>> +    *res = disk_space_parse((char *)buf,&end);
>> +    if (*end != '\0')
>> +        return -EINVAL;
>> +
>> +    /* FIXME - need to return *res as block aligned? */
>> +    return 0;
>> +}
>> +
>>   int res_counter_memparse_write_strategy(const char *buf,
>>                       unsigned long long *res)
>>   {
> 

