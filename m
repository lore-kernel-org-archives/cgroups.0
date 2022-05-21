From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: enable accounting for struct cgroup
Date: Sat, 21 May 2022 10:28:47 +0300
Message-ID: <c8835a1c-2266-0131-7fd6-e6449750353b@openvz.org>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <a17be77f-dc3b-d69a-16e2-f7309959c525@openvz.org>
 <20220519165325.GA2434@blackbody.suse.cz>
 <740dfcb1-5c5f-6a40-0f71-65f277f976d6@openvz.org>
 <d28233ee-bccb-7bc3-c2ec-461fd7f95e6a@openvz.org> <Yog4jCygrYPtPXg5@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7V73RXe3dU41vM2yXc5RdFK0d/D3JpjuPldiMy6fTKw=;
        b=Esn+ulXtp2NG4hm6JqTfL5/p0EfkrSuWUCOO9w7zITqkI+Wwl0e6DtqieOfHEaVUKT
         CB1xY2oebbxCY3E8LwiqBz+y2Zf2z9agssq/85w0pSqE/4dqYAPZBtarkvx2muFGrykT
         EZ2UKFoJT8TmJ5oJv7ZyDvNWs08PxumdZ4lgVtdlpMVYHdQqHDUZ0N02osjAQ0fSHNjw
         Vy049oSifghAwEI6PVkb5XQ8uUEeCz3gQ2UzxnUvmlvpcmm+yyr53Y8OHR04t0s8wPnF
         e7PcC3M+g8ioR3SvtmreqXQJ3ku+cu9rH1uB4Meyz3/UKxJ5w+ehGz4L4RnJmh6r52bp
         aosQ==
Content-Language: en-US
In-Reply-To: <Yog4jCygrYPtPXg5@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 5/21/22 03:55, Roman Gushchin wrote:
> On Fri, May 20, 2022 at 11:16:32PM +0300, Vasily Averin wrote:

>> common part:
>> 16  ~   352     5632    5632    KERNFS (*)
>> 1   +   4096    4096    9728    (cgroup_mkdir+0xe4)
>> 1       584     584     10312   (radix_tree_node_alloc.constprop.0+0x89)
>> 1       192     192     10504   (__d_alloc+0x29)
>> 2       72      144     10648   (avc_alloc_node+0x27)
>> 2       64      128     10776   (percpu_ref_init+0x6a)
>> 1       64      64      10840   (memcg_list_lru_alloc+0x21a)
>>
>> 1   +   192     192     192     call_site=psi_cgroup_alloc+0x1e
>> 1   +   96      96      288     call_site=cgroup_rstat_init+0x5f
>> 2       12      24      312     call_site=percpu_ref_init+0x23
>> 1       6       6       318     call_site=__percpu_counter_init+0x22
> 
> I'm curios, how do you generate these data?

trace_cmd + awk + /dev/hand

> Just an idea: it could be a nice tool, placed somewhere in tools/cgroup/...

I'm agree, nice idea. I'll try to implement it.
