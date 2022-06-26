From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] memcg: notify about global mem_cgroup_id space
 depletion
Date: Sun, 26 Jun 2022 10:11:31 +0300
Message-ID: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
References: <YrXDV7uPpmDigh3G@dhcp22.suse.cz>
 <c53e1df0-5174-66de-23cc-18797f0b512d@openvz.org> <Yre8tNUY8vBrO0yl@castle>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IBedsG9Q5xgkDI4Di1vJ798mBW+tiuIsna2FmqI3oz8=;
        b=BROfm7VbE1SLLJAAQRbRMYSFFuYVMx32Rq+TL06HlNfW5yYfeyzp7rFodfTjhMjslf
         0kC1417O0TcfoXi1Kqm4Gt20jySLwoxrWnqXsZUbwc6hInzvpw4nSCdGJOPaVRItWqO4
         J8qLBhnW1aIyqh8xBUjsDdMn3k0mfnUqDgSj7zSiqU3iHUOp7lOBno8nMLR8CbxLOACn
         f61afhZ2Ix88+32NTl/aBBhRUibW0rTfgoY4jnRvVHf6inQrRlyQpYJEiRBTUA2mmDkf
         4i/mRGDfvXof4eGvNcvi1Jpo9sBrvqsSwZVMzm2uGpOwcABIac+++DEDXAsWzuaol1lu
         lkKQ==
Content-Language: en-US
In-Reply-To: <Yre8tNUY8vBrO0yl@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/26/22 04:56, Roman Gushchin wrote:
> On Sat, Jun 25, 2022 at 05:04:27PM +0300, Vasily Averin wrote:
>> Currently host owner is not informed about the exhaustion of the
>> global mem_cgroup_id space. When this happens, systemd cannot
>> start a new service, but nothing points to the real cause of
>> this failure.
>>
>> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index d4c606a06bcd..5229321636f2 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5317,6 +5317,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>>  				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
>>  	if (memcg->id.id < 0) {
>>  		error = memcg->id.id;
>> +		pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
>>  		goto fail;
>>  	}
> 
> Hm, in this case it should return -ENOSPC and it's a very unique return code.
> If it's not returned from the mkdir() call, we should fix this.
> Otherwise it's up to systemd to handle it properly.
> 
> I'm not opposing for adding a warning, but parsing dmesg is not how
> the error handling should be done.

I'm agree,  I think it's a good idea. Moreover I think it makes sense to
use -ENOSPC  when the local cgroup's limit is reached.
Currently cgroup_mkdir() returns -EAGAIN, this looks strange for me.

        if (!cgroup_check_hierarchy_limits(parent)) {
                ret = -EAGAIN;
                goto out_unlock;
        }

Thank you,
	Vasily Averin
