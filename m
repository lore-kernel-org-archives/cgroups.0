From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm/page_owner: Record task command name
Date: Mon, 31 Jan 2022 16:46:27 -0500
Message-ID: <12f62103-d0e9-3010-4c7b-7b80f086734d@redhat.com>
References: <20220131192308.608837-1-longman@redhat.com>
 <20220131192308.608837-5-longman@redhat.com>
 <YfhMd5LTzTHu9zMD@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643665595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrfhAK5TTZj4g7edUXER7YgS33zywQPgQldaDuFqoqY=;
        b=ZAGbKnlUlBMiMpP3I7jUE6wJcxEpMjyry8jISD82Am/HXbWtjzs+StBXfIvt3l862EMjqc
        Uabvfq0bjH3LYb+6o0ute7xbrSQ7QDs+spZb8mWh7HmDMybTGGQ8bXozeeo9Tw2bP/Ht9c
        x72RFBYbp7A6nFEmdjTKGTFL+PotdKg=
Content-Language: en-US
In-Reply-To: <YfhMd5LTzTHu9zMD-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 1/31/22 15:54, Roman Gushchin wrote:
> On Mon, Jan 31, 2022 at 02:23:08PM -0500, Waiman Long wrote:
>> The page_owner information currently includes the pid of the calling
>> task. That is useful as long as the task is still running. Otherwise,
>> the number is meaningless. To have more information about the allocating
>> tasks that had exited by the time the page_owner information is
>> retrieved, we need to store the command name of the task.
>>
>> Add a new comm field into page_owner structure to store the command name
>> and display it when the page_owner information is retrieved. Only the
>> first 15 characters of the command name will be copied, but that should
>> be enough in most cases. Even for those commands with longer names,
>> it shouldn't be hard to guess what they are.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/page_owner.c | 16 ++++++++++++----
>>   1 file changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index a471c74c7fe0..8b2b381fd986 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -20,6 +20,7 @@
>>    * to use off stack temporal storage
>>    */
>>   #define PAGE_OWNER_STACK_DEPTH (16)
>> +#define PAGE_OWNER_COMM_LEN	16
> Not sure I understand why not simply use TASK_COMM_LEN ?

Yes, you are right. I thought TASK_COMM_LEN is larger than 16 without 
actually checking it. Will fix that.

Cheers,
Longman

