From: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 5 Sep 2023 15:09:50 -0400
Message-ID: <db22fc20-c6df-50a7-f4ae-582ced24835c@amazon.com>
References: <20230831142046.37177-1-luizcap@amazon.com>
 <20230905170318.GA16629@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
 <af394f53-224d-baff-5c7d-87eff7fcaad2@redhat.com>
 <664019c3-c4b1-6603-7a3d-f44a81737178@redhat.com>
 <7ae52eec-0df3-9bef-e4f6-e33a1873c464@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1693941187; x=1725477187;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RtGZX3EuEn1Pqxl6Ng+QSA/c3MIgDkLWa0RmqqyIoTI=;
  b=CoNWbBzeRKx9lsKJheo8qwgKMbPudtX5CQxyJrJU/rky4uBtLVpmWKbw
   tG8MnMkj0nQg11+f5jmgzlXZienZfe83B7mxaVoiY8rH6V/K6p4NRQRM3
   9SxdWCWEytQP+MG7pszCnBJPKwCTr2W/glYH5ktkKfo37t/x+7lVvnupy
   8=;
Content-Language: en-US
In-Reply-To: <7ae52eec-0df3-9bef-e4f6-e33a1873c464-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



On 2023-09-05 15:06, Waiman Long wrote:

> 
> 
> 
> On 9/5/23 15:03, Waiman Long wrote:
>>
>> On 9/5/23 14:59, Waiman Long wrote:
>>>
>>> On 9/5/23 13:03, Luiz Capitulino wrote:
>>>> On Thu, Aug 31, 2023 at 10:20:46AM -0400, Luiz Capitulino wrote:
>>>>> We have a need of using favordynmods with cgroup v1, which doesn't
>>>>> support
>>>>> changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
>>>>> build-time is not an option because we want to be able to selectively
>>>>> enable it for certain systems.
>>>>>
>>>>> This commit addresses this by introducing the cgroup_favordynmods=
>>>>> command-line option. This option works for both cgroup v1 and v2 and
>>>>> also allows for disabling favorynmods when the kernel built with
>>>>> CONFIG_FAVOR_DYNMODS=y.
>>>>>
>>>>> Signed-off-by: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
>>>> Hi,
>>>>
>>>> Would somebody take a look at this patch please?
>>>>
>>>> Thanks,
>>>>
>>>> - Luiz
>>>
>>> The patch looks good to me. I do have a minor comment that it may be
>>> better to use the relatively new __ro_after_init qualifier instead of
>>> __read_mostly.

Will do the change and post v2 shortly.

>>>
>> With this patch, CGROUP_FAVOR_DYNMODS kconfig option will have no
>> user. So this config option should be removed as well.
> 
> My bad. That is not true. Please ignore this comment.

OK, big thanks for taking a look so quickly!

- Luiz

> 
> Regards,
> Longman
> 
