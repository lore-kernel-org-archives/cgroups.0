From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting for pids in nested pid
 namespaces
Date: Fri, 23 Apr 2021 05:09:01 +0300
Message-ID: <38945563-59ad-fb5e-9f7f-eb65ae4bf55e@virtuozzo.com>
References: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com>
 <YIIcKa/ANkQX07Nf@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=YyvzTBXOZaej9Iif+I45XB+57Mj/H9zw9b1SnxCqh14=; b=A0p1hY4ZtFRZna+gt
        ISa88C+xCiGWrQnFgpL4ySg6FqUXKSm+wkm8wt0oymsbi7jRduiYwpX5pXyc7le7xEcMQylW3TpWK
        7EqLPvmf3XHviQza4d65+tQQR+1n4h+GuGLy3pqJkaxt3YZDBZTK3vZiVuv67MrnIGRGAU99bBlbY
        =;
In-Reply-To: <YIIcKa/ANkQX07Nf@carbon>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

On 4/23/21 4:00 AM, Roman Gushchin wrote:
> On Thu, Apr 22, 2021 at 08:44:15AM +0300, Vasily Averin wrote:
>> init_pid_ns.pid_cachep have enabled memcg accounting, though this
>> setting was disabled for nested pid namespaces.
>>
>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>> ---
>>  kernel/pid_namespace.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>> index 6cd6715..a46a372 100644
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -51,7 +51,8 @@ static struct kmem_cache *create_pid_cachep(unsigned int level)
>>  	mutex_lock(&pid_caches_mutex);
>>  	/* Name collision forces to do allocation under mutex. */
>>  	if (!*pkc)
>> -		*pkc = kmem_cache_create(name, len, 0, SLAB_HWCACHE_ALIGN, 0);
>> +		*pkc = kmem_cache_create(name, len, 0,
>> +					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
>>  	mutex_unlock(&pid_caches_mutex);
>>  	/* current can fail, but someone else can succeed. */
>>  	return READ_ONCE(*pkc);
>> -- 
>> 1.8.3.1
>>
> 
> It looks good to me! It makes total sense to apply the same rules to the root
> and non-root levels.
> 
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> Btw, is there any reason why this patch is not included into the series?

It is a bugfix and I think it should be added to upstream ASAP.
Another patches adds a new functionality, they can cause questions or objections
and anyway can wait.

Thank you,
	Vasily Averin
