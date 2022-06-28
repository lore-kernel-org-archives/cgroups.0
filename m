From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Tue, 28 Jun 2022 06:59:06 +0300
Message-ID: <17916824-ba97-68ba-8166-9402d5f4440c@openvz.org>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org> <YrpO9CUDt8hpUprr@castle>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MFS2x9pNQLwXGwuNgzQ1iIUHTuj+zHNF+6//GrDccok=;
        b=mxbVmJ++2Cc5/l/lqWx9Fs7t2Zg7/rpqevzlWyOhXZcy9grpe35G9l9ySScKLev9uU
         Dz4LDLeUYcVPDUSNls7Ymx0CeJl3DwKUSThgh4DQBTI8XLC2NylaXNKQahTJuNrrhUjh
         aREqf+FUffagdLwymwDwlWSSZTJY8wZ/FbaTDj6Cjw5imW4HlIy0AFuvLVetwmwNEHvp
         qh5Lj5ek3pFqkm0PtNrDLngV8a5QKRAFrMwMy8CK7R61VAE541rKqNoB9E4tl9f5IEsO
         KlC6BIKb6Pz11uDudiW1HiZtesTcxv+lpD+FqTR2LY+0s3ApEMvSGfdZXdhf8T98XTo0
         pVEw==
Content-Language: en-US
In-Reply-To: <YrpO9CUDt8hpUprr@castle>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/28/22 03:44, Roman Gushchin wrote:
> On Mon, Jun 27, 2022 at 05:12:55AM +0300, Vasily Averin wrote:
>> When cgroup_mkdir reaches the limits of the cgroup hierarchy, it should
>> not return -EAGAIN, but instead react similarly to reaching the global
>> limit.
>>
>> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>> ---
>>  kernel/cgroup/cgroup.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 1be0f81fe8e1..243239553ea3 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -5495,7 +5495,7 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
>>  		return -ENODEV;
>>  
>>  	if (!cgroup_check_hierarchy_limits(parent)) {
>> -		ret = -EAGAIN;
>> +		ret = -ENOSPC;
> 
> I'd not argue whether ENOSPC is better or worse here, but I don't think we need
> to change it now. It's been in this state for a long time and is a part of ABI.
> EAGAIN is pretty unique as a mkdir() result, so systemd can handle it well.

I would agree with you, however in my opinion EAGAIN is used to restart an
interrupted system call. Thus, I worry its return can loop the user space without
any chance of continuation.

However, maybe I'm confusing something?

Thank you,
	Vasily Averin
